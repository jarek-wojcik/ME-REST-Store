Class DrawBoxComponent extends PrimitiveComponent
    native
    noexport
    editinlinenew
    collapsecategories;

var(DrawBoxComponent) Color BoxColor;
var(DrawBoxComponent) Material BoxMaterial;
var(DrawBoxComponent) Vector BoxExtent;
var(DrawBoxComponent) bool bDrawWireBox;
var(DrawBoxComponent) bool bDrawLitBox;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BoxColor = {B = 0, G = 0, R = 255, A = 255}
    BoxExtent = {X = 200.0, Y = 200.0, Z = 200.0}
    bDrawWireBox = TRUE
    ReplacementPrimitive = None
    HiddenGame = TRUE
}