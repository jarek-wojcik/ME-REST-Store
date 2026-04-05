Class SplineMeshComponent extends StaticMeshComponent
    native
    editinlinenew;

struct native SplineMeshParams 
{
    var Vector StartPos;
    var Vector StartTangent;
    var Vector EndPos;
    var Vector EndTangent;
    var Vector2D StartScale;
    var Vector2D StartOffset;
    var Vector2D EndScale;
    var Vector2D EndOffset;
    var float StartRoll;
    var float EndRoll;
};

var SplineMeshParams SplineParams;
var Vector SplineXDir;
var bool bSmoothInterpRollScale;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SplineXDir = {X = 1.0, Y = 0.0, Z = 0.0}
    ReplacementPrimitive = None
    bUseAsOccluder = FALSE
    bUsePrecomputedShadows = TRUE
}