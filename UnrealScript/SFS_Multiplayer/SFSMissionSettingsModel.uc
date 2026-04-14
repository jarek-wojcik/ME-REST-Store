Class SFSMissionSettingsModel;

struct SFSMissionSettingsStruct 
{
    var bool bDisableObjectiveWaves;
    var int StartWave;
    var int MaxEnemies;
    var int MaxEnemiesPerSpawnPoint;
    var array<string> BlockedEnemyArchetypes;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}