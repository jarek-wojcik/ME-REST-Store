package model

import (
	"crypto/rand"
	"fmt"
)

// newID generates a random 16-character hex string suitable for use as an
// entity ID across all BoltDB buckets (teams, bots, etc.).
func newID() string {
	b := make([]byte, 8)
	_, _ = rand.Read(b)
	return fmt.Sprintf("%x", b)
}
