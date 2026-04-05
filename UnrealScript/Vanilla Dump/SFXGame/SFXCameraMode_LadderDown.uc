Class SFXCameraMode_LadderDown extends SFXCameraMode_Combat;

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
    local SFXCustomAction_ReachSpecMove CA;
    local Vector ToEnd;
    local Vector ToEnd2D;
    local NavigationPoint StartNode;
    local NavigationPoint EndNode;
    
    BP = BioPawn(GetViewTargetAsPawn());
    BP.GetCurrentCustomAction(Action);
    CA = SFXCustomAction_ReachSpecMove(Action);
    if (CA == None)
    {
        return;
    }
    StartNode = CA.MovementPath.Start;
    EndNode = NavigationPoint(CA.MovementPath.End.Actor);
    if (EndNode != None && StartNode != None)
    {
        ToEnd = EndNode.location - StartNode.location;
        ToEnd.Z /= 2.0;
        ToEnd = Normal(ToEnd);
        ToEnd2D = ToEnd;
        ToEnd2D.Z = 0.0;
        ToEnd2D = Normal(ToEnd2D);
        if (CA.MoveStage == EMoveStage.EMS_End)
        {
            CameraTargetDir = Rotator(ToEnd2D);
        }
        else
        {
            CameraTargetDir = Rotator(ToEnd);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=MotionBlurEffect Name=s_DefaultBlur
    End Template
    Begin Template Class=SFXCameraInput Name=s_Input
    End Template
    Blur = s_DefaultBlur
    Offset = {X = 80.0, Y = 0.0, Z = -20.0}
    HookOffset = {X = 0.0, Y = 40.0, Z = 80.0}
    HookName = 'God'
    Input = s_Input
    bRecenterCameraNew = TRUE
    bAutoCancelCameraRecentering = TRUE
}