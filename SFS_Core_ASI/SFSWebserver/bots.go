package main

import (
	"encoding/json"
	"fmt"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

const botsBucket = "bots"

// CardURLs holds all pre-computed endpoint and element-ID strings for a card
// view. Embedding this in a card view struct keeps templates free of routing
// logic and makes the same templates reusable for both bots and spectres.
type CardURLs struct {
	CardID                 string // HTML element id, e.g. "bot-card-abc123"
	DeleteURL              string // DELETE endpoint for this entity
	DeleteConfirm          string // hx-confirm message shown before deletion
	CharSelectorURL        string // GET: opens character selector modal
	WeaponSelectorURL      string // GET: opens weapon selector modal
	Mod1SelectorURL        string // GET: opens weapon mod 1 selector modal
	Mod2SelectorURL        string // GET: opens weapon mod 2 selector modal
	PowerBaseURL           string // prefix for power rank/evo routes, e.g. "/api/bots/id/power"
	IsSpectre              bool   // true for spectre cards; enables borrow-power UI
	HasBorrowedPower       bool   // true when a borrowed power is already set (spectres only)
	AddPowerURL            string // GET: opens the borrow-power character picker (spectres only)
	ClearBorrowedPowerURL  string // DELETE: removes the borrowed power slot (spectres only)
	AppearanceSelectorURL  string // GET: opens character selector for appearance-only change (spectres only)
	RenameURL              string // POST: renames the entity; form field "name" (spectres only)
	Weapon2SelectorURL     string // GET: opens weapon selector for second weapon slot (spectres only)
	Weapon2Mod1SelectorURL string // GET: opens weapon mod selector for second weapon mod 1 (spectres only)
	Weapon2Mod2SelectorURL string // GET: opens weapon mod selector for second weapon mod 2 (spectres only)
	WeaponClearURL         string // POST: clears weapon (spectres only)
	Weapon2ClearURL        string // POST: clears second weapon (spectres only)
}

// PowerSlotView pairs a persisted PowerSlot with its resolved PowerDef and
// flattened evolution fields for easy template access.
type PowerSlotView struct {
	model.PowerSlot
	PowerDef        *model.PowerDef // nil if PowerID is empty or unknown
	SlotIdx         int             // 0–4, used in API route paths
	Evo0            string          // Evolution[0]: "A" or "B" (rank 4 choice)
	Evo1            string          // Evolution[1]: "A" or "B" (rank 5 choice)
	Evo2            string          // Evolution[2]: "A" or "B" (rank 6 choice)
	SlotBaseURL     string          // e.g. "/api/bots/abc123/power/0"
	IsBorrowedPower bool            // true for the borrowed-power slot (spectres only)
	ChangePowerURL  string          // GET: opens power-change flow for this slot (spectres only; empty for bots)
}

// BotView pairs a persisted Bot with its resolved catalog definitions
// for template rendering.
type BotView struct {
	model.Bot
	Name              string // display name; derived from CharDef.Name (bots are not user-renameable)
	CharDef           *model.CharacterDef
	AppearanceCharDef *model.CharacterDef // always nil for bots; present so bot_card template compiles uniformly
	WeaponDef         *model.WeaponDef    // nil when no weapon is assigned
	WeaponMod1Def     *model.WeaponModDef // nil when no mod is assigned in slot 1
	WeaponMod2Def     *model.WeaponModDef // nil when no mod is assigned in slot 2
	PowerViews        []PowerSlotView
	CardURLs
}

// getBot fetches a single bot by ID. Returns an error if the bot is not found.
func getBot(db *bolt.DB, botID string) (model.Bot, error) {
	var bot model.Bot
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		if b == nil {
			return fmt.Errorf("bot not found")
		}
		v := b.Get([]byte(botID))
		if v == nil {
			return fmt.Errorf("bot not found")
		}
		return json.Unmarshal(v, &bot)
	})
	return bot, err
}

// ensureBotsBucket creates the bots bucket if it does not already exist.
func ensureBotsBucket(db *bolt.DB) error {
	return db.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(botsBucket))
		return err
	})
}

