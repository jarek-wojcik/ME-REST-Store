Class LocalPlayer extends Player within Engine
    native
    transient
    config(Engine);

struct native CurrentPostProcessVolumeInfo 
{
    var PostProcessSettings LastSettings;
    var PostProcessVolume LastVolumeUsed;
    var float BlendStartTime;
    var float LastBlendTime;
};
struct SynchronizedActorVisibilityHistory 
{
    var Pointer State;
    var Pointer CriticalSection;
};

var const transient noimport CurrentPostProcessVolumeInfo CurrentPPInfo;
var const transient noimport CurrentPostProcessVolumeInfo LevelPPInfo;
var PostProcessSettings OverridePPDeltaSettings;
var PostProcessSettings PostProcessSettingsOverride;
var const array<PostProcessChain> PlayerPostProcessChains;
var string LastMap;
var transient array<RequestedPostProcessEffect> RequestedPPEffects;
var const transient native SynchronizedActorVisibilityHistory ActorVisibilityHistory;
var const native Pointer ViewState;
var const transient native Pointer UmbraCamera;
var transient Vector LastViewLocation;
var Vector2D Origin;
var Vector2D Size;
var int ControllerId;
var GameViewportClient ViewportClient;
var const PostProcessChain PlayerPostProcess;
var config float OverridePPRecoveryTime;
var float OverridePPStartTime;
var float OverridePPEndTime;
var float OverridePPOpacity;
var const float NearClipPlane;
var bool bOverridePostProcessSettings;
var bool bRecoveryFromPostProcessOverride;
var bool bWantToResetToMapDefaultPP;
var const editconst transient bool bSentSplitJoin;

public native function BioAddPostProcessEffect(PostProcessEffect pEffect, Object pOwner, EAddPostProcessEffectCombineType nCombineType);

public final native function BioRecalculatePostProcessEffects();

public native function BioRemovePostProcessEffect(PostProcessEffect pEffect);

public final native function DeProject(Vector2D RelativeScreenPos, out Vector WorldOrigin, out Vector WorldDirection);

public final native function bool GetActorVisibility(Actor TestActor);

public final event function string GetNickname()
{
    local GameEngine TheEngine;
    
    TheEngine = GameEngine(Outer);
    if (TheEngine != None && TheEngine.OnlineSubsystem != None && TheEngine.OnlineSubsystem.PlayerInterface != None)
    {
        return TheEngine.OnlineSubsystem.PlayerInterface.GetPlayerNickname(byte(ControllerId));
    }
    else
    {
        return "";
    }
}
public native function PostProcessChain GetPostProcessChain(int InIndex);

public final event function UniqueNetId GetUniqueNetId()
{
    local UniqueNetId Result;
    local GameEngine TheEngine;
    
    TheEngine = GameEngine(Outer);
    if (TheEngine != None && TheEngine.OnlineSubsystem != None && TheEngine.OnlineSubsystem.PlayerInterface != None)
    {
        TheEngine.OnlineSubsystem.PlayerInterface.GetUniquePlayerId(byte(ControllerId), Result);
    }
    return Result;
}
public native function bool InsertPostProcessingChain(PostProcessChain InChain, int InIndex, bool bInClone);

public native function bool RemoveAllPostProcessingChains();

public native function bool RemovePostProcessingChain(int InIndex);

public final native function SendSplitJoin();

public final native function bool SpawnPlayActor(string URL, out string OutError);

public native function TouchPlayerPostProcessChain();

public final native function ZeroOverridePPDeltaSettings();

public simulated function ClearPostProcessSettingsOverride(optional float RecoveryTime = -1.0)
{
    if (bOverridePostProcessSettings)
    {
        if (RecoveryTime < float(0))
        {
            OverridePPRecoveryTime = default.OverridePPRecoveryTime;
        }
        else
        {
            OverridePPRecoveryTime = RecoveryTime;
        }
        bOverridePostProcessSettings = FALSE;
        if (RecoveryTime == 0.0)
        {
            ZeroOverridePPDeltaSettings();
            bRecoveryFromPostProcessOverride = FALSE;
        }
        else
        {
            bRecoveryFromPostProcessOverride = TRUE;
            OverridePPEndTime = -1.0;
        }
    }
}
public simulated function OverridePostProcessSettings(PostProcessSettings OverrideSettings, float StartBlendTime)
{
    if (!Class'WorldInfo'.static.IsMenuLevel())
    {
        PostProcessSettingsOverride = OverrideSettings;
        if (!bOverridePostProcessSettings && !bRecoveryFromPostProcessOverride)
        {
            ZeroOverridePPDeltaSettings();
        }
        bOverridePostProcessSettings = TRUE;
        OverridePPStartTime = StartBlendTime;
    }
}
public final function SetControllerId(int NewControllerId)
{
    local LocalPlayer OtherPlayer;
    local int CurrentControllerId;
    
    if (ControllerId != NewControllerId)
    {
        if (Actor != None)
        {
            Actor.PreControllerIdChange();
        }
        CurrentControllerId = ControllerId;
        ControllerId = -1;
        OtherPlayer = ViewportClient.FindPlayerByControllerId(NewControllerId);
        if (OtherPlayer != None)
        {
            OtherPlayer.SetControllerId(CurrentControllerId);
        }
        ControllerId = NewControllerId;
        if (Actor != None)
        {
            Actor.PostControllerIdChange();
        }
    }
}
public simulated function UpdateOverridePostProcessSettings(PostProcessSettings OverrideSettings)
{
    PostProcessSettingsOverride = OverrideSettings;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CurrentPPInfo = {
                     LastSettings = {
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
                                    }, 
                     LastVolumeUsed = None, 
                     BlendStartTime = 0.0, 
                     LastBlendTime = 0.0
                    }
    LevelPPInfo = {
                   LastSettings = {
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
                                  }, 
                   LastVolumeUsed = None, 
                   BlendStartTime = 0.0, 
                   LastBlendTime = 0.0
                  }
    OverridePPDeltaSettings = {
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
    PostProcessSettingsOverride = {
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
    OverridePPRecoveryTime = 1.0
    NearClipPlane = 10.0
}