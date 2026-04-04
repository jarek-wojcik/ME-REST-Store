Class SFXCustomAction_PlayerStandardImpactForward extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('None', 'DG_Impact_PC_ShortImpact_Behind', 'None')
                  }
    bBreakFromCover = FALSE
    bDisableMovement = FALSE
    bNotifyKnockedOutOfCover = FALSE
}