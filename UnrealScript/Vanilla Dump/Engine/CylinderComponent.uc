Class CylinderComponent extends PrimitiveComponent
    native
    noexport
    editinlinenew
    collapsecategories;

var(CylinderComponent) const export float CollisionHeight;
var(CylinderComponent) const export float CollisionRadius;
var(CylinderComponent) const Color CylinderColor;
var const bool bDrawBoundingBox;
var const bool bDrawNonColliding;
var const bool bAlwaysRenderIfSelected;

public final native function SetCylinderSize(float NewRadius, float NewHeight);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CollisionHeight = 22.0
    CollisionRadius = 22.0
    CylinderColor = {B = 157, G = 149, R = 223, A = 255}
    bDrawBoundingBox = TRUE
    ReplacementPrimitive = None
    HiddenGame = TRUE
    bCastDynamicShadow = FALSE
    BlockZeroExtent = TRUE
    BlockNonZeroExtent = TRUE
}