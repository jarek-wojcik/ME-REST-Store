package main

import (
	"encoding/json"
	"fmt"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

const spectresBucket = "spectres"

// SpectreView pairs a persisted Spectre with resolved catalog definitions.
// It is structurally compatible with the "bot_card" template because all
// bot-specific routing was replaced by the embedded CardURLs fields.
type SpectreView struct {
	model.Spectre
	CharDef       *model.CharacterDef
	WeaponDef     *model.WeaponDef
	WeaponMod1Def *model.WeaponModDef
	WeaponMod2Def *model.WeaponModDef
	PowerViews    []PowerSlotView
	CardURLs
}

// spectreURLs returns pre-computed CardURLs for a given spectre ID.
func spectreURLs(spectreID string) CardURLs {
	base := "/api/spectres/" + spectreID
	return CardURLs{
		CardID:                "spectre-card-" + spectreID,
		DeleteURL:             base,
		DeleteConfirm:         "Remove this spectre?",
		CharSelectorURL:       "/api/characters/selector?entityId=" + spectreID + "&kind=spectre",
		WeaponSelectorURL:     "/api/weapons/selector?entityId=" + spectreID + "&kind=spectre",
		Mod1SelectorURL:       "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre&slot=1",
		Mod2SelectorURL:       "/api/weapon-mods/selector?entityId=" + spectreID + "&kind=spectre&slot=2",
		PowerBaseURL:          base + "/power",
		IsSpectre:             true,
		AddPowerURL:           base + "/borrowed-power/selector",
		ClearBorrowedPowerURL: base + "/borrowed-power",
	}
}

// ensureSpectresBucket creates the spectres bucket if it does not exist.
func ensureSpectresBucket(db *bolt.DB) error {
	return db.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(spectresBucket))
		return err
	})
}

// listSpectres returns all spectres in insertion order.
func listSpectres(db *bolt.DB) ([]model.Spectre, error) {
	var spectres []model.Spectre
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return nil
		}
		return b.ForEach(func(_, v []byte) error {
			var s model.Spectre
			if err := json.Unmarshal(v, &s); err != nil {
				return err
			}
			spectres = append(spectres, s)
			return nil
		})
	})
	return spectres, err
}

// getSpectre fetches a single spectre by ID.
func getSpectre(db *bolt.DB, spectreID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return fmt.Errorf("spectre not found")
		}
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		return json.Unmarshal(v, &s)
	})
	return s, err
}

// createSpectre persists a new spectre with the given name.
func createSpectre(db *bolt.DB, name string) (model.Spectre, error) {
	const defaultChar = "AdeptHumanMale"
	s := model.Spectre{
		ID:          newID(),
		Name:        name,
		CharacterID: defaultChar,
		Powers:      defaultPowersForChar(defaultChar),
	}
	data, err := json.Marshal(s)
	if err != nil {
		return model.Spectre{}, err
	}
	err = db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		return b.Put([]byte(s.ID), data)
	})
	return s, err
}

// deleteSpectre removes a spectre by ID. Returns false if it did not exist.
func deleteSpectre(db *bolt.DB, spectreID string) (bool, error) {
	var existed bool
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b.Get([]byte(spectreID)) != nil {
			existed = true
			return b.Delete([]byte(spectreID))
		}
		return nil
	})
	return existed, err
}

// updateSpectreCharacter changes the character and resets powers.
func updateSpectreCharacter(db *bolt.DB, spectreID, charID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.CharacterID = charID
		s.Powers = defaultPowersForChar(charID)
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreWeapon changes the equipped weapon.
func updateSpectreWeapon(db *bolt.DB, spectreID, weaponID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.WeaponID = weaponID
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreWeaponMod changes a weapon mod slot (1 or 2).
func updateSpectreWeaponMod(db *bolt.DB, spectreID string, slot int, modID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		switch slot {
		case 1:
			s.WeaponMod1ID = modID
		case 2:
			s.WeaponMod2ID = modID
		}
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(s.ID), data)
	})
	return s, err
}

