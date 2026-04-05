Class CameraActor extends Actor
    native
    placeable;

var(CameraActor) interp PostProcessSettings CamOverridePostProcess;
var(CameraActor) interp float AspectRatio;
var(CameraActor) interp float FOVAngle;
var(CameraActor) interp float CamOverridePostProcessAlpha;
var editinline export DrawFrustumComponent DrawFrustum;
var editinline export StaticMeshComponent MeshComp;
var(CameraActor) bool bConstrainAspectRatio;

public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local float XL;
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    Super.DisplayDebug(HUD, out_YL, out_YPos);
    Canvas.StrLen("TEST", XL, out_YL);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("FOV:" $ FOVAngle, FALSE);
}
public simulated function GetCameraView(float DeltaTime, out TPOV OutPOV)
{
    GetActorEyesViewPoint(OutPOV.location, OutPOV.Rotation);
    OutPOV.FOV = FOVAngle;
}

replication
{
    if (Role == ENetRole.ROLE_Authority)
        AspectRatio, FOVAngle;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CamOverridePostProcess = {
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
    AspectRatio = 1.77778006
    FOVAngle = 90.0
    bConstrainAspectRatio = TRUE
    Components = (None, None)
    NetUpdateFrequency = 1.0
    bNoDelete = TRUE
    Physics = EPhysics.PHYS_Interpolating
}