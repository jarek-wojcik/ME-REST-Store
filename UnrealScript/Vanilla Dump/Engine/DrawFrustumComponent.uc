Class DrawFrustumComponent extends PrimitiveComponent
    native
    noexport
    editinlinenew
    collapsecategories;

var(DrawFrustumComponent) Color FrustumColor;
var(DrawFrustumComponent) float FrustumAngle;
var(DrawFrustumComponent) float FrustumAspectRatio;
var(DrawFrustumComponent) float FrustumStartDist;
var(DrawFrustumComponent) float FrustumEndDist;
var(DrawFrustumComponent) Texture Texture;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FrustumColor = {B = 255, G = 0, R = 255, A = 255}
    FrustumAngle = 90.0
    FrustumAspectRatio = 1.33333004
    FrustumStartDist = 100.0
    FrustumEndDist = 1000.0
    ReplacementPrimitive = None
    HiddenGame = TRUE
}