Class SFXPowerCustomAction_AmmoPower extends SFXPowerCustomAction_AmmoPowerBase
    abstract
    config(Game);

var Class<SFXGameEffect_AmmoPower> WeaponPowerEffectClass;
var Class<SFXDamageType> ConcussiveShotDamageType;
var Guid OmniToolGuid;
var StaticMesh oTracer;
var ParticleSystem oImpactVFX;
var ParticleSystem oMuzzleVFX;
var ParticleSystem oMuzzleLoopVFX;
var float SquadEffectiveness;
var stringref NotRecommended_HeavyWeaponEquipped;
var RvrClientEffectInterface CE_ConcussiveShotImpact;
var RvrClientEffectInterface CE_ConcussiveShotProjectile;
var WwiseEvent ConcussiveShotImpactSound;
var WwiseEvent LoadAmmoPowerSound;
var WwiseEvent HenchmanLoadAmmoPowerSound;
var RvrClientEffectInterface CE_OmniTool;
var float OmniToolDuration;
var clearcrosslevel BioPawn DelayedSetWeaponPowerTarget;
var bool bModifyTracer;
var bool bModifyImpactVFX;
var bool bModifyMuzzle;

public function bool CanUsePower(Actor oTarget)
{
    local SFXWeapon Weapon;
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    if (m_oPawn != None && SFXHeavyWeapon(m_oPawn.Weapon) != None)
    {
        return FALSE;
    }
    if (SFXPawn_Player(m_oPawn) == None)
    {
        Weapon = SFXWeapon(m_oPawn.Weapon);
        if (Weapon != None)
        {
            Manager = Weapon.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None)
            {
                foreach Manager.GameEffects(Effect, )
                {
                    if (SFXGameEffect_AmmoPower(Effect) != None && SFXGameEffect_AmmoPower(Effect).AddedByPlayer && !m_bPlayerOrderedPowerUse)
                    {
                        return FALSE;
                    }
                }
            }
        }
    }
    return Super(SFXPowerCustomAction).CanUsePower(oTarget);
}
public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local BioPawn oPawn;
    
    oPawn = BioPawn(oImpacted);
    if (oPawn != None && (oImpacted == m_oPawn || m_bPlayerOrderedPowerUse))
    {
        if (oPawn.Weapon != None)
        {
            SetWeaponPower(oPawn, SFXWeapon(oPawn.Weapon), TRUE);
        }
        else if (m_oPawn.Role == ENetRole.ROLE_SimulatedProxy && oImpacted == m_oPawn)
        {
            DeferedSetWeaponPower();
        }
    }
    return TRUE;
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super(SFXPowerCustomAction).PrecacheVFX(ObjectPool, ClientEffects);
    ObjectPool.PrecacheImpactParticleSystemComponent(default.oImpactVFX);
}
public function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    local SFXWeapon Weapon;
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    if (SFXHeavyWeapon(m_oPawn.Weapon) != None)
    {
        sOptionalInfo = string(NotRecommended_HeavyWeaponEquipped);
        return FALSE;
    }
    Weapon = SFXWeapon(m_oPawn.Weapon);
    if (Weapon != None)
    {
        Manager = Weapon.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            foreach Manager.GameEffects(Effect, )
            {
                if (SFXGameEffect_AmmoPower(Effect) != None && Effect.Class == WeaponPowerEffectClass)
                {
                    sOptionalInfo = string(NotRecommended_WeaponPowerAlreadyOn);
                    return FALSE;
                }
            }
        }
    }
    return TRUE;
}
public function StartCustomAction()
{
    Super(SFXPowerCustomAction).StartCustomAction();
    if (SFXPawn_Player(m_oPawn) != None && LoadAmmoPowerSound != None)
    {
        m_oPawn.PlaySound(LoadAmmoPowerSound, TRUE);
    }
    else if (HenchmanLoadAmmoPowerSound != None)
    {
        m_oPawn.PlaySound(HenchmanLoadAmmoPowerSound, TRUE);
    }
    OmniToolGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().Start(CE_OmniTool, m_oPawn);
    m_oPawn.SetTimer(OmniToolDuration, FALSE, 'StopOmniTool', Self);
}
public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    if (m_oPawn == None)
    {
        return;
    }
    if (ImpactCount == -1)
    {
        DelayedSetWeaponPowerTarget = BioPawn(oActor);
        DelayedSetWeaponPower();
    }
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    DoConcussiveShotSpecialImpact(oActor, Duration);
}
public function DoJoinInProgress()
{
    local SFXWeapon Weapon;
    local SFXModule_GameEffectManager Manager;
    
    if (ShouldReplicate() == FALSE)
    {
        return;
    }
    foreach m_oPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        Manager = Weapon.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            if (Manager.HasEffectOfType(WeaponPowerEffectClass))
            {
                ReplicateImpact(m_oPawn, -1);
                return;
            }
        }
    }
}
public function OnPowerRankIncreased()
{
    local SFXWeapon Weapon;
    local SFXModule_GameEffectManager Manager;
    
    Super(SFXPowerCustomActionBase).OnPowerRankIncreased();
    foreach m_oPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        Manager = Weapon.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            if (Manager.HasEffectOfType(WeaponPowerEffectClass))
            {
                SetWeaponPower(m_oPawn, Weapon, TRUE);
            }
        }
    }
}
public function ReloadAmmoPower(BioPawn Target, SFXWeapon Weapon)
{
    if (Target != None && Weapon != None)
    {
        SetWeaponPower(Target, Weapon, TRUE);
    }
}
public function bool SetWeaponPower(BioPawn oPawn, SFXWeapon oWeapon, bool bOverrideCurrentPower)
{
    local SFXHeavyWeapon oHeavyWeapon;
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_WeaponVFXChange WeaponVFXEffect;
    
    if (oWeapon == None || oPawn == None)
    {
        return FALSE;
    }
    oHeavyWeapon = SFXHeavyWeapon(oWeapon);
    if (oHeavyWeapon != None)
    {
        return FALSE;
    }
    Manager = oWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return FALSE;
    }
    if (Manager.HasEffectOfCategory(oWeapon.Name))
    {
        if (bOverrideCurrentPower)
        {
            Manager.RemoveEffectsByCategory(oWeapon.Name);
        }
        else
        {
            return FALSE;
        }
    }
    WeaponVFXEffect = SFXGameEffect_WeaponVFXChange(Manager.CreateEffect(Class'SFXGameEffect_WeaponVFXChange', oWeapon.Name, 0.0, 2, 1.0, m_oPawn.Controller));
    if (WeaponVFXEffect != None)
    {
        WeaponVFXEffect.bModifyImpactVFX = bModifyImpactVFX;
        WeaponVFXEffect.oImpactVFX = oImpactVFX;
        WeaponVFXEffect.bModifyMuzzleFlash = bModifyMuzzle;
        WeaponVFXEffect.oMuzzleVFX = oMuzzleVFX;
        WeaponVFXEffect.oMuzzleLoopVFX = oMuzzleLoopVFX;
        if (!oWeapon.bNoAmmoPowerTracers)
        {
            WeaponVFXEffect.bModifyTracer = bModifyTracer;
            WeaponVFXEffect.Tracer = oTracer;
        }
        WeaponVFXEffect.OnApplied();
    }
    ApplyPowerEffects(oPawn, oWeapon);
    oWeapon.AmmoPowerName = PowerName;
    oWeapon.AmmoPowerSourceTag = m_oPawn.Tag;
    return TRUE;
}
public final function StopOmniTool()
{
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_OmniTool, OmniToolGuid, TRUE);
}
public function ApplyPowerEffects(BioPawn oPawn, SFXWeapon oWeapon);

