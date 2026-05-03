package controllers

import (
	"encoding/json"
	"fmt"
	"sort"
	"time"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

const teamsBucket = "teams"

// EnsureTeamsBucket creates the teams bucket if it does not already exist.
func EnsureTeamsBucket(db *bolt.DB) error {
	return db.Update(func(tx *bolt.Tx) error {
		_, err := tx.CreateBucketIfNotExists([]byte(teamsBucket))
		return err
	})
}

// listTeams returns all teams ordered by insertion (BoltDB key order).
func listTeams(db *bolt.DB) ([]model.Team, error) {
	var teams []model.Team
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(teamsBucket))
		if b == nil {
			return nil
		}
		return b.ForEach(func(_, v []byte) error {
			var t model.Team
			if err := json.Unmarshal(v, &t); err != nil {
				return err
			}
			teams = append(teams, t)
			return nil
		})
	})
	sort.Slice(teams, func(i, j int) bool {
		return teams[i].CreatedAt > teams[j].CreatedAt
	})
	return teams, err
}

// createTeam persists a new team and returns it.
func createTeam(db *bolt.DB, name string) (model.Team, error) {
	t := model.Team{ID: newID(), Name: name, CreatedAt: time.Now().UnixNano()}
	data, err := json.Marshal(t)
	if err != nil {
		return model.Team{}, err
	}
	err = db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(teamsBucket))
		return b.Put([]byte(t.ID), data)
	})
	return t, err
}

// getTeam fetches a single team by ID.
func getTeam(db *bolt.DB, id string) (model.Team, error) {
	var t model.Team
	err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(teamsBucket))
		if b == nil {
			return fmt.Errorf("team not found")
		}
		v := b.Get([]byte(id))
		if v == nil {
			return fmt.Errorf("team not found")
		}
		return json.Unmarshal(v, &t)
	})
	return t, err
}

// toggleTeamActive flips the Active flag for a team.
// When activating, all other teams are deactivated in the same transaction.
func toggleTeamActive(db *bolt.DB, id string) (model.Team, error) {
	var t model.Team
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(teamsBucket))
		v := b.Get([]byte(id))
		if v == nil {
			return fmt.Errorf("team not found")
		}
		if err := json.Unmarshal(v, &t); err != nil {
			return err
		}
		t.Active = !t.Active
		if t.Active {
			if err := b.ForEach(func(k, val []byte) error {
				if string(k) == id {
					return nil
				}
				var other model.Team
				if err := json.Unmarshal(val, &other); err != nil {
					return err
				}
				if !other.Active {
					return nil
				}
				other.Active = false
				data, err := json.Marshal(other)
				if err != nil {
					return err
				}
				return b.Put(k, data)
			}); err != nil {
				return err
			}
		}
		data, err := json.Marshal(t)
		if err != nil {
			return err
		}
		return b.Put([]byte(id), data)
	})
	return t, err
}

// renameTeam updates the Name field of a team.
func renameTeam(db *bolt.DB, id, name string) (model.Team, error) {
	var t model.Team
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(teamsBucket))
		v := b.Get([]byte(id))
		if v == nil {
			return fmt.Errorf("team not found")
		}
		if err := json.Unmarshal(v, &t); err != nil {
			return err
		}
		t.Name = name
		data, err := json.Marshal(t)
		if err != nil {
			return err
		}
		return b.Put([]byte(id), data)
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
