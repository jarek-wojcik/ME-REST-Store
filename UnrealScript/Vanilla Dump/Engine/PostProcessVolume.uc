Class PostProcessVolume extends Volume
    native
    placeable;

struct native PostProcessSettings 
{
    var LUTBlender ColorGradingLUT;
    var(PostProcessSettings) LinearColor RimShader_Color;
    var(PostProcessSettings) Vector DOF_FocusPosition;
    var(PostProcessSettings) interp Vector Scene_HighLights;
    var(PostProcessSettings) interp Vector Scene_MidTones;
    var(PostProcessSettings) interp Vector Scene_Shadows;
    var(PostProcessSettings) interp float Bloom_Scale;
    var(PostProcessSettings) interp float Bloom_Threshold;
    var(PostProcessSettings) interp Color Bloom_Tint;
    var(PostProcessSettings) interp float Bloom_ScreenBlendThreshold;
    var(PostProcessSettings) float Bloom_InterpolationDuration;
    var(PostProcessSettings) interp float DOF_FalloffExponent;
    var(PostProcessSettings) interp float DOF_BlurKernelSize;
    var(PostProcessSettings) interp float DOF_BlurBloomKernelSize;
    var(PostProcessSettings) interp float DOF_MaxNearBlurAmount;
    var(PostProcessSettings) interp float DOF_MaxFarBlurAmount;
    var(PostProcessSettings) Color DOF_ModulateBlurColor;
    var(PostProcessSettings) interp float DOF_FocusInnerRadius;
    var(PostProcessSettings) interp float DOF_FocusDistance;
    var(PostProcessSettings) float DOF_InterpolationDuration;
    var(PostProcessSettings) interp float MotionBlur_MaxVelocity;
    var(PostProcessSettings) interp float MotionBlur_Amount;
    var(PostProcessSettings) interp float MotionBlur_CameraRotationThreshold;
    var(PostProcessSettings) interp float MotionBlur_CameraTranslationThreshold;
    var(PostProcessSettings) float MotionBlur_InterpolationDuration;
    var(PostProcessSettings) interp float Scene_Desaturation;
    var(PostProcessSettings) float Scene_InterpolationDuration;
    var(PostProcessSettings) float RimShader_InterpolationDuration;
    var(PostProcessSettings) Texture ColorGrading_LookupTable;
    var transient float PP_DesaturationMultiplier;
    var transient float PP_HighlightsMultiplier;
    var transient float PP_MidTonesMultiplier;
    var transient float PP_ShadowsMultiplier;
    var bool bOverride_EnableBloom;
    var bool bOverride_EnableDOF;
    var bool bOverride_EnableMotionBlur;
    var bool bOverride_EnableSceneEffect;
    var bool bOverride_AllowAmbientOcclusion;
    var bool bOverride_OverrideRimShaderColor;
    var bool bOverride_Bloom_Scale;
    var bool bOverride_Bloom_Threshold;
    var bool bOverride_Bloom_Tint;
    var bool bOverride_Bloom_ScreenBlendThreshold;
    var bool bOverride_Bloom_InterpolationDuration;
    var bool bOverride_DOF_FalloffExponent;
    var bool bOverride_DOF_BlurKernelSize;
    var bool bOverride_DOF_BlurBloomKernelSize;
    var bool bOverride_DOF_MaxNearBlurAmount;
    var bool bOverride_DOF_MaxFarBlurAmount;
    var bool bOverride_DOF_ModulateBlurColor;
    var bool bOverride_DOF_FocusType;
    var bool bOverride_DOF_FocusInnerRadius;
    var bool bOverride_DOF_FocusDistance;
    var bool bOverride_DOF_FocusPosition;
    var bool bOverride_DOF_InterpolationDuration;
    var bool bOverride_MotionBlur_MaxVelocity;
    var bool bOverride_MotionBlur_Amount;
    var bool bOverride_MotionBlur_FullMotionBlur;
    var bool bOverride_MotionBlur_CameraRotationThreshold;
    var bool bOverride_MotionBlur_CameraTranslationThreshold;
    var bool bOverride_MotionBlur_InterpolationDuration;
    var bool bOverride_Scene_Desaturation;
    var bool bOverride_Scene_HighLights;
    var bool bOverride_Scene_MidTones;
    var bool bOverride_Scene_Shadows;
    var bool bOverride_Scene_InterpolationDuration;
    var bool bOverride_RimShader_Color;
    var bool bOverride_RimShader_InterpolationDuration;
    var(PostProcessSettings) bool bEnableBloom;
    var(PostProcessSettings) bool bEnableDOF;
    var(PostProcessSettings) bool bEnableMotionBlur;
    var(PostProcessSettings) bool bEnableSceneEffect;
    var(PostProcessSettings) bool bAllowAmbientOcclusion;
    var(PostProcessSettings) bool bOverrideRimShaderColor;
    var bool bOverride_EnableFilmic;
    var(PostProcessSettings) bool bEnableFilmic;
    var bool bOverride_EnableVignette;
    var(PostProcessSettings) bool bEnableVignette;
    var bool bOverride_EnableFilmGrain;
    var(PostProcessSettings) bool bEnableFilmGrain;
    var(PostProcessSettings) bool MotionBlur_FullMotionBlur;
    var(PostProcessSettings) EFocusType DOF_FocusType;
    
