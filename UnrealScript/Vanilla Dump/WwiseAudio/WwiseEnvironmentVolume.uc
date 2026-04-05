Class WwiseEnvironmentVolume extends Volume
    native
    placeable;

var(WwiseEnvironmentVolume) float Priority;
var(WwiseEnvironmentVolume) editconst export WwiseEnvironmentSettings Settings;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        CollideActors = FALSE
        BlockNonZeroExtent = FALSE
    End Template
    Begin Object Class=WwiseEnvironmentSettings Name=pDefaultSettings
    End Object
    Settings = pDefaultSettings
    BrushColor = {B = 15, G = 75, R = 255, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bCollideActors = FALSE
}