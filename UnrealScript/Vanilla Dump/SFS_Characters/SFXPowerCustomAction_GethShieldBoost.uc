Class SFXPowerCustomAction_GethShieldBoost extends SFXPowerCustomAction_DefensiveShield
    config(Game);

var config PowerData ShieldsRestored;
var config float Evolve_DamageReductionBonus1;
var config float Evolve_DamageReductionBonus2;
var config float Evolve_ShieldRestoreBonus;
var config float Evolve_ShieldRegenBonus;
var config float Evolve_PowerDamageBonus;
var config float Evolve_EncumbranceBonus;
var RvrClientEffectInterface CE_EDICrustTemplate;
var ParticleSystem ShieldRechargeEffect;

public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(DamageReduction, Evolve_DamageReductionBonus1);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(ShieldsRestored, Evolve_ShieldRestoreBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(EncumbrancePenalty, -Evolve_EncumbranceBonus);
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(DamageReduction, Evolve_DamageReductionBonus2);
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = SFXPawn_Henchman(m_oPawn) == None ? CooldownTime : HenchmanCooldownTime;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Time;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_Cooldown;
    PowerStatBars[1].Data = DamageReduction;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_DamageReduction;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DamageReductionBonus1;
    PowerStatBars[1].EvolvedBonuses[5] = Evolve_DamageReductionBonus2;
    PowerStatBars[2].Data = ShieldsRestored;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[2].srStatBarDisplayTitle = $695125;
    PowerStatBars[2].EvolvedBonuses[1] = Evolve_ShieldRestoreBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super.RecalculateAllPowerData(bReset);
    RecalculatePowerData(ShieldsRestored, bReset);
}
public function StartPowerCooldown();

public function ApplyArmor()
{
    local SFXModule_GameEffectManager Manager;
    
    if (SFXPawn_Henchman(m_oPawn) != None)
    {
        CE_ArmorCrustTemplate = CE_EDICrustTemplate;
    }
    else
    {
        CE_ArmorCrustTemplate = default.CE_ArmorCrustTemplate;
    }
    Super.ApplyArmor();
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    if (IsEvolvedWithChoice(2))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_ShieldRegenBonus', -Evolve_ShieldRegenBonus, Name, m_oPawn.Controller);
    }
    if (IsEvolvedWithChoice(3))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_PowerDamageBonus, 0.0, Name, Self, FALSE, TRUE, TRUE, TRUE, FALSE);
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Force', Evolve_PowerDamageBonus, 0.0, Name, Self, FALSE, TRUE, TRUE, TRUE, FALSE);
    }
}
public function RemoveArmor()
{
    local SFXShield_Base Shields;
    local BioCheatManager CheatManager;
    
    Super.RemoveArmor();
    if (m_oPawn.Role == ENetRole.ROLE_Authority)
    {
        Shields = m_oPawn.GetShields();
        if (Shields != None)
        {
            Shields.SetCurrentShields(FClamp(Shields.GetCurrentShields() + ShieldsRestored.CurrentValue * Shields.GetMaxShields(), 0.0, Shields.GetMaxShields()));
            SFXGRI(m_oPawn.WorldInfo.GRI).DuringAsyncWorker.SpawnEffectAtLocation(m_oPawn, ShieldRechargeEffect, m_oPawn.location, m_oPawn.Rotation);
        }
    }
    CheatManager = m_oPawn.PowerManager.GetCheatManager();
    if (CheatManager != None && CheatManager.m_bEnablePowerCooldown == FALSE)
    {
        return;
    }
    m_oPawn.PowerManager.SetSharedCooldown(GetPowerCooldown());
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ShieldsRestored = {
                       DynamicBonuses = (), 
                       RankBonuses[0] = 0.0, 
                       RankBonuses[1] = 0.0, 
                       RankBonuses[2] = 0.200000003, 
                       RankBonuses[3] = 0.0, 
                       RankBonuses[4] = 0.0, 
                       RankBonuses[5] = 0.0, 
                       BaseValue = 0.5, 
                       CurrentValue = 0.0, 
                       Formula = EPowerDataFormula.BonusIsHardValue
                      }
    Evolve_DamageReductionBonus1 = 0.0500000007
    Evolve_DamageReductionBonus2 = 0.100000001
    Evolve_ShieldRestoreBonus = 0.300000012
    Evolve_ShieldRegenBonus = 0.150000006
    Evolve_PowerDamageBonus = 0.25
    Evolve_EncumbranceBonus = 0.300000012
    CE_EDICrustTemplate = RvrClientEffect'BioVFX_C_Shield.VCFX.Geth_ShieldBoost_VCFX_Edi_Crust'
    ShieldRechargeEffect = ParticleSystem'BioVFX_C_Shield.Particles.Shield_Booster_Geth'
    DamageReduction = {BaseValue = 0.150000006, Formula = EPowerDataFormula.BonusIsHardValue}
    EncumbrancePenalty = {BaseValue = 0.600000024, Formula = EPowerDataFormula.BonusIsHardValue}
    CE_ArmorCrustTemplate = RvrClientEffect'BioVFX_C_Shield.VCFX.Geth_ShieldBoost_VCFX_TargetCrust'
    CE_CasterCrustTemplate = RvrClientEffect'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_Arm_Left_VCFX'
    CastSound = WwiseEvent'Wwise_Power_Soldier_Fortif.Play_power_P_dmatrix_cast'
    HenchmanCastSound = WwiseEvent'Wwise_Power_Soldier_Fortif.Play_power_NP_dmatrix_cast'
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    CooldownTime = {RankBonuses[1] = 0.25, BaseValue = 10.0, Formula = EPowerDataFormula.DivideByBonusSum}
    HenchmanCooldownTime = {RankBonuses[1] = 0.25, BaseValue = 20.0, Formula = EPowerDataFormula.DivideByBonusSum}
    EffectDuration = {BaseValue = 2.0}
    Ranks = ({
              Icon = 55, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $314068, 
              Evolved1Description = $314072, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 55, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $314069, 
              Evolved1Description = $676390, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 55, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $314070, 
              Evolved1Description = $676391, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 55, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $314071, 
              Evolved1Description = $339506, 
              Evolved2Name = $339504, 
              Evolved2Description = $339505
             }, 
             {
              Icon = 55, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $676392, 
              Evolved1Description = $676393, 
              Evolved2Name = $676394, 
              Evolved2Description = $676395
             }, 
             {
              Icon = 55, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $676396, 
              Evolved1Description = $676397, 
              Evolved2Name = $676398, 
              Evolved2Description = $676399
             }
            )
    PowerName = 'GethShieldBoost'
    PowerCustomActionID = 34
    DisplayName = $314066
    Description = $314067
    Icon = 55
    TalentDescription = $314067
    IsBonusPower = TRUE
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Buff
}