package main

import (
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"time"
	"strings"

	bolt "go.etcd.io/bbolt"
)

const bucketName = "sfs"

// defaultDBPath returns the default location for the BoltDB file.
//
// On Windows, this will typically resolve to:
//   C:\Users\<user>\Documents\BioWare\Mass Effect 3\sfsdatabase.db
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

	// Ensure the bucket exists before serving requests.
	if err := ensureBucket(db); err != nil {
		panic(err)
	}

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
