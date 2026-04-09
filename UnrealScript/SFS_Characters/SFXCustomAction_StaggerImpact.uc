Class SFXCustomAction_StaggerImpact extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('DG_Impact_PC_StaggerImpact')
                  }
    bRotateOnHit = TRUE
    ERootMotionMode = ERootMotionMode.RMM_Accel
    Priority = ECustomActionPriority.CA_Priority_High
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_ReceivedDamage
}