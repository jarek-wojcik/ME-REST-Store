package controllers

// MissionParamsController will handle HTTP routes for configuring match
// parameters (map, difficulty, wave count, enemy faction, etc.).
// Currently a stub — routes will be added as the feature is built out.
type MissionParamsController struct{}

func NewMissionParamsController() *MissionParamsController {
	return &MissionParamsController{}
}

// Register wires mission-parameter routes onto the default mux.
func (c *MissionParamsController) Register() {
	// TODO: add mission parameter routes here
}
