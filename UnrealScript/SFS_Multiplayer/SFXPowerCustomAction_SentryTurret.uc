Class SFXPowerCustomAction_SentryTurret extends SFXPowerCustomAction
    config(Game);

var config PowerData TurretShields;
var config PowerData RocketCooldown;
var config PowerData RocketDamage;
var config PowerData RocketForce;
var config PowerData RocketRadius;
var config PowerData FlamethrowerDamagePerSec;
var config PowerData FlamethrowerDamageDuration;
var config PowerData FreezeDuration;
var config PowerData ShockCooldown;
var config PowerData ShockDamage;
var config PowerData ShockForce;
var config PowerData ShockRadius;
var Guid TurretBaseGuid;
var Vector SpawnLocation;
var config float Evolve_CryoFreezeChance;
var config float Evolve_ArmorPiercingDamage;
var config float Evolve_ShieldBonus;
var config float Evolve_DamageBonus;
var SFXPawn_SentryTurret Turret;
var stringref NotRecommended_TurretDeployed;
var float SpawnDelay;
var RvrClientEffectInterface CE_TurretBase;
var RvrClientEffectInterface CE_ShutdownEffect;
var RvrClientEffectInterface CE_DeathEffect;
var config float SpawnZOffset;
var config float NonCombatTimeout_Length;
var config float NonCombatTimeout_UpdateFrequency;
var bool DeathByShutdown;

