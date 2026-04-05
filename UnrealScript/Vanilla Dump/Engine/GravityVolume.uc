Class GravityVolume extends PhysicsVolume
    native
    placeable;

var(GravityVolume) float GravityZ;
var(GravityVolume) float RBPhysicsGravityScaling;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    GravityZ = -520.0
    RBPhysicsGravityScaling = 1.0
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}