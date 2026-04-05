Class RB_ForceFieldExcludeVolume extends Volume
    native
    placeable;

var(RB_ForceFieldExcludeVolume) int ForceFieldChannel;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        BlockNonZeroExtent = FALSE
        bDisableAllRigidBody = FALSE
    End Template
    ForceFieldChannel = 1
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}