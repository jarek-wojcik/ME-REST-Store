Class CameraModifier_CameraShake extends CameraModifier
    native;

struct native CameraShakeInstance 
{
    var Matrix UserPlaySpaceMatrix;
    var Vector LocSinOffset;
    var Vector RotSinOffset;
    var clearcrosslevel CameraShake SourceShake;
    var float OscillatorTimeRemaining;
    var float CurrentBlendInTime;
    var float CurrentBlendOutTime;
    var float FOVSinOffset;
    var float Scale;
    var CameraAnimInst AnimInst;
    var bool bBlendingIn;
    var bool bBlendingOut;
    var ECameraAnimPlaySpace PlaySpace;
};

var clearcrosslevel array<CameraShakeInstance> ActiveShakes;
var(CameraModifier_CameraShake) const float SplitScreenShakeScale;

public native function bool ModifyCamera(Camera Camera, float DeltaTime, out TPOV OutPOV);

public native function UpdateCameraShake(float DeltaTime, out CameraShakeInstance Shake, out TPOV OutPOV);

public function AddCameraShake(CameraShake NewShake, float Scale, optional ECameraAnimPlaySpace PlaySpace = 0, optional Rotator UserPlaySpaceRot)
{
    local int ShakeIdx;
    local int NumShakes;
    
    if (NewShake != None)
    {
        if (NewShake.bSingleInstance)
        {
            ShakeIdx = ActiveShakes.Find('SourceShake', NewShake);
            if (ShakeIdx != -1)
            {
                ReinitShake(ShakeIdx, Scale);
                return;
            }
        }
        NumShakes = ActiveShakes.Length;
        ActiveShakes[NumShakes] = InitializeShake(NewShake, Scale, PlaySpace, UserPlaySpaceRot);
    }
}
protected static function float InitializeOffset(const out FOscillator Param)
{
    switch (Param.InitialOffset)
    {
        case EInitialOscillatorOffset.EOO_OffsetRandom:
            return FRand() * float(2) * 3.14159274;
            break;
        case EInitialOscillatorOffset.EOO_OffsetZero:
            return 0.0;
            break;
        default:
    }
    return 0.0;
}
protected function CameraShakeInstance InitializeShake(CameraShake NewShake, float Scale, ECameraAnimPlaySpace PlaySpace, optional Rotator UserPlaySpaceRot)
{
    local CameraShakeInstance Inst;
    local float Duration;
    local bool bRandomStart;
    local bool bLoop;
    
    Inst.SourceShake = NewShake;
    Inst.Scale = Scale;
    if (Class'Engine'.static.IsSplitScreen())
    {
        Scale *= SplitScreenShakeScale;
    }
    if (NewShake.OscillationDuration != 0.0)
    {
        Inst.RotSinOffset.X = InitializeOffset(NewShake.RotOscillation.Pitch);
        Inst.RotSinOffset.Y = InitializeOffset(NewShake.RotOscillation.Yaw);
        Inst.RotSinOffset.Z = InitializeOffset(NewShake.RotOscillation.Roll);
        Inst.LocSinOffset.X = InitializeOffset(NewShake.LocOscillation.X);
        Inst.LocSinOffset.Y = InitializeOffset(NewShake.LocOscillation.Y);
        Inst.LocSinOffset.Z = InitializeOffset(NewShake.LocOscillation.Z);
        Inst.FOVSinOffset = InitializeOffset(NewShake.FOVOscillation);
        Inst.OscillatorTimeRemaining = NewShake.OscillationDuration;
        if (NewShake.OscillationBlendInTime > 0.0)
        {
            Inst.bBlendingIn = TRUE;
            Inst.CurrentBlendInTime = 0.0;
        }
    }
    if (NewShake.Anim != None)
    {
        if (NewShake.bRandomAnimSegment)
        {
            bLoop = TRUE;
            bRandomStart = TRUE;
            Duration = NewShake.RandomAnimSegmentDuration;
        }
        if (Scale > 0.0)
        {
            Inst.AnimInst = CameraOwner.PlayCameraAnim(NewShake.Anim, NewShake.AnimPlayRate, Scale, NewShake.AnimBlendInTime, NewShake.AnimBlendOutTime, bLoop, bRandomStart, Duration, NewShake.bSingleInstance);
            if (PlaySpace != ECameraAnimPlaySpace.CAPS_CameraLocal && Inst.AnimInst != None)
            {
                Inst.AnimInst.SetPlaySpace(PlaySpace, UserPlaySpaceRot);
            }
        }
    }
    Inst.PlaySpace = PlaySpace;
    if (Inst.PlaySpace == ECameraAnimPlaySpace.CAPS_UserDefined)
    {
        Inst.UserPlaySpaceMatrix = MakeRotationMatrix(UserPlaySpaceRot);
    }
    return Inst;
}
protected function ReinitShake(int ActiveShakeIdx, float Scale)
{
    local CameraShake SourceShake;
    local float Duration;
    local bool bRandomStart;
    local bool bLoop;
    
    if (Class'Engine'.static.IsSplitScreen())
    {
        Scale *= SplitScreenShakeScale;
    }
    ActiveShakes[ActiveShakeIdx].Scale = Scale;
    SourceShake = ActiveShakes[ActiveShakeIdx].SourceShake;
    if (SourceShake.OscillationDuration != 0.0)
    {
        ActiveShakes[ActiveShakeIdx].OscillatorTimeRemaining = SourceShake.OscillationDuration;
        if (ActiveShakes[ActiveShakeIdx].bBlendingOut)
        {
            ActiveShakes[ActiveShakeIdx].bBlendingOut = FALSE;
            ActiveShakes[ActiveShakeIdx].CurrentBlendOutTime = 0.0;
            ActiveShakes[ActiveShakeIdx].bBlendingIn = TRUE;
            ActiveShakes[ActiveShakeIdx].CurrentBlendInTime = ActiveShakes[ActiveShakeIdx].SourceShake.OscillationBlendInTime * (1.0 - ActiveShakes[ActiveShakeIdx].CurrentBlendOutTime / ActiveShakes[ActiveShakeIdx].SourceShake.OscillationBlendOutTime);
        }
    }
    if (SourceShake.Anim != None)
    {
        if (SourceShake.bRandomAnimSegment)
        {
            bLoop = TRUE;
            bRandomStart = TRUE;
            Duration = SourceShake.RandomAnimSegmentDuration;
        }
        ActiveShakes[ActiveShakeIdx].AnimInst = CameraOwner.PlayCameraAnim(SourceShake.Anim, SourceShake.AnimPlayRate, Scale, SourceShake.AnimBlendInTime, SourceShake.AnimBlendOutTime, bLoop, bRandomStart, Duration, TRUE);
    }
}
public function RemoveAllCameraShakes()
{
    local int idx;
    local CameraAnimInst AnimInst;
    
    for (idx = 0; idx < ActiveShakes.Length; ++idx)
    {
        AnimInst = ActiveShakes[idx].AnimInst;
        if (AnimInst != None && !AnimInst.bFinished)
        {
            CameraOwner.StopCameraAnim(AnimInst, TRUE);
        }
    }
    ActiveShakes.Length = 0;
}
public function RemoveCameraShake(CameraShake Shake)
{
    local int idx;
    local CameraAnimInst AnimInst;
    
    idx = ActiveShakes.Find('SourceShake', Shake);
    if (idx != -1)
    {
        AnimInst = ActiveShakes[idx].AnimInst;
        if (AnimInst != None && !AnimInst.bFinished)
        {
            CameraOwner.StopCameraAnim(AnimInst, TRUE);
        }
        ActiveShakes.Remove(idx, 1);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SplitScreenShakeScale = 0.5
}