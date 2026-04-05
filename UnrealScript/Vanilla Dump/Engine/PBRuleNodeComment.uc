Class PBRuleNodeComment extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

var(PBRuleNodeComment) int SizeX;
var(PBRuleNodeComment) int SizeY;
var(PBRuleNodeComment) int BorderWidth;
var(PBRuleNodeComment) Color BorderColor;
var(PBRuleNodeComment) Color FillColor;
var(PBRuleNodeComment) bool bFilled;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SizeX = 128
    SizeY = 64
    BorderWidth = 1
    BorderColor = {B = 0, G = 0, R = 0, A = 255}
    FillColor = {B = 255, G = 255, R = 255, A = 16}
    bFilled = TRUE
    NextRules = ()
}