    structdefaultproperties
    {
        RimShader_Color = {R = 0.47044, G = 0.585973024, B = 0.827726007, A = 1.0}
        Scene_HighLights = {X = 1.0, Y = 1.0, Z = 1.0}
        Scene_MidTones = {X = 1.0, Y = 1.0, Z = 1.0}
        Bloom_Scale = 1.0
        Bloom_Threshold = 1.0
        Bloom_Tint = {B = 255, G = 255, R = 255, A = 0}
        Bloom_ScreenBlendThreshold = 10.0
        Bloom_InterpolationDuration = 1.0
        DOF_FalloffExponent = 4.0
        DOF_BlurKernelSize = 16.0
        DOF_BlurBloomKernelSize = 16.0
        DOF_MaxNearBlurAmount = 1.0
        DOF_MaxFarBlurAmount = 1.0
        DOF_ModulateBlurColor = {B = 255, G = 255, R = 255, A = 255}
        DOF_FocusInnerRadius = 2000.0
        DOF_InterpolationDuration = 1.0
        MotionBlur_MaxVelocity = 1.0
        MotionBlur_Amount = 0.5
        MotionBlur_CameraRotationThreshold = 45.0
        MotionBlur_CameraTranslationThreshold = 10000.0
        MotionBlur_InterpolationDuration = 1.0
        Scene_InterpolationDuration = 1.0
        RimShader_InterpolationDuration = 1.0
        PP_HighlightsMultiplier = 1.0
        PP_MidTonesMultiplier = 1.0
        bOverride_EnableBloom = TRUE
        bOverride_EnableDOF = TRUE
        bOverride_EnableMotionBlur = TRUE
        bOverride_EnableSceneEffect = TRUE
        bOverride_AllowAmbientOcclusion = TRUE
        bOverride_OverrideRimShaderColor = TRUE
        bOverride_Bloom_Scale = TRUE
        bOverride_Bloom_Threshold = TRUE
        bOverride_Bloom_Tint = TRUE
        bOverride_Bloom_ScreenBlendThreshold = TRUE
        bOverride_Bloom_InterpolationDuration = TRUE
        bOverride_DOF_FalloffExponent = TRUE
        bOverride_DOF_BlurKernelSize = TRUE
        bOverride_DOF_BlurBloomKernelSize = TRUE
        bOverride_DOF_MaxNearBlurAmount = TRUE
        bOverride_DOF_MaxFarBlurAmount = TRUE
        bOverride_DOF_ModulateBlurColor = TRUE
        bOverride_DOF_FocusType = TRUE
        bOverride_DOF_FocusInnerRadius = TRUE
        bOverride_DOF_FocusDistance = TRUE
        bOverride_DOF_FocusPosition = TRUE
        bOverride_DOF_InterpolationDuration = TRUE
        bOverride_MotionBlur_MaxVelocity = TRUE
        bOverride_MotionBlur_Amount = TRUE
        bOverride_MotionBlur_FullMotionBlur = TRUE
        bOverride_MotionBlur_CameraRotationThreshold = TRUE
        bOverride_MotionBlur_CameraTranslationThreshold = TRUE
        bOverride_MotionBlur_InterpolationDuration = TRUE
        bOverride_Scene_Desaturation = TRUE
        bOverride_Scene_HighLights = TRUE
        bOverride_Scene_MidTones = TRUE
        bOverride_Scene_Shadows = TRUE
        bOverride_Scene_InterpolationDuration = TRUE
        bOverride_RimShader_Color = TRUE
        bOverride_RimShader_InterpolationDuration = TRUE
        bEnableBloom = TRUE
        bEnableMotionBlur = TRUE
        bEnableSceneEffect = TRUE
        bAllowAmbientOcclusion = TRUE
        bOverride_EnableFilmic = TRUE
        bEnableFilmic = TRUE
        bOverride_EnableVignette = TRUE
        bEnableVignette = TRUE
        bOverride_EnableFilmGrain = TRUE
        bEnableFilmGrain = TRUE
        MotionBlur_FullMotionBlur = TRUE
    }
};
struct native LUTBlender 
{
    var array<Texture> LUTTextures;
    var array<float> LUTWeights;
};

var(PostProcessVolume) PostProcessSettings Settings;
var(PostProcessVolume) float Priority;
var const transient noimport PostProcessVolume NextLowerPriorityVolume;
var(PostProcessVolume) bool bEnabled;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = TRUE;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnabled = FALSE;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnabled = !bEnabled;
    }
    ForceNetRelevant();
    SetForcedInitialReplicatedProperty(BoolProperty'bEnabled', bEnabled == default.bEnabled);
}

