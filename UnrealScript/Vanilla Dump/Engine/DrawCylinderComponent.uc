Class DrawCylinderComponent extends PrimitiveComponent
    native
    noexport
    editinlinenew
    collapsecategories;

var(DrawCylinderComponent) Color CylinderColor;
var(DrawCylinderComponent) Material CylinderMaterial;
var(DrawCylinderComponent) float CylinderRadius;
var(DrawCylinderComponent) float CylinderTopRadius;
var(DrawCylinderComponent) float CylinderHeight;
var(DrawCylinderComponent) float CylinderHeightOffset;
var(DrawCylinderComponent) int CylinderSides;
var(DrawCylinderComponent) bool bDrawWireCylinder;
var(DrawCylinderComponent) bool bDrawLitCylinder;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CylinderColor = {B = 0, G = 0, R = 255, A = 255}
    CylinderRadius = 100.0
    CylinderTopRadius = 100.0
    CylinderHeight = 100.0
    CylinderSides = 16
    bDrawWireCylinder = TRUE
    ReplacementPrimitive = None
    HiddenGame = TRUE
}