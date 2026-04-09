Class SFXCustomAction_AILadderClimbDown extends SFXCustomAction_LadderClimbDownBase
    config(Game);

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
    StartRootRotationPitch = ERootRotationOption.RRO_Extract
    StartRootRotationYaw = ERootRotationOption.RRO_Extract
    StartRootRotationRoll = ERootRotationOption.RRO_Extract
    EndRootRotationPitch = ERootRotationOption.RRO_Extract
    EndRootRotationYaw = ERootRotationOption.RRO_Extract
    EndRootRotationRoll = ERootRotationOption.RRO_Extract
    StartRMRM = ERootMotionRotationMode.RMRM_RotateActor
    EndRMRM = ERootMotionRotationMode.RMRM_RotateActor
}