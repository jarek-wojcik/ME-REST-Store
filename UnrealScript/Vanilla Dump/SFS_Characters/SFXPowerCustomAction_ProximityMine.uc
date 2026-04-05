Class SFXPowerCustomAction_ProximityMine extends SFXPowerCustomAction
    config(Game);

var config PowerData Evolve_DamageTakenDebuffStrength;
var config PowerData Evolve_SlowDebuffStrength;
var config PowerData Evolve_DebuffDuration;
var config float Evolve_DamageBonus;
var config float Evolve_RadiusBonus;
var config float Evolve_SecondDamageBonus;
var config float Evolve_CooldownBonus;
var config int MaxActiveMines;
var RvrClientEffectInterface CE_HalfFrozenTemplate;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local RvrClientEffectTarget TargetInfo;
    local SFXPawn Pawn;
    local float fAssistBudget;
    
    Pawn = SFXPawn(oImpacted);
    if (Pawn == None)
    {
        return FALSE;
    }
    Manager = Pawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return FALSE;
    }
    if (IsEvolvedWithChoice(3))
    {
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_MovementSpeedBonus', Name);
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_MovementSpeedBonus', Name, Evolve_DebuffDuration.CurrentValue, 1, -Evolve_SlowDebuffStrength.CurrentValue, m_oPawn.Controller);
        TargetInfo.Instigator = Pawn;
        TargetInfo.SpawnValue.X = Evolve_DebuffDuration.CurrentValue;
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_HalfFrozenTemplate, TargetInfo);
        fAssistBudget += 0.25;
    }
    if (IsEvolvedWithChoice(2))
    {
        Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_DamageTakenBonus', Name);
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_DamageTakenBonus', Name, Evolve_DebuffDuration.CurrentValue, 1, Evolve_DamageTakenDebuffStrength.CurrentValue, m_oPawn.Controller);
        fAssistBudget += 0.25;
    }
    if (fAssistBudget > float(0))
    {
        Pawn.AddPowerAssistEvent(m_oPawn, DisplayName, fAssistBudget);
    }
    return TRUE;
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super.PrecacheVFX(ObjectPool, ClientEffects);
    ObjectPool.PrecacheProjectile(Class'SFXProjectile_PowerCustomAction_ProximityMine');
}
public function DoJoinInProgress()
{
    local SFXProjectile_PowerCustomAction oProjectile;
    local SFXProjectile_PowerCustomAction_ProximityMine oProjectileMine;
    
    Super(SFXPowerCustomActionBase).DoJoinInProgress();
    if (ShouldReplicate())
    {
        foreach Projectiles(oProjectile, )
        {
            oProjectileMine = SFXProjectile_PowerCustomAction_ProximityMine(oProjectile);
            if (oProjectileMine != None && oProjectileMine.bIsMineDeployed)
            {
                oProjectileMine.ReplicateMineDeployed();
            }
        }
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus);
            AddEvolvedRankBonus(Force, Evolve_DamageBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(ImpactRadius, Evolve_RadiusBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(Damage, Evolve_SecondDamageBonus);
            AddEvolvedRankBonus(Force, Evolve_SecondDamageBonus);
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(CooldownTime, Evolve_CooldownBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_CooldownBonus);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function float GetImpactDamage(Actor oImpacted, out Class<SFXDamageType> DamageType)
{
    local float ImpactDamage;
    
    ImpactDamage = Super.GetImpactDamage(oImpacted, DamageType);
    DamageType = Class'SFXDamageType_ProximityMine';
    return ImpactDamage;
}
public function bool GetProjectileAttachPoint(out Vector AttachPoint)
{
    local Rotator Rotation;
    
    if (SFXWeapon(m_oPawn.Weapon) != None && SkeletalMeshComponent(m_oPawn.Weapon.Mesh) != None)
    {
        if (SkeletalMeshComponent(m_oPawn.Weapon.Mesh).GetSocketWorldLocationAndRotation(SFXWeapon(m_oPawn.Weapon).MuzzleSocketName, AttachPoint, Rotation) == FALSE)
        {
            AttachPoint = m_oPawn.location;
        }
    }
    return TRUE;
}
public function OnOwnerDestroyed()
{
    local SFXProjectile_PowerCustomAction oProjectile;
    
    Super(SFXPowerCustomActionBase).OnOwnerDestroyed();
    if (m_oPawn != None && m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        foreach Projectiles(oProjectile, )
        {
            oProjectile.Explode(oProjectile.location, Normal(Vector(oProjectile.Rotation)));
        }
    }
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[5] = Evolve_CooldownBonus;
    PowerStatBars[1].Data = Damage;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Damage;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[1].EvolvedBonuses[4] = Evolve_SecondDamageBonus;
    PowerStatBars[2].Data = ImpactRadius;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Distance;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Distance;
    PowerStatBars[2].srStatBarDisplayTitle = StatBarTitle_ImpactRadius;
    PowerStatBars[2].EvolvedBonuses[1] = Evolve_RadiusBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(Evolve_DamageTakenDebuffStrength, bReset);
    RecalculatePowerData(Evolve_SlowDebuffStrength, bReset);
    RecalculatePowerData(Evolve_DebuffDuration, bReset);
}
public function ReleaseInstantPower()
{
    local SFXProjectile_PowerCustomAction_ProximityMine Projectile;
    local BioWorldInfo WorldInfo;
    local BioPlayerController PlayerController;
    local SFXPawn_Player PlayerPawn;
    local Vector TraceHitLocation;
    local Vector TraceNormal;
    local bool TraceReturn;
    local Actor TraceHitActor;
    local SFXPlayerCamera PlayerCamera;
    
    if (m_oPawn == None)
    {
        return;
    }
    WorldInfo = BioWorldInfo(m_oPawn.WorldInfo);
    if (WorldInfo == None)
    {
        return;
    }
    PlayerController = WorldInfo.GetLocalPlayerController();
    if (PlayerController == None)
    {
        return;
    }
    PlayerCamera = SFXPlayerCamera(PlayerController.PlayerCamera);
    if (PlayerCamera != None)
    {
        TraceReturn = PlayerCamera.GetTrace(TraceHitActor, TraceHitLocation, TraceNormal);
        if (!TraceReturn)
        {
            return;
        }
    }
    if (m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        Projectile = SFXGRI(m_oPawn.WorldInfo.GRI).ObjectPool.GetProjectile(Class'SFXProjectile_PowerCustomAction_ProximityMine', m_oPawn, m_oPawn.Instigator, TraceHitLocation, Rotator(TraceNormal * -1.0));
        if (Projectile != None)
        {
            Projectile.MinePower = Self;
            PlayerPawn = SFXPawn_Player(m_oPawn);
            if (PlayerPawn == None)
            {
                Projectiles.AddItem(Projectile);
            }
            Projectile.InitializePowerProjectile(m_oPawn, Projectile.MaxSpeed, ProjectileRadius, Self);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_ShotgunSpecial
        m_nmOrigSetName = 'HMM_BC_ShotgunSpecial'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_ShotgunSpecial_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_ShotgunSpecial_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_ShotgunSpecial_BioAnimSetData'
    End Object
    Evolve_DamageTakenDebuffStrength = {
                                        DynamicBonuses = (), 
                                        RankBonuses[0] = 0.0, 
                                        RankBonuses[1] = 0.0, 
                                        RankBonuses[2] = 0.0, 
                                        RankBonuses[3] = 0.0, 
                                        RankBonuses[4] = 0.0, 
                                        RankBonuses[5] = 0.0, 
                                        BaseValue = 0.25, 
                                        CurrentValue = 0.0, 
                                        Formula = EPowerDataFormula.Normal
                                       }
    Evolve_SlowDebuffStrength = {
                                 DynamicBonuses = (), 
                                 RankBonuses[0] = 0.0, 
                                 RankBonuses[1] = 0.0, 
                                 RankBonuses[2] = 0.0, 
                                 RankBonuses[3] = 0.0, 
                                 RankBonuses[4] = 0.0, 
                                 RankBonuses[5] = 0.0, 
                                 BaseValue = 0.300000012, 
                                 CurrentValue = 0.0, 
                                 Formula = EPowerDataFormula.Normal
                                }
    Evolve_DebuffDuration = {
                             DynamicBonuses = (), 
                             RankBonuses[0] = 0.0, 
                             RankBonuses[1] = 0.0, 
                             RankBonuses[2] = 0.0, 
                             RankBonuses[3] = 0.0, 
                             RankBonuses[4] = 0.0, 
                             RankBonuses[5] = 0.0, 
                             BaseValue = 8.0, 
                             CurrentValue = 0.0, 
                             Formula = EPowerDataFormula.Normal
                            }
    Evolve_DamageBonus = 0.300000012
    Evolve_RadiusBonus = 0.5
    Evolve_SecondDamageBonus = 0.5
    Evolve_CooldownBonus = 0.400000006
    MaxActiveMines = 3
    CE_HalfFrozenTemplate = RvrClientEffect'BioVFX_C_CryoBlaster.VCFX.Cryo_Half_Frozen_VCFX'
    ComboDetonators = (Class'SFXGameEffect_PowerCombo_Electric', Class'SFXGameEffect_PowerCombo_Fire', Class'SFXGameEffect_PowerCombo_Cryo')
    EvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Tech_ProxMine.Play_power_tech_P_proxmine_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                          )
    EvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Tech_ProxMine.Play_power_tech_P_proxmine_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                        )
    HenchmanEvolvedImpactSounds = ({Sound = WwiseEvent'Wwise_Power_Tech_ProxMine.Play_power_tech_NP_proxmine_evolimpact', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                  )
    HenchmanEvolvedCastSounds = ({Sound = WwiseEvent'Wwise_Power_Tech_ProxMine.Play_power_tech_NP_proxmine_evolcast', bAnyEvolved = TRUE, bReplaceBaseSound = TRUE, EvolveChoice = EEvolveChoice.EvolveChoice1}
                                )
    ProjectileClass = Class'SFXProjectile_PowerCustomAction_ProximityMine'
    DetonationRumbleClass = Class'SFXRumble_Power_HeavyImpact'
    DetonationScreenShakeClass = Class'SFXShake_Power_HeavyImpact'
    DetonationParameters = {BlockedByObjects = FALSE}
    CastAnimSet = MY_DYN_HMM_BC_ShotgunSpecial
    CE_ReleaseEffectTemplate = RvrClientEffect'BioVFX_C_NapalmGrenade.VCFX.ProximityMine_Muzzle_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Tech_ProxMine.Play_power_tech_P_proxmine_impact'
    CastSound = WwiseEvent'Wwise_Power_Tech_ProxMine.Play_power_tech_P_proxmine_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Tech_ProxMine.Play_power_tech_NP_proxmine_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Tech_ProxMine.Play_power_tech_NP_proxmine_cast'
    bPlayStartCastAnim = FALSE
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 10.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 20.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    ImpactRadius = {BaseValue = 200.0}
    EffectDuration = {BaseValue = 30.0}
    Damage = {RankBonuses[2] = 0.200000003, BaseValue = 400.0}
    Force = {RankBonuses[2] = 0.200000003, BaseValue = 300.0}
    ProjectileSpeed = {BaseValue = 4000.0}
    Ranks = ({
              Icon = 83, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572665, 
              Evolved1Description = $658547, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 83, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572669, 
              Evolved1Description = $572674, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 83, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572670, 
              Evolved1Description = $572675, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 83, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572676, 
              Evolved1Description = $572682, 
              Evolved2Name = $572677, 
              Evolved2Description = $572683
             }, 
             {
              Icon = 83, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572678, 
              Evolved1Description = $572686, 
              Evolved2Name = $572679, 
              Evolved2Description = $572687
             }, 
             {
              Icon = 83, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572680, 
              Evolved1Description = $572689, 
              Evolved2Name = $572681, 
              Evolved2Description = $572690
             }
            )
    PowerName = 'ProximityMine'
    PowerCustomActionID = 60
    DisplayName = $572665
    Description = $703577
    Icon = 83
    TalentDescription = $703577
    IsBonusPower = TRUE
    PowerType = EPowerType.PowerType_Projectile
}