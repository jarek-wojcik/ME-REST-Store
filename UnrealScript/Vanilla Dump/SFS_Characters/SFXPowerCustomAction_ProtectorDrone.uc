Class SFXPowerCustomAction_ProtectorDrone extends SFXPowerCustomAction_ProtectorDroneBase
    config(Game);

var config PowerData DroneDamage;
var config int Evolve_NumExtraTargets;
var config float Evolve_DamageBonus;
var config float Evolve_ImpactRadiusBonus;
var config float Evolve_FrequencyBonus;
var config float Evolve_DurationBonus;
var config float Evolve_ImpactRadiusBonus2;
var config float Evolve_IncapacitateChance;
var config float ZapCooldown;
var SFXPawn_ProtectorDrone Drone;
var RvrClientEffectInterface CE_DroneExplosionTemplate;
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
            break;
        case 'DroneDamage':
            ApplyBonusToParameter(DroneDamage, Bonus, bRemove);
            break;
        case 'DroneCooldown':
            ApplyBonusToParameter(CooldownTime, Bonus, bRemove);
            ApplyBonusToParameter(HenchmanCooldownTime, Bonus, bRemove);
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
            AddEvolvedRankBonus(EffectDuration, Evolve_DurationBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(ImpactRadius, Evolve_ImpactRadiusBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(DroneDamage, Evolve_DamageBonus);
            AddEvolvedRankBonus(ImpactRadius, Evolve_ImpactRadiusBonus2);
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
    local Vector SpawnLocation;
    
    DespawnDrone(Drone);
    Super(SFXPowerCustomAction).OnPowerDetonated(HitLocation, HitNormal, oProjectile, HitActor);
    if (m_oPawn == None || m_oPawn.Role < ENetRole.ROLE_Authority)
    {
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
    PowerStatBars[1].EvolvedBonuses[3] = Evolve_DamageBonus;
    PowerStatBars[2].Data = ImpactRadius;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Distance;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Distance;
    PowerStatBars[2].srStatBarDisplayTitle = $706052;
    PowerStatBars[2].EvolvedBonuses[1] = Evolve_ImpactRadiusBonus;
    PowerStatBars[2].EvolvedBonuses[3] = Evolve_ImpactRadiusBonus2;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(DroneDamage, bReset);
}
public function DespawnDroneHelper()
{
    DespawnDrone(Drone);
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
public function OnDroneKilled(SFXPawn_ProtectorDroneBase oDrone)
{
    oDrone.PlaySound(DroneDeathSound, TRUE);
}
public function SetupSpawnedDrone(SFXPawn_ProtectorDroneBase SpawnedDrone)
{
    local SFXAI_Core DroneAI;
    local SFXPowerCustomAction_CombatDroneZap Power;
    
    Super.SetupSpawnedDrone(SpawnedDrone);
    Drone = SFXPawn_ProtectorDrone(SpawnedDrone);
    if (Drone == None)
    {
        return;
    }
    DroneAI = SFXAI_Core(Drone.Controller);
    if (m_oTargetToAimAt != None && DroneAI != None)
    {
        DroneAI.ForcedTarget = m_oTargetToAimAt;
    }
    Power = SFXPowerCustomAction_CombatDroneZap(Drone.PowerManager.GetPowerByClass(Class'SFXPowerCustomAction_CombatDroneZap'));
    if (Power != None)
    {
        if (IsEvolvedWithChoice(2))
        {
            Power.AddEvolvedRankBonus(Power.CooldownTime, Evolve_FrequencyBonus);
        }
        if (IsEvolvedWithChoice(4))
        {
            Power.IncapacitateChance = Evolve_IncapacitateChance;
        }
        if (IsEvolvedWithChoice(5))
        {
            Power.NumCharges = Evolve_NumExtraTargets + 1;
        }
        Power.CooldownTime.BaseValue = ZapCooldown;
        Power.ImpactRadius = ImpactRadius;
        Power.Damage.BaseValue = DroneDamage.CurrentValue;
        Power.DefaultDamageType = DefaultDamageType;
        Power.RecalculateAllPowerInfo(FALSE);
    }
    m_oPawn.SetTimer(EffectDuration.CurrentValue, FALSE, 'DespawnDroneHelper', Self);
}
public function SFXPawn_ProtectorDroneBase SpawnDrone(Vector location, Rotator Rotation)
{
    local SFXPawn_ProtectorDrone PlayerDrone;
    
    PlayerDrone = SFXPawn_ProtectorDrone(Super.SpawnDrone(location, Rotation));
    m_oPawn.SetTimer(NonCombatTimeout_UpdateFrequency, TRUE, 'DroneNonCombatCheck', Self);
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
    DroneDamage = {
                   DynamicBonuses = (), 
                   RankBonuses[0] = 0.0, 
                   RankBonuses[1] = 0.0, 
                   RankBonuses[2] = 0.300000012, 
                   RankBonuses[3] = 0.0, 
                   RankBonuses[4] = 0.0, 
                   RankBonuses[5] = 0.0, 
                   BaseValue = 25.0, 
                   CurrentValue = 0.0, 
                   Formula = EPowerDataFormula.Normal
                  }
    Evolve_NumExtraTargets = 2
    Evolve_DamageBonus = 1.0
    Evolve_ImpactRadiusBonus = 0.400000006
    Evolve_FrequencyBonus = 0.5
    Evolve_DurationBonus = 1.0
    Evolve_ImpactRadiusBonus2 = 0.600000024
    Evolve_IncapacitateChance = 0.300000012
    ZapCooldown = 2.0
    DroneDeathSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_S_combatdrone_death'
    NonCombatTimeout_Length = 5.0
    NonCombatTimeout_UpdateFrequency = 1.0
    DroneClass = Class'SFXPawn_ProtectorDrone'
    DroneAIClass = Class'SFXAI_ProtectorDrone'
    DefaultDamageType = Class'SFXDamageType_ProtectorDrone'
    CustomCasterCrustParameters = {X = 1.0, Y = 0.0, Z = 0.0}
    ReleaseTime = 0.300000012
    CastAnimSet = MY_DYN_HMM_BC_RifleTechTool
    CE_CasterCrustTemplate = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_LeftFull_Cbt_VCFX_M'
    CastSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_P_combatdrone_cast'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_NP_combatdrone_cast'
    bCustomCasterCrustParameters = TRUE
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 6.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 12.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    ImpactRadius = {BaseValue = 500.0}
    EffectDuration = {BaseValue = 45.0}
    Ranks = ({
              Icon = 90, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $663224, 
              Evolved1Description = $690855, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 90, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690856, 
              Evolved1Description = $690857, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 90, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690858, 
              Evolved1Description = $690859, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 90, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690860, 
              Evolved1Description = $690861, 
              Evolved2Name = $690862, 
              Evolved2Description = $690863
             }, 
             {
              Icon = 90, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690864, 
              Evolved1Description = $690865, 
              Evolved2Name = $690866, 
              Evolved2Description = $690867
             }, 
             {
              Icon = 90, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690868, 
              Evolved1Description = $690869, 
              Evolved2Name = $690870, 
              Evolved2Description = $690871
             }
            )
    DisplayName = $663224
    Description = $690854
    Icon = 90
    TalentDescription = $690854
    IsBonusPower = TRUE
    PowerType = EPowerType.PowerType_Instant
}