Class PBRuleNodeQuad extends PBRuleNodeBase
    native
    editinlinenew
    collapsecategories;

var(PBRuleNodeQuad) MaterialInterface Material;
var(PBRuleNodeQuad) float RepeatMaxSizeX;
var(PBRuleNodeQuad) float RepeatMaxSizeZ;
var(PBRuleNodeQuad) int QuadLightmapRes;
var(PBRuleNodeQuad) float YOffset;
var(PBRuleNodeQuad) bool bDisableMaterialRepeat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RepeatMaxSizeX = 512.0
    RepeatMaxSizeZ = 512.0
    QuadLightmapRes = 32
    NextRules = ()
}