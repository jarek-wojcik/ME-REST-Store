Class CameraAnimInst
    native;

var transient Matrix UserPlaySpaceMatrix;
var transient PostProcessSettings LastPPSettings;
var CameraAnim CamAnim;
var transient float CurTime;
var float BlendInTime;
var float BlendOutTime;
var transient float CurBlendInTime;
var transient float CurBlendOutTime;
var float PlayRate;
var float BasePlayScale;
var float TransientScaleModifier;
var float CurrentBlendWeight;
var transient float RemainingTime;
var transient InterpTrackMove MoveTrack;
var transient InterpTrackInstMove MoveInst;
var transient AnimNodeSequence SourceAnimNode;
var transient float LastPPSettingsAlpha;
var export InterpGroupInst InterpGroupInst;
var transient bool bLooping;
var transient bool bFinished;
var transient bool bAutoReleaseWhenFinished;
var transient bool bBlendingIn;
var transient bool bBlendingOut;
var protectedwrite ECameraAnimPlaySpace PlaySpace;

public final native function AdvanceAnim(float DeltaTime, bool bJump);

public final native function ApplyTransientScaling(float Scalar);

public final native function Play(CameraAnim Anim, Actor CamActor, float InRate, float InScale, float InBlendInTime, float InBlendOutTime, bool bInLoop, bool bRandomStartTime, optional float Duration);

public final native function PlayEx(CameraAnim Anim, Actor CamActor, float InRate, float InScale, float StartTime, float InBlendInTime, float InBlendOutTime, bool bInLoop, bool bRandomStartTime, optional float Duration);

public final native function SetPlaySpace(ECameraAnimPlaySpace NewSpace, optional Rotator UserPlaySpace);

public final native function Stop(optional bool bImmediate);

public final native function Update(float NewRate, float NewScale, float NewBlendInTime, float NewBlendOutTime, optional float NewDuration);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=InterpGroupInst Name=InterpGroupInst0
    End Object
    LastPPSettings = {
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
    PlayRate = 1.0
    TransientScaleModifier = 1.0
    InterpGroupInst = InterpGroupInst0
    bFinished = TRUE
    bAutoReleaseWhenFinished = TRUE
}