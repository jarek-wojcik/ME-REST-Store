Class SFSMissionSettingsModel;

struct SFSMissionSettingsStruct 
{
    var bool bDisableObjectiveWaves;
    // 1-10 matching the UI; 0 or 1 = start from the beginning (no skip)
    var int StartWave;
    // 0 = use game default (8)
    var int MaxEnemies;
    // 0 = use game default (5)
    var int MaxEnemiesPerSpawnPoint;
    // EnemyArchetypeName strings (e.g. "Char_Enemies.Archetypes.Cerberus.Phantom")
    // that should be suppressed from all horde waves.
    var array<string> BlockedEnemyArchetypes;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}