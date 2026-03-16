package controllers

import (
	"fmt"

	bolt "go.etcd.io/bbolt"
)

const settingsBucket = "settings"

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
