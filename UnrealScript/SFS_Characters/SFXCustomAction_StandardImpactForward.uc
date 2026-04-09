Class SFXCustomAction_StandardImpactForward extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('DG_Impact_PC_ShortImpact_Behind')
                  }
    ERootMotionMode = ERootMotionMode.RMM_Translate
    PlayerCameraMode = Class'SFXCameraMode_HitReaction'
    fCameraTransitionIn = 0.25
    fCameraTransitionOut = 0.25
}