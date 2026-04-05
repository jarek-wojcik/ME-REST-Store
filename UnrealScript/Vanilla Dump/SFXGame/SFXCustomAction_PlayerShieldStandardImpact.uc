Class SFXCustomAction_PlayerShieldStandardImpact extends SFXCustomAction_SingleAnim
    config(Game);

var(SFXCustomAction_PlayerShieldStandardImpact) BodyStance BS_Anim1;
var transient int RandPercent;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Anim1, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    if (RandPercent <= 33)
    {
        BS_Anim = default.BS_Anim;
    }
    else if (RandPercent <= 66)
    {
        BS_Anim = default.BS_Anim1;
    }
    else
    {
        BS_Anim = default.BS_Anim;
    }
    Super.StartCustomAction();
}
public function EndAction()
{
    InterruptThisCustomAction();
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    if (m_oPawn != None && m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        RandPercent = int(FRand() * 100.0);
        RandomReactionRolled = byte(RandPercent);
    }
    else
    {
        RandPercent = int(RandomReactionRolled);
    }
    return Super(BioCustomAction).InternalCanDoCustomAction(SyncPawn, bForced);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Anim1 = {
                AnimName = ('None', 'DG_Right', 'None')
               }
    BS_Anim = {
               AnimName = ('None', 'DG_Left', 'None')
              }
    fAnimBlendInTime = 0.100000001
    fAnimBlendOutTime = 0.100000001
    OverrideList = (Class'SFXCustomAction_Ragdoll', Class'SFXCustomAction_AnimatedRagdoll', Class'SFXCustomAction_Frozen', Class'BioCustomAction')
    bBreakFromCover = FALSE
    bDisableMovement = FALSE
    bNotifyKnockedOutOfCover = FALSE
    bDisableShooting = FALSE
    bAllowChargeHolding = TRUE
    bDisableAiming = FALSE
    bBlockingAction = FALSE
    bPushAICommand = FALSE
}