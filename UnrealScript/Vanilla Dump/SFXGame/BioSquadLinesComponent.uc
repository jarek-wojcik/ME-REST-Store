Class BioSquadLinesComponent extends PrimitiveComponent
    native
    editinlinenew
    collapsecategories;

var transient Color vPlayPenLineColor;
var transient Color vSquadLeaderColor;
var transient Color vSquadMemberColor;
var transient Color vSquadAssetColor;
var transient Color vDynamicCoverColor;
var transient bool bInited;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    vPlayPenLineColor = {B = 184, G = 109, R = 247, A = 255}
    vSquadLeaderColor = {B = 0, G = 255, R = 0, A = 255}
    vSquadMemberColor = {B = 255, G = 0, R = 0, A = 255}
    vSquadAssetColor = {B = 255, G = 255, R = 0, A = 255}
    ReplacementPrimitive = None
}