// listBotsForTeam returns all bots belonging to teamID.
// BoltDB has no indices so this is a full scan; fine for local use (<100 bots).
func listBotsForTeam(db *bolt.DB, teamID string) ([]model.Bot, error) {
	var bots []model.Bot
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		if b == nil {
			return nil
		}
		return b.ForEach(func(_, v []byte) error {
			var bot model.Bot
			if err := json.Unmarshal(v, &bot); err != nil {
				return err
			}
			if bot.TeamID == teamID {
				bots = append(bots, bot)
			}
			return nil
		})
	})
	return bots, err
}

// defaultPowersForChar builds the initial []PowerSlot for a character.
func defaultPowersForChar(charID string) []model.PowerSlot {
	char := model.CharacterByID(charID)
	if char == nil {
		return []model.PowerSlot{}
	}
	var slots []model.PowerSlot
	for _, pid := range char.PowerIDs {
		if pid != "" {
			slots = append(slots, model.DefaultPower(pid))
		}
	}
	if slots == nil {
		return []model.PowerSlot{}
	}
	return slots
}

// createBot persists a new bot with the given character and returns it.
func createBot(db *bolt.DB, teamID string, charID string) (model.Bot, error) {
	bot := model.Bot{
		ID:           newID(),
		TeamID:       teamID,
		CharacterID:  charID,
		WeaponID:     "",
		WeaponMod1ID: "",
		WeaponMod2ID: "",
		Powers:       defaultPowersForChar(charID),
	}
	data, err := json.Marshal(bot)
	if err != nil {
		return model.Bot{}, err
	}
	err = db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		return b.Put([]byte(bot.ID), data)
	})
	return bot, err
}

// updateBotCharacter changes a bot's character, resets its powers to the new
// character's defaults, and returns the updated bot.
func updateBotCharacter(db *bolt.DB, botID string, charID string) (model.Bot, error) {
	var bot model.Bot
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		v := b.Get([]byte(botID))
		if v == nil {
			return fmt.Errorf("bot not found")
		}
		if err := json.Unmarshal(v, &bot); err != nil {
			return err
		}
		bot.CharacterID = charID
		bot.Powers = defaultPowersForChar(charID)
		data, err := json.Marshal(bot)
		if err != nil {
			return err
		}
		return b.Put([]byte(botID), data)
	})
	return bot, err
}

// updateBotWeapon changes a bot's weapon and returns the updated bot.
func updateBotWeapon(db *bolt.DB, botID string, weaponID string) (model.Bot, error) {
	var bot model.Bot
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		v := b.Get([]byte(botID))
		if v == nil {
			return fmt.Errorf("bot not found")
		}
		if err := json.Unmarshal(v, &bot); err != nil {
			return err
		}
		bot.WeaponID = weaponID
		data, err := json.Marshal(bot)
		if err != nil {
			return err
		}
		return b.Put([]byte(botID), data)
	})
	return bot, err
}

// updateBotPowerRank sets the rank (0–6) of one power slot and returns the updated bot.
func updateBotPowerRank(db *bolt.DB, botID string, slotIdx int, rank int) (model.Bot, error) {
	var bot model.Bot
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		v := b.Get([]byte(botID))
		if v == nil {
			return fmt.Errorf("bot not found")
		}
		if err := json.Unmarshal(v, &bot); err != nil {
			return err
		}
		if slotIdx < 0 || slotIdx >= len(bot.Powers) {
			return fmt.Errorf("invalid slot index")
		}
		bot.Powers[slotIdx].Rank = rank
		data, err := json.Marshal(bot)
		if err != nil {
			return err
		}
		return b.Put([]byte(botID), data)
	})
	return bot, err
}

// updateBotPowerEvolution sets an A/B evolution choice for one power slot.
// evoIdx is 0, 1, or 2 (for ranks 4, 5, 6 respectively).
func updateBotPowerEvolution(db *bolt.DB, botID string, slotIdx int, evoIdx int, choice string) (model.Bot, error) {
	var bot model.Bot
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		v := b.Get([]byte(botID))
		if v == nil {
			return fmt.Errorf("bot not found")
		}
		if err := json.Unmarshal(v, &bot); err != nil {
			return err
		}
		if slotIdx < 0 || slotIdx >= len(bot.Powers) {
			return fmt.Errorf("invalid slot index")
		}
		if evoIdx < 0 || evoIdx > 2 {
			return fmt.Errorf("invalid evo index")
		}
		bot.Powers[slotIdx].Evolution[evoIdx] = choice
		data, err := json.Marshal(bot)
		if err != nil {
			return err
		}
		return b.Put([]byte(botID), data)
	})
	return bot, err
}

