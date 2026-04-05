Class SFXEnemySpawnPoint extends NavigationPoint
    placeable;

var(SpawnPoint) array<EAICustomAction> SupportedCustomActions;
var(SpawnPoint) array<Class<SFXCustomReachSpec>> SupportedReachSpecs;
var(SpawnPoint) float Weight;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Weight = 1.0
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}