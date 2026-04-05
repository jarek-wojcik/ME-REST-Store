Class SFXCustomAction_ClassMelee extends SFXCustomAction_SyncPawnInstigator_Base
    abstract
    config(Game);

var BodyStance BS_Attacker;
var BodyStance BS_Victim;
var(Damage) Class<SFXDamageType> DamageType;
var(Power) Class<SFXPowerCustomAction> PowerClass;
var(AnimControl) SFXAnimSetCookSpec AnimInfo;
var(Timing) float SyncAttackTimer;
var(Timing) float AnimPlayRate;
var(Timing) float AttackerBlendInTime;
var(Timing) float AttackerBlendOut;
var(Timing) float VictimPlayRate;
var(Timing) float VictimBlendInTime;
var(Damage) float DamageAmount;
var(Power) SFXPowerCustomAction_MeleePassivePower Power;
var transient bool bApplyDamage;
var(RootMotion) ERootMotionMode eVictimRootMotionMode;

public function StartCustomAction()
{
    m_oPawn.RegisterTemporaryAnim(AnimInfo.AnimSet);
    if (m_oPawn.SyncPawn != None && (m_oPawn.Role == ENetRole.ROLE_SimulatedProxy || CanInteractWithPawn(BioPawn(m_oPawn.SyncPawn))))
    {
        SyncPartner = BioPawn(m_oPawn.SyncPawn);
    }
    m_oPawn.SyncPawn = None;
    Super.StartCustomAction();
    bApplyDamage = FALSE;
    if (Power == None && m_oPawn.PowerManager != None)
    {
        Power = SFXPowerCustomAction_MeleePassivePower(m_oPawn.PowerManager.GetPowerByClass(PowerClass));
    }
}
public function StartInteraction()
{
    MoveToMarkers();
    if (!bMoveSyncPawn || SyncPartner != None && (SyncPartner.Role != ENetRole.ROLE_Authority && !bForceLocalSimulation))
    {
        StartMeleeAttack();
    }
    else
    {
        m_oPawn.SetTimer(InteractionStartTimeOut, FALSE, 'InteractionStartTimedOut', Self);
    }
    Super.StartInteraction();
}
public function GetAttackerAnim(out BodyStance Stance)
{
    Stance = BS_Attacker;
}
public function GetVictimAnim(out BodyStance Stance)
{
    Stance = BS_Victim;
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    return TRUE;
}
public function InterruptThisCustomAction()
{
    bApplyDamage = FALSE;
    Super(BioCustomAction).InterruptThisCustomAction();
}
public function NonSyncedAction()
{
    StartMeleeAttack();
}
public function OnPartnerLeavingCustomAction();

public function OnPartnerReachedDestination()
{
    m_oPawn.ClearTimer('InteractionStartTimedOut', Self);
    StartMeleeAttack();
}
public function StartMeleeAttack()
{
    local BodyStance AttackAnim;
    
    GetAttackerAnim(AttackAnim);
    m_oPawn.PlayBodyStance(AttackAnim, AnimPlayRate, AttackerBlendInTime, AttackerBlendOut);
    m_oPawn.SetBodyStanceAnimEndNotification(AttackAnim, TRUE);
    ApplyTimeline(TimelineTemplate, m_oPawn, SyncPartner);
    if (SyncPartner != None)
    {
        if (SyncAttackTimer > 0.0)
        {
            m_oPawn.SetTimer(SyncAttackTimer, FALSE, 'SyncAttack', Self);
        }
        else
        {
            SyncAttack();
        }
    }
}
public function StopCustomAction()
{
    local BodyStance AttackAnim;
    local BodyStance VictimAnim;
    
    GetAttackerAnim(AttackAnim);
    GetVictimAnim(VictimAnim);
    m_oPawn.UnregisterTemporaryAnim(AnimInfo.AnimSet);
    m_oPawn.SetBodyStanceAnimEndNotification(AttackAnim, FALSE);
    m_oPawn.StopBodyStance(AttackAnim, AttackerBlendOut);
    RemoveTimeline();
    if (SyncPartner != None)
    {
        SyncPartner.UnregisterTemporaryAnim(AnimInfo.AnimSet);
        if (eVictimRootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            SyncPartner.Mesh.RootMotionMode = SyncPartner.Mesh.default.RootMotionMode;
            SyncPartner.SetBodyStanceRootBoneAxisOption(VictimAnim, 1, 1, 1);
        }
    }
    if (SyncPartner != None && DamageAmount > 0.0 && bApplyDamage)
    {
        SyncPartner.TakeDamage(DamageAmount, m_oPawn.Controller, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), DamageType);
    }
    if (m_oPawn.IsInvisible())
    {
        m_oPawn.BreakStealth();
    }
    Super.StopCustomAction();
}
public function SyncAttack()
{
    local BodyStance VictimAnim;
    
    GetVictimAnim(VictimAnim);
    SyncPartner.RegisterTemporaryAnim(AnimInfo.AnimSet);
    SyncPartner.PlayBodyStance(VictimAnim, VictimPlayRate, VictimBlendInTime, 0.0);
    if (eVictimRootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        SyncPartner.SetBodyStanceRootBoneAxisOption(VictimAnim, 2, 2, 2);
        SyncPartner.Mesh.RootMotionMode = eVictimRootMotionMode;
    }
    bApplyDamage = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DamageType = Class'SFXDamageType_Melee'
    SyncAttackTimer = 0.100000001
    AnimPlayRate = 1.0
    AttackerBlendInTime = 0.200000003
    AttackerBlendOut = 0.200000003
    VictimPlayRate = 1.0
    VictimBlendInTime = 0.200000003
    DamageAmount = 10000.0
    MarkerOffset = {X = 100.0, Y = 0.0, Z = 0.0}
    PartnerCustomAction = 3
    MaxPartnerDistance = 450.0
    MoveSpeed = 650.0
    bIgnoreDamage = TRUE
    bHideWeapon = TRUE
    bTurnOffReticle = TRUE
    bReplicateCustomAction = TRUE
    Priority = ECustomActionPriority.CA_Priority_High
}