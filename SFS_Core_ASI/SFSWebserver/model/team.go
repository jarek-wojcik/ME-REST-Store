package model

// Team is a named group of bots in the Strike Teams tab.
// Future fields (e.g. Bots []Bot) will be added here; the JSON encoding
// in BoltDB handles schema evolution gracefully as long as new fields are
// optional/zero-valued.
type Team struct {
	ID     string `json:"id"`
	Name   string `json:"name"`
	Active bool   `json:"active,omitempty"` // only one team may be active at a time
}
