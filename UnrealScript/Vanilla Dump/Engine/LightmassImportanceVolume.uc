Class LightmassImportanceVolume extends Volume
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        RBChannel = ERBCollisionChannel.RBCC_Nothing
        CollideActors = FALSE
        BlockNonZeroExtent = FALSE
    End Template
    BrushColor = {B = 25, G = 255, R = 255, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bCollideActors = FALSE
}