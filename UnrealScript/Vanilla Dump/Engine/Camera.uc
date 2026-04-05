Class Camera extends Actor
    native
    transient;

const MAX_ACTIVE_CAMERA_ANIMS = 8;
enum ECameraAnimPlaySpace
{
    CAPS_CameraLocal,
    CAPS_World,
    CAPS_UserDefined,
};
struct native ViewTargetTransitionParams 
{
    var(ViewTargetTransitionParams) float BlendTime;
    var(ViewTargetTransitionParams) float BlendExp;
    var(ViewTargetTransitionParams) bool bSkipCameraReset;
    var(ViewTargetTransitionParams) EViewTargetBlendFunction BlendFunction;
    
    structdefaultproperties
    {
        BlendExp = 2.0
        BlendFunction = EViewTargetBlendFunction.VTBlend_Cubic
    }
};
enum EViewTargetBlendFunction
{
    VTBlend_Linear,
    VTBlend_Cubic,
    VTBlend_EaseIn,
    VTBlend_EaseOut,
    VTBlend_EaseInOut,
};
struct native TViewTarget 
{
    var(TViewTarget) TPOV POV;
    var(TViewTarget) Actor Target;
    var(TViewTarget) Controller Controller;
    var(TViewTarget) float AspectRatio;
    var(TViewTarget) PlayerReplicationInfo PRI;
};
struct native TCameraCache 
{
    var TPOV POV;
    var float TimeStamp;
};

var PostProcessSettings CamPostProcessSettings;
var clearcrosslevel array<CameraModifier> ModifierList;
var transient array<EmitterCameraLensEffectBase> CameraLensEffects;
var array<CameraAnimInst> ActiveAnims;
var array<CameraAnimInst> FreeAnims;
var(Camera) Class<CameraModifier_CameraShake> CameraShakeCamModClass;
var TViewTarget ViewTarget;
var TViewTarget PendingViewTarget;
var TCameraCache CameraCache;
var CameraAnimInst AnimInstPool[8];
var ViewTargetTransitionParams BlendParams;
var Vector ColorScale;
var Vector DesiredColorScale;
var Vector OriginalColorScale;
var Vector FreeCamOffset;
var Name CameraStyle;
var Vector2D FadeAlpha;
var PlayerController PCOwner;
var float DefaultFOV;
var float LockedFOV;
var float ConstrainedAspectRatio;
var float DefaultAspectRatio;
var Color FadeColor;
var float FadeAmount;
var float CamOverridePostProcessAlpha;
var float ColorScaleInterpDuration;
var float ColorScaleInterpStartTime;
var float BlendTimeToGo;
var float FreeCamDistance;
var float FadeTime;
var float FadeTimeRemaining;
var(Camera) transient CameraModifier_CameraShake CameraShakeCamMod;
var transient DynamicCameraActor AnimCameraActor;
var bool bLockedFOV;
var bool bConstrainAspectRatio;
var bool bEnableFading;
var bool bEnableColorScaling;
var bool bEnableColorScaleInterp;

public native function ApplyCameraModifiers(float DeltaTime, out TPOV OutPOV);

public native function CheckViewTarget(out TViewTarget VT);

public event function Destroyed()
{
    AnimCameraActor.Destroy();
    Super.Destroyed();
}
public final native function GetCameraViewPoint(out Vector OutCamLoc, out Rotator OutCamRot);

public function float GetFOVAngle()
{
    if (bLockedFOV)
    {
        return LockedFOV;
    }
    return CameraCache.POV.FOV;
}
public simulated native function CameraAnimInst PlayCameraAnim(CameraAnim Anim, optional float Rate = 1.0, optional float Scale = 1.0, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bRandomStartTime, optional float Duration, optional bool bSingleInstance);

public function PostBeginPlay()
{
    local int idx;
    
    Super.PostBeginPlay();
    if (CameraShakeCamMod == None && CameraShakeCamModClass != None)
    {
        CameraShakeCamMod = CameraModifier_CameraShake(CreateCameraModifier(CameraShakeCamModClass));
    }
    for (idx = 0; idx < 8; ++idx)
    {
        AnimInstPool[idx] = new (Self) Class'CameraAnimInst';
        FreeAnims[idx] = AnimInstPool[idx];
    }
    AnimCameraActor = Spawn(Class'DynamicCameraActor', Self, , , , , , TRUE);
}
public native function SetViewTarget(Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams);

public simulated native function StopAllCameraAnims(optional bool bImmediate);

public simulated native function StopAllCameraAnimsByType(CameraAnim Anim, optional bool bImmediate);

public simulated native function StopCameraAnim(CameraAnimInst AnimInst, optional bool bImmediate);

