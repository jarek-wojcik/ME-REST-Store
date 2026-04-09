Class SFXPowerCustomAction_CombatDrone extends SFXPowerCustomAction_CombatDroneBase
    config(Game);

var config PowerData DroneZapCooldown;
var config PowerData DroneShields;
var config PowerData DroneDamage;
var config PowerData ExplosionDamage;
var config PowerData ExplosionRadius;
var config PowerData ExplosionForce;
var config PowerData RocketCooldown;
var config PowerData RocketDamage;
var config PowerData RocketForce;
var config PowerData RocketRadius;
var config PowerData ShockCooldown;
var config PowerData ShockDamage;
var config PowerData ShockForce;
var config PowerData ShockRadius;
var config AreaEffectParameters ExplosionParameters;
var Vector DroneDiedLocation;
var config int Evolve_NumExtraTargets;
var config float Evolve_DamageBonus;
var config float Evolve_ShieldBonus;
var config float Evolve_DamageBonus2;
var config float Evolve_ShieldBonus2;
var config float Evolve_ShieldDamageBonus;
var SFXPawn_CombatDrone Drone;
var stringref NotRecommended_DroneDeployed;
var RvrClientEffectInterface CE_DroneExplosionTemplate;
var RvrClientEffectInterface CE_DroneDeathTemplate;
var WwiseEvent DroneExplosionSound;
var WwiseEvent DroneDeathSound;
var config float NonCombatTimeout_Length;
var config float NonCombatTimeout_UpdateFrequency;

