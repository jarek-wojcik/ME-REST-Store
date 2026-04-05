Class CameraAnim
    native;

var const PostProcessSettings BasePPSettings;
var const Box BoundingBox;
var InterpGroup CameraInterpGroup;
var const float AnimLength;
var const float BasePPSettingsAlpha;
var const float BaseFOV;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BasePPSettings = {
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
                      bOverride_EnableBloom = FALSE, 
                      bOverride_EnableDOF = FALSE, 
                      bOverride_EnableMotionBlur = FALSE, 
                      bOverride_EnableSceneEffect = FALSE, 
                      bOverride_AllowAmbientOcclusion = FALSE, 
                      bOverride_OverrideRimShaderColor = FALSE, 
                      bOverride_Bloom_Scale = FALSE, 
                      bOverride_Bloom_Threshold = FALSE, 
                      bOverride_Bloom_Tint = FALSE, 
                      bOverride_Bloom_ScreenBlendThreshold = FALSE, 
                      bOverride_Bloom_InterpolationDuration = FALSE, 
                      bOverride_DOF_FalloffExponent = FALSE, 
                      bOverride_DOF_BlurKernelSize = FALSE, 
                      bOverride_DOF_BlurBloomKernelSize = FALSE, 
                      bOverride_DOF_MaxNearBlurAmount = FALSE, 
                      bOverride_DOF_MaxFarBlurAmount = FALSE, 
                      bOverride_DOF_ModulateBlurColor = FALSE, 
                      bOverride_DOF_FocusType = FALSE, 
                      bOverride_DOF_FocusInnerRadius = FALSE, 
                      bOverride_DOF_FocusDistance = FALSE, 
                      bOverride_DOF_FocusPosition = FALSE, 
                      bOverride_DOF_InterpolationDuration = FALSE, 
                      bOverride_MotionBlur_MaxVelocity = FALSE, 
                      bOverride_MotionBlur_Amount = FALSE, 
                      bOverride_MotionBlur_FullMotionBlur = FALSE, 
                      bOverride_MotionBlur_CameraRotationThreshold = FALSE, 
                      bOverride_MotionBlur_CameraTranslationThreshold = FALSE, 
                      bOverride_MotionBlur_InterpolationDuration = FALSE, 
                      bOverride_Scene_Desaturation = FALSE, 
                      bOverride_Scene_HighLights = FALSE, 
                      bOverride_Scene_MidTones = FALSE, 
                      bOverride_Scene_Shadows = FALSE, 
                      bOverride_Scene_InterpolationDuration = FALSE, 
                      bOverride_RimShader_Color = FALSE, 
                      bOverride_RimShader_InterpolationDuration = FALSE, 
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
    AnimLength = 3.0
    BasePPSettingsAlpha = 1.0
    BaseFOV = 90.0
}