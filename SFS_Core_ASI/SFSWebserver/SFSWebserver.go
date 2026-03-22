package main

import (
	"embed"
	"fmt"
	"html/template"
	"image/png"
	"io"
	"io/fs"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"sfswebserver/controllers"
	me3integration "sfswebserver/controllers/me3Integration"

	bolt "go.etcd.io/bbolt"
)

//go:embed templates
var templateFS embed.FS

//go:embed static
var staticFS embed.FS

// defaultDBPath returns the default location for the BoltDB file.
//
// On Windows, this will typically resolve to:
//
//	C:\Users\<user>\Documents\BioWare\Mass Effect 3\sfsdatabase.db
//
// If the home directory cannot be determined, it falls back to using the
// current working directory (relative path "sfsdatabase.db").
//
// It also ensures the folder structure exists by creating it if needed.
func defaultDBPath() string {
	// Best effort: "C:\Users\<user>\Documents"
	homeDir, err := os.UserHomeDir()
	if err != nil || homeDir == "" {
		// Last resort: current directory
		return "sfsdatabase.db"
	}

	dataDir := filepath.Join(homeDir, "Documents", "BioWare", "Mass Effect 3")
	_ = os.MkdirAll(dataDir, 0700) // ensure folders exist

	return filepath.Join(dataDir, "sfsdatabase.db")
}

// openDB opens (or creates) a BoltDB file at the provided path.
//
// The timeout is used to avoid hanging forever if the DB is locked by another process.
func openDB(path string) (*bolt.DB, error) {
	return bolt.Open(path, 0600, &bolt.Options{Timeout: 1 * time.Second})
}

// respondText writes a plain-text HTTP response with a status code.
//
// Kept as a helper to ensure consistent content type and status handling.
func respondText(responseWriter http.ResponseWriter, status int, body string) {
	responseWriter.Header().Set("Content-Type", "text/plain; charset=utf-8")
	responseWriter.WriteHeader(status)
	_, _ = responseWriter.Write([]byte(body))
}

// pngStrippedFileServer returns an http.Handler that serves files from fsys,
// re-encoding any .png file through Go's image/png codec to strip embedded
// gAMA / iCCP / sRGB colour-profile chunks. Chromium (WebView2) applies ICC
// colour corrections from those chunks, making the images look over-bright.
// Go's PNG encoder never writes colour-profile chunks, so the output is treated
// as plain sRGB and rendered with the original pixel values intact.
// All non-PNG files are forwarded to a standard http.FileServer.
func pngStrippedFileServer(fsys fs.FS) http.Handler {
	fallback := http.FileServer(http.FS(fsys))
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if !strings.HasSuffix(strings.ToLower(r.URL.Path), ".png") {
			fallback.ServeHTTP(w, r)
			return
		}
		f, err := fsys.Open(r.URL.Path)
		if err != nil {
			http.NotFound(w, r)
			return
		}
		defer f.Close()
		img, err := png.Decode(f)
		if err != nil {
			log.Printf("[WARN] png decode %s: %v — serving raw", r.URL.Path, err)
			fallback.ServeHTTP(w, r)
			return
		}
		w.Header().Set("Content-Type", "image/png")
		w.Header().Set("Cache-Control", "max-age=3600")
		if encErr := png.Encode(w, img); encErr != nil {
			log.Printf("[WARN] png re-encode %s: %v", r.URL.Path, encErr)
		}
	})
}

