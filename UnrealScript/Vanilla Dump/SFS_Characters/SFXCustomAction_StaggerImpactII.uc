Class SFXCustomAction_StaggerImpactII extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('DG_Impact_Body_Backward01')
                  }
    bRotateOnHit = TRUE
    ERootMotionMode = ERootMotionMode.RMM_Translate
    Priority = ECustomActionPriority.CA_Priority_High
}