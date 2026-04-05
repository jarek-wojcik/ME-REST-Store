Class LightComponent extends ActorComponent
    native
    noexport
    abstract;

enum EShadowFilterQuality
{
    SFQ_Low,
    SFQ_Medium,
    SFQ_High,
};
enum EShadowProjectionTechnique
{
    ShadowProjTech_Default,
    ShadowProjTech_PCF,
    ShadowProjTech_VSM,
    ShadowProjTech_BPCF_Low,
    ShadowProjTech_BPCF_Medium,
    ShadowProjTech_BPCF_High,
};
enum ELightShadowMode
{
    LightShadow_Normal,
    LightShadow_Modulate,
    LightShadow_ModulateBetter,
};
enum ELightAffectsClassification
{
    LAC_USER_SELECTED,
    LAC_DYNAMIC_AFFECTING,
    LAC_STATIC_AFFECTING,
    LAC_DYNAMIC_AND_STATIC_AFFECTING,
};
struct StaticLightingMaskContainer 
{
    var bool bInitialized;
    var(StaticLightingMaskContainer) bool Unnamed_1;
    var(StaticLightingMaskContainer) bool Unnamed_2;
    var(StaticLightingMaskContainer) bool Unnamed_3;
    var(StaticLightingMaskContainer) bool Unnamed_4;
    var(StaticLightingMaskContainer) bool Unnamed_5;
    var(StaticLightingMaskContainer) bool Unnamed_6;
    var(StaticLightingMaskContainer) bool Unnamed_7;
    var(StaticLightingMaskContainer) bool Unnamed_8;
    var(StaticLightingMaskContainer) bool Unnamed_9;
    var(StaticLightingMaskContainer) bool Unnamed_10;
    var(StaticLightingMaskContainer) bool Unnamed_11;
    var(StaticLightingMaskContainer) bool Unnamed_12;
    var(StaticLightingMaskContainer) bool Unnamed_13;
    var(StaticLightingMaskContainer) bool Unnamed_14;
    var(StaticLightingMaskContainer) bool Unnamed_15;
    var(StaticLightingMaskContainer) bool Unnamed_16;
};
struct LightingChannelContainer 
{
    var bool bInitialized;
    var(LightingChannelContainer) bool BSP;
    var(LightingChannelContainer) bool Static;
    var(LightingChannelContainer) bool Dynamic;
    var(LightingChannelContainer) bool CompositeDynamic;
    var(LightingChannelContainer) bool Skybox;
    var(LightingChannelContainer) bool Unnamed_1;
    var(LightingChannelContainer) bool Unnamed_2;
    var(LightingChannelContainer) bool Unnamed_3;
    var(LightingChannelContainer) bool Unnamed_4;
    var(LightingChannelContainer) bool Unnamed_5;
    var(LightingChannelContainer) bool Unnamed_6;
    var(LightingChannelContainer) bool Cinematic_1;
    var(LightingChannelContainer) bool Cinematic_2;
    var(LightingChannelContainer) bool Cinematic_3;
    var(LightingChannelContainer) bool Cinematic_4;
    var(LightingChannelContainer) bool Cinematic_5;
    var(LightingChannelContainer) bool Cinematic_6;
    var(LightingChannelContainer) bool Cinematic_7;
    var(LightingChannelContainer) bool Cinematic_8;
    var(LightingChannelContainer) bool Cinematic_9;
    var(LightingChannelContainer) bool Cinematic_10;
    var(LightingChannelContainer) bool Gameplay_1;
    var(LightingChannelContainer) bool Gameplay_2;
    var(LightingChannelContainer) bool Gameplay_3;
    var(LightingChannelContainer) bool Gameplay_4;
    var(LightingChannelContainer) bool Crowd;
};

