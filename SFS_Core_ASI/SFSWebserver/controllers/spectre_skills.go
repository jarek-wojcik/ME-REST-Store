package controllers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"sfswebserver/model"

	bolt "go.etcd.io/bbolt"
)

// SkillSegment is one of the ten level-block indicators rendered in the UI.
// CapstoneChoice is one of the three capstone options shown for a capstone level.
type CapstoneChoice struct {
	Selected    bool
	ChoiceNum   int
	ChoiceLabel string
	Description string
	SelectURL   string
	Enabled     bool
}

// SkillSegment is one of the ten level-block indicators rendered in the UI.
type SkillSegment struct {
	Filled          bool
	LevelNum        int    // 1-indexed level this segment represents
	Description     string // tooltip text shown on hover
	SetLevelURL     string // POST: sets skill to exactly this level
	CapstoneChoices []CapstoneChoice
	SelectedCapstoneLabel string // short label of selected capstone for quick/condensed UI
}

// SkillView is the template-facing view for one skill row on the character sheet.
type SkillView struct {
	Def          *model.SkillDef
	Level        int
	CanLevelUp   bool // true when SkillPoints > 0 and Level < MaxSkillLevel
	CanLevelDown bool // true when Level > 0
	LevelUpURL   string
	LevelDownURL string
	Segments     []SkillSegment // always MaxSkillLevel entries
}

// spectreSkillViews builds the ordered list of SkillViews for the character sheet.
// Conditional skills (BarrierOnly / ShieldOnly) are filtered here based on the
// spectre's current shield type.
func spectreSkillViews(s model.Spectre, spectreID string) []SkillView {
	isBarrier := s.ShieldType == "Barrier"
	base := "/api/spectres/" + spectreID + "/skill/"

	var views []SkillView
	for i := range model.SkillCatalog {
		def := &model.SkillCatalog[i]
		if def.BarrierOnly && !isBarrier {
			continue
		}
		if def.ShieldOnly && isBarrier {
			continue
		}

		level := s.SkillLevels[def.ID]
		capstoneSelections := s.SkillCapstoneChoices[def.ID]
		segments := make([]SkillSegment, model.MaxSkillLevel)
		for j := 0; j < model.MaxSkillLevel; j++ {
			levelNum := j + 1
			segment := SkillSegment{
				Filled:      j < level,
				LevelNum:    levelNum,
				Description: def.Descriptions[j],
				SetLevelURL: fmt.Sprintf("%s%s/set/%d", base, def.ID, levelNum),
			}
			// Build capstone choices for this level from the skill definition.
			caps := model.CapstonesForLevel(def, levelNum)
			if len(caps) > 0 {
				segment.CapstoneChoices = make([]CapstoneChoice, len(caps))
				for choiceIndex, cap := range caps {
					choiceLabel := cap.Title
					if choiceLabel == "" {
						choiceLabel = fmt.Sprintf("%c", 'A'+choiceIndex)
					}
					selected := false
					if capstoneSelections != nil {
						selectedChoice, ok := capstoneSelections[fmt.Sprint(levelNum)]
						selected = ok && selectedChoice == choiceIndex
					}
					// capstone is enabled when the spectre already has the level,
					// or when they can afford to raise the skill to that level
					enabled := false
					if level >= levelNum {
						enabled = true
					} else {
						need := levelNum - level
						if s.SkillPoints >= need {
							enabled = true
						}
					}
					// When a capstone is already selected, clicking it again should
					// clear the skill (set level to 0). Otherwise it selects the
					// capstone (and raises the skill to that level if needed).
					selectURL := fmt.Sprintf("%s%s/capstone/%d/%d", base, def.ID, levelNum, choiceIndex+1)
					if selected {
						// toggle-off behavior: clear the skill to level 0
						selectURL = fmt.Sprintf("%s%s/set/0", base, def.ID)
					}
					desc := cap.Description
					if desc == "" {
						desc = fmt.Sprintf("Capstone %s for level %d", choiceLabel, levelNum)
					}
					segment.CapstoneChoices[choiceIndex] = CapstoneChoice{
						Selected:    selected,
						ChoiceNum:   choiceIndex + 1,
						ChoiceLabel: choiceLabel,
						Description: desc,
						SelectURL:   selectURL,
						Enabled:     enabled,
					}
					if selected {
						segment.SelectedCapstoneLabel = choiceLabel
					}
				}
			}
			segments[j] = segment
		}
		views = append(views, SkillView{
			Def:          def,
			Level:        level,
			CanLevelUp:   level < model.MaxSkillLevel && s.SkillPoints > 0,
			CanLevelDown: level > 0,
			LevelUpURL:   base + def.ID + "/up",
			LevelDownURL: base + def.ID + "/down",
			Segments:     segments,
		})
	}
	return views
}