public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super.PrecacheVFX(ObjectPool, ClientEffects);
    Class'SFXPawn_SentryTurret'.static.PrecacheVFX(ObjectPool, ClientEffects);
}
public event function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    if (IsTurretAlive())
    {
        sOptionalInfo = string(NotRecommended_TurretDeployed);
        return FALSE;
    }
    return TRUE;
}
public function StartCustomAction()
{
    DespawnTurret(Turret);
    Super.StartCustomAction();
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super.ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'Damage':
            ApplyBonusToParameter(RocketDamage, Bonus, bRemove);
            ApplyBonusToParameter(FlamethrowerDamagePerSec, Bonus, bRemove);
            ApplyBonusToParameter(ShockDamage, Bonus, bRemove);
            break;
        case 'Force':
            ApplyBonusToParameter(RocketForce, Bonus, bRemove);
            ApplyBonusToParameter(ShockForce, Bonus, bRemove);
            break;
        case 'EffectDuration':
            ApplyBonusToParameter(FreezeDuration, Bonus, bRemove);
            ApplyBonusToParameter(FlamethrowerDamageDuration, Bonus, bRemove);
            break;
        case 'ImpactRadius':
            ApplyBonusToParameter(RocketRadius, Bonus, bRemove);
            ApplyBonusToParameter(ShockRadius, Bonus, bRemove);
            break;
        case 'DroneShields':
            ApplyBonusToParameter(TurretShields, Bonus, bRemove);
            break;
        case 'DroneDamage':
            ApplyBonusToParameter(Damage, Bonus, bRemove);
            ApplyBonusToParameter(RocketDamage, Bonus, bRemove);
            ApplyBonusToParameter(FlamethrowerDamagePerSec, Bonus, bRemove);
            ApplyBonusToParameter(ShockDamage, Bonus, bRemove);
            break;
        default:
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(TurretShields, Evolve_ShieldBonus);
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus);
            AddEvolvedRankBonus(RocketDamage, Evolve_DamageBonus);
            AddEvolvedRankBonus(FlamethrowerDamagePerSec, Evolve_DamageBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            break;
        case EEvolveChoice.EvolveChoice6:
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function OnPowerDetonated(Vector HitLocation, Vector HitNormal, optional SFXProjectile_PowerCustomAction oProjectile, optional Actor HitActor)
{
    Super.OnPowerDetonated(HitLocation, HitNormal, oProjectile, HitActor);
    DespawnTurret(Turret);
    SpawnLocation = HitLocation;
    TurretBaseGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartAtLocation(CE_TurretBase, HitLocation, vect(1.0, 0.0, 0.0), GetDefaultClientEffectParams());
    m_oPawn.SetTimer(SpawnDelay, FALSE, 'DelayedSpawn', Self);
}
public function OnPowerRankIncreased()
{
    Super(SFXPowerCustomActionBase).OnPowerRankIncreased();
    DespawnTurret(Turret);
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[1].Data = Damage;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[1].srStatBarDisplayTitle = $585849;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[2].Data = TurretShields;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[2].srStatBarDisplayTitle = $584269;
    PowerStatBars[2].EvolvedBonuses[0] = Evolve_ShieldBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(TurretShields, bReset);
    RecalculatePowerData(RocketCooldown, bReset);
    RecalculatePowerData(RocketDamage, bReset);
    RecalculatePowerData(RocketForce, bReset);
    RecalculatePowerData(RocketRadius, bReset);
    RecalculatePowerData(FlamethrowerDamagePerSec, bReset);
    RecalculatePowerData(FlamethrowerDamageDuration, bReset);
    RecalculatePowerData(FreezeDuration, bReset);
    RecalculatePowerData(ShockCooldown, bReset);
    RecalculatePowerData(ShockDamage, bReset);
    RecalculatePowerData(ShockForce, bReset);
    RecalculatePowerData(ShockRadius, bReset);
}
public function DelayedSpawn()
{
    local Vector FloorLocation;
    
    if (m_oPawn == None || m_oPawn.Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    SpawnLocation.Z += SpawnZOffset;
    if (GetFloorLocation(SpawnLocation, FloorLocation))
    {
        SpawnLocation = FloorLocation;
    }
    SpawnTurret(SpawnLocation + vect(0.0, 0.0, 50.0), m_oPawn.Rotation);
}
public function DespawnTurret(SFXPawn_SentryTurret oTurret)
{
    if (oTurret != None && m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        oTurret.Died(m_oPawn.Controller, Class'SFXDamageType_Default', oTurret.location);
    }
}
public function bool IsTurretAlive()
{
    if (Turret != None && Turret.LifeSpan > float(0) && !Turret.IsDead())
    {
        return TRUE;
    }
    return FALSE;
}
public function OnTurretKilled(SFXPawn_SentryTurret oTurret)
{
    if (!DeathByShutdown)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_DeathEffect, oTurret);
    }
    DeathByShutdown = FALSE;
}
public function SetupCurrentTurret()
{
    local ScaledFloat MaxShields;
    local SFXWeapon Weapon;
    local SFXPowerCustomAction Power;
    local SFXWeapon_Heavy_FlameThrower_SentryTurret FlameThrower;
    local SFXPowerCustomAction_SentryTurretCryoAmmo CryoPower;
    local SFXModule_Damage DmgModule;
    
    if (Turret == None)
    {
        return;
    }
    Turret.TurretBaseVFXGuid = TurretBaseGuid;
    ApplyTemporaryGameEffect(Turret, Class'SFXGameEffect_IgnorePawn', 5.0, 1.0, Name, m_oPawn.Controller);
    Turret.__OnTurretKilled__Delegate = OnTurretKilled;
    if (IsEvolvedWithChoice(1))
    {
        Power = SFXPowerCustomAction(Turret.PowerManager.GetPowerByClass(Class'SFXPowerCustomAction_SentryTurretShock'));
        if (Power != None)
        {
            Power.bEnabled = TRUE;
            Power.CooldownTime.BaseValue = ShockCooldown.CurrentValue;
            Power.Damage.BaseValue = ShockDamage.CurrentValue;
            Power.Force.BaseValue = ShockForce.CurrentValue;
            Power.ImpactRadius.BaseValue = ShockRadius.CurrentValue;
            Power.MaximumRange.BaseValue = ShockRadius.CurrentValue;
            Power.RecalculateAllPowerInfo(FALSE);
        }
    }
    if (IsEvolvedWithChoice(2))
    {
        CryoPower = SFXPowerCustomAction_SentryTurretCryoAmmo(Turret.PowerManager.GetPowerByClass(Class'SFXPowerCustomAction_SentryTurretCryoAmmo'));
        if (CryoPower != None)
        {
            CryoPower.bEnabled = TRUE;
            CryoPower.FreezeChance = Evolve_CryoFreezeChance;
            CryoPower.EffectDuration.BaseValue = FreezeDuration.CurrentValue;
            CryoPower.RecalculateAllPowerInfo(FALSE);
        }
    }
    if (IsEvolvedWithChoice(3))
    {
        Power = SFXPowerCustomAction(Turret.PowerManager.GetPowerByClass(Class'SFXPowerCustomAction_SentryTurretArmorPiercingAmmo'));
        if (Power != None)
        {
            Power.bEnabled = TRUE;
            Power.Damage.BaseValue = Evolve_ArmorPiercingDamage;
            Power.RecalculateAllPowerInfo(FALSE);
        }
    }
    if (IsEvolvedWithChoice(4))
    {
        Power = SFXPowerCustomAction(Turret.PowerManager.GetPowerByClass(Class'SFXPowerCustomAction_SentryTurretRocket'));
        if (Power != None)
        {
            Power.bEnabled = TRUE;
            Power.CooldownTime.BaseValue = RocketCooldown.CurrentValue;
            Power.Damage.BaseValue = RocketDamage.CurrentValue;
            Power.Force.BaseValue = RocketForce.CurrentValue;
            Power.ImpactRadius.BaseValue = RocketRadius.CurrentValue;
            Power.RecalculateAllPowerInfo(FALSE);
        }
    }
    if (IsEvolvedWithChoice(5))
    {
        Turret.CreateWeapon(Class'SFXWeapon_Heavy_FlameThrower_SentryTurret', FALSE);
        FlameThrower = SFXWeapon_Heavy_FlameThrower_SentryTurret(Turret.InvManager.FindInventoryType(Class'SFXWeapon_Heavy_FlameThrower_SentryTurret'));
        if (FlameThrower != None)
        {
            FlameThrower.DamagePerSecond = FlamethrowerDamagePerSec.CurrentValue;
            FlameThrower.DamageDuration = FlamethrowerDamageDuration.CurrentValue;
            FlameThrower.SentryTurretPower = Self;
        }
    }
    DmgModule = Turret.GetModule(Class'SFXModule_Damage');
    if (DmgModule != None)
    {
        MaxShields.X = TurretShields.CurrentValue;
        MaxShields.Y = TurretShields.CurrentValue;
        Class'SFXGame'.static.ReCalculate(MaxShields);
        DmgModule.SetMaxHealth(MaxShields);
        DmgModule.SetCurrentHealth(MaxShields.Value);
    }
    Weapon = SFXWeapon(Turret.Weapon);
    if (Weapon != None)
    {
        Weapon.Damage.X = Damage.CurrentValue;
        Weapon.Damage.Y = Damage.CurrentValue;
        Class'SFXGame'.static.ReCalculate(Weapon.Damage);
    }
}
public function SFXPawn_SentryTurret SpawnTurret(Vector location, Rotator Rotation)
{
    local SFXAI_Core TurretAI;
    
    Turret = m_oPawn.Spawn(Class'SFXPawn_SentryTurret', , 'SentryTurret', location, Rotation, , , TRUE);
    if (Turret != None)
    {
        Turret.SetupCasterAndReplication(m_oPawn, PowerCustomActionID);
        if (IsEvolvedWithChoice(1))
        {
            Turret.bHasShock = TRUE;
        }
        Turret.StartVFX();
        TurretAI = m_oPawn.Spawn(Class'SFXAI_SentryTurret', , , location, Rotation, None, TRUE);
        if (TurretAI == None)
        {
            return None;
        }
        TurretAI.Instigator = m_oPawn;
        Turret.Instigator = m_oPawn;
        TurretAI.Possess(Turret, FALSE);
        TurretAI = SFXAI_Core(Turret.Controller);
        if (TurretAI != None)
        {
            TurretAI.SetTeam(int(m_oPawn.Controller.GetTeamNum()));
            TurretAI.AutoAcquireEnemy();
        }
        SetupCurrentTurret();
        if (!m_oPawn.WorldInfo.GRI.IsMultiplayerGame())
        {
            m_oPawn.SetTimer(NonCombatTimeout_UpdateFrequency, TRUE, 'TurretNonCombatCheck', Self);
        }
        return Turret;
    }
    else
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(None, TurretBaseGuid, TRUE);
    }
}
public final function NonCombatDespawnTurret()
{
    m_oPawn.ClearTimer('TurretNonCombatCheck', Self);
    DeathByShutdown = TRUE;
    DespawnTurret(Turret);
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_ShutdownEffect, Turret);
}
public final function TurretNonCombatCheck()
{
    local bool bTimerActive;
    local int EnemyCount;
    
    if (Turret == None || BioAiController(Turret.Controller) == None)
    {
        m_oPawn.ClearTimer('TurretNonCombatCheck', Self);
        return;
    }
    bTimerActive = m_oPawn.IsTimerActive('NonCombatDespawnTurret', Self);
    EnemyCount = BioAiController(Turret.Controller).EnemyList.Length;
    if (EnemyCount <= 0 && bTimerActive == FALSE)
    {
        m_oPawn.SetTimer(NonCombatTimeout_Length, FALSE, 'NonCombatDespawnTurret', Self);
    }
    else if (EnemyCount > 0 && bTimerActive == TRUE)
    {
        m_oPawn.ClearTimer('NonCombatDespawnTurret', Self);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_CB_Grenade
        m_nmOrigSetName = 'HMM_CB_Grenade'
        Sequences = (AnimSequence'BIOG_HMM_CB_A.HMM_CB_Grenade_CB_Grenade2')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_CB_A.HMM_CB_Grenade_BioAnimSetData'
    End Object
    TurretShields = {
                     DynamicBonuses = (), 
                     RankBonuses[0] = 0.0, 
                     RankBonuses[1] = 0.0, 
                     RankBonuses[2] = 0.300000012, 
                     RankBonuses[3] = 0.0, 
                     RankBonuses[4] = 0.0, 
                     RankBonuses[5] = 0.0, 
                     BaseValue = 500.0, 
                     CurrentValue = 0.0, 
                     Formula = EPowerDataFormula.Normal
                    }
    RocketCooldown = {
                      DynamicBonuses = (), 
                      RankBonuses[0] = 0.0, 
                      RankBonuses[1] = 0.0, 
                      RankBonuses[2] = 0.0, 
                      RankBonuses[3] = 0.0, 
                      RankBonuses[4] = 0.0, 
                      RankBonuses[5] = 0.0, 
                      BaseValue = 4.0, 
                      CurrentValue = 0.0, 
                      Formula = EPowerDataFormula.Normal
                     }
    RocketDamage = {
                    DynamicBonuses = (), 
                    RankBonuses[0] = 0.0, 
                    RankBonuses[1] = 0.0, 
                    RankBonuses[2] = 0.300000012, 
                    RankBonuses[3] = 0.0, 
                    RankBonuses[4] = 0.0, 
                    RankBonuses[5] = 0.0, 
                    BaseValue = 150.0, 
                    CurrentValue = 0.0, 
                    Formula = EPowerDataFormula.Normal
                   }
    RocketForce = {
                   DynamicBonuses = (), 
                   RankBonuses[0] = 0.0, 
                   RankBonuses[1] = 0.0, 
                   RankBonuses[2] = 0.0, 
                   RankBonuses[3] = 0.0, 
                   RankBonuses[4] = 0.0, 
                   RankBonuses[5] = 0.0, 
                   BaseValue = 300.0, 
                   CurrentValue = 0.0, 
                   Formula = EPowerDataFormula.Normal
                  }
    RocketRadius = {
                    DynamicBonuses = (), 
                    RankBonuses[0] = 0.0, 
                    RankBonuses[1] = 0.0, 
                    RankBonuses[2] = 0.0, 
                    RankBonuses[3] = 0.0, 
                    RankBonuses[4] = 0.0, 
                    RankBonuses[5] = 0.0, 
                    BaseValue = 150.0, 
                    CurrentValue = 0.0, 
                    Formula = EPowerDataFormula.Normal
                   }
    FlamethrowerDamagePerSec = {
                                DynamicBonuses = (), 
                                RankBonuses[0] = 0.0, 
                                RankBonuses[1] = 0.0, 
                                RankBonuses[2] = 0.300000012, 
                                RankBonuses[3] = 0.0, 
                                RankBonuses[4] = 0.0, 
                                RankBonuses[5] = 0.0, 
                                BaseValue = 55.0, 
                                CurrentValue = 0.0, 
                                Formula = EPowerDataFormula.Normal
                               }
    FlamethrowerDamageDuration = {
                                  DynamicBonuses = (), 
                                  RankBonuses[0] = 0.0, 
                                  RankBonuses[1] = 0.0, 
                                  RankBonuses[2] = 0.0, 
                                  RankBonuses[3] = 0.0, 
                                  RankBonuses[4] = 0.0, 
                                  RankBonuses[5] = 0.0, 
                                  BaseValue = 1.0, 
                                  CurrentValue = 0.0, 
                                  Formula = EPowerDataFormula.Normal
                                 }
    FreezeDuration = {
                      DynamicBonuses = (), 
                      RankBonuses[0] = 0.0, 
                      RankBonuses[1] = 0.0, 
                      RankBonuses[2] = 0.0, 
                      RankBonuses[3] = 0.0, 
                      RankBonuses[4] = 0.0, 
                      RankBonuses[5] = 0.0, 
                      BaseValue = 3.0, 
                      CurrentValue = 0.0, 
                      Formula = EPowerDataFormula.Normal
                     }
    ShockCooldown = {
                     DynamicBonuses = (), 
                     RankBonuses[0] = 0.0, 
                     RankBonuses[1] = 0.0, 
                     RankBonuses[2] = 0.0, 
                     RankBonuses[3] = 0.0, 
                     RankBonuses[4] = 0.0, 
                     RankBonuses[5] = 0.0, 
                     BaseValue = 5.0, 
                     CurrentValue = 0.0, 
                     Formula = EPowerDataFormula.Normal
                    }
    ShockDamage = {
                   DynamicBonuses = (), 
                   RankBonuses[0] = 0.0, 
                   RankBonuses[1] = 0.0, 
                   RankBonuses[2] = 0.300000012, 
                   RankBonuses[3] = 0.0, 
                   RankBonuses[4] = 0.0, 
                   RankBonuses[5] = 0.0, 
                   BaseValue = 100.0, 
                   CurrentValue = 0.0, 
                   Formula = EPowerDataFormula.Normal
                  }
    ShockForce = {
                  DynamicBonuses = (), 
                  RankBonuses[0] = 0.0, 
                  RankBonuses[1] = 0.0, 
                  RankBonuses[2] = 0.0, 
                  RankBonuses[3] = 0.0, 
                  RankBonuses[4] = 0.0, 
                  RankBonuses[5] = 0.0, 
                  BaseValue = 450.0, 
                  CurrentValue = 0.0, 
                  Formula = EPowerDataFormula.Normal
                 }
    ShockRadius = {
                   DynamicBonuses = (), 
                   RankBonuses[0] = 0.0, 
                   RankBonuses[1] = 0.0, 
                   RankBonuses[2] = 0.0, 
                   RankBonuses[3] = 0.0, 
                   RankBonuses[4] = 0.0, 
                   RankBonuses[5] = 0.0, 
                   BaseValue = 250.0, 
                   CurrentValue = 0.0, 
                   Formula = EPowerDataFormula.Normal
                  }
    Evolve_CryoFreezeChance = 1.0
    Evolve_ArmorPiercingDamage = 1.0
    Evolve_ShieldBonus = 0.400000006
    Evolve_DamageBonus = 0.400000006
    NotRecommended_TurretDeployed = $559135
    SpawnDelay = 0.300000012
    CE_TurretBase = RvrClientEffect'BioVFX_T_TechBall.VCFX.SentryTurret_Spawn_VCFX'
    CE_ShutdownEffect = RvrClientEffect'BioVFX_T_TechBall.VCFX.SentryTurret_ShutDown_VCFX'
    CE_DeathEffect = RvrClientEffect'BioVFX_T_TechBall.VCFX.SentryTurret_Destroyed_VCFX'
    SpawnZOffset = 150.0
    NonCombatTimeout_Length = 5.0
    NonCombatTimeout_UpdateFrequency = 1.0
    BS_EndCastAnimation = {
                           AnimName = ('CB_Grenade2', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'None'
                                      )
                          }
    ProjectileClass = Class'SFXProjectile_PowerCustomAction_SentryTurret'
    CustomCasterCrustParameters = {X = 1.0, Y = 0.0, Z = 0.0}
    ReleaseTime = 0.550000012
    CastAnimSet = MY_DYN_HMM_CB_Grenade
    CastCameraAnim = CameraAnim'BioVFX_C_CamAnim.Powers.BC_RifleTelekinesisFloat'
    CE_CasterCrustTemplate = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_RightFull_VCFX_M'
    ImpactSound = WwiseEvent'Wwise_Power_Tech_SenTurret.Play_power_tech_S_turret_land'
    CastSound = WwiseEvent'Wwise_Power_Tech_SenTurret.Play_power_tech_P_turret_cast'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Tech_SenTurret.Play_power_tech_NP_turret_cast'
    bPlayStartCastAnim = FALSE
    bCustomCasterCrustParameters = TRUE
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 5.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 4000.0}
    Damage = {RankBonuses[2] = 0.300000012, BaseValue = 25.0}
    ProjectileSpeed = {BaseValue = 3000.0}
    Ranks = ({
              Icon = 81, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $558975, 
              Evolved1Description = $558976, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 81, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $558980, 
              Evolved1Description = $558985, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 81, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $558981, 
              Evolved1Description = $558986, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 81, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $559100, 
              Evolved1Description = $559106, 
              Evolved2Name = $559101, 
              Evolved2Description = $559107
             }, 
             {
              Icon = 81, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $559098, 
              Evolved1Description = $559104, 
              Evolved2Name = $559099, 
              Evolved2Description = $559105
             }, 
             {
              Icon = 81, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $559102, 
              Evolved1Description = $559108, 
              Evolved2Name = $559103, 
              Evolved2Description = $559109
             }
            )
    PowerName = 'SentryTurret'
    PowerCustomActionID = 32
    DisplayName = $558975
    Description = $703688
    Icon = 81
    TalentDescription = $703688
    PowerType = EPowerType.PowerType_Projectile
    bHideWeapon = TRUE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_CombatDrone
}