// setupLogging opens (or creates) SFSWebserver.log next to the running
// executable and tees all log output to both the file and stdout.
// Returns the open *os.File so main() can defer its Close.
func setupLogging() *os.File {
	exePath, err := os.Executable()
	logPath := "SFSWebserver.log"
	if err == nil {
		logPath = filepath.Join(filepath.Dir(exePath), "SFSWebserver.log")
	}
	f, err := os.OpenFile(logPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
	if err != nil {
		// Can't open log file — stdout only is fine.
		log.SetOutput(os.Stdout)
		log.Printf("[WARN] could not open log file %s: %v — logging to stdout only", logPath, err)
		return nil
	}
	log.SetOutput(io.MultiWriter(os.Stdout, f))
	log.SetFlags(log.Ldate | log.Ltime | log.Lmsgprefix)
	log.Printf("[INFO] logging to %s", logPath)
	return f
}

func main() {
	logFile := setupLogging()
	if logFile != nil {
		defer logFile.Close()
	}
	log.Printf("[INFO] SFSWebserver starting")

	// Default server port and DB path.
	port := 6060
	dbPath := defaultDBPath()

	// Optional CLI overrides:
	//   argv[1] = port
	//   argv[2] = db file path
	if len(os.Args) > 1 {
		fmt.Sscanf(os.Args[1], "%d", &port)
	}
	if len(os.Args) > 2 {
		dbPath = os.Args[2]
	}
	log.Printf("[INFO] port=%d  db=%s", port, dbPath)

	// Open database.
	log.Printf("[INFO] opening database")
	db, err := openDB(dbPath)
	if err != nil {
		log.Fatalf("[FATAL] openDB: %v", err)
	}
	defer db.Close()
	log.Printf("[INFO] database opened")

	// Migrate legacy bots to the spectres bucket (safe to run every start).
	log.Printf("[INFO] migrating legacy bots")
	if err := controllers.MigrateBotsToSpectres(db); err != nil {
		log.Printf("[WARN] migrateBotsToSpectres: %v", err)
	}

	// Ensure buckets exist before serving requests.
	log.Printf("[INFO] ensuring buckets")
	if err := controllers.EnsureKVBucket(db); err != nil {
		log.Fatalf("[FATAL] ensureKVBucket: %v", err)
	}
	if err := controllers.EnsureTeamsBucket(db); err != nil {
		log.Fatalf("[FATAL] ensureTeamsBucket: %v", err)
	}
	if err := controllers.EnsureSpectresBucket(db); err != nil {
		log.Fatalf("[FATAL] ensureSpectresBucket: %v", err)
	}
	if err := controllers.EnsureSettingsBucket(db); err != nil {
		log.Fatalf("[FATAL] ensureSettingsBucket: %v", err)
	}
	log.Printf("[INFO] buckets ready")

	// Parse all templates as a single set so partials can call each other
	// via {{template "name" .}}.
	log.Printf("[INFO] parsing templates")
	tmpl, err := template.New("").ParseFS(templateFS,
		"templates/*.html",
		"templates/partials/*.html",
	)
	if err != nil {
		log.Fatalf("[FATAL] template parse error: %v", err)
	}
	log.Printf("[INFO] templates parsed OK")

	// GET /static/*
	// Serves images and other static assets embedded in the binary.
	staticSub, err := fs.Sub(staticFS, "static")
	if err != nil {
		log.Fatalf("[FATAL] fs.Sub static: %v", err)
	}
	http.Handle("/static/", http.StripPrefix("/static/", pngStrippedFileServer(staticSub)))

	// GET /spectreportal/
	// Serves the main UI shell with tab navigation.
	http.HandleFunc("/spectreportal/", func(w http.ResponseWriter, r *http.Request) {
		scale, _ := controllers.GetSetting(db, "scale", "1")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		if err := tmpl.ExecuteTemplate(w, "spectreportal", map[string]any{"Scale": scale}); err != nil {
			respondText(w, 500, "template error\n")
		}
	})

	// Register resource controllers.
	controllers.NewKVController(db).Register()
	controllers.NewTeamsController(db, tmpl).Register()
	controllers.NewSpectreController(db, tmpl).Register()
	controllers.NewSelectorsController(db, tmpl).Register()
	controllers.NewMissionParamsController().Register()
	controllers.NewSettingsController(db).Register()
	me3integration.NewMe3IntegrationController(db).Register()

	// GET /health
	// Simple health endpoint for checking whether the server is running.
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		respondText(w, 200, "ok\n")
	})

	// Bind to loopback only (local machine).
	addr := fmt.Sprintf("127.0.0.1:%d", port)
	log.Printf("[INFO] listening on http://%s", addr)

	// Start HTTP server (blocks forever unless an error occurs).
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatalf("[FATAL] ListenAndServe: %v", err)
	}
}
