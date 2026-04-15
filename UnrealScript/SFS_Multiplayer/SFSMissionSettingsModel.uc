Class SFSMissionSettingsModel;

struct SFSMissionSettingsStruct 
{
    var bool bDisableObjectiveWaves;
    var int StartWave;
    var int MaxEnemies;
    var int MaxEnemiesPerSpawnPoint;
    var array<string> EnabledEnemyArchetypes;
    var array<int> EnabledEnemyRatios;
    var bool bCrossFactionEnemies;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}