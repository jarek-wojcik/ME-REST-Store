Class SFXCustomAction_StandardImpactII extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('DG_Impact_Standard02')
                  }
    ERootMotionMode = ERootMotionMode.RMM_Translate
}