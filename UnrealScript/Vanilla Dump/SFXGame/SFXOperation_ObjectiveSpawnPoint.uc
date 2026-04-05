Class SFXOperation_ObjectiveSpawnPoint extends BioStartLocation
    placeable;

enum EObjectiveLocation
{
    EObjectiveLocation_Table,
    EObjectiveLocation_Floor,
};

var(SFXOperation_ObjectiveSpawnPoint) array<string> SupportedSpawnTags;
var(SpawnPoint) float Weight;
var transient float DynamicWeight;
var(SFXOperation_ObjectiveSpawnPoint) SFXCombatZone CombatZone;
var(SFXOperation_ObjectiveSpawnPoint) Actor AnnexZoneLocation;
var(SFXOperation_ObjectiveSpawnPoint) EObjectiveLocation SpawnLocation;

public final simulated function bool IsObjectiveValidForSpawn(SFXOperation_ObjectiveData ObjectiveData)
{
    local string RequiredSpawnTagIter;
    local string ObjectiveDataSpawnTagIter;
    local bool SpawnTagFound;
    local int Index;
    local bool SpawnLocFound;
    
    if (ObjectiveData.MeshAssets.Length > 0)
    {
        for (Index = 0; Index < ObjectiveData.MeshAssets.Length; Index++)
        {
            if (int(ObjectiveData.MeshAssets[Index].SpawnLocation) == int(SpawnLocation))
            {
                SpawnLocFound = TRUE;
                break;
            }
        }
        if (!SpawnLocFound)
        {
            return FALSE;
        }
    }
    foreach ObjectiveData.RequiredSpawnTags(ObjectiveDataSpawnTagIter, )
    {
        SpawnTagFound = FALSE;
        foreach SupportedSpawnTags(RequiredSpawnTagIter, )
        {
            if (RequiredSpawnTagIter == ObjectiveDataSpawnTagIter)
            {
                SpawnTagFound = TRUE;
                break;
            }
        }
        if (!SpawnTagFound)
        {
            return FALSE;
        }
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Weight = 1.0
    Components = (CollisionCylinder, None, None, None)
    CollisionComponent = CollisionCylinder
}