Class SFXCustomAction_StandardImpact extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('DG_Impact_Standard01')
                  }
    fAnimPlayRate = 1.25
    ERootMotionMode = ERootMotionMode.RMM_Accel
    PlayerCameraMode = Class'SFXCameraMode_HitReaction'
    fCameraTransitionIn = 0.25
    fCameraTransitionOut = 0.25
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_ReceivedDamage
}