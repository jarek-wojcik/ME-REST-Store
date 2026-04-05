Class DrawCapsuleComponent extends PrimitiveComponent
    native
    noexport
    editinlinenew
    collapsecategories;

var(DrawCapsuleComponent) Color CapsuleColor;
var(DrawCapsuleComponent) Material CapsuleMaterial;
var(DrawCapsuleComponent) float CapsuleHeight;
var(DrawCapsuleComponent) float CapsuleRadius;
var(DrawCapsuleComponent) bool bDrawWireCapsule;
var(DrawCapsuleComponent) bool bDrawLitCapsule;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CapsuleColor = {B = 0, G = 0, R = 255, A = 255}
    CapsuleHeight = 200.0
    CapsuleRadius = 200.0
    bDrawWireCapsule = TRUE
    ReplacementPrimitive = None
    HiddenGame = TRUE
}