Class EnvironmentVolume extends Volume
    implements(Interface_NavMeshPathObstacle, Interface_NavMeshPathObject)
    native
    placeable;

var const native noexport Pointer VfTable_IInterface_NavMeshPathObstacle;
var const native noexport Pointer VfTable_IInterface_NavMeshPathObject;
var const transient bool bSplitNavMesh;

public final native function SetSplitNavMesh(bool bNewValue);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}