package main

import (
	"fmt"
	"net/http"
	"os"
	"time"

	bolt "go.etcd.io/bbolt"
)

const bucketName = "kv"

func openDB(path string) (*bolt.DB, error) {
	return bolt.Open(path, 0600, &bolt.Options{Timeout: 1 * time.Second})
}

func ensureBucket(db *bolt.DB) error {
	return db.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(bucketName))
		return err
	})
}

func respondText(w http.ResponseWriter, status int, body string) {
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	w.WriteHeader(status)
	_, _ = w.Write([]byte(body))
}

func main() {
	port := 6060
	dbPath := "reststore.db"
	if len(os.Args) > 1 {
		fmt.Sscanf(os.Args[1], "%d", &port)
	}
	if len(os.Args) > 2 {
		dbPath = os.Args[2]
	}

	db, err := openDB(dbPath)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	if err := ensureBucket(db); err != nil {
		panic(err)
	}

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		respondText(w, 200, "ok\n")
	})

	http.HandleFunc("/store", func(w http.ResponseWriter, r *http.Request) {
		key := r.URL.Query().Get("key")
		value := r.URL.Query().Get("value")
		if key == "" {
			respondText(w, 400, "missing key\n")
			return
		}

		err := db.Update(func(tx *bolt.Tx) error {
			b := tx.Bucket([]byte(bucketName))
			return b.Put([]byte(key), []byte(value))
		})
		if err != nil {
			respondText(w, 500, "write failed\n")
			return
		}
		respondText(w, 200, "stored\n")
	})

	http.HandleFunc("/retrieve", func(w http.ResponseWriter, r *http.Request) {
		key := r.URL.Query().Get("key")
		if key == "" {
			respondText(w, 400, "missing key\n")
			return
		}

		var value []byte
		err := db.View(func(tx *bolt.Tx) error {
			b := tx.Bucket([]byte(bucketName))
			v := b.Get([]byte(key))
			if v == nil {
				return nil
			}
			value = append([]byte{}, v...) // copy
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

	http.HandleFunc("/delete", func(w http.ResponseWriter, r *http.Request) {
		key := r.URL.Query().Get("key")
		if key == "" {
			respondText(w, 400, "missing key\n")
			return
		}

		var existed bool
		err := db.Update(func(tx *bolt.Tx) error {
			b := tx.Bucket([]byte(bucketName))
			if b.Get([]byte(key)) != nil {
				existed = true
				return b.Delete([]byte(key))
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

	addr := fmt.Sprintf("127.0.0.1:%d", port)
	_ = http.ListenAndServe(addr, nil)
}
