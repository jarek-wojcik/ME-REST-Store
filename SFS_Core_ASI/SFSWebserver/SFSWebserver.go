package main

import (
	"embed"
	"fmt"
	"html/template"
	"io/fs"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	bolt "go.etcd.io/bbolt"
)

//go:embed templates
var templateFS embed.FS

//go:embed static
var staticFS embed.FS

const bucketName = "sfs"

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

// ensureBucket makes sure our main bucket exists before we serve any requests.
func ensureBucket(db *bolt.DB) error {
	return db.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(bucketName))
		return err
	})
}

// respondText writes a plain-text HTTP response with a status code.
//
// Kept as a helper to ensure consistent content type and status handling.
func respondText(responseWriter http.ResponseWriter, status int, body string) {
	responseWriter.Header().Set("Content-Type", "text/plain; charset=utf-8")
	responseWriter.WriteHeader(status)
	_, _ = responseWriter.Write([]byte(body))
}

func main() {
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

	// Open database.
	db, err := openDB(dbPath)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	// Ensure buckets exist before serving requests.
	if err := ensureBucket(db); err != nil {
		panic(err)
	}
	if err := ensureTeamsBucket(db); err != nil {
		panic(err)
	}
	if err := ensureBotsBucket(db); err != nil {
		panic(err)
	}

	// Parse all templates as a single set so partials can call each other
	// via {{template "name" .}}.
	tmpl := template.Must(template.New("").ParseFS(templateFS,
		"templates/*.html",
		"templates/partials/*.html",
	))

	// renderTeams writes the team_list partial.
	renderTeams := func(w http.ResponseWriter) {
		teams, err := listTeams(db)
		if err != nil {
			respondText(w, 500, "db error\n")
			return
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "team_list", map[string]any{"Teams": teams})
	}

	// renderBotPanel writes the bot_panel partial for the given team.
	renderBotPanel := func(w http.ResponseWriter, teamID string) {
		bots, err := listBotsForTeam(db, teamID)
		if err != nil {
			respondText(w, 500, "db error\n")
			return
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "bot_panel", map[string]any{
			"TeamID": teamID,
			"Bots":   botViews(bots),
		})
	}

	// renderBotCard writes a single bot_card partial.
	renderBotCard := func(w http.ResponseWriter, bot Bot) {
		def := CharacterByID(bot.CharacterID)
		if def == nil {
			def = &CharacterCatalog[0]
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "bot_card", BotView{
			Bot:           bot,
			CharDef:       def,
			WeaponDef:     WeaponByID(bot.WeaponID),
			WeaponMod1Def: WeaponModByID(bot.WeaponMod1ID),
			WeaponMod2Def: WeaponModByID(bot.WeaponMod2ID),
			PowerViews:    powerViews(bot.Powers),
		})
	}

	// GET /static/*
	// Serves images and other static assets embedded in the binary.
	staticSub, err := fs.Sub(staticFS, "static")
	if err != nil {
		panic(err)
	}
	http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.FS(staticSub))))

	// GET /spectreportal/
	// Serves the main UI shell with tab navigation.
	http.HandleFunc("/spectreportal/", func(responseWriter http.ResponseWriter, request *http.Request) {
		responseWriter.Header().Set("Content-Type", "text/html; charset=utf-8")
		if err := tmpl.ExecuteTemplate(responseWriter, "spectreportal", nil); err != nil {
			respondText(responseWriter, 500, "template error\n")
		}
	})

	// GET /api/teams
	// Returns the team list HTML partial (used by HTMX on initial tab load).
	http.HandleFunc("GET /api/teams", func(w http.ResponseWriter, r *http.Request) {
		renderTeams(w)
	})

	// POST /api/teams
	// Creates a new team. Form field: name. Returns the updated team list partial.
	http.HandleFunc("POST /api/teams", func(w http.ResponseWriter, r *http.Request) {
		name := strings.TrimSpace(r.FormValue("name"))
		if name == "" {
			respondText(w, 400, "missing name\n")
			return
		}
		if _, err := createTeam(db, name); err != nil {
			respondText(w, 500, "create failed\n")
			return
		}
		renderTeams(w)
	})

	// DELETE /api/teams/{id}
	// Deletes a team by ID. Returns the updated team list partial.
	http.HandleFunc("DELETE /api/teams/{id}", func(w http.ResponseWriter, r *http.Request) {
		id := r.PathValue("id")
		existed, err := deleteTeam(db, id)
		if err != nil {
			respondText(w, 500, "delete failed\n")
			return
		}
		if !existed {
			respondText(w, 404, "not found\n")
			return
		}
		renderTeams(w)
	})

	// GET /api/teams/{id}/bots
	// Returns the bot panel for the selected team.
	http.HandleFunc("GET /api/teams/{id}/bots", func(w http.ResponseWriter, r *http.Request) {
		renderBotPanel(w, r.PathValue("id"))
	})

	// POST /api/teams/{id}/bots
	// Creates a default bot (Human Adept Male) and returns the updated bot panel.
	http.HandleFunc("POST /api/teams/{id}/bots", func(w http.ResponseWriter, r *http.Request) {
		teamID := r.PathValue("id")
		if _, err := createBot(db, teamID, "AdeptHumanMale"); err != nil {
			respondText(w, 500, "create failed\n")
			return
		}
		renderBotPanel(w, teamID)
	})

	// DELETE /api/bots/{id}
	// Removes a bot. Returns an empty string (HTMX outerHTML swap removes the card).
	http.HandleFunc("DELETE /api/bots/{id}", func(w http.ResponseWriter, r *http.Request) {
		existed, err := deleteBot(db, r.PathValue("id"))
		if err != nil {
			respondText(w, 500, "delete failed\n")
			return
		}
		if !existed {
			respondText(w, 404, "not found\n")
			return
		}
		w.WriteHeader(200) // empty body — HTMX outerHTML swap removes the element
	})

	// GET /api/characters/selector?botId={id}
	// Returns the character selector grid partial for use in the modal.
	http.HandleFunc("GET /api/characters/selector", func(w http.ResponseWriter, r *http.Request) {
		botID := r.URL.Query().Get("botId")
		if botID == "" {
			respondText(w, 400, "missing botId\n")
			return
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "character_selector", map[string]any{
			"BotID":      botID,
			"Characters": CharacterCatalog,
		})
	})

	// POST /api/bots/{id}/character/{charId}
	// Updates a bot's character. Returns the updated bot_card partial.
	http.HandleFunc("POST /api/bots/{id}/character/{charId}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		charID := r.PathValue("charId")
		if CharacterByID(charID) == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		bot, err := updateBotCharacter(db, botID, charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderBotCard(w, bot)
	})

	// GET /api/weapons/selector?botId={id}
	// Returns the weapon selector grid partial for use in the modal.
	http.HandleFunc("GET /api/weapons/selector", func(w http.ResponseWriter, r *http.Request) {
		botID := r.URL.Query().Get("botId")
		if botID == "" {
			respondText(w, 400, "missing botId\n")
			return
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "weapon_selector", map[string]any{
			"BotID":   botID,
			"Weapons": WeaponCatalog,
		})
	})

	// POST /api/bots/{id}/weapon/{weaponId}
	// Updates a bot's weapon. Returns the updated bot_card partial.
	http.HandleFunc("POST /api/bots/{id}/weapon/{weaponId}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		weaponID := r.PathValue("weaponId")
		if WeaponByID(weaponID) == nil {
			respondText(w, 400, "unknown weapon\n")
			return
		}
		bot, err := updateBotWeapon(db, botID, weaponID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderBotCard(w, bot)
	})

	// GET /api/weapon-mods/selector?botId={id}&slot={1|2}
	// Returns the weapon mod selector grid partial for use in the modal.
	// Only mods compatible with the bot's currently equipped weapon are shown;
	// universal mods (WeaponTypeAny) are always included.
	http.HandleFunc("GET /api/weapon-mods/selector", func(w http.ResponseWriter, r *http.Request) {
		botID := r.URL.Query().Get("botId")
		slot := r.URL.Query().Get("slot")
		if botID == "" || (slot != "1" && slot != "2") {
			respondText(w, 400, "missing or invalid botId/slot\n")
			return
		}
		bot, err := getBot(db, botID)
		if err != nil {
			respondText(w, 404, "bot not found\n")
			return
		}
		// Determine which weapon type is equipped (nil = no weapon).
		weaponDef := WeaponByID(bot.WeaponID)
		// Filter mods: keep universal mods and those matching the weapon's type.
		var filtered []WeaponModDef
		for _, mod := range WeaponModCatalog {
			if mod.WeaponType == WeaponTypeAny {
				filtered = append(filtered, mod)
			} else if weaponDef != nil && mod.WeaponType == weaponDef.Category {
				filtered = append(filtered, mod)
			}
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "weapon_mod_selector", map[string]any{
			"BotID": botID,
			"Slot":  slot,
			"Mods":  filtered,
		})
	})

	// POST /api/bots/{id}/mod/{slot}/{modId}
	// Updates a bot's weapon mod in the given slot (1 or 2). Returns the updated bot_card partial.
	http.HandleFunc("POST /api/bots/{id}/mod/{slot}/{modId}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		slotStr := r.PathValue("slot")
		modID := r.PathValue("modId")
		var slot int
		switch slotStr {
		case "1":
			slot = 1
		case "2":
			slot = 2
		default:
			respondText(w, 400, "slot must be 1 or 2\n")
			return
		}
		// Allow clearing a slot by posting modId "none".
		if modID != "none" && WeaponModByID(modID) == nil {
			respondText(w, 400, "unknown mod\n")
			return
		}
		if modID == "none" {
			modID = ""
		}
		bot, err := updateBotWeaponMod(db, botID, slot, modID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderBotCard(w, bot)
	})

	// POST /api/bots/{id}/power/{slot}/rankevo/{rank}/{evoIdx}/{choice}
	// Atomically sets rank AND one evolution choice (used for evo-cell clicks at ranks 4–6).
	http.HandleFunc("POST /api/bots/{id}/power/{slot}/rankevo/{rank}/{evoIdx}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		var slotIdx, rank, evoIdx int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		if _, err := fmt.Sscan(r.PathValue("rank"), &rank); err != nil || rank < 4 || rank > 6 {
			respondText(w, 400, "rank must be 4–6\n")
			return
		}
		if _, err := fmt.Sscan(r.PathValue("evoIdx"), &evoIdx); err != nil || evoIdx < 0 || evoIdx > 2 {
			respondText(w, 400, "evoIdx must be 0–2\n")
			return
		}
		choice := r.PathValue("choice")
		if choice != "A" && choice != "B" {
			respondText(w, 400, "choice must be A or B\n")
			return
		}
		bot, err := updateBotPowerRankAndEvo(db, botID, slotIdx, rank, evoIdx, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderBotCard(w, bot)
	})

	// POST /api/bots/{id}/power/{slot}/rank/{rank}
	// Sets the rank (0–6) for a power slot. Returns the updated bot_card partial.
	http.HandleFunc("POST /api/bots/{id}/power/{slot}/rank/{rank}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		var slotIdx, rank int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		if _, err := fmt.Sscan(r.PathValue("rank"), &rank); err != nil || rank < 0 || rank > 6 {
			respondText(w, 400, "rank must be 0–6\n")
			return
		}
		bot, err := updateBotPowerRank(db, botID, slotIdx, rank)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderBotCard(w, bot)
	})

	// POST /api/bots/{id}/power/{slot}/evo/{evoIdx}/{choice}
	// Sets an A/B evolution choice (evoIdx: 0–2; choice: A or B). Returns the updated bot_card partial.
	http.HandleFunc("POST /api/bots/{id}/power/{slot}/evo/{evoIdx}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		var slotIdx, evoIdx int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		if _, err := fmt.Sscan(r.PathValue("evoIdx"), &evoIdx); err != nil || evoIdx < 0 || evoIdx > 2 {
			respondText(w, 400, "evoIdx must be 0–2\n")
			return
		}
		choice := r.PathValue("choice")
		if choice != "A" && choice != "B" {
			respondText(w, 400, "choice must be A or B\n")
			return
		}
		bot, err := updateBotPowerEvolution(db, botID, slotIdx, evoIdx, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderBotCard(w, bot)
	})

	// GET /health
	// Simple health endpoint for checking whether the server is running.
	http.HandleFunc("/health", func(responseWriter http.ResponseWriter, request *http.Request) {
		respondText(responseWriter, 200, "ok\n")
	})

	// GET /store?key=...&value=...
	// Stores a key/value string pair into the bucket.
	http.HandleFunc("/store", func(responseWriter http.ResponseWriter, request *http.Request) {
		key := request.URL.Query().Get("key")
		value := request.URL.Query().Get("value")

		// Validate inputs.
		if key == "" {
			respondText(responseWriter, 400, "missing key\n")
			return
		}

		// Write value to BoltDB.
		err := db.Update(func(tx *bolt.Tx) error {
			bucket := tx.Bucket([]byte(bucketName))
			return bucket.Put([]byte(key), []byte(value))
		})
		if err != nil {
			respondText(responseWriter, 500, "write failed\n")
			return
		}

		respondText(responseWriter, 200, "stored\n")
	})

	http.HandleFunc("/allKeys", func(responseWriter http.ResponseWriter, request *http.Request) {
		var pairs []string

		err := db.View(func(tx *bolt.Tx) error {
			bucket := tx.Bucket([]byte(bucketName))
			if bucket == nil {
				return nil
			}

			return bucket.ForEach(func(keyBytes, valueBytes []byte) error {
				pairs = append(pairs, string(keyBytes)+":"+string(valueBytes))
				return nil
			})
		})
		if err != nil {
			respondText(responseWriter, 500, "read failed\n")
			return
		}

		respondText(responseWriter, 200, strings.Join(pairs, ",")+"\n")
	})

	// GET /retrieve?key=...
	// Fetches the stored value for a key.
	http.HandleFunc("/retrieve", func(responseWriter http.ResponseWriter, request *http.Request) {
		key := request.URL.Query().Get("key")

		// Validate inputs.
		if key == "" {
			respondText(responseWriter, 400, "missing key\n")
			return
		}

		// Read value from BoltDB.
		var value []byte
		err := db.View(func(tx *bolt.Tx) error {
			bucket := tx.Bucket([]byte(bucketName))

			storedValue := bucket.Get([]byte(key))
			if storedValue == nil {
				// Not found (return nil error and handle outside).
				return nil
			}

			// Copy because BoltDB memory is only valid during the transaction.
			value = append([]byte{}, storedValue...)
			return nil
		})
		if err != nil {
			respondText(responseWriter, 500, "read failed\n")
			return
		}
		if value == nil {
			respondText(responseWriter, 404, "not found\n")
			return
		}

		respondText(responseWriter, 200, string(value)+"\n")
	})

	// GET /delete?key=...
	// Deletes a stored key (if it exists).
	http.HandleFunc("/delete", func(responseWriter http.ResponseWriter, request *http.Request) {
		key := request.URL.Query().Get("key")

		// Validate inputs.
		if key == "" {
			respondText(responseWriter, 400, "missing key\n")
			return
		}

		// Attempt delete inside a write transaction.
		var existed bool
		err := db.Update(func(tx *bolt.Tx) error {
			bucket := tx.Bucket([]byte(bucketName))

			if bucket.Get([]byte(key)) != nil {
				existed = true
				return bucket.Delete([]byte(key))
			}

			// If it doesn't exist, do nothing (no error).
			return nil
		})
		if err != nil {
			respondText(responseWriter, 500, "delete failed\n")
			return
		}
		if !existed {
			respondText(responseWriter, 404, "not found\n")
			return
		}

		respondText(responseWriter, 200, "deleted\n")
	})

	// Bind to loopback only (local machine).
	addr := fmt.Sprintf("127.0.0.1:%d", port)

	// Start HTTP server (blocks forever unless an error occurs).
	_ = http.ListenAndServe(addr, nil)
}
