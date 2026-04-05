Class DynamicLightEnvironmentComponent extends LightEnvironmentComponent
    native;

enum EDynamicLightEnvironmentBoundsMethod
{
    DLEB_OwnerComponents,
    DLEB_ManualOverride,
    DLEB_ActiveComponents,
};

var const editinline export array<LightComponent> OverriddenLightComponents;
var const transient native Pointer State;
var BoxSphereBounds OverriddenBounds;
var(DynamicLightEnvironmentComponent) LinearColor AmbientShadowColor;
var(DynamicLightEnvironmentComponent) LinearColor AmbientGlow;
var(DynamicLightEnvironmentComponent) LinearColor MaxModulatedShadowColor;
var(DynamicLightEnvironmentComponent) Vector AmbientShadowSourceDirection;
var(DynamicLightEnvironmentComponent) float InvisibleUpdateTime;
var(DynamicLightEnvironmentComponent) float MinTimeBetweenFullUpdates;
var float ShadowInterpolationSpeed;
var(DynamicLightEnvironmentComponent) int NumVolumeVisibilitySamples;
var(DynamicLightEnvironmentComponent) float LightDesaturation;
var(DynamicLightEnvironmentComponent) float LightDistance;
var(DynamicLightEnvironmentComponent) float ShadowDistance;
var(DynamicLightEnvironmentComponent) float ModShadowFadeoutTime;
var(DynamicLightEnvironmentComponent) float ModShadowFadeoutExponent;
var float DominantShadowTransitionStartDistance;
var float DominantShadowTransitionEndDistance;
var(DynamicLightEnvironmentComponent) int MinShadowResolution;
var(DynamicLightEnvironmentComponent) int MaxShadowResolution;
var(DynamicLightEnvironmentComponent) int ShadowFadeResolution;
var(DynamicLightEnvironmentComponent) float BouncedLightingFactor;
var(DynamicLightEnvironmentComponent) float BouncedLightingDesaturation;
var(DynamicLightEnvironmentComponent) float MinShadowAngle;
var LightingChannelContainer OverriddenLightingChannels;
var(DynamicLightEnvironmentComponent) bool bCastShadows;
var(DynamicLightEnvironmentComponent) bool bCompositeShadowsFromDynamicLights;
var const bool bForceCompositeAllLights;
var(DynamicLightEnvironmentComponent) bool bDynamic;
var(DynamicLightEnvironmentComponent) bool bSynthesizeDirectionalLight;
var(DynamicLightEnvironmentComponent) bool bSynthesizeSHLight;
var(DynamicLightEnvironmentComponent) bool bForceAllowLightEnvSphericalHarmonicLights;
var(DynamicLightEnvironmentComponent) bool bRequiresNonLatentUpdates;
var bool bTraceFromClosestBoundsPoint;
var bool bIsCharacterLightEnvironment;
var bool bOverrideOwnerLightingChannels;
var(DynamicLightEnvironmentComponent) bool bShadowBouncedLight;
var(DynamicLightEnvironmentComponent) EShadowFilterQuality ShadowFilterQuality;
var(DynamicLightEnvironmentComponent) ELightShadowMode LightShadowMode;
var EDynamicLightEnvironmentBoundsMethod BoundsMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AmbientShadowColor = {R = 0.00100000005, G = 0.00100000005, B = 0.00100000005, A = 1.0}
    AmbientGlow = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    MaxModulatedShadowColor = {R = 0.5, G = 0.5, B = 0.5, A = 1.0}
    AmbientShadowSourceDirection = {X = 0.00999999978, Y = 0.0, Z = 0.99000001}
    InvisibleUpdateTime = 5.0
    MinTimeBetweenFullUpdates = 1.0
    ShadowInterpolationSpeed = 0.00400000019
    NumVolumeVisibilitySamples = 1
    LightDistance = 10.0
    ShadowDistance = 5.0
    ModShadowFadeoutExponent = 3.0
    DominantShadowTransitionStartDistance = 100.0
    DominantShadowTransitionEndDistance = 10.0
    BouncedLightingFactor = 0.300000012
    BouncedLightingDesaturation = 0.5
    MinShadowAngle = 25.0
    bCastShadows = TRUE
    bCompositeShadowsFromDynamicLights = TRUE
    bDynamic = TRUE
    bSynthesizeDirectionalLight = TRUE
    bShadowBouncedLight = TRUE
    LightShadowMode = ELightShadowMode.LightShadow_Modulate
    BoundsMethod = EDynamicLightEnvironmentBoundsMethod.DLEB_ActiveComponents
}