Class SFXCustomAction_PlayerLadderClimbDown extends SFXCustomAction_LadderClimbDownBase
    config(Game);

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
                AnimName = ('EX_LadderDown_Enter')
               }
    BS_Loop = {
               AnimName = ('EX_LadderDown_Loop')
              }
    BS_End = {
              AnimName = ('EX_LadderDown_Exit')
             }
    fEndAnimDist = 100.0
    EndRMM = ERootMotionMode.RMM_Translate
    StartRootRotationPitch = ERootRotationOption.RRO_Extract
    StartRootRotationYaw = ERootRotationOption.RRO_Extract
    StartRootRotationRoll = ERootRotationOption.RRO_Extract
    EndRootRotationPitch = ERootRotationOption.RRO_Extract
    EndRootRotationYaw = ERootRotationOption.RRO_Extract
    EndRootRotationRoll = ERootRotationOption.RRO_Extract
    PlayerCameraMode = Class'SFXCameraMode_LadderDown'
    fCameraTransitionIn = 1.0
    fCameraTransitionOut = 1.0
    bDisableLook = FALSE
}