package model

// MissionSettings holds per-mission behaviour flags that can be queried by
// the ME3 game layer before a match starts.
// Additional fields will be added here as the system grows.
type MissionSettings struct {
	// DisableObjectiveWaves prevents objective waves from spawning during a
	// Firebase mission when set to true.
	DisableObjectiveWaves bool `json:"disableObjectiveWaves"`
	// StartWave is the wave number (1–10, UI-facing) to jump to at match start.
	// 0 or 1 means start from the beginning (default).
	StartWave int `json:"startWave"`
	// MaxEnemies overrides the maximum number of enemies alive simultaneously.
	// 0 means use the game default (8).
	MaxEnemies int `json:"maxEnemies"`
	// MaxEnemiesPerSpawnPoint overrides the per-spawn-point enemy cap.
	// 0 means use the game default (5).
	MaxEnemiesPerSpawnPoint int `json:"maxEnemiesPerSpawnPoint"`
	// EnabledEnemies is a whitelist of enemy archetype names allowed to spawn.
	// If empty, all enemies are allowed (no restriction).
	// e.g. "Char_Enemies.Archetypes.Cerberus.Centurion"
	EnabledEnemies []string `json:"enabledEnemies"`
	// CrossFactionEnemies allows the enabled enemy list to pull in enemy types
	// from factions other than the one selected in the lobby.
	// When false (default), only waves whose pool contains at least one enabled
	// type are modified — off-faction waves are left untouched.
	CrossFactionEnemies bool `json:"crossFactionEnemies"`
}