public function ConcussiveShotCustomImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal);

public function DeferedSetWeaponPower()
{
    if (m_oPawn == None)
    {
        return;
    }
    if (m_oPawn.Weapon != None)
    {
        SetWeaponPower(m_oPawn, SFXWeapon(m_oPawn.Weapon), TRUE);
    }
    else
    {
        m_oPawn.SetTimer(0.100000001, FALSE, 'DeferedSetWeaponPower', Self);
    }
}
public final function DelayedSetWeaponPower()
{
    if (DelayedSetWeaponPowerTarget == None)
    {
        return;
    }
    if (DelayedSetWeaponPowerTarget.Weapon == None)
    {
        m_oPawn.SetTimer(0.100000001, FALSE, 'DelayedSetWeaponPower', Self);
    }
    else
    {
        SetWeaponPower(DelayedSetWeaponPowerTarget, SFXWeapon(DelayedSetWeaponPowerTarget.Weapon), TRUE);
    }
}
public function DoConcussiveShotSpecialImpact(Actor oImpacted, float ImpactEffectDuration);

public function ReplicateConcussiveShotSpecialImpact(BioPawn oImpacted, float DurationOfEffect)
{
    if (ShouldReplicate())
    {
        ReplicatePowerSubsequentImpact(oImpacted, , DurationOfEffect);
    }
}
public function SetupEffect(SFXGameEffect_AmmoPower Effect, optional BioPawn oPawn);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_SniperSpecial
        m_nmOrigSetName = 'HMM_BC_SniperSpecial'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start_Cover_Neutral', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start_Cover_Neutral_Mid', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_End_Cover_Neutral', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_End_Cover_Neutral_Mid')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BioAnimSetData'
    End Object
    SquadEffectiveness = 0.5
    NotRecommended_HeavyWeaponEquipped = $341023
    CE_OmniTool = RvrClientEffect'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_Arm_Right_VCFX'
    OmniToolDuration = 0.75
    ReleaseTime = 0.5
    CastAnimSet = MY_DYN_HMM_BC_SniperSpecial
    CastSound = WwiseEvent'Wwise_Power_Soldier_Ammo.Play_power_soldier_P_ammo_basic_cast'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Soldier_Ammo.Play_power_soldier_NP_ammo_basic_cast'
    LeanOutToCast = FALSE
    UsesSharedCooldown = FALSE
    PowerType = EPowerType.PowerType_Buff
    HenchmanPowerType = EPowerType.PowerType_Buff
    MinTimeBetweenActions = 1.0
}