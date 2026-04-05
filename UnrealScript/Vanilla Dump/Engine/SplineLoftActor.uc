Class SplineLoftActor extends SplineActor
    native
    placeable;

var editinline export array<SplineMeshComponent> SplineMeshComps;
var(SplineLoftActor) const array<MaterialInterface> DeformMeshMaterials;
var(SplineLoftActor) Vector WorldXDir;
var(SplineLoftActor) Vector2D Offset;
var(SplineLoftActor) float ScaleX;
var(SplineLoftActor) float ScaleY;
var(SplineLoftActor) const StaticMesh DeformMesh;
var(SplineLoftActor) float Roll;
var(SplineLoftActor) bool bSmoothInterpRollAndScale;
var(SplineLoftActor) bool bAcceptsLights;
var(SplineLoftActor) bool bCastShadow;

public native function ClearLoftMesh();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WorldXDir = {X = 1.0, Y = 0.0, Z = 0.0}
    ScaleX = 1.0
    ScaleY = 1.0
    bSmoothInterpRollAndScale = TRUE
    bAcceptsLights = TRUE
    bStatic = TRUE
    bWorldGeometry = TRUE
    bGameRelevant = TRUE
    bMovable = FALSE
    bCollideActors = TRUE
    bBlockActors = TRUE
    bEdShouldSnap = TRUE
}