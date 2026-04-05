Class SFXPowerCustomAction_EnergyDrain extends SFXPowerCustomAction
    config(Game);

var config PowerData ShieldsRestored;
var config PowerData Evolve_DamageReductionDuration;
var config float OrganicDamageMultiplier;
var config float Evolve_DamageBonus1;
var config float Evolve_DamageBonus2;
var config float Evolve_RadiusBonus;
var config float Evolve_CooldownBonus;
var config float Evolve_ShieldsRestoredBonus;
var config float Evolve_DamageReductionAmount;
var config float ShieldRegenPenalty;
var config float ShieldRegenPenaltyDuration;
var float MachineHealth;
var float EnergyShields;
var config float ElectricComboDuration;
var WwiseEvent WwiseHitEvent;
var RvrClientEffect CE_ExplosionTemplate;
var RvrClientEffectInterface CE_ArmorCrustTemplate;
var bool bDrainedTarget;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXPawn ImpactedPawn;
    local float ShieldDrainAmount;
    local RvrClientEffectTarget CETarget;
    local SFXModule_GameEffectManager Manager;
    
    ImpactedPawn = SFXPawn(oImpacted);
    if (ImpactedPawn == None || Resistance == EPowerResistance.Resistance_Full)
    {
        return FALSE;
    }
    ImpactedPawn.AddPowerAssistEvent(m_oPawn, DisplayName, PowerAssistPartialControlValue);
    if (IsMachineRace(ImpactedPawn))
    {
        ShieldDrainAmount = MachineHealth - ImpactedPawn.GetCurrentHealth();
    }
    ShieldDrainAmount += EnergyShields - GetCurrentEnergyShields(ImpactedPawn);
    AddComboEffect(ImpactedPawn, Class'SFXGameEffect_PowerCombo_Electric', ElectricComboDuration);
    Manager = ImpactedPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None && !Manager.HasEffectOfTypeAndCategory(Class'SFXGameEffect_ShieldRegenBonus', Name))
    {
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_ShieldRegenBonus', Name, ShieldRegenPenaltyDuration, 1, ShieldRegenPenalty, m_oPawn.Controller, m_oPawn);
    }
    if (ShieldDrainAmount <= float(0))
    {
        return FALSE;
    }
    bDrainedTarget = TRUE;
    CETarget.Instigator = m_oPawn;
    if (bDrainedTarget && IsEvolvedWithChoice(5))
    {
        CETarget.SpawnValue.X = Evolve_DamageReductionDuration.CurrentValue;
    }
    else
    {
        CETarget.SpawnValue.X = 1.0;
    }
    Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayOnTarget(CE_ArmorCrustTemplate, CETarget);
    if (m_oPawn != None && m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        ProcessShieldDrain(ImpactedPawn, ShieldDrainAmount * ShieldsRestored.CurrentValue);
    }
    return TRUE;
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super.ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'EffectDuration':
            ApplyBonusToParameter(Evolve_DamageReductionDuration, Bonus, bRemove);
            break;
        default:
    }
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    ProcessShieldDrain(BioPawn(oActor), float(ImpactCount) / 10.0);
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus1);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(ImpactRadius, Evolve_RadiusBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            AddEvolvedRankBonus(ShieldsRestored, Evolve_ShieldsRestoredBonus);
            break;
        case EEvolveChoice.EvolveChoice4:
            AddEvolvedRankBonus(CooldownTime, Evolve_CooldownBonus);
            AddEvolvedRankBonus(HenchmanCooldownTime, Evolve_CooldownBonus);
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus2);
            break;
        case EEvolveChoice.EvolveChoice6:
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function float GetImpactDamage(Actor oImpacted, out Class<SFXDamageType> DamageType)
{
    local BioPawn ImpactedPawn;
    local float fDamage;
    
    fDamage = Damage.CurrentValue;
    DamageType = Class'SFXDamageType_EnergyDrainRobot';
    ImpactedPawn = BioPawn(oImpacted);
    if (ImpactedPawn != None)
    {
        EnergyShields = GetCurrentEnergyShields(ImpactedPawn);
        if (IsMachineRace(ImpactedPawn))
        {
            MachineHealth = ImpactedPawn.GetCurrentHealth();
            DamageType = Class'SFXDamageType_EnergyDrainRobot';
        }
        else
        {
            fDamage *= OrganicDamageMultiplier;
            DamageType = Class'SFXDamageType_EnergyDrain';
        }
    }
    return fDamage;
}
public function OnPowerDetonated(Vector HitLocation, Vector HitNormal, optional SFXProjectile_PowerCustomAction oProjectile, optional Actor HitActor)
{
    local Vector Param;
    
    Super.OnPowerDetonated(HitLocation, HitNormal, oProjectile, HitActor);
    if (CE_ExplosionTemplate != None)
    {
        Param.X = EffectDuration.CurrentValue;
        if (IsEvolvedWithChoice(1))
        {
            Param.Y = 1.0;
        }
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(CE_ExplosionTemplate, HitLocation, HitNormal, Param);
    }
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 4;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[0].EvolvedBonuses[3] = Evolve_CooldownBonus;
    PowerStatBars[1].Data = Damage;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_Damage;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DamageBonus1;
    PowerStatBars[1].EvolvedBonuses[4] = Evolve_DamageBonus2;
    PowerStatBars[2].Data = ImpactRadius;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Distance;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Distance;
    PowerStatBars[2].srStatBarDisplayTitle = StatBarTitle_ImpactRadius;
    PowerStatBars[2].EvolvedBonuses[1] = Evolve_RadiusBonus;
    PowerStatBars[3].Data = ShieldsRestored;
    PowerStatBars[3].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[3].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[3].srStatBarDisplayTitle = $701816;
    PowerStatBars[3].EvolvedBonuses[2] = Evolve_ShieldsRestoredBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(ShieldsRestored, bReset);
    RecalculatePowerData(Evolve_DamageReductionDuration, bReset);
}
public function StartPower()
{
    bDrainedTarget = FALSE;
    Super.StartPower();
}
public function float GetCurrentEnergyShields(BioPawn oPawn)
{
    local float fEnergyShieldsLeft;
    local SFXShield_Base EnergyShield;
    
    if (oPawn != None && oPawn.InvManager != None)
    {
        foreach oPawn.InvManager.InventoryActors(Class'SFXShield_Base', EnergyShield)
        {
            fEnergyShieldsLeft += EnergyShield.GetCurrentShields();
        }
    }
    return fEnergyShieldsLeft;
}
public final function ProcessShieldDrain(BioPawn ImpactedPawn, float ShieldDrainAmount)
{
    local SFXShield_Base MyShields;
    local SFXModule_GameEffectManager Manager;
    
    if (ShouldReplicate())
    {
        ReplicatePowerSubsequentImpact(ImpactedPawn, , , int(ShieldDrainAmount * 10.0));
    }
    MyShields = m_oPawn.GetShields();
    if (MyShields != None)
    {
        MyShields.SetCurrentShields(FClamp(MyShields.GetCurrentShields() + ShieldDrainAmount, 0.0, MyShields.GetMaxShields()));
    }
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None && IsEvolvedWithChoice(5))
    {
        Manager.RemoveEffectsByCategory(Name);
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_DamageTakenBonus', Name, Evolve_DamageReductionDuration.CurrentValue, 1, -Evolve_DamageReductionAmount, m_oPawn.Controller);
    }
    SFXGRI(m_oPawn.WorldInfo.GRI).PlayTransientSound(WwiseHitEvent, ImpactedPawn.location);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_RifleTechTool
        m_nmOrigSetName = 'HMM_BC_RifleTechTool'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BC_End')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_RifleTechTool_BioAnimSetData'
    End Object
    ShieldsRestored = {
                       DynamicBonuses = (), 
                       RankBonuses[0] = 0.0, 
                       RankBonuses[1] = 0.0, 
                       RankBonuses[2] = 0.0, 
                       RankBonuses[3] = 0.0, 
                       RankBonuses[4] = 0.0, 
                       RankBonuses[5] = 0.0, 
                       BaseValue = 0.5, 
                       CurrentValue = 0.0, 
                       Formula = EPowerDataFormula.BonusIsHardValue
                      }
    Evolve_DamageReductionDuration = {
                                      DynamicBonuses = (), 
                                      RankBonuses[0] = 0.0, 
                                      RankBonuses[1] = 0.0, 
                                      RankBonuses[2] = 0.0, 
                                      RankBonuses[3] = 0.0, 
                                      RankBonuses[4] = 0.0, 
                                      RankBonuses[5] = 0.0, 
                                      BaseValue = 10.0, 
                                      CurrentValue = 0.0, 
                                      Formula = EPowerDataFormula.Normal
                                     }
    OrganicDamageMultiplier = 0.5
    Evolve_DamageBonus1 = 0.300000012
    Evolve_DamageBonus2 = 0.400000006
    Evolve_RadiusBonus = 1.0
    Evolve_CooldownBonus = 0.25
    Evolve_ShieldsRestoredBonus = 0.5
    Evolve_DamageReductionAmount = 0.150000006
    ShieldRegenPenalty = 1.0
    ShieldRegenPenaltyDuration = 8.0
    ElectricComboDuration = 3.0
    WwiseHitEvent = WwiseEvent'Wwise_VFX_Tech.Play_vfx_overload_imp'
    CE_ExplosionTemplate = RvrClientEffect'BioVFX_Hch_Tali.VCFX.ShieldJack_Imp_VCFX'
    CE_ArmorCrustTemplate = RvrClientEffect'BioVFX_Hch_Tali.VCFX.ShieldJack_PlayerCrust_VCFX'
    ComboDetonators = (Class'SFXGameEffect_PowerCombo_Electric', Class'SFXGameEffect_PowerCombo_Cryo', Class'SFXGameEffect_PowerCombo_Fire')
    DetonationRumbleClass = Class'SFXRumble_Power_HeavyImpact'
    DetonationScreenShakeClass = Class'SFXShake_Power_HeavyImpact'
    ReleaseTime = 0.100000001
    CastAnimSet = MY_DYN_HMM_BC_RifleTechTool
    CE_CasterCrustTemplate = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_LeftFull_Cbt_VCFX_M'
    CE_TargetCrustTemplate = RvrClientEffect'BioVFX_Hch_Tali.VCFX.ShieldJack_Target_Crust_VCFX'
    CE_ReleaseEffectTemplate = RvrClientEffect'BioVFX_Hch_Tali.VCFX.EnergyDrain_Release_VCFX'
    ImpactSound = WwiseEvent'Wwise_Power_Tech_EnergyDrain.Play_power_tech_P_enerdrain_impact'
    CastSound = WwiseEvent'Wwise_Power_Tech_EnergyDrain.Play_power_tech_P_enerdrain_cast'
    HenchmanImpactSound = WwiseEvent'Wwise_Power_Tech_EnergyDrain.Play_power_tech_NP_enerdrain_impact'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Tech_EnergyDrain.Play_power_tech_NP_enerdrain_cast'
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 8.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 16.0, Formula = EPowerDataFormula.DivideByBonusSum}
    MaximumRange = {BaseValue = 6000.0}
    ImpactRadius = {BaseValue = 150.0}
    MaximumImpactTargets = {BaseValue = 2.0}
    EffectDuration = {BaseValue = 1.0}
    Damage = {RankBonuses[2] = 0.200000003, BaseValue = 220.0}
    Force = {BaseValue = 200.0}
    Ranks = ({
              Icon = 48, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $205894, 
              Evolved1Description = $205895, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 48, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $577972, 
              Evolved1Description = $577977, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 48, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $577973, 
              Evolved1Description = $577978, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 48, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $577979, 
              Evolved1Description = $577985, 
              Evolved2Name = $577980, 
              Evolved2Description = $577986
             }, 
             {
              Icon = 48, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $577981, 
              Evolved1Description = $577987, 
              Evolved2Name = $577982, 
              Evolved2Description = $577988
             }, 
             {
              Icon = 48, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $577983, 
              Evolved1Description = $577989, 
              Evolved2Name = $577984, 
              Evolved2Description = $577990
             }
            )
    PowerName = 'EnergyDrain'
    PowerCustomActionID = 35
    DisplayName = $205894
    Description = $703687
    Icon = 48
    TalentDescription = $703687
    IsBonusPower = TRUE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_EnergyDrain
}