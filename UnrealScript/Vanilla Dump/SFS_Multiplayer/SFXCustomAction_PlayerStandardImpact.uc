Class SFXCustomAction_PlayerStandardImpact extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('None', 'DG_Left', 'None')
                  }
    fAnimPlayRate = 0.800000012
    fAnimBlendInTime = 0.100000001
    bAllowAnimInterrupt = FALSE
    bDisableMovement = FALSE
    bBlockingAction = FALSE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_ReceivedDamage
}