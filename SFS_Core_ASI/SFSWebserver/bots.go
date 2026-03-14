package main

import (
	"encoding/json"
	"fmt"

	bolt "go.etcd.io/bbolt"
)

const botsBucket = "bots"

// BotView pairs a persisted Bot with its resolved catalog definitions
// for template rendering.
type BotView struct {
	Bot
	CharDef       *CharacterDef
	WeaponDef     *WeaponDef    // nil when no weapon is assigned
	WeaponMod1Def *WeaponModDef // nil when no mod is assigned in slot 1
	WeaponMod2Def *WeaponModDef // nil when no mod is assigned in slot 2
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
func listBotsForTeam(db *bolt.DB, teamID string) ([]Bot, error) {
	var bots []Bot
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		if b == nil {
			return nil
		}
		return b.ForEach(func(_, v []byte) error {
			var bot Bot
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

// createBot persists a new bot with the given character and returns it.
func createBot(db *bolt.DB, teamID string, charID string) (Bot, error) {
	bot := Bot{
		ID:           newID(),
		TeamID:       teamID,
		CharacterID:  charID,
		WeaponID:     "",
		WeaponMod1ID: "",
		WeaponMod2ID: "",
		Powers:       []PowerSlot{},
	}
	data, err := json.Marshal(bot)
	if err != nil {
		return Bot{}, err
	}
	err = db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(botsBucket))
		return b.Put([]byte(bot.ID), data)
	})
	return bot, err
}

// updateBotCharacter changes a bot's character and returns the updated bot.
func updateBotCharacter(db *bolt.DB, botID string, charID string) (Bot, error) {
	var bot Bot
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
		data, err := json.Marshal(bot)
		if err != nil {
			return err
		}
		return b.Put([]byte(botID), data)
	})
	return bot, err
}

// updateBotWeapon changes a bot's weapon and returns the updated bot.
func updateBotWeapon(db *bolt.DB, botID string, weaponID string) (Bot, error) {
	var bot Bot
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
func updateBotWeaponMod(db *bolt.DB, botID string, slot int, modID string) (Bot, error) {
	var bot Bot
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
		return b.Put([]byte(botID), data)
	})
	return bot, err
}

// botViews resolves catalog definitions for each bot.
func botViews(bots []Bot) []BotView {
	views := make([]BotView, 0, len(bots))
	for _, bot := range bots {
		def := CharacterByID(bot.CharacterID)
		if def == nil {
			def = &CharacterCatalog[0]
		}
		views = append(views, BotView{
			Bot:           bot,
			CharDef:       def,
			WeaponDef:     WeaponByID(bot.WeaponID),
			WeaponMod1Def: WeaponModByID(bot.WeaponMod1ID),
			WeaponMod2Def: WeaponModByID(bot.WeaponMod2ID),
		})
	}
	return views
}
