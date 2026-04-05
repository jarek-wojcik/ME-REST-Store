Class PostProcessEffect
    native;

var(PostProcessEffect) Name EffectName;
var int NodePosY;
var int NodePosX;
var int DrawWidth;
var int DrawHeight;
var int OutDrawY;
var int InDrawY;
var(PostProcessEffect) bool bShowInEditor;
var(PostProcessEffect) bool bShowInGame;
var(PostProcessEffect) bool bUseWorldSettings;
var(PostProcessEffect) bool bMergePostUber;
var bool bAffectsLightingOnly;
var(PostProcessEffect) ESceneDepthPriorityGroup SceneDPG;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bShowInEditor = TRUE
    bShowInGame = TRUE
    SceneDPG = ESceneDepthPriorityGroup.SDPG_PostProcess
}