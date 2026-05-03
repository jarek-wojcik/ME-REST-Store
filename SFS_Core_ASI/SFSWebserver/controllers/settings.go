package controllers

import (
	"fmt"
	"strconv"

	bolt "go.etcd.io/bbolt"
)

const settingsBucket = "settings"

// DefaultMaxSquadSize is the default maximum number of operatives per strike team.
const DefaultMaxSquadSize = 4

// GetMaxSquadSize reads the persisted maxSquadSize setting, falling back to
// DefaultMaxSquadSize if it has not been set or cannot be parsed.
func GetMaxSquadSize(db *bolt.DB) int {
	raw, err := GetSetting(db, "maxSquadSize", strconv.Itoa(DefaultMaxSquadSize))
	if err != nil {
		return DefaultMaxSquadSize
	}
	n, err := strconv.Atoi(raw)
	if err != nil || n < 1 || n > 10 {
		return DefaultMaxSquadSize
	}
	return n
}

// EnsureSettingsBucket creates the settings bucket if it does not already exist.
func EnsureSettingsBucket(db *bolt.DB) error {
	return db.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(settingsBucket))
		return err
	})
}

// GetSetting retrieves a setting by key. Returns fallback if the key is not found.
func GetSetting(db *bolt.DB, key, fallback string) (string, error) {
	var val string
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(settingsBucket))
		if b == nil {
			val = fallback
			return nil
		}
		v := b.Get([]byte(key))
		if v == nil {
			val = fallback
		} else {
			val = string(v)
		}
		return nil
	})
	return val, err
}

// SetSetting stores a setting value by key.
func SetSetting(db *bolt.DB, key, value string) error {
	return db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(settingsBucket))
		if b == nil {
			return fmt.Errorf("settings bucket not found")
		}
		return b.Put([]byte(key), []byte(value))
	})
}