// setSpectreSkillAbsolute sets a skill to an exact level, adjusting SkillPoints
// accordingly. Spending points is capped by the available pool; refunds are
// always allowed. targetLevel must be in [0, MaxSkillLevel].
func setSpectreSkillAbsolute(db *bolt.DB, spectreID, skillID string, targetLevel int) (model.Spectre, error) {
	if model.SkillByID(skillID) == nil {
		return model.Spectre{}, fmt.Errorf("unknown skill: %s", skillID)
	}
	if targetLevel < 0 || targetLevel > model.MaxSkillLevel {
		return model.Spectre{}, fmt.Errorf("level must be 0–%d", model.MaxSkillLevel)
	}
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return fmt.Errorf("spectre not found")
		}
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.MigrateWeapons()
		s.MigrateSkills()

		current := s.SkillLevels[skillID]
		delta := targetLevel - current
		if delta == 0 {
			return nil // no-op
		}
		if delta > 0 && s.SkillPoints < delta {
			return fmt.Errorf("not enough skill points")
		}
		s.SkillLevels[skillID] = targetLevel
		s.SkillPoints -= delta // positive spend reduces pool; negative refund increases it
		clearObsoleteCapstones(&s, skillID, targetLevel)

		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// updateSpectreSkillLevel spends (delta=+1) or refunds (delta=-1) one skill
// point for the given skill. Returns an error when the operation is invalid
// (no points, skill at max/min, unknown skill ID).
func updateSpectreSkillLevel(db *bolt.DB, spectreID, skillID string, delta int) (model.Spectre, error) {
	if model.SkillByID(skillID) == nil {
		return model.Spectre{}, fmt.Errorf("unknown skill: %s", skillID)
	}
	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return fmt.Errorf("spectre not found")
		}
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.MigrateWeapons()
		s.MigrateSkills()

		current := s.SkillLevels[skillID]
		if delta > 0 {
			if s.SkillPoints <= 0 {
				return fmt.Errorf("no skill points remaining")
			}
			if current >= model.MaxSkillLevel {
				return fmt.Errorf("skill already at maximum level")
			}
			s.SkillLevels[skillID] = current + 1
			s.SkillPoints--
		} else {
			if current <= 0 {
				return fmt.Errorf("skill already at minimum level")
			}
			s.SkillLevels[skillID] = current - 1
			s.SkillPoints++
		}
		clearObsoleteCapstones(&s, skillID, s.SkillLevels[skillID])

		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

func clearObsoleteCapstones(s *model.Spectre, skillID string, newLevel int) {
	if s.SkillCapstoneChoices == nil {
		return
	}
	choices, ok := s.SkillCapstoneChoices[skillID]
	if !ok {
		return
	}
	def := model.SkillByID(skillID)
	if def == nil {
		return
	}
	for _, c := range def.Capstones {
		// c.Level is zero-based; stored choice keys use 1-based UI levels.
		if c.Level >= newLevel {
			delete(choices, fmt.Sprint(c.Level+1))
		}
	}
	if len(choices) == 0 {
		delete(s.SkillCapstoneChoices, skillID)
	}
}