var const transient native noimport Pointer SceneInfo;
var const transient native Matrix WorldToLight;
var const transient native Matrix LightToWorld;
var const duplicatetransient Guid LightGuid;
var const duplicatetransient Guid LightmapGuid;
var(LightComponent) const interp float Brightness;
var(LightComponent) const interp Color LightColor;
var(LightComponent) const export LightFunction Function;
var(LightComponent) const interp float LightEnv_BouncedLightBrightness;
var(LightComponent) const interp Color LightEnv_BouncedModulationColor;
var(LightComponent) const bool bEnabled;
var(LightComponent) const bool CastShadows;
var(LightComponent) const bool CastStaticShadows;
var(LightComponent) bool CastDynamicShadows;
var(LightComponent) bool bCastCompositeShadow;
var(LightComponent) bool bAffectCompositeShadowDirection;
var(LightComponent) bool bNonModulatedSelfShadowing;
var(LightComponent) interp bool bSelfShadowOnly;
var bool bAllowPreShadow;
var(LightComponent) const bool bForceDynamicLight;
var(LightComponent) const bool UseDirectLightMap;
var const bool bHasLightEverBeenBuiltIntoLightMap;
var(LightComponent) const bool bOnlyAffectSameAndSpecifiedLevels;
var(LightComponent) const bool bCanAffectDynamicPrimitivesOutsideDynamicChannel;
var(LightComponent) bool bUseVolumes;
var(LightShafts) bool bRenderLightShafts;
var const bool bPrecomputedLightingIsValid;
var(LightComponent) bool bAllowedToBypassLightEnvironments;
var bool bCullModulatedShadowOnSubject;
var(LightComponent) bool bAllowDynamicProjective;
var const editinline export LightEnvironmentComponent LightEnvironment;
var(LightComponent) const array<Name> OtherLevelsToAffect;
var(LightComponent) const LightingChannelContainer LightingChannels;
var const native array<Pointer> InclusionConvexVolumes;
var const native array<Pointer> ExclusionConvexVolumes;
var(LightComponent) const editconst ELightAffectsClassification LightAffectsClassification;
var(LightComponent) ELightShadowMode LightShadowMode;
var(LightComponent) LinearColor ModShadowColor;
var(LightComponent) float ModShadowFadeoutTime;
var(LightComponent) float ModShadowFadeoutExponent;
var const native duplicatetransient int LightListIndex;
var(LightComponent) EShadowProjectionTechnique ShadowProjectionTechnique;
var(LightComponent) EShadowFilterQuality ShadowFilterQuality;
var(LightComponent) int MinShadowResolution;
var(LightComponent) int MaxShadowResolution;
var(LightComponent) int ShadowFadeResolution;
var(LightShafts) float OcclusionDepthRange;
var(LightShafts) interp float BloomScale;
var(LightShafts) float BloomThreshold;
var(LightShafts) float BloomScreenBlendThreshold;
var(LightShafts) interp Color BloomTint;
var(LightShafts) float RadialBlurPercent;
var(LightShafts) interp float OcclusionMaskDarkness;

public final native function Vector GetDirection();

public final native function Vector GetOrigin();

public final native function SetEnabled(bool bSetEnabled);

public final native function SetLightProperties(optional float NewBrightness = Brightness, optional Color NewLightColor = LightColor, optional LightFunction NewLightFunction = Function);

public final native function UpdateColorAndBrightness();

public final native function UpdateLightShaftParameters();

public function OnUpdatePropertyBloomScale()
{
    UpdateLightShaftParameters();
}
public function OnUpdatePropertyBloomTint()
{
    UpdateLightShaftParameters();
}
public function OnUpdatePropertyOcclusionMaskDarkness()
{
    UpdateLightShaftParameters();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Brightness = 1.0
    LightColor = {B = 255, G = 255, R = 255, A = 0}
    LightEnv_BouncedLightBrightness = 1.0
    LightEnv_BouncedModulationColor = {B = 255, G = 255, R = 255, A = 0}
    bEnabled = TRUE
    CastShadows = TRUE
    CastStaticShadows = TRUE
    CastDynamicShadows = TRUE
    bCastCompositeShadow = TRUE
    bAffectCompositeShadowDirection = TRUE
    bPrecomputedLightingIsValid = TRUE
    LightingChannels = {
                        bInitialized = TRUE, 
                        BSP = TRUE, 
                        Static = TRUE, 
                        Dynamic = TRUE, 
                        CompositeDynamic = TRUE, 
                        Skybox = FALSE, 
                        Unnamed_1 = FALSE, 
                        Unnamed_2 = FALSE, 
                        Unnamed_3 = FALSE, 
                        Unnamed_4 = FALSE, 
                        Unnamed_5 = FALSE, 
                        Unnamed_6 = FALSE, 
                        Cinematic_1 = FALSE, 
                        Cinematic_2 = FALSE, 
                        Cinematic_3 = FALSE, 
                        Cinematic_4 = FALSE, 
                        Cinematic_5 = FALSE, 
                        Cinematic_6 = FALSE, 
                        Cinematic_7 = FALSE, 
                        Cinematic_8 = FALSE, 
                        Cinematic_9 = FALSE, 
                        Cinematic_10 = FALSE, 
                        Gameplay_1 = FALSE, 
                        Gameplay_2 = FALSE, 
                        Gameplay_3 = FALSE, 
                        Gameplay_4 = FALSE, 
                        Crowd = FALSE
                       }
    ModShadowColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    ModShadowFadeoutExponent = 3.0
    OcclusionDepthRange = 20000.0
    BloomScale = 2.0
    BloomScreenBlendThreshold = 1.0
    BloomTint = {B = 255, G = 255, R = 255, A = 0}
    RadialBlurPercent = 100.0
    OcclusionMaskDarkness = 0.300000012
    ComponentType = EComponentType.COMPONENT_Lights
}