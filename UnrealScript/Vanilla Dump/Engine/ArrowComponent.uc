Class ArrowComponent extends PrimitiveComponent
    native
    noexport
    editinlinenew
    collapsecategories;

var(ArrowComponent) Color ArrowColor;
var(ArrowComponent) float ArrowSize;
var(ArrowComponent) bool bTreatAsASprite;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ArrowColor = {B = 0, G = 0, R = 255, A = 255}
    ArrowSize = 1.0
    ReplacementPrimitive = None
    HiddenGame = TRUE
    AlwaysLoadOnClient = FALSE
    AlwaysLoadOnServer = FALSE
}