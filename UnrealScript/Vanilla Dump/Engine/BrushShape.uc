Class BrushShape extends Brush
    native
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        AlwaysLoadOnClient = TRUE
        LightingChannels = {bInitialized = TRUE, Dynamic = TRUE}
    End Template
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}