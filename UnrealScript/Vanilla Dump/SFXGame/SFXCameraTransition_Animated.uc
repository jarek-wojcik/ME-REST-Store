Class SFXCameraTransition_Animated extends SFXCameraMode_Interpolate;

var(SFXCameraTransition_Animated) CameraAnim Anim;
var(SFXCameraTransition_Animated) float DefaultBlendInTime;
var(SFXCameraTransition_Animated) float DefaultBlendOutTime;
var(SFXCameraTransition_Animated) bool bAnimationBegun;
var(SFXCameraTransition_Animated) bool bScalePlayRate;

public function Tick(float TimeDelta)
{
    local float AnimPlaySpeed;
    local PlayerController PC;
    
    Super.Tick(TimeDelta);
    if (!bAnimationBegun)
    {
        bAnimationBegun = TRUE;
        if (bScalePlayRate)
        {
            AnimPlaySpeed = Anim.AnimLength / TotalTime;
        }
        else
        {
            AnimPlaySpeed = 1.0;
            TotalTime = Anim.AnimLength;
        }
        PC = PlayerController(GetViewTargetAsController());
        SFXPlayerCamera(PC.PlayerCamera).PlayCameraAnim(Anim, AnimPlaySpeed, , 0.0, 0.0);
    }
}
public function InitializeTransition(SFXCameraMode FromMode, SFXCameraMode ToMode, float Time, bool PreserveTarget)
{
    Super.InitializeTransition(FromMode, ToMode, Time, PreserveTarget);
    bAnimationBegun = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Anim = CameraAnim'CameraAnimations.TestTransition'
    DefaultBlendInTime = 0.200000003
    DefaultBlendOutTime = 0.200000003
    bScalePlayRate = TRUE
    Input = s_Input
}