public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super(SFXPowerCustomAction).PrecacheVFX(ObjectPool, ClientEffects);
    if (default.DroneClass != None)
    {
        default.DroneClass.static.PrecacheVFX(ObjectPool, ClientEffects);
    }
}
public function StartCustomAction()
{
    DespawnDrone(Drone);
    Super(SFXPowerCustomAction).StartCustomAction();
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super(SFXPowerCustomAction).ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'Damage':
            ApplyBonusToParameter(DroneDamage, Bonus, bRemove);
            ApplyBonusToParameter(ExplosionDamage, Bonus, bRemove);
            ApplyBonusToParameter(ShockDamage, Bonus, bRemove);
            ApplyBonusToParameter(RocketDamage, Bonus, bRemove);
            break;
        case 'Force':
            ApplyBonusToParameter(ExplosionForce, Bonus, bRemove);
            ApplyBonusToParameter(ShockForce, Bonus, bRemove);
            ApplyBonusToParameter(RocketForce, Bonus, bRemove);
            break;
        case 'ImpactRadius':
            ApplyBonusToParameter(ExplosionRadius, Bonus, bRemove);
            ApplyBonusToParameter(RocketRadius, Bonus, bRemove);
            ApplyBonusToParameter(ShockRadius, Bonus, bRemove);
            break;
        case 'DroneShields':
            ApplyBonusToParameter(DroneShields, Bonus, bRemove);
            break;
        case 'DroneDamage':
            ApplyBonusToParameter(DroneDamage, Bonus, bRemove);
            ApplyBonusToParameter(ExplosionDamage, Bonus, bRemove);
            ApplyBonusToParameter(ShockDamage, Bonus, bRemove);
            ApplyBonusToParameter(RocketDamage, Bonus, bRemove);
            break;
        case 'DroneCooldown':
            ApplyBonusToParameter(CooldownTime, Bonus, bRemove);
            ApplyBonusToParameter(HenchmanCooldownTime, Bonus, bRemove);
            break;
        default:
    }
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    if (oActor != None && Drone != None)
    {
        DoAreaExplosionForActor(oActor, Drone.location, ImpactCount, ExplosionDamage.CurrentValue, GetDamageType(), ExplosionForce.CurrentValue, ExplosionParameters, 0, None);
        if (BioPawn(oActor) != None)
        {
            BioPawn(oActor).ClientPlayAnimatedReaction(CustomActionReactionType);
        }
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(DroneDamage, Evolve_DamageBonus);
            AddEvolvedRankBonus(DroneShields, Evolve_ShieldBonus);
            AddEvolvedRankBonus(RocketDamage, Evolve_DamageBonus);
            AddEvolvedRankBonus(RocketForce, Evolve_DamageBonus);
            AddEvolvedRankBonus(ExplosionDamage, Evolve_DamageBonus);
            AddEvolvedRankBonus(ExplosionForce, Evolve_DamageBonus);
            AddEvolvedRankBonus(ShockDamage, Evolve_DamageBonus);
            AddEvolvedRankBonus(ShockForce, Evolve_DamageBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(DroneDamage, Evolve_DamageBonus2);
            AddEvolvedRankBonus(DroneShields, Evolve_ShieldBonus2);
            AddEvolvedRankBonus(RocketDamage, Evolve_DamageBonus2);
            AddEvolvedRankBonus(RocketForce, Evolve_DamageBonus2);
            AddEvolvedRankBonus(ExplosionDamage, Evolve_DamageBonus2);
            AddEvolvedRankBonus(ExplosionForce, Evolve_DamageBonus2);
            AddEvolvedRankBonus(ShockDamage, Evolve_DamageBonus2);
            AddEvolvedRankBonus(ShockForce, Evolve_DamageBonus2);
            break;
        case EEvolveChoice.EvolveChoice5:
            break;
        case EEvolveChoice.EvolveChoice6:
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function Class<SFXDamageType> GetDamageType()
{
    return Class'SFXDamageType_CombatDrone';
}
public function OnPowerDetonated(Vector HitLocation, Vector HitNormal, optional SFXProjectile_PowerCustomAction oProjectile, optional Actor HitActor)
{
    local Vector SpawnLocation;
    local BioPawn oTarget;
    local EPowerType Type;
    
    DespawnDrone(Drone);
    Super(SFXPowerCustomAction).OnPowerDetonated(HitLocation, HitNormal, oProjectile, HitActor);
    if (m_oPawn == None || m_oPawn.Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    if (SFXPawn_Henchman(m_oPawn) != None)
    {
        Type = HenchmanPowerType;
    }
    else
    {
        Type = PowerType;
    }
    if (Type == EPowerType.PowerType_Projectile)
    {
        SpawnDrone(HitLocation + vect(0.0, 0.0, 50.0), m_oPawn.Rotation);
    }
    else
    {
        oTarget = BioPawn(m_oTargetToAimAt);
        if (oTarget != None && oTarget.IsHostile(m_oPawn))
        {
            SpawnLocation = GetBackLocation(oTarget);
            if (IsSafeSpawnLocation(SpawnLocation))
            {
                SpawnDrone(SpawnLocation, m_oPawn.Rotation);
                return;
            }
            SpawnLocation = GetFrontLocation(oTarget);
            if (IsSafeSpawnLocation(SpawnLocation))
            {
                SpawnDrone(SpawnLocation, m_oPawn.Rotation);
                return;
            }
        }
        else if (IsSafeSpawnLocation(m_vLocationToAimAt))
        {
            SpawnDrone(m_vLocationToAimAt, m_oPawn.Rotation);
            return;
        }
        SpawnLocation = GetFrontLocation(m_oPawn);
        if (IsSafeSpawnLocation(SpawnLocation))
        {
            SpawnDrone(SpawnLocation, m_oPawn.Rotation);
            return;
        }
        SpawnLocation = GetBackLocation(m_oPawn);
        if (IsSafeSpawnLocation(SpawnLocation))
        {
            SpawnDrone(SpawnLocation, m_oPawn.Rotation);
            return;
        }
    }
}
public function OnPowerRankIncreased()
{
    Super(SFXPowerCustomActionBase).OnPowerRankIncreased();
    DespawnDrone(Drone);
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[1].Data = DroneDamage;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[1].srStatBarDisplayTitle = $585820;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[1].EvolvedBonuses[3] = Evolve_DamageBonus2;
    PowerStatBars[2].Data = DroneShields;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[2].srStatBarDisplayTitle = $584253;
    PowerStatBars[2].EvolvedBonuses[0] = Evolve_ShieldBonus;
    PowerStatBars[2].EvolvedBonuses[3] = Evolve_ShieldBonus2;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(DroneShields, bReset);
    RecalculatePowerData(DroneDamage, bReset);
    RecalculatePowerData(DroneZapCooldown, bReset);
    RecalculatePowerData(ExplosionDamage, bReset);
    RecalculatePowerData(ExplosionForce, bReset);
    RecalculatePowerData(ExplosionRadius, bReset);
    RecalculatePowerData(RocketCooldown, bReset);
    RecalculatePowerData(RocketDamage, bReset);
    RecalculatePowerData(RocketForce, bReset);
    RecalculatePowerData(RocketRadius, bReset);
    RecalculatePowerData(ShockCooldown, bReset);
    RecalculatePowerData(ShockDamage, bReset);
    RecalculatePowerData(ShockForce, bReset);
    RecalculatePowerData(ShockRadius, bReset);
}
public final function DroneNonCombatCheck()
{
    local bool bTimerActive;
    local int EnemyCount;
    
    if (Drone == None || BioAiController(Drone.Controller) == None)
    {
        m_oPawn.ClearTimer('DroneNonCombatCheck', Self);
        return;
    }
    bTimerActive = m_oPawn.IsTimerActive('NonCombatDespawnDrone', Self);
    EnemyCount = BioAiController(Drone.Controller).EnemyList.Length;
    if (EnemyCount <= 0 && bTimerActive == FALSE)
    {
        m_oPawn.SetTimer(NonCombatTimeout_Length, FALSE, 'NonCombatDespawnDrone', Self);
    }
    else if (EnemyCount > 0 && bTimerActive == TRUE)
    {
        m_oPawn.ClearTimer('NonCombatDespawnDrone', Self);
    }
}
public function bool IsDroneAlive()
{
    if (Drone != None && Drone.LifeSpan > float(0) && !Drone.IsDead())
    {
        return TRUE;
    }
    return FALSE;
}
public final function NonCombatDespawnDrone()
{
    m_oPawn.ClearTimer('DroneNonCombatCheck', Self);
    DespawnDrone(Drone);
}
public function bool OnDeathExplosionImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    CheckForPowerCombo(oImpacted, Resistance, HitLocation, HitNormal);
    return TRUE;
}
public function OnDroneKilled(SFXPawn_CombatDroneBase oDrone)
{
    if (IsEvolvedWithChoice(1) && oDrone != None && oDrone.KilledBy != m_oPawn.Controller)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(CE_DroneExplosionTemplate, oDrone.location, vect(0.0, 0.0, 1.0));
        oDrone.PlaySound(DroneExplosionSound, TRUE);
        AreaExplosion(oDrone.location, ExplosionRadius.CurrentValue, ExplosionDamage.CurrentValue, GetDamageType(), ExplosionForce.CurrentValue, ExplosionParameters, 0, OnDeathExplosionImpact);
    }
    else if (oDrone != None)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(CE_DroneDeathTemplate, oDrone.location, vect(0.0, 0.0, 1.0));
        oDrone.PlaySound(DroneDeathSound, TRUE);
    }
}
public function SetupSpawnedDrone(SFXPawn_CombatDroneBase SpawnedDrone)
{
    local SFXAI_Core DroneAI;
    local ScaledFloat MaxShields;
    local SFXPowerCustomAction Power;
    local Class<SFXDamageType> DamageType;
    local SFXModule_Damage DmgModule;
    
    Super.SetupSpawnedDrone(SpawnedDrone);
    Drone = SFXPawn_CombatDrone(SpawnedDrone);
    if (Drone == None)
    {
        return;
    }
    ApplyPermanentGameEffect(Drone, Class'SFXGameEffect_IgnorePawn', 1.0, Name, m_oPawn.Controller);
    DroneAI = SFXAI_Core(Drone.Controller);
    if (m_oTargetToAimAt != None && DroneAI != None)
    {
        DroneAI.ForcedTarget = m_oTargetToAimAt;
    }
    DmgModule = Drone.GetModule(Class'SFXModule_Damage');
    if (DmgModule != None)
    {
        MaxShields.X = DroneShields.CurrentValue;
        MaxShields.Y = DroneShields.CurrentValue;
        Class'SFXGame'.static.ReCalculate(MaxShields);
        DmgModule.SetMaxHealth(MaxShields);
        DmgModule.SetCurrentHealth(MaxShields.Value);
    }
    DamageType = GetDamageType();
    Power = SFXPowerCustomAction(Drone.PowerManager.GetPowerByClass(Class'SFXPowerCustomAction_CombatDroneZap'));
    if (SFXPowerCustomAction_CombatDroneZap(Power) != None)
    {
        if (IsEvolvedWithChoice(5))
        {
            SFXPowerCustomAction_CombatDroneZap(Power).NumCharges = Evolve_NumExtraTargets;
        }
        Power.CooldownTime.BaseValue = DroneZapCooldown.CurrentValue;
        Power.Damage.BaseValue = DroneDamage.CurrentValue;
        Power.DefaultDamageType = DamageType;
        Power.RecalculateAllPowerInfo(FALSE);
    }
    if (IsEvolvedWithChoice(1))
    {
        Drone.ClientEffectParameters.Y = 1.0;
    }
    if (IsEvolvedWithChoice(2))
    {
        Power = SFXPowerCustomAction(Drone.PowerManager.GetPowerByClass(Class'SFXPowerCustomAction_CombatDroneShock'));
        if (Power != None)
        {
            Power.bEnabled = TRUE;
            Power.CooldownTime.BaseValue = ShockCooldown.CurrentValue;
            Power.Damage.BaseValue = ShockDamage.CurrentValue;
            Power.Force.BaseValue = ShockForce.CurrentValue;
            Power.ImpactRadius.BaseValue = ShockRadius.CurrentValue;
            Power.MaximumRange.BaseValue = ShockRadius.CurrentValue;
            Power.RecalculateAllPowerInfo(FALSE);
            Drone.ClientEffectParameters.X = 1.0;
        }
    }
    if (IsEvolvedWithChoice(4))
    {
        Power = SFXPowerCustomAction(Drone.PowerManager.GetPowerByClass(Class'SFXPowerCustomAction_CombatDroneRocket'));
        if (Power != None)
        {
            Power.bEnabled = TRUE;
            Power.CooldownTime.BaseValue = RocketCooldown.CurrentValue;
            Power.Damage.BaseValue = RocketDamage.CurrentValue;
            Power.DefaultDamageType = DamageType;
            Power.Force.BaseValue = RocketForce.CurrentValue;
            Power.ImpactRadius.BaseValue = RocketRadius.CurrentValue;
            Power.RecalculateAllPowerInfo(FALSE);
        }
    }
}
public function SFXPawn_CombatDroneBase SpawnDrone(Vector location, Rotator Rotation)
{
    local SFXPawn_CombatDrone PlayerDrone;
    
    PlayerDrone = SFXPawn_CombatDrone(Super.SpawnDrone(location, Rotation));
    if (!m_oPawn.WorldInfo.GRI.IsMultiplayerGame())
    {
        m_oPawn.SetTimer(NonCombatTimeout_UpdateFrequency, TRUE, 'DroneNonCombatCheck', Self);
    }
    return PlayerDrone;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_RifleTechTool
        m_nmOrigSetName = 'HMM_BC_RifleTechTool'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BioAnimSetData'
    End Object
    DroneZapCooldown = {
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
    DroneShields = {
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
    DroneDamage = {
                   DynamicBonuses = (), 
                   RankBonuses[0] = 0.0, 
                   RankBonuses[1] = 0.0, 
                   RankBonuses[2] = 0.300000012, 
                   RankBonuses[3] = 0.0, 
                   RankBonuses[4] = 0.0, 
                   RankBonuses[5] = 0.0, 
                   BaseValue = 40.0, 
                   CurrentValue = 0.0, 
                   Formula = EPowerDataFormula.Normal
                  }
    ExplosionDamage = {
                       DynamicBonuses = (), 
                       RankBonuses[0] = 0.0, 
                       RankBonuses[1] = 0.0, 
                       RankBonuses[2] = 0.300000012, 
                       RankBonuses[3] = 0.0, 
                       RankBonuses[4] = 0.0, 
                       RankBonuses[5] = 0.0, 
                       BaseValue = 120.0, 
                       CurrentValue = 0.0, 
                       Formula = EPowerDataFormula.Normal
                      }
    ExplosionRadius = {
                       DynamicBonuses = (), 
                       RankBonuses[0] = 0.0, 
                       RankBonuses[1] = 0.0, 
                       RankBonuses[2] = 0.0, 
                       RankBonuses[3] = 0.0, 
                       RankBonuses[4] = 0.0, 
                       RankBonuses[5] = 0.0, 
                       BaseValue = 500.0, 
                       CurrentValue = 0.0, 
                       Formula = EPowerDataFormula.Normal
                      }
    ExplosionForce = {
                      DynamicBonuses = (), 
                      RankBonuses[0] = 0.0, 
                      RankBonuses[1] = 0.0, 
                      RankBonuses[2] = 0.300000012, 
                      RankBonuses[3] = 0.0, 
                      RankBonuses[4] = 0.0, 
                      RankBonuses[5] = 0.0, 
                      BaseValue = 400.0, 
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
                   RankBonuses[2] = 0.300000012, 
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
                  RankBonuses[2] = 0.300000012, 
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
    ExplosionParameters = {
                           ConeDirection = {X = 0.0, Y = 0.0, Z = 0.0}, 
                           HitDirectionOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                           ConeAngle = 0.0, 
                           ImpactFriends = FALSE, 
                           ImpactDeadPawns = FALSE, 
                           ImpactPlaceables = TRUE, 
                           BlockedByObjects = TRUE, 
                           DistancedSorted = FALSE
                          }
    Evolve_NumExtraTargets = 3
    Evolve_DamageBonus = 0.400000006
    Evolve_ShieldBonus = 0.400000006
    Evolve_DamageBonus2 = 0.5
    Evolve_ShieldBonus2 = 0.5
    Evolve_ShieldDamageBonus = 1.0
    CE_DroneExplosionTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.TechBall_Explosion_VCFX'
    CE_DroneDeathTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.TechBall_Death_VCFX'
    DroneExplosionSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_S_combatdrone_explosion'
    DroneDeathSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_S_combatdrone_death'
    NonCombatTimeout_Length = 5.0
    NonCombatTimeout_UpdateFrequency = 1.0
    DroneClass = Class'SFXPawn_CombatDrone'
    DroneAIClass = Class'SFXAI_CombatDrone'
    ComboDetonators = (Class'SFXGameEffect_PowerCombo_Electric', Class'SFXGameEffect_PowerCombo_Fire', Class'SFXGameEffect_PowerCombo_Cryo')
    CustomCasterCrustParameters = {X = 1.0, Y = 0.0, Z = 0.0}
    ReleaseTime = 0.300000012
    CastAnimSet = MY_DYN_HMM_BC_RifleTechTool
    CastCameraAnim = CameraAnim'BioVFX_C_CamAnim.Powers.BC_RifleTelekinesisFloat'
    CE_CasterCrustTemplate = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_LeftFull_Cbt_VCFX_M'
    CastSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_P_combatdrone_cast'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_NP_combatdrone_cast'
    bCustomCasterCrustParameters = TRUE
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 5.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 10.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    Ranks = ({
              Icon = 42, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $199784, 
              Evolved1Description = $199785, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 42, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $199787, 
              Evolved1Description = $155378, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 42, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $199909, 
              Evolved1Description = $559669, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 42, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $558063, 
              Evolved1Description = $558070, 
              Evolved2Name = $558064, 
              Evolved2Description = $558072
             }, 
             {
              Icon = 42, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $558065, 
              Evolved1Description = $558073, 
              Evolved2Name = $558066, 
              Evolved2Description = $558074
             }, 
             {
              Icon = 42, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $558067, 
              Evolved1Description = $558075, 
              Evolved2Name = $558068, 
              Evolved2Description = $558076
             }
            )
    DisplayName = $199784
    Description = $703685
    Icon = 42
    TalentDescription = $703685
    PowerType = EPowerType.PowerType_Instant
}