public function StopCameraShake(CameraShake Shake)
{
    if (Shake != None)
    {
        CameraShakeCamMod.RemoveCameraShake(Shake);
    }
}
public event simulated function UpdateCamera(float DeltaTime)
{
    local TPOV NewPOV;
    local float DurationPct;
    local float BlendPct;
    
    if (bEnableColorScaleInterp)
    {
        BlendPct = FClamp((WorldInfo.TimeSeconds - ColorScaleInterpStartTime) / ColorScaleInterpDuration, 0.0, 1.0);
        ColorScale = VLerp(OriginalColorScale, DesiredColorScale, BlendPct);
        if (BlendPct == 1.0)
        {
            bEnableColorScaleInterp = FALSE;
        }
    }
    bConstrainAspectRatio = FALSE;
    CamOverridePostProcessAlpha = 0.0;
    CheckViewTarget(ViewTarget);
    UpdateViewTarget(ViewTarget, DeltaTime);
    NewPOV = ViewTarget.POV;
    ConstrainedAspectRatio = ViewTarget.AspectRatio;
    if (PendingViewTarget.Target != None)
    {
        BlendTimeToGo -= DeltaTime;
        bConstrainAspectRatio = FALSE;
        CheckViewTarget(PendingViewTarget);
        UpdateViewTarget(PendingViewTarget, DeltaTime);
        if (BlendTimeToGo > float(0))
        {
            DurationPct = 1.0 - BlendTimeToGo / BlendParams.BlendTime;
            switch (BlendParams.BlendFunction)
            {
                case EViewTargetBlendFunction.VTBlend_Linear:
                    BlendPct = Lerp(0.0, 1.0, DurationPct);
                    break;
                case EViewTargetBlendFunction.VTBlend_Cubic:
                    BlendPct = FCubicInterp(0.0, 0.0, 1.0, 0.0, DurationPct);
                    break;
                case EViewTargetBlendFunction.VTBlend_EaseIn:
                    BlendPct = FInterpEaseIn(0.0, 1.0, DurationPct, BlendParams.BlendExp);
                    break;
                case EViewTargetBlendFunction.VTBlend_EaseOut:
                    BlendPct = FInterpEaseOut(0.0, 1.0, DurationPct, BlendParams.BlendExp);
                    break;
                case EViewTargetBlendFunction.VTBlend_EaseInOut:
                    BlendPct = FInterpEaseInOut(0.0, 1.0, DurationPct, BlendParams.BlendExp);
                    break;
                default:
            }
            NewPOV = BlendViewTargets(ViewTarget, PendingViewTarget, BlendPct);
        }
        else
        {
            ViewTarget = PendingViewTarget;
            PendingViewTarget.Target = None;
            PendingViewTarget.Controller = None;
            BlendTimeToGo = 0.0;
            NewPOV = PendingViewTarget.POV;
        }
        if (bConstrainAspectRatio)
        {
            ConstrainedAspectRatio = PendingViewTarget.AspectRatio;
        }
    }
    FillCameraCache(NewPOV);
    if (bEnableFading && FadeTimeRemaining > 0.0)
    {
        FadeTimeRemaining = FMax(FadeTimeRemaining - DeltaTime, 0.0);
        if (FadeTime > 0.0)
        {
            FadeAmount = FadeAlpha.X + (1.0 - FadeTimeRemaining / FadeTime) * (FadeAlpha.Y - FadeAlpha.X);
        }
    }
}
public simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Vector EyesLoc;
    local Rotator EyesRot;
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255);
    Canvas.DrawText("\tCamera Style:" $ CameraStyle @ "main ViewTarget:" $ ViewTarget.Target);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("   CamLoc:" $ CameraCache.POV.location @ "CamRot:" $ CameraCache.POV.Rotation @ "FOV:" $ CameraCache.POV.FOV);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    Canvas.DrawText("   AspectRatio:" $ ConstrainedAspectRatio);
    out_YPos += out_YL;
    Canvas.SetPos(4.0, out_YPos);
    if (ViewTarget.Target != None)
    {
        ViewTarget.Target.GetActorEyesViewPoint(EyesLoc, EyesRot);
        Canvas.DrawText("   EyesLoc:" $ EyesLoc @ "EyesRot:" $ EyesRot);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
}
public function AddCameraLensEffect(Class<EmitterCameraLensEffectBase> LensEffectEmitterClass)
{
    local Vector CamLoc;
    local Rotator CamRot;
    local EmitterCameraLensEffectBase LensEffect;
    
    if (LensEffectEmitterClass != None)
    {
        if (!LensEffectEmitterClass.default.bAllowMultipleInstances)
        {
            LensEffect = FindCameraLensEffect(LensEffectEmitterClass);
            if (LensEffect != None)
            {
                LensEffect.NotifyRetriggered();
            }
        }
        if (LensEffect == None)
        {
            LensEffect = Spawn(LensEffectEmitterClass, PCOwner.GetViewTarget());
            if (LensEffect != None)
            {
                GetCameraViewPoint(CamLoc, CamRot);
                LensEffect.UpdateLocation(CamLoc, CamRot, GetFOVAngle());
                LensEffect.RegisterCamera(Self);
                CameraLensEffects.AddItem(LensEffect);
            }
        }
    }
}
public function bool AllowPawnRotation()
{
    return TRUE;
}
public final function TPOV BlendViewTargets(const out TViewTarget A, const out TViewTarget B, float Alpha)
{
    local TPOV POV;
    
    POV.location = VLerp(A.POV.location, B.POV.location, Alpha);
    POV.FOV = Lerp(A.POV.FOV, B.POV.FOV, Alpha);
    POV.Rotation = RLerp(A.POV.Rotation, B.POV.Rotation, Alpha, TRUE);
    return POV;
}
public static function float CalcRadialShakeScale(Camera Cam, Vector Epicenter, float InnerRadius, float OuterRadius, float Falloff)
{
    local Vector POVLoc;
    local float DistPct;
    local Rotator POVRot;
    
    Cam.GetCameraViewPoint(POVLoc, POVRot);
    if (InnerRadius < OuterRadius)
    {
        DistPct = (VSize(Epicenter - POVLoc) - InnerRadius) / (OuterRadius - InnerRadius);
        DistPct = 1.0 - FClamp(DistPct, 0.0, 1.0);
        return DistPct ** Falloff;
    }
    else
    {
        return VSize(Epicenter - POVLoc) < InnerRadius ? 1.0 : 0.0;
    }
}
public function ClearAllCameraShakes()
{
    CameraShakeCamMod.RemoveAllCameraShakes();
}
public function ClearCameraLensEffects()
{
    local EmitterCameraLensEffectBase LensEffect;
    
    foreach CameraLensEffects(LensEffect, )
    {
        LensEffect.Destroy();
    }
    CameraLensEffects.Length = 0;
}
protected function CameraModifier CreateCameraModifier(Class<CameraModifier> ModifierClass)
{
    local CameraModifier NewMod;
    
    NewMod = new (Outer) ModifierClass;
    NewMod.Init();
    NewMod.AddCameraModifier(Self);
    return NewMod;
}
public final function FillCameraCache(const out TPOV NewPOV)
{
    CameraCache.TimeStamp = WorldInfo.TimeSeconds;
    CameraCache.POV = NewPOV;
}
public function EmitterCameraLensEffectBase FindCameraLensEffect(Class<EmitterCameraLensEffectBase> LensEffectEmitterClass)
{
    local EmitterCameraLensEffectBase LensEffect;
    
    foreach CameraLensEffects(LensEffect, )
    {
        if (LensEffect.Class == LensEffectEmitterClass && !LensEffect.bDeleteMe)
        {
            return LensEffect;
        }
    }
    return None;
}
public function InitializeFor(PlayerController PC)
{
    CameraCache.POV.FOV = DefaultFOV;
    PCOwner = PC;
    SetViewTarget(PC.ViewTarget);
    SetDesiredColorScale(WorldInfo.DefaultColorScale, 5.0);
    UpdateCamera(0.0);
}
public function PlayCameraShake(CameraShake Shake, float Scale, optional ECameraAnimPlaySpace PlaySpace = 0, optional Rotator UserPlaySpaceRot)
{
    if (Shake != None)
    {
        CameraShakeCamMod.AddCameraShake(Shake, Scale, PlaySpace, UserPlaySpaceRot);
    }
}
public static function PlayWorldCameraShake(CameraShake Shake, Actor ShakeInstigator, Vector Epicenter, float InnerRadius, float OuterRadius, float Falloff, bool bTryForceFeedback, optional bool bOrientShakeTowardsEpicenter)
{
    local PlayerController PC;
    local float ShakeScale;
    local Rotator CamRot;
    local Vector CamLoc;
    
    if (ShakeInstigator != None)
    {
        foreach ShakeInstigator.LocalPlayerControllers(Class'PlayerController', PC)
        {
            if (PC.PlayerCamera != None)
            {
                ShakeScale = CalcRadialShakeScale(PC.PlayerCamera, Epicenter, InnerRadius, OuterRadius, Falloff);
                if (bOrientShakeTowardsEpicenter && PC.Pawn != None)
                {
                    PC.PlayerCamera.GetCameraViewPoint(CamLoc, CamRot);
                    PC.ClientPlayCameraShake(Shake, ShakeScale, bTryForceFeedback, 2, Rotator(Epicenter - CamLoc));
                }
                else
                {
                    PC.ClientPlayCameraShake(Shake, ShakeScale, bTryForceFeedback);
                }
            }
        }
    }
}
public function ProcessViewRotation(float DeltaTime, out Rotator OutViewRotation, out Rotator OutDeltaRot)
{
    local int ModifierIdx;
    
    for (ModifierIdx = 0; ModifierIdx < ModifierList.Length; ModifierIdx++)
    {
        if (ModifierList[ModifierIdx] != None)
        {
            if (ModifierList[ModifierIdx].ProcessViewRotation(ViewTarget.Target, DeltaTime, OutViewRotation, OutDeltaRot))
            {
                break;
            }
        }
    }
}
public function RemoveCameraLensEffect(EmitterCameraLensEffectBase Emitter)
{
    CameraLensEffects.RemoveItem(Emitter);
}
public simulated function SetDesiredColorScale(Vector NewColorScale, float InterpTime)
{
    if (!bEnableColorScaling)
    {
        bEnableColorScaling = TRUE;
        ColorScale.X = 1.0;
        ColorScale.Y = 1.0;
        ColorScale.Z = 1.0;
    }
    if (NewColorScale != ColorScale)
    {
        OriginalColorScale = ColorScale;
        DesiredColorScale = NewColorScale;
        ColorScaleInterpStartTime = WorldInfo.TimeSeconds;
        ColorScaleInterpDuration = InterpTime;
        bEnableColorScaleInterp = TRUE;
    }
}
public function SetFOV(float NewFOV)
{
    if (NewFOV < float(1) || NewFOV > float(170))
    {
        bLockedFOV = FALSE;
        return;
    }
    bLockedFOV = TRUE;
    LockedFOV = NewFOV;
}
public function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
    local Vector Loc;
    local Vector pos;
    local Vector HitLocation;
    local Vector HitNormal;
    local Rotator Rot;
    local Actor HitActor;
    local CameraActor CamActor;
    local bool bDoNotApplyModifiers;
    local TPOV OrigPOV;
    
    OrigPOV = OutVT.POV;
    OutVT.POV.FOV = DefaultFOV;
    CamActor = CameraActor(OutVT.Target);
    if (CamActor != None)
    {
        CamActor.GetCameraView(DeltaTime, OutVT.POV);
        bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
        OutVT.AspectRatio = CamActor.AspectRatio;
        CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
        CamPostProcessSettings = CamActor.CamOverridePostProcess;
    }
    else if (Pawn(OutVT.Target) == None || !Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.location, OutVT.POV.Rotation, OutVT.POV.FOV))
    {
        bDoNotApplyModifiers = TRUE;
        switch (CameraStyle)
        {
            case 'Fixed':
                OutVT.POV = OrigPOV;
                break;
            case 'ThirdPerson':
            case 'FreeCam':
            case 'FreeCam_Default':
                Loc = OutVT.Target.location;
                Rot = OutVT.Target.Rotation;
                if (CameraStyle == 'FreeCam' || CameraStyle == 'FreeCam_Default')
                {
                    Rot = PCOwner.Rotation;
                }
                Loc += FreeCamOffset >> Rot;
                pos = Loc - Vector(Rot) * FreeCamDistance;
                HitActor = Trace(HitLocation, HitNormal, pos, Loc, FALSE, vect(12.0, 12.0, 12.0), , );
                OutVT.POV.location = HitActor == None ? pos : HitLocation;
                OutVT.POV.Rotation = Rot;
                break;
            case 'FirstPerson':
            default:
                OutVT.Target.GetActorEyesViewPoint(OutVT.POV.location, OutVT.POV.Rotation);
                break;
        }
    }
    if (!bDoNotApplyModifiers)
    {
        ApplyCameraModifiers(DeltaTime, OutVT.POV);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CamPostProcessSettings = {
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
    CameraShakeCamModClass = Class'CameraModifier_CameraShake'
    ViewTarget = {
                  POV = {
                         location = {X = 0.0, Y = 0.0, Z = 0.0}, 
                         Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                         FOV = 90.0
                        }, 
                  Target = None, 
                  Controller = None, 
                  AspectRatio = 0.0, 
                  PRI = None
                 }
    PendingViewTarget = {
                         POV = {
                                location = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                                FOV = 90.0
                               }, 
                         Target = None, 
                         Controller = None, 
                         AspectRatio = 0.0, 
                         PRI = None
                        }
    CameraCache = {
                   POV = {
                          location = {X = 0.0, Y = 0.0, Z = 0.0}, 
                          Rotation = {Pitch = 0, Yaw = 0, Roll = 0}, 
                          FOV = 90.0
                         }, 
                   TimeStamp = 0.0
                  }
    BlendParams = {BlendTime = 0.0, BlendExp = 2.0, bSkipCameraReset = FALSE, BlendFunction = EViewTargetBlendFunction.VTBlend_Cubic}
    DefaultFOV = 90.0
    DefaultAspectRatio = 1.33333004
    FreeCamDistance = 256.0
    bHidden = TRUE
}