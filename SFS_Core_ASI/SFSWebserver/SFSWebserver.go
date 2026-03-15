package main

import (
	"embed"
	"fmt"
	"html/template"
	"io"
	"io/fs"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"sfswebserver/model"

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

	// Ensure buckets exist before serving requests.
	log.Printf("[INFO] ensuring buckets")
	if err := ensureBucket(db); err != nil {
		log.Fatalf("[FATAL] ensureBucket: %v", err)
	}
	if err := ensureTeamsBucket(db); err != nil {
		log.Fatalf("[FATAL] ensureTeamsBucket: %v", err)
	}
	if err := ensureBotsBucket(db); err != nil {
		log.Fatalf("[FATAL] ensureBotsBucket: %v", err)
	}
	if err := ensureSpectresBucket(db); err != nil {
		log.Fatalf("[FATAL] ensureSpectresBucket: %v", err)
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
	renderBotCard := func(w http.ResponseWriter, bot model.Bot) {
		def := model.CharacterByID(bot.CharacterID)
		if def == nil {
			def = &model.CharacterCatalog[0]
		}
		urls := botURLs(bot.ID)
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "bot_card", BotView{
			Bot:           bot,
			Name:          def.Name,
			CharDef:       def,
			WeaponDef:     model.WeaponByID(bot.WeaponID),
			WeaponMod1Def: model.WeaponModByID(bot.WeaponMod1ID),
			WeaponMod2Def: model.WeaponModByID(bot.WeaponMod2ID),
			PowerViews:    powerViews(bot.Powers, urls.PowerBaseURL),
			CardURLs:      urls,
		})
	}

	// renderSpectreCard writes the bot_card partial for a spectre.
	renderSpectreCard := func(w http.ResponseWriter, s model.Spectre) {
		def := model.CharacterByID(s.CharacterID)
		if def == nil {
			def = &model.CharacterCatalog[0]
		}
		urls := spectreURLs(s.ID)
		urls.HasBorrowedPower = s.BorrowedPower != nil
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "bot_card", SpectreView{
			Spectre:           s,
			CharDef:           def,
			AppearanceCharDef: model.CharacterByID(s.AppearanceCharacterID),
			WeaponDef:         model.WeaponByID(s.WeaponID),
			WeaponMod1Def:     model.WeaponModByID(s.WeaponMod1ID),
			WeaponMod2Def:     model.WeaponModByID(s.WeaponMod2ID),
			Weapon2Def:        model.WeaponByID(s.Weapon2ID),
			Weapon2Mod1Def:    model.WeaponModByID(s.Weapon2Mod1ID),
			Weapon2Mod2Def:    model.WeaponModByID(s.Weapon2Mod2ID),
			PowerViews:        spectrePowerViews(s, urls),
			CardURLs:          urls,
		})
	}

	// renderSpectreList writes the spectre_list partial.
	renderSpectreList := func(w http.ResponseWriter) {
		spectres, err := listSpectres(db)
		if err != nil {
			respondText(w, 500, "db error\n")
			return
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "spectre_list", map[string]any{
			"Spectres": spectreViews(spectres),
		})
	}

	// GET /static/*
	// Serves images and other static assets embedded in the binary.
	staticSub, err := fs.Sub(staticFS, "static")
	if err != nil {
		log.Fatalf("[FATAL] fs.Sub static: %v", err)
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

	// GET /api/characters/selector?entityId={id}&kind={bot|spectre}
	// Returns the character selector grid partial for use in the modal.
	http.HandleFunc("GET /api/characters/selector", func(w http.ResponseWriter, r *http.Request) {
		entityID := r.URL.Query().Get("entityId")
		kind := r.URL.Query().Get("kind")
		if entityID == "" {
			respondText(w, 400, "missing entityId\n")
			return
		}
		var charPostURLBase, targetID string
		switch kind {
		case "spectre":
			charPostURLBase = "/api/spectres/" + entityID + "/character"
			targetID = "spectre-card-" + entityID
		case "spectre-appearance":
			charPostURLBase = "/api/spectres/" + entityID + "/appearance"
			targetID = "spectre-card-" + entityID
		default: // "bot"
			charPostURLBase = "/api/bots/" + entityID + "/character"
			targetID = "bot-card-" + entityID
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "character_selector", map[string]any{
			"CharPostURLBase": charPostURLBase,
			"TargetID":        targetID,
			"Groups":          model.GroupedCharacters(),
		})
	})

	// POST /api/bots/{id}/character/{charId}
	// Updates a bot's character. Returns the updated bot_card partial.
	http.HandleFunc("POST /api/bots/{id}/character/{charId}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		charID := r.PathValue("charId")
		if model.CharacterByID(charID) == nil {
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

	// GET /api/weapons/selector?entityId={id}&kind={bot|spectre}
	// Returns the weapon selector grid partial for use in the modal.
	http.HandleFunc("GET /api/weapons/selector", func(w http.ResponseWriter, r *http.Request) {
		entityID := r.URL.Query().Get("entityId")
		kind := r.URL.Query().Get("kind")
		if entityID == "" {
			respondText(w, 400, "missing entityId\n")
			return
		}
		var weaponPostURLBase, targetID string
		switch kind {
		case "spectre":
			weaponPostURLBase = "/api/spectres/" + entityID + "/weapon"
			targetID = "spectre-card-" + entityID
		case "spectre-weapon2":
			weaponPostURLBase = "/api/spectres/" + entityID + "/weapon2"
			targetID = "spectre-card-" + entityID
		default: // "bot"
			weaponPostURLBase = "/api/bots/" + entityID + "/weapon"
			targetID = "bot-card-" + entityID
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "weapon_selector", map[string]any{
			"WeaponPostURLBase": weaponPostURLBase,
			"TargetID":          targetID,
			"Groups":            model.GroupedWeapons(),
		})
	})

	// POST /api/bots/{id}/weapon/{weaponId}
	// Updates a bot's weapon. Returns the updated bot_card partial.
	http.HandleFunc("POST /api/bots/{id}/weapon/{weaponId}", func(w http.ResponseWriter, r *http.Request) {
		botID := r.PathValue("id")
		weaponID := r.PathValue("weaponId")
		if model.WeaponByID(weaponID) == nil {
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

	// GET /api/weapon-mods/selector?entityId={id}&kind={bot|spectre}&slot={1|2}
	// Returns the weapon mod selector grid partial for use in the modal.
	// Only mods compatible with the entity's currently equipped weapon are shown;
	// universal mods (WeaponTypeAny) are always included.
	http.HandleFunc("GET /api/weapon-mods/selector", func(w http.ResponseWriter, r *http.Request) {
		entityID := r.URL.Query().Get("entityId")
		slot := r.URL.Query().Get("slot")
		kind := r.URL.Query().Get("kind")
		if entityID == "" || (slot != "1" && slot != "2") {
			respondText(w, 400, "missing or invalid entityId/slot\n")
			return
		}
		var weaponID string
		switch kind {
		case "spectre":
			if sv, err2 := getSpectre(db, entityID); err2 == nil {
				weaponID = sv.WeaponID
			} else {
				respondText(w, 404, "entity not found\n")
				return
			}
		case "spectre-weapon2":
			if sv, err2 := getSpectre(db, entityID); err2 == nil {
				weaponID = sv.Weapon2ID
			} else {
				respondText(w, 404, "entity not found\n")
				return
			}
		default: // "bot"
			if bv, err2 := getBot(db, entityID); err2 == nil {
				weaponID = bv.WeaponID
			} else {
				respondText(w, 404, "entity not found\n")
				return
			}
		}
		// Determine which weapon type is equipped (nil = no weapon).
		weaponDef := model.WeaponByID(weaponID)
		// Filter mods: keep universal mods and those matching the weapon's type.
		var filtered []model.WeaponModDef
		for _, mod := range model.WeaponModCatalog {
			if mod.WeaponType == model.WeaponTypeAny {
				filtered = append(filtered, mod)
			} else if weaponDef != nil && mod.WeaponType == weaponDef.Category {
				filtered = append(filtered, mod)
			}
		}
		var modPostURLBase, targetID string
		switch kind {
		case "spectre":
			modPostURLBase = "/api/spectres/" + entityID + "/mod/" + slot
			targetID = "spectre-card-" + entityID
		case "spectre-weapon2":
			modPostURLBase = "/api/spectres/" + entityID + "/mod2/" + slot
			targetID = "spectre-card-" + entityID
		default: // "bot"
			modPostURLBase = "/api/bots/" + entityID + "/mod/" + slot
			targetID = "bot-card-" + entityID
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "weapon_mod_selector", map[string]any{
			"ModPostURLBase": modPostURLBase,
			"ModClearURL":    modPostURLBase + "/none",
			"TargetID":       targetID,
			"Slot":           slot,
			"Mods":           filtered,
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
		if modID != "none" && model.WeaponModByID(modID) == nil {
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

	// GET /api/spectres
	// Returns the spectre list partial (full left+right panel).
	http.HandleFunc("GET /api/spectres", func(w http.ResponseWriter, r *http.Request) {
		renderSpectreList(w)
	})

	// POST /api/spectres
	// Creates a new spectre. Form field: name. Returns updated spectre list.
	http.HandleFunc("POST /api/spectres", func(w http.ResponseWriter, r *http.Request) {
		name := strings.TrimSpace(r.FormValue("name"))
		if name == "" {
			respondText(w, 400, "missing name\n")
			return
		}
		if _, err := createSpectre(db, name); err != nil {
			respondText(w, 500, "create failed\n")
			return
		}
		renderSpectreList(w)
	})

	// DELETE /api/spectres/{id}
	// Removes a spectre. Returns the updated spectre list.
	http.HandleFunc("DELETE /api/spectres/{id}", func(w http.ResponseWriter, r *http.Request) {
		existed, err := deleteSpectre(db, r.PathValue("id"))
		if err != nil {
			respondText(w, 500, "delete failed\n")
			return
		}
		if !existed {
			respondText(w, 404, "not found\n")
			return
		}
		renderSpectreList(w)
	})

	// GET /api/spectres/{id}/card
	// Returns the bot_card partial for a single spectre (loads the right panel).
	http.HandleFunc("GET /api/spectres/{id}/card", func(w http.ResponseWriter, r *http.Request) {
		s, err := getSpectre(db, r.PathValue("id"))
		if err != nil {
			respondText(w, 404, "not found\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/character/{charId}
	http.HandleFunc("POST /api/spectres/{id}/character/{charId}", func(w http.ResponseWriter, r *http.Request) {
		charID := r.PathValue("charId")
		if model.CharacterByID(charID) == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		s, err := updateSpectreCharacter(db, r.PathValue("id"), charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/appearance/{charId}
	// Changes the portrait image only; base class, powers, and loadout are unchanged.
	http.HandleFunc("POST /api/spectres/{id}/appearance/{charId}", func(w http.ResponseWriter, r *http.Request) {
		charID := r.PathValue("charId")
		if model.CharacterByID(charID) == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		s, err := updateSpectreAppearance(db, r.PathValue("id"), charID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/rename
	// Renames a spectre. Form body: name=<new name>. Returns the updated card.
	http.HandleFunc("POST /api/spectres/{id}/rename", func(w http.ResponseWriter, r *http.Request) {
		if err := r.ParseForm(); err != nil {
			respondText(w, 400, "bad form\n")
			return
		}
		name := r.FormValue("name")
		if name == "" {
			respondText(w, 400, "name required\n")
			return
		}
		s, err := updateSpectreName(db, r.PathValue("id"), name)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/weapon/none
	http.HandleFunc("POST /api/spectres/{id}/weapon/none", func(w http.ResponseWriter, r *http.Request) {
		s, err := updateSpectreWeapon(db, r.PathValue("id"), "")
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/weapon/{weaponId}
	http.HandleFunc("POST /api/spectres/{id}/weapon/{weaponId}", func(w http.ResponseWriter, r *http.Request) {
		weaponID := r.PathValue("weaponId")
		if model.WeaponByID(weaponID) == nil {
			respondText(w, 400, "unknown weapon\n")
			return
		}
		s, err := updateSpectreWeapon(db, r.PathValue("id"), weaponID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/weapon2/none
	http.HandleFunc("POST /api/spectres/{id}/weapon2/none", func(w http.ResponseWriter, r *http.Request) {
		s, err := updateSpectreWeapon2(db, r.PathValue("id"), "")
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/weapon2/{weaponId}
	http.HandleFunc("POST /api/spectres/{id}/weapon2/{weaponId}", func(w http.ResponseWriter, r *http.Request) {
		weaponID := r.PathValue("weaponId")
		if model.WeaponByID(weaponID) == nil {
			respondText(w, 400, "unknown weapon\n")
			return
		}
		s, err := updateSpectreWeapon2(db, r.PathValue("id"), weaponID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/mod2/{slot}/{modId} — mod slots for second weapon
	http.HandleFunc("POST /api/spectres/{id}/mod2/{slot}/{modId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		slotStr := r.PathValue("slot")
		modID := r.PathValue("modId")
		var slot int
		switch slotStr {
		case "1":
			slot = 1
		case "2":
			slot = 2
		default:
			respondText(w, 400, "invalid slot\n")
			return
		}
		if modID == "none" {
			modID = ""
		}
		s, err := updateSpectreWeapon2Mod(db, spectreID, slot, modID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/mod/{slot}/{modId}
	http.HandleFunc("POST /api/spectres/{id}/mod/{slot}/{modId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
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
		if modID != "none" && model.WeaponModByID(modID) == nil {
			respondText(w, 400, "unknown mod\n")
			return
		}
		if modID == "none" {
			modID = ""
		}
		s, err := updateSpectreWeaponMod(db, spectreID, slot, modID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/power/{slot}/rankevo/{rank}/{evoIdx}/{choice}
	http.HandleFunc("POST /api/spectres/{id}/power/{slot}/rankevo/{rank}/{evoIdx}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
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
		s, err := updateSpectrePowerRankAndEvo(db, spectreID, slotIdx, rank, evoIdx, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/power/{slot}/rank/{rank}
	http.HandleFunc("POST /api/spectres/{id}/power/{slot}/rank/{rank}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		var slotIdx, rank int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		if _, err := fmt.Sscan(r.PathValue("rank"), &rank); err != nil || rank < 0 || rank > 6 {
			respondText(w, 400, "rank must be 0–6\n")
			return
		}
		s, err := updateSpectrePowerRank(db, spectreID, slotIdx, rank)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/power/{slot}/evo/{evoIdx}/{choice}
	http.HandleFunc("POST /api/spectres/{id}/power/{slot}/evo/{evoIdx}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
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
		s, err := updateSpectrePowerEvolution(db, spectreID, slotIdx, evoIdx, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// GET /api/spectres/{id}/borrowed-power/selector
	// Returns the borrow-power character picker partial (step 1 of the flow).
	http.HandleFunc("GET /api/spectres/{id}/borrowed-power/selector", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "spectre_borrow_char", map[string]any{
			"Heading":         "Borrow a Power",
			"FromCharURLBase": "/api/spectres/" + spectreID + "/borrowed-power",
			"Groups":          model.GroupedCharacters(),
		})
	})

	// GET /api/spectres/{id}/borrowed-power/from-char/{charId}
	// Returns the power picker for the selected source character (step 2).
	http.HandleFunc("GET /api/spectres/{id}/borrowed-power/from-char/{charId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		charID := r.PathValue("charId")
		charDef := model.CharacterByID(charID)
		if charDef == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		var powers []*model.PowerDef
		for _, pid := range charDef.PowerIDs {
			if pid != "" {
				powers = append(powers, model.PowerByID(pid))
			}
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "spectre_borrow_power", map[string]any{
			"CharDef":      charDef,
			"Powers":       powers,
			"BackURL":      "/api/spectres/" + spectreID + "/borrowed-power/selector",
			"PostURLBase":  "/api/spectres/" + spectreID + "/borrowed-power/add",
			"TargetCardID": "spectre-card-" + spectreID,
		})
	})

	// POST /api/spectres/{id}/borrowed-power/add/{powerID}
	// Persists the chosen borrowed power and returns the refreshed spectre card.
	http.HandleFunc("POST /api/spectres/{id}/borrowed-power/add/{powerID}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		powerID := r.PathValue("powerID")
		if model.PowerByID(powerID) == nil {
			respondText(w, 400, "unknown power\n")
			return
		}
		s, err := addSpectreBorrowedPower(db, spectreID, powerID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// GET /api/spectres/{id}/power/{slot}/change/selector
	// Opens the character picker for changing one normal power slot.
	http.HandleFunc("GET /api/spectres/{id}/power/{slot}/change/selector", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		slot := r.PathValue("slot")
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "spectre_borrow_char", map[string]any{
			"Heading":         "Change Power",
			"FromCharURLBase": "/api/spectres/" + spectreID + "/power/" + slot + "/change",
			"Groups":          model.GroupedCharacters(),
		})
	})

	// GET /api/spectres/{id}/power/{slot}/change/from-char/{charId}
	// Returns the power picker for the selected source character.
	http.HandleFunc("GET /api/spectres/{id}/power/{slot}/change/from-char/{charId}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		slot := r.PathValue("slot")
		charID := r.PathValue("charId")
		charDef := model.CharacterByID(charID)
		if charDef == nil {
			respondText(w, 400, "unknown character\n")
			return
		}
		var powers []*model.PowerDef
		for _, pid := range charDef.PowerIDs {
			if pid != "" {
				powers = append(powers, model.PowerByID(pid))
			}
		}
		w.Header().Set("Content-Type", "text/html; charset=utf-8")
		_ = tmpl.ExecuteTemplate(w, "spectre_borrow_power", map[string]any{
			"CharDef":      charDef,
			"Powers":       powers,
			"BackURL":      "/api/spectres/" + spectreID + "/power/" + slot + "/change/selector",
			"PostURLBase":  "/api/spectres/" + spectreID + "/power/" + slot + "/change/set",
			"TargetCardID": "spectre-card-" + spectreID,
		})
	})

	// POST /api/spectres/{id}/power/{slot}/change/set/{powerID}
	// Replaces the power in the given slot and returns the refreshed spectre card.
	http.HandleFunc("POST /api/spectres/{id}/power/{slot}/change/set/{powerID}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		powerID := r.PathValue("powerID")
		var slotIdx int
		if _, err := fmt.Sscan(r.PathValue("slot"), &slotIdx); err != nil || slotIdx < 0 || slotIdx > 4 {
			respondText(w, 400, "slot must be 0–4\n")
			return
		}
		if model.PowerByID(powerID) == nil {
			respondText(w, 400, "unknown power\n")
			return
		}
		s, err := updateSpectrePowerID(db, spectreID, slotIdx, powerID)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// DELETE /api/spectres/{id}/borrowed-power
	// Removes the borrowed power slot and returns the refreshed spectre card.
	http.HandleFunc("DELETE /api/spectres/{id}/borrowed-power", func(w http.ResponseWriter, r *http.Request) {
		s, err := clearSpectreBorrowedPower(db, r.PathValue("id"))
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/borrowed-power/rank/{rank}
	// Sets the rank of the borrowed power slot.
	http.HandleFunc("POST /api/spectres/{id}/borrowed-power/rank/{rank}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		var rank int
		if _, err := fmt.Sscan(r.PathValue("rank"), &rank); err != nil || rank < 0 || rank > 6 {
			respondText(w, 400, "rank must be 0–6\n")
			return
		}
		s, err := updateSpectreBorrowedPowerRank(db, spectreID, rank)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
	})

	// POST /api/spectres/{id}/borrowed-power/rankevo/{rank}/{evoIdx}/{choice}
	// Atomically sets rank and evolution choice on the borrowed power slot.
	http.HandleFunc("POST /api/spectres/{id}/borrowed-power/rankevo/{rank}/{evoIdx}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		spectreID := r.PathValue("id")
		var rank, evoIdx int
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
		s, err := updateSpectreBorrowedPowerRankAndEvo(db, spectreID, rank, evoIdx, choice)
		if err != nil {
			respondText(w, 500, "update failed\n")
			return
		}
		renderSpectreCard(w, s)
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
	log.Printf("[INFO] listening on http://%s", addr)

	// Start HTTP server (blocks forever unless an error occurs).
	if err := http.ListenAndServe(addr, nil); err != nil {
		log.Fatalf("[FATAL] ListenAndServe: %v", err)
	}
}