// updateSpectrePowerRank sets the rank (0–6) of one power slot.
func updateSpectrePowerRank(db *bolt.DB, spectreID string, slotIdx, rank int) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if slotIdx < 0 || slotIdx >= len(s.Powers) {
			return fmt.Errorf("invalid slot index")
		}
		s.Powers[slotIdx].Rank = rank
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectrePowerEvolution sets an A/B evolution choice.
func updateSpectrePowerEvolution(db *bolt.DB, spectreID string, slotIdx, evoIdx int, choice string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if slotIdx < 0 || slotIdx >= len(s.Powers) {
			return fmt.Errorf("invalid slot index")
		}
		if evoIdx < 0 || evoIdx > 2 {
			return fmt.Errorf("invalid evo index")
		}
		s.Powers[slotIdx].Evolution[evoIdx] = choice
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectrePowerRankAndEvo atomically sets rank and an evolution choice.
func updateSpectrePowerRankAndEvo(db *bolt.DB, spectreID string, slotIdx, rank, evoIdx int, choice string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if slotIdx < 0 || slotIdx >= len(s.Powers) {
			return fmt.Errorf("invalid slot index")
		}
		if evoIdx < 0 || evoIdx > 2 {
			return fmt.Errorf("invalid evo index")
		}
		s.Powers[slotIdx].Rank = rank
		s.Powers[slotIdx].Evolution[evoIdx] = choice
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// spectrePowerViews builds the full []PowerSlotView for a spectre, including
// the borrowed power as the last entry when one is set.
func spectrePowerViews(s model.Spectre, urls CardURLs) []PowerSlotView {
	pv := powerViews(s.Powers, urls.PowerBaseURL)
	if s.BorrowedPower != nil {
		bp := *s.BorrowedPower
		pv = append(pv, PowerSlotView{
			PowerSlot:       bp,
			PowerDef:        model.PowerByID(bp.PowerID),
			SlotIdx:         len(s.Powers),
			Evo0:            bp.Evolution[0],
			Evo1:            bp.Evolution[1],
			Evo2:            bp.Evolution[2],
			SlotBaseURL:     "/api/spectres/" + s.ID + "/borrowed-power",
			IsBorrowedPower: true,
		})
	}
	return pv
}

// spectreViews resolves catalog definitions for each spectre.
func spectreViews(spectres []model.Spectre) []SpectreView {
	views := make([]SpectreView, 0, len(spectres))
	for _, s := range spectres {
		def := model.CharacterByID(s.CharacterID)
		if def == nil {
			def = &model.CharacterCatalog[0]
		}
		urls := spectreURLs(s.ID)
		urls.HasBorrowedPower = s.BorrowedPower != nil
		views = append(views, SpectreView{
			Spectre:       s,
			CharDef:       def,
			WeaponDef:     model.WeaponByID(s.WeaponID),
			WeaponMod1Def: model.WeaponModByID(s.WeaponMod1ID),
			WeaponMod2Def: model.WeaponModByID(s.WeaponMod2ID),
			PowerViews:    spectrePowerViews(s, urls),
			CardURLs:      urls,
		})
	}
	return views
}

// addSpectreBorrowedPower sets (or replaces) the borrowed power slot.
func addSpectreBorrowedPower(db *bolt.DB, spectreID, powerID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		slot := model.DefaultPower(powerID)
		s.BorrowedPower = &slot
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// clearSpectreBorrowedPower removes the borrowed power slot.
func clearSpectreBorrowedPower(db *bolt.DB, spectreID string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.BorrowedPower = nil
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreBorrowedPowerRank sets the rank of the borrowed power slot.
func updateSpectreBorrowedPowerRank(db *bolt.DB, spectreID string, rank int) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if s.BorrowedPower == nil {
			return fmt.Errorf("no borrowed power set")
		}
		s.BorrowedPower.Rank = rank
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreBorrowedPowerRankAndEvo atomically sets rank and an evolution
// choice on the borrowed power slot.
func updateSpectreBorrowedPowerRankAndEvo(db *bolt.DB, spectreID string, rank, evoIdx int, choice string) (model.Spectre, error) {
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		if s.BorrowedPower == nil {
			return fmt.Errorf("no borrowed power set")
		}
		if evoIdx < 0 || evoIdx > 2 {
			return fmt.Errorf("invalid evo index")
		}
		s.BorrowedPower.Rank = rank
		s.BorrowedPower.Evolution[evoIdx] = choice
		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}
