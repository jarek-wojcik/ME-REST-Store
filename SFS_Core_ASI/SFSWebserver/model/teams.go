package model

import (
	"encoding/json"

	bolt "go.etcd.io/bbolt"
)

const teamsBucket = "teams"

// ensureTeamsBucket creates the teams bucket if it does not already exist.
func ensureTeamsBucket(db *bolt.DB) error {
	return db.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(teamsBucket))
		return err
	})
}

// listTeams returns all teams ordered by insertion (BoltDB key order).
func listTeams(db *bolt.DB) ([]Team, error) {
	var teams []Team
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(teamsBucket))
		if b == nil {
			return nil
		}
		return b.ForEach(func(_, v []byte) error {
			var t Team
			if err := json.Unmarshal(v, &t); err != nil {
				return err
			}
			teams = append(teams, t)
			return nil
		})
	})
	return teams, err
}

// createTeam persists a new team and returns it.
func createTeam(db *bolt.DB, name string) (Team, error) {
	t := Team{ID: newID(), Name: name}
	data, err := json.Marshal(t)
	if err != nil {
		return Team{}, err
	}
	err = db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(teamsBucket))
		return b.Put([]byte(t.ID), data)
	})
	return t, err
}

// deleteTeam removes a team by ID. Returns false if the ID did not exist.
func deleteTeam(db *bolt.DB, id string) (bool, error) {
	var existed bool
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(teamsBucket))
		if b.Get([]byte(id)) != nil {
			existed = true
			return b.Delete([]byte(id))
		}
		return nil
	})
	return existed, err
}
