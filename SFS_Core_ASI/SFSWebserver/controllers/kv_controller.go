package controllers

import (
	"net/http"
	"strings"

	bolt "go.etcd.io/bbolt"
)

const kvBucketName = "sfs"

// EnsureKVBucket creates the raw key-value bucket if it does not already exist.
func EnsureKVBucket(db *bolt.DB) error {
	return db.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(kvBucketName))
		return err
	})
}

// KVController handles the raw key-value store endpoints used by the ASI C++ layer.
type KVController struct {
	db *bolt.DB
}

func NewKVController(db *bolt.DB) *KVController {
	return &KVController{db: db}
}

// Register wires all raw KV routes onto the default mux.
func (c *KVController) Register() {
	// GET /store?key=...&value=...
	// Stores a key/value string pair into the bucket.
	http.HandleFunc("/store", func(w http.ResponseWriter, r *http.Request) {
		key := r.URL.Query().Get("key")
		value := r.URL.Query().Get("value")

		if key == "" {
			respondText(w, 400, "missing key\n")
			return
		}

		err := c.db.Update(func(tx *bolt.Tx) error {
			bucket := tx.Bucket([]byte(kvBucketName))
			return bucket.Put([]byte(key), []byte(value))
		})
		if err != nil {
			respondText(w, 500, "write failed\n")
			return
		}

		respondText(w, 200, "stored\n")
	})

	// GET /allKeys
	// Returns all key:value pairs as a comma-separated list.
	http.HandleFunc("/allKeys", func(w http.ResponseWriter, r *http.Request) {
		var pairs []string

		err := c.db.View(func(tx *bolt.Tx) error {
			bucket := tx.Bucket([]byte(kvBucketName))
			if bucket == nil {
				return nil
			}
			return bucket.ForEach(func(k, v []byte) error {
				pairs = append(pairs, string(k)+":"+string(v))
				return nil
			})
		})
		if err != nil {
			respondText(w, 500, "read failed\n")
			return
		}

		respondText(w, 200, strings.Join(pairs, ",")+"\n")
	})

	// GET /retrieve?key=...
	// Fetches the stored value for a key.
	http.HandleFunc("/retrieve", func(w http.ResponseWriter, r *http.Request) {
		key := r.URL.Query().Get("key")

		if key == "" {
			respondText(w, 400, "missing key\n")
			return
		}

		var value []byte
		err := c.db.View(func(tx *bolt.Tx) error {
			bucket := tx.Bucket([]byte(kvBucketName))
			stored := bucket.Get([]byte(key))
			if stored != nil {
				value = append([]byte{}, stored...)
			}
			return nil
		})
		if err != nil {
			respondText(w, 500, "read failed\n")
			return
		}
		if value == nil {
			respondText(w, 404, "not found\n")
			return
		}

		respondText(w, 200, string(value)+"\n")
	})

	// GET /delete?key=...
	// Deletes a stored key (if it exists).
	http.HandleFunc("/delete", func(w http.ResponseWriter, r *http.Request) {
		key := r.URL.Query().Get("key")

		if key == "" {
			respondText(w, 400, "missing key\n")
			return
		}

		var existed bool
		err := c.db.Update(func(tx *bolt.Tx) error {
			bucket := tx.Bucket([]byte(kvBucketName))
			if bucket.Get([]byte(key)) != nil {
				existed = true
				return bucket.Delete([]byte(key))
			}
			return nil
		})
		if err != nil {
			respondText(w, 500, "delete failed\n")
			return
		}
		if !existed {
			respondText(w, 404, "not found\n")
			return
		}

		respondText(w, 200, "deleted\n")
	})
}
