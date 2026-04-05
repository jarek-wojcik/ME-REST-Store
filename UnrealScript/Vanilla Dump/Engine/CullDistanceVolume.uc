Class CullDistanceVolume extends Volume
    native
    placeable;

struct native CullDistanceSizePair 
{
    var(CullDistanceSizePair) float Size;
    var(CullDistanceSizePair) float CullDistance;
};

var(CullDistanceVolume) array<CullDistanceSizePair> CullDistances;
var(CullDistanceVolume) bool bEnabled;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        CollideActors = FALSE
        BlockNonZeroExtent = FALSE
    End Template
    CullDistances = ({Size = 0.0, CullDistance = 0.0}, 
                     {Size = 10000.0, CullDistance = 0.0}
                    )
    bEnabled = TRUE
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bCollideActors = FALSE
}