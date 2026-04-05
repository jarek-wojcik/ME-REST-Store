Class SFXCameraMode_Melee extends SFXCameraMode_Combat;

public function Tick(float DeltaTime)
{
    SetTarget();
    Super(SFXCameraMode).Tick(DeltaTime);
}
public function ProcessViewRotation(float DeltaTime, out Rotator OutViewRotation, out Rotator OutDeltaRot);

public function SetTarget()
{
    local BioPawn BP;
    local BioCustomAction Action;
    local SFXCustomAction_ProceduralSync CA;
    local Rotator ToEnd;
    
    BP = BioPawn(GetViewTargetAsPawn());
    BP.GetCurrentCustomAction(Action);
    CA = SFXCustomAction_ProceduralSync(Action);
    if (CA == None)
    {
        CameraTargetDir = BP.Controller.Rotation;
        return;
    }
    else
    {
        bRecenterCameraNew = TRUE;
        ToEnd = BP.Rotation;
        ToEnd.Pitch = 0;
        CameraTargetDir = ToEnd;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
        CameraSensitivity = {X = 10.0, Y = 10.0}
    End Template
    Blur = s_DefaultBlur
    TimeToRecenter = 0.25
    Input = s_Input
    bRecenterCamera = TRUE
}