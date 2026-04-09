Class SFXCustomAction_PlayerMeleed extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('None', 'DG_Right', 'None')
                  }
    fAnimPlayRate = 0.800000012
    fAnimBlendInTime = 0.100000001
    bAllowAnimInterrupt = FALSE
    PlayerCameraMode = Class'SFXCameraMode_HitReaction'
    fCameraTransitionIn = 0.25
    fCameraTransitionOut = 0.25
    bDisableMovement = FALSE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_ReceivedDamage
}