Class SFXOperation_ObjectiveData
    perobjectconfig
    config(Game);

struct SFXOperation_ObjectiveMeshInfo 
{
    var string UniqueString;
    var string MeshPath;
    var Vector Translation;
    var Rotator Rotation;
    var stringref GameName;
    var int MeshVOLine;
    var float Scale;
    var EObjectiveLocation SpawnLocation;
    var ETargetTipText TipText;
};

var config string ObjectiveType;
var config biodynamicload string AssetPath;
var config array<string> RequiredSpawnTags;
var config array<SFXOperation_ObjectiveMeshInfo> MeshAssets;
var string ChosenMeshUniqueString;
var config float MinDistanceFromPlayerForSpawn;
var config bool PerformVisibilityCheckForSpawn;

public final function bool CanSelectedMeshSpawnAtLocation(SFXOperation_ObjectiveSpawnPoint SpawnPoint)
{
    local int Index;
    
    if (SpawnPoint == None)
    {
        return FALSE;
    }
    if (MeshAssets.Length == 0)
    {
        return TRUE;
    }
    Index = MeshAssets.Find('UniqueString', ChosenMeshUniqueString);
    if (Index == -1)
    {
        return FALSE;
    }
    return int(MeshAssets[Index].SpawnLocation) == int(SpawnPoint.SpawnLocation);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}