Class SFXCustomAction_JumpDown extends SFXCustomAction_BoostDownBase
    config(Game);

public function PlayStartAnimation()
{
    local SFXCustomReachSpec ReachSpec;
    local SFXNav_BlockingPathNode StartPoint;
    local SFXNav_BlockingPathNode EndPoint;
    
    ReachSpec = SFXCustomReachSpec(MovementPath);
    if (ReachSpec != None && float(ReachSpec.Distance) <= 0.0)
    {
        EndThisCustomAction();
        return;
    }
    StartPoint = SFXNav_BlockingPathNode(ReachSpec.Start);
    EndPoint = SFXNav_BlockingPathNode(ReachSpec.End.Actor);
    if (StartPoint != None && EndPoint != None)
    {
        Super(SFXCustomAction_ProceduralMoveBase).PlayStartAnimation();
    }
    else
    {
        EndThisCustomAction();
    }
}
public function TickInput(BioPlayerInput Input, float DeltaTime)
{
    if (MoveStage == EMoveStage.EMS_Sync)
    {
        if (Input.Outer.DetectPressAway(MovementPath.Start.location, MovementPath.End.Actor.location))
        {
            m_oPawn.InterruptCustomAction();
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Start = {
                AnimName = ('CB_JumpDown_3m_Enter')
               }
    BS_Loop = {
               AnimName = ('CB_JumpDown_Loop')
              }
    BS_End = {
              AnimName = ('CB_JumpDown_3m_Exit')
             }
    fEndAnimDist = 50.0
    fStartBlendInTime = 0.200000003
    fStartBlendOutTime = 0.200000003
    fLoopBlendInTime = 0.200000003
    fLoopBlendOutTime = 0.150000006
    fEndBlendInTime = 0.200000003
    fEndBlendOutTime = 0.200000003
    fLoopTimeout = 0.75
    StartRMM = ERootMotionMode.RMM_Translate
    EndRMM = ERootMotionMode.RMM_Translate
    PlayerCameraMode = Class'SFXCameraMode_LadderDown'
    GravityScale = 3.0
    fCameraTransitionIn = 0.5
    fCameraTransitionOut = 0.5
    bAllowChargeHolding = TRUE
}