replication
{
    if (bNetDirty)
        bEnabled;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        CollideActors = FALSE
        BlockNonZeroExtent = FALSE
    End Template
    Settings = {
                ColorGradingLUT = {
                                   LUTTextures = (), 
                                   LUTWeights = ()
                                  }, 
                RimShader_Color = {R = 0.47044, G = 0.585973024, B = 0.827726007, A = 1.0}, 
                DOF_FocusPosition = {X = 0.0, Y = 0.0, Z = 0.0}, 
                Scene_HighLights = {X = 1.0, Y = 1.0, Z = 1.0}, 
                Scene_MidTones = {X = 1.0, Y = 1.0, Z = 1.0}, 
                Scene_Shadows = {X = 0.0, Y = 0.0, Z = 0.0}, 
                Bloom_Scale = 1.0, 
                Bloom_Threshold = 1.0, 
                Bloom_Tint = {B = 255, G = 255, R = 255, A = 0}, 
                Bloom_ScreenBlendThreshold = 10.0, 
                Bloom_InterpolationDuration = 1.0, 
                DOF_FalloffExponent = 4.0, 
                DOF_BlurKernelSize = 16.0, 
                DOF_BlurBloomKernelSize = 16.0, 
                DOF_MaxNearBlurAmount = 1.0, 
                DOF_MaxFarBlurAmount = 1.0, 
                DOF_ModulateBlurColor = {B = 255, G = 255, R = 255, A = 255}, 
                DOF_FocusInnerRadius = 2000.0, 
                DOF_FocusDistance = 0.0, 
                DOF_InterpolationDuration = 1.0, 
                MotionBlur_MaxVelocity = 1.0, 
                MotionBlur_Amount = 0.5, 
                MotionBlur_CameraRotationThreshold = 45.0, 
                MotionBlur_CameraTranslationThreshold = 10000.0, 
                MotionBlur_InterpolationDuration = 1.0, 
                Scene_Desaturation = 0.0, 
                Scene_InterpolationDuration = 1.0, 
                RimShader_InterpolationDuration = 1.0, 
                ColorGrading_LookupTable = None, 
                PP_DesaturationMultiplier = 0.0, 
                PP_HighlightsMultiplier = 1.0, 
                PP_MidTonesMultiplier = 1.0, 
                PP_ShadowsMultiplier = 0.0, 
                bOverride_EnableBloom = TRUE, 
                bOverride_EnableDOF = TRUE, 
                bOverride_EnableMotionBlur = TRUE, 
                bOverride_EnableSceneEffect = TRUE, 
                bOverride_AllowAmbientOcclusion = TRUE, 
                bOverride_OverrideRimShaderColor = TRUE, 
                bOverride_Bloom_Scale = TRUE, 
                bOverride_Bloom_Threshold = TRUE, 
                bOverride_Bloom_Tint = TRUE, 
                bOverride_Bloom_ScreenBlendThreshold = TRUE, 
                bOverride_Bloom_InterpolationDuration = TRUE, 
                bOverride_DOF_FalloffExponent = TRUE, 
                bOverride_DOF_BlurKernelSize = TRUE, 
                bOverride_DOF_BlurBloomKernelSize = TRUE, 
                bOverride_DOF_MaxNearBlurAmount = TRUE, 
                bOverride_DOF_MaxFarBlurAmount = TRUE, 
                bOverride_DOF_ModulateBlurColor = TRUE, 
                bOverride_DOF_FocusType = TRUE, 
                bOverride_DOF_FocusInnerRadius = TRUE, 
                bOverride_DOF_FocusDistance = TRUE, 
                bOverride_DOF_FocusPosition = TRUE, 
                bOverride_DOF_InterpolationDuration = TRUE, 
                bOverride_MotionBlur_MaxVelocity = TRUE, 
                bOverride_MotionBlur_Amount = TRUE, 
                bOverride_MotionBlur_FullMotionBlur = TRUE, 
                bOverride_MotionBlur_CameraRotationThreshold = TRUE, 
                bOverride_MotionBlur_CameraTranslationThreshold = TRUE, 
                bOverride_MotionBlur_InterpolationDuration = TRUE, 
                bOverride_Scene_Desaturation = TRUE, 
                bOverride_Scene_HighLights = TRUE, 
                bOverride_Scene_MidTones = TRUE, 
                bOverride_Scene_Shadows = TRUE, 
                bOverride_Scene_InterpolationDuration = TRUE, 
                bOverride_RimShader_Color = TRUE, 
                bOverride_RimShader_InterpolationDuration = TRUE, 
                bEnableBloom = TRUE, 
                bEnableDOF = FALSE, 
                bEnableMotionBlur = TRUE, 
                bEnableSceneEffect = TRUE, 
                bAllowAmbientOcclusion = TRUE, 
                bOverrideRimShaderColor = FALSE, 
                bOverride_EnableFilmic = TRUE, 
                bEnableFilmic = TRUE, 
                bOverride_EnableVignette = TRUE, 
                bEnableVignette = TRUE, 
                bOverride_EnableFilmGrain = TRUE, 
                bEnableFilmGrain = TRUE, 
                MotionBlur_FullMotionBlur = TRUE, 
                DOF_FocusType = EFocusType.FOCUS_Distance
               }
    bEnabled = TRUE
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bStatic = FALSE
    bTickIsDisabled = TRUE
    bCollideActors = FALSE
}