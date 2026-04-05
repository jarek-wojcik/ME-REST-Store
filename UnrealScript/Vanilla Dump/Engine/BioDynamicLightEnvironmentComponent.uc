Class BioDynamicLightEnvironmentComponent extends DynamicLightEnvironmentComponent
    native
    config(Engine);

enum ERimLightControlType
{
    RLCT_Key,
    RLCT_Camera,
};
enum EDLEStateType
{
    DLEST_Default,
    DLEST_Cinematic,
    DLEST_Simple,
};

var transient array<SFXLightProbeBlendVolume> LightProbeVolumeStack;
var const transient native Pointer BioState;
var(Animate) interp Vector KeyLightScale;
var(Animate) interp Vector FillLightScale;
var(Animate) interp Vector AmbientLightScale;
var(Debug) Name TargetBoneName;
var(Debug) config interp float SHAmbientScale;
var(Debug) config float BlendTime;
var(Debug) config float PopAngleLimit;
var(Debug) config float SurfaceBoundsRatio;
var(Debug) config float MinPolarAngle;
var(Animate) interp float RimLightYaw;
var(Animate) interp float RimLightPitch;
var(Animate) interp float RimLightScale;
var(Animate) interp Color RimLightColor;
var(Animate) SFXLightRig CinematicLightRig;
var(Animate) float LightRigOrientation;
var const config float LastFrameWeight_Cinematic;
var const config float LastFrameWeight_Exploration;
var(Debug) config bool LightAxisEnabled;
var(Debug) bool DisplayDebugLines;
var(Debug) config bool ForcePolarKeyFill;
var(Debug) config bool UseOptimizedLightingPath;
var(Debug) bool UseTargetBoneAsOrigin;
var(Debug) bool bLockEnvironment;
var const config bool SmoothShadowLight_Cinematic;
var const config bool SmoothShadowLight_Exploration;
var transient bool bHasDirtyInterpProperties;
var(BioDynamicLightEnvironmentComponent) bool bSupportsLightProbes;
var(BioDynamicLightEnvironmentComponent) const EDLEStateType QualityType;
var(Animate) ERimLightControlType RimLightControl;

public static native function BioDynamicLightEnvironmentComponent ScriptFindDLE(const Actor InActor);

public native function SetQuality(EDLEStateType Quality);

public final native function TouchLightProbeBlendVolume(SFXLightProbeBlendVolume InVolume);

public final native function UntouchLightProbeBlendVolume(SFXLightProbeBlendVolume InVolume);

public function OnUpdatePropertyAmbientLightScale()
{
    bHasDirtyInterpProperties = TRUE;
}
public function OnUpdatePropertyFillLightScale()
{
    bHasDirtyInterpProperties = TRUE;
}
public function OnUpdatePropertyKeyLightScale()
{
    bHasDirtyInterpProperties = TRUE;
}
public function OnUpdatePropertyRimLightColor()
{
    bHasDirtyInterpProperties = TRUE;
}
public function OnUpdatePropertyRimLightControl()
{
    bHasDirtyInterpProperties = TRUE;
}
public function OnUpdatePropertyRimLightPitch()
{
    bHasDirtyInterpProperties = TRUE;
}
public function OnUpdatePropertyRimLightScale()
{
    bHasDirtyInterpProperties = TRUE;
}
public function OnUpdatePropertyRimLightYaw()
{
    bHasDirtyInterpProperties = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    KeyLightScale = {X = 1.0, Y = 1.0, Z = 1.0}
    FillLightScale = {X = 1.0, Y = 1.0, Z = 1.0}
    AmbientLightScale = {X = 1.0, Y = 1.0, Z = 1.0}
    SHAmbientScale = 0.200000003
    BlendTime = 0.300000012
    PopAngleLimit = 45.0
    MinPolarAngle = 90.0
    RimLightYaw = -33.0
    RimLightPitch = 30.0
    RimLightColor = {B = 255, G = 255, R = 255, A = 0}
    LastFrameWeight_Cinematic = 1.10000002
    LastFrameWeight_Exploration = 1.00100005
    LightAxisEnabled = TRUE
    UseOptimizedLightingPath = TRUE
    SmoothShadowLight_Exploration = TRUE
    bSupportsLightProbes = TRUE
    bSynthesizeSHLight = TRUE
}