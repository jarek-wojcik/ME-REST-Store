Class PathBlockingVolume extends Volume
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        BlockActors = TRUE
        BlockZeroExtent = TRUE
        BlockRigidBody = TRUE
        AlwaysLoadOnClient = FALSE
        AlwaysLoadOnServer = FALSE
    End Template
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bWorldGeometry = TRUE
    bCollideActors = FALSE
    bBlockActors = TRUE
}