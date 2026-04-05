Class SFXCustomAction_StaggerImpactForward extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('DG_Impact_Body_Forward01')
                  }
    ERootMotionMode = ERootMotionMode.RMM_Accel
    Priority = ECustomActionPriority.CA_Priority_High
}