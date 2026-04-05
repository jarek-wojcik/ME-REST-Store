Class SFXCustomAction_Meleed extends SFXCustomAction_DamageReaction
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Reaction = {
                   AnimName = ('DG_Impact_Body_Backward01')
                  }
    bRotateOnHit = TRUE
    ERootMotionMode = ERootMotionMode.RMM_Accel
    OverrideList = (Class'SFXCustomAction_Ragdoll', Class'SFXCustomAction_AnimatedRagdoll', Class'SFXCustomAction_Frozen', Class'SFXCustomAction_Meleed', Class'SFXCustomAction_MeleedLeft', Class'SFXCustomAction_MeleedRight', Class'SFXCustomAction_MeleedForward')
}