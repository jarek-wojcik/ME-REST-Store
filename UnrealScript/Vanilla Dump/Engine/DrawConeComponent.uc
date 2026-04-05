Class DrawConeComponent extends PrimitiveComponent
    native
    editinlinenew
    collapsecategories;

var(DrawConeComponent) Color ConeColor;
var(DrawConeComponent) float ConeRadius;
var(DrawConeComponent) float ConeAngle;
var(DrawConeComponent) int ConeSides;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ConeColor = {B = 255, G = 200, R = 150, A = 255}
    ConeRadius = 100.0
    ConeAngle = 44.0
    ConeSides = 16
    ReplacementPrimitive = None
    HiddenGame = TRUE
}