// updateBotPowerRankAndEvo atomically sets a power slot's rank and one
// evolution choice in a single DB write.  Used for rank-4/5/6 evo cell clicks.
func updateBotPowerRankAndEvo(db *bolt.DB, botID string, slotIdx int, rank int, evoIdx int, choice string) (model.Bot, error) {
	var bot model.Bot
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		v := b.Get([]byte(botID))
		if v == nil {
			return fmt.Errorf("bot not found")
		}
		if err := json.Unmarshal(v, &bot); err != nil {
			return err
		}
		if slotIdx < 0 || slotIdx >= len(bot.Powers) {
			return fmt.Errorf("invalid slot index")
		}
		if evoIdx < 0 || evoIdx > 2 {
			return fmt.Errorf("invalid evo index")
		}
		bot.Powers[slotIdx].Rank = rank
		bot.Powers[slotIdx].Evolution[evoIdx] = choice
		data, err := json.Marshal(bot)
		if err != nil {
			return err
		}
		return b.Put([]byte(botID), data)
	})
	return bot, err
}

// deleteBot removes a bot by ID. Returns false if the ID did not exist.
func deleteBot(db *bolt.DB, botID string) (bool, error) {
	var existed bool
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		if b.Get([]byte(botID)) != nil {
			existed = true
			return b.Delete([]byte(botID))
		}
		return nil
	})
	return existed, err
}

// updateBotWeaponMod changes a bot's weapon mod in the given slot (1 or 2)
// and returns the updated bot.
func updateBotWeaponMod(db *bolt.DB, botID string, slot int, modID string) (model.Bot, error) {
	var bot model.Bot
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		v := b.Get([]byte(botID))
		if v == nil {
			return fmt.Errorf("bot not found")
		}
		if err := json.Unmarshal(v, &bot); err != nil {
			return err
		}
		switch slot {
		case 1:
			bot.WeaponMod1ID = modID
		case 2:
			bot.WeaponMod2ID = modID
		}
		data, err := json.Marshal(bot)
		if err != nil {
			return err
		}
		return b.Put([]byte(bot.ID), data)
	})
	return bot, err
}

// powerViews resolves PowerDef, flattens evolutions, and pre-computes per-slot
// URL prefixes for use in templates.
func powerViews(slots []model.PowerSlot, powerBaseURL string) []PowerSlotView {
	views := make([]PowerSlotView, len(slots))
	for i, ps := range slots {
		views[i] = PowerSlotView{
			PowerSlot:   ps,
			PowerDef:    model.PowerByID(ps.PowerID),
			SlotIdx:     i,
			Evo0:        ps.Evolution[0],
			Evo1:        ps.Evolution[1],
			Evo2:        ps.Evolution[2],
			SlotBaseURL: fmt.Sprintf("%s/%d", powerBaseURL, i),
		}
	}
	return views
}

// botURLs returns the pre-computed CardURLs for a given bot ID.
func botURLs(botID string) CardURLs {
	base := "/api/bots/" + botID
	return CardURLs{
		CardID:            "bot-card-" + botID,
		DeleteURL:         base,
		DeleteConfirm:     "Remove this bot?",
		CharSelectorURL:   "/api/characters/selector?entityId=" + botID + "&kind=bot",
		WeaponSelectorURL: "/api/weapons/selector?entityId=" + botID + "&kind=bot",
		Mod1SelectorURL:   "/api/weapon-mods/selector?entityId=" + botID + "&kind=bot&slot=1",
		Mod2SelectorURL:   "/api/weapon-mods/selector?entityId=" + botID + "&kind=bot&slot=2",
		PowerBaseURL:      base + "/power",
	}
}

// botViews resolves catalog definitions for each bot.
func botViews(bots []model.Bot) []BotView {
	views := make([]BotView, 0, len(bots))
	for _, bot := range bots {
		def := model.CharacterByID(bot.CharacterID)
		if def == nil {
			def = &model.CharacterCatalog[0]
		}
		urls := botURLs(bot.ID)
		views = append(views, BotView{
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
	return views
}