func setSpectreCapstoneChoice(db *bolt.DB, spectreID, skillID string, capstoneLevel, choice int) (model.Spectre, error) {
	def := model.SkillByID(skillID)
	if def == nil {
		return model.Spectre{}, fmt.Errorf("unknown skill: %s", skillID)
	}
	caps := model.CapstonesForLevel(def, capstoneLevel)
	if len(caps) == 0 {
		return model.Spectre{}, fmt.Errorf("invalid capstone level: %d", capstoneLevel)
	}
	if choice < 0 || choice >= len(caps) {
		return model.Spectre{}, fmt.Errorf("invalid capstone choice: %d", choice)
	}

	var s model.Spectre
	err := db.Update(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(spectresBucket))
		if b == nil {
			return fmt.Errorf("spectre not found")
		}
		v := b.Get([]byte(spectreID))
		if v == nil {
			return fmt.Errorf("spectre not found")
		}
		if err := json.Unmarshal(v, &s); err != nil {
			return err
		}
		s.MigrateWeapons()
		s.MigrateSkills()

		current := s.SkillLevels[skillID]
		if current < capstoneLevel {
			delta := capstoneLevel - current
			if s.SkillPoints < delta {
				return fmt.Errorf("not enough skill points")
			}
			s.SkillLevels[skillID] = capstoneLevel
			s.SkillPoints -= delta
		}
		if s.SkillCapstoneChoices == nil {
			s.SkillCapstoneChoices = make(map[string]map[string]int)
		}
		if s.SkillCapstoneChoices[skillID] == nil {
			s.SkillCapstoneChoices[skillID] = make(map[string]int)
		}
		s.SkillCapstoneChoices[skillID][fmt.Sprint(capstoneLevel)] = choice
		clearObsoleteCapstones(&s, skillID, s.SkillLevels[skillID])

		data, err := json.Marshal(s)
		if err != nil {
			return err
		}
		return b.Put([]byte(spectreID), data)
	})
	return s, err
}

// RegisterSkillRoutes wires the skill HTTP routes onto the default mux.
// Must be called from SpectreController.Register().
func (c *SpectreController) RegisterSkillRoutes() {
	// POST /api/spectres/{id}/skill/{skillId}/up
	// Spends one skill point to advance the given skill by one level.
	http.HandleFunc("POST /api/spectres/{id}/skill/{skillId}/up", func(w http.ResponseWriter, r *http.Request) {
		s, err := updateSpectreSkillLevel(c.db, r.PathValue("id"), r.PathValue("skillId"), +1)
		if err != nil {
			respondText(w, 400, err.Error()+"\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/skill/{skillId}/down
	// Refunds one skill point by reducing the given skill by one level.
	http.HandleFunc("POST /api/spectres/{id}/skill/{skillId}/down", func(w http.ResponseWriter, r *http.Request) {
		s, err := updateSpectreSkillLevel(c.db, r.PathValue("id"), r.PathValue("skillId"), -1)
		if err != nil {
			respondText(w, 400, err.Error()+"\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/skill/{skillId}/set/{level}
	// Sets the skill to exactly the given level [0-10], adjusting the point pool.
	http.HandleFunc("POST /api/spectres/{id}/skill/{skillId}/set/{level}", func(w http.ResponseWriter, r *http.Request) {
		var level int
		if _, err := fmt.Sscan(r.PathValue("level"), &level); err != nil {
			respondText(w, 400, "invalid level\n")
			return
		}
		s, err := setSpectreSkillAbsolute(c.db, r.PathValue("id"), r.PathValue("skillId"), level)
		if err != nil {
			respondText(w, 400, err.Error()+"\n")
			return
		}
		c.renderCard(w, s, false)
	})

	// POST /api/spectres/{id}/skill/{skillId}/capstone/{level}/{choice}
	// Selects one of the three capstone options for the given skill capstone level.
	http.HandleFunc("POST /api/spectres/{id}/skill/{skillId}/capstone/{level}/{choice}", func(w http.ResponseWriter, r *http.Request) {
		level, err := strconv.Atoi(r.PathValue("level"))
		if err != nil {
			respondText(w, 400, "invalid level\n")
			return
		}
		choice, err := strconv.Atoi(r.PathValue("choice"))
		if err != nil {
			respondText(w, 400, "invalid choice\n")
			return
		}
		s, err := setSpectreCapstoneChoice(c.db, r.PathValue("id"), r.PathValue("skillId"), level, choice-1)
		if err != nil {
			respondText(w, 400, err.Error()+"\n")
			return
		}
		c.renderCard(w, s, false)
	})
}
