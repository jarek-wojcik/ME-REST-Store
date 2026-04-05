Class SFXCustomAction_Reload extends SFXCustomAction_ReloadBase
    config(Game);

var(SFXCustomAction_Reload) BodyStance BS_Anim;
var(SFXCustomAction_Reload) float fAnimBlendInTime;
var(SFXCustomAction_Reload) float fAnimBlendOutTime;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Anim, UsedAnims);
    Super(BioCustomAction).GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    Super(BioCustomAction).StartCustomAction();
    m_oPawn.PlayBodyStance(BS_Anim, 1.0, fAnimBlendInTime, fAnimBlendOutTime, FALSE, , 'RELOAD');
}
public function StopCustomAction()
{
    Super(BioCustomAction).StopCustomAction();
    m_oPawn.StopBodyStance(BS_Anim, fAnimBlendOutTime);
    m_oPawn.SetBodyStanceAnimLooping(BS_Anim, FALSE);
    if (m_oPawn != None && SFXWeapon(m_oPawn.Weapon) != None)
    {
        SFXWeapon(m_oPawn.Weapon).CancelReload();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Anim = {
               AnimName = ('None', 
                           'CB_Reload', 
                           'CB_Reload', 
                           'CB_ReloadCover', 
                           'None', 
                           'CB_ReloadCover_Mid', 
                           'None', 
                           'None', 
                           'None', 
                           'None', 
                           'None', 
                           'CB_Reload'
                          )
              }
    fAnimBlendInTime = 0.200000003
    fAnimBlendOutTime = 0.200000003
    OverrideList = (Class'SFXCustomAction_Ragdoll', 
                    Class'SFXCustomAction_AnimatedRagdoll', 
                    Class'SFXCustomAction_Frozen', 
                    Class'SFXCustomAction_PlayerStandardImpact', 
                    Class'SFXCustomAction_PlayerStaggerImpact', 
                    Class'SFXCustomAction_PlayerKnockbackImpact', 
                    Class'SFXCustomAction_PlayerMeleed', 
                    Class'SFXCustomAction_MeleedLeft', 
                    Class'SFXCustomAction_MeleedRight', 
                    Class'SFXCustomAction_PlayerOnFire', 
                    Class'SFXCustomAction_MeleedRight', 
                    Class'SFXCustomAction_SyncPawnPartner_Base', 
                    Class'SFXCustomAction_SwatTurn', 
                    Class'SFXCustomAction_CoverSlipBase', 
                    Class'BioCustomAction_CoverMantle', 
                    Class'BioCustomAction_CoverClimb', 
                    Class'SFXCustomAction_PlayerEvadeLeft', 
                    Class'SFXCustomAction_PlayerEvadeRight', 
                    Class'SFXCustomAction_PlayerEvadeForward', 
                    Class'SFXCustomAction_PlayerEvadeBackwards'
                   )
    bDisableLeftHandIK = TRUE
    bDisableAiming = FALSE
    bBlockingAction = FALSE
    bPushAICommand = FALSE
    Priority = ECustomActionPriority.CA_Priority_Medium
}