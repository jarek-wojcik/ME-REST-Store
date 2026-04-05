Class WwiseOcclusionVolume extends Volume
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        bAcceptsLights = FALSE
        BlockZeroExtent = TRUE
        BlockNonZeroExtent = FALSE
    End Template
    BrushColor = {B = 255, G = 0, R = 0, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    OverridePhysMat = TRUE
}