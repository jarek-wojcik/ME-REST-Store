Class SFXCustomAction_Cover90TurnLeft extends SFXCustomAction_Cover90TurnBase
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Anim = {
               AnimName = ('CB_MidLTurn90Outer_Enter')
              }
    fAnimBlendInTime = 0.100000001
    fAnimBlendOutTime = 0.200000003
    CameraTransitionTime = 1.0
    ERootMotionRotationMode = ERootMotionRotationMode.RMRM_RotateActor
    bDisableLook = TRUE
}