package model

// MissionSettings holds per-mission behaviour flags that can be queried by
// the ME3 game layer before a match starts.
// Additional fields will be added here as the system grows.
type MissionSettings struct {
	// DisableObjectiveWaves prevents objective waves from spawning during a
	// Firebase mission when set to true.
	DisableObjectiveWaves bool `json:"disableObjectiveWaves"`
	// MaxEnemies overrides the maximum number of enemies alive simultaneously.
	// 0 means use the game default (8).
	MaxEnemies int `json:"maxEnemies"`
	// MaxEnemiesPerSpawnPoint overrides the per-spawn-point enemy cap.
	// 0 means use the game default (5).
	MaxEnemiesPerSpawnPoint int `json:"maxEnemiesPerSpawnPoint"`
}
