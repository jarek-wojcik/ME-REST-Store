Class DrawSphereComponent extends PrimitiveComponent
    native
    noexport
    editinlinenew
    collapsecategories;

var(DrawSphereComponent) Color SphereColor;
var(DrawSphereComponent) Material SphereMaterial;
var(DrawSphereComponent) float SphereRadius;
var(DrawSphereComponent) int SphereSides;
var(DrawSphereComponent) bool bDrawWireSphere;
var(DrawSphereComponent) bool bDrawLitSphere;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SphereColor = {B = 0, G = 0, R = 255, A = 255}
    SphereRadius = 100.0
    SphereSides = 16
    bDrawWireSphere = TRUE
    ReplacementPrimitive = None
    HiddenGame = TRUE
}