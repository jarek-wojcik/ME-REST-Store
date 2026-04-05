Class SFXCustomAction_PlayerStaggerImpact extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('DG_Impact_PC_StaggerImpact')
                  }
    fAnimBlendInTime = 0.100000001
    ERootMotionMode = ERootMotionMode.RMM_Accel
    bBreakFromCover = FALSE
    bNotifyKnockedOutOfCover = FALSE
    Priority = ECustomActionPriority.CA_Priority_High
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_ReceivedDamage
}