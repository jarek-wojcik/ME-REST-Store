Class SFXPowerCustomActionMP_MeleePassiveBase extends SFXPowerCustomAction_MeleePassivePower
    config(Game);

var config PowerData HealthShieldBonus;
var config PowerData MeleeDamageBonus;
var config float Evolve_MeleeDamageBonus1;
var config float Evolve_MeleeDamageBonus2;
var config float Evolve_HealthShieldBonus1;
var config float Evolve_HealthShieldBonus2;
var config float Evolve_MeleeSpreeBonus;
var config float Evolve_ShieldRegenBonus;
var config float Evolve_MeleeSpreeDuration;
var config float Evolve_CustomSpreeBonus;
var config float Evolve_CustomSpreeDuration;

public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super(SFXPowerCustomAction).ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'MeleeDamage':
            ApplyBonusToParameter(MeleeDamage, Bonus, bRemove);
            ApplyBonusToParameter(MeleeForce, Bonus, bRemove);
            ApplyBonusToParameter(HeavyMeleeDamage, Bonus, bRemove);
            ApplyBonusToParameter(HeavyMeleeForce, Bonus, bRemove);
            break;
        default:
    }
}
public function ApplyGlobalBonus()
{
    Super(SFXPowerCustomAction_PassivePower).ApplyGlobalBonus();
    if (Rank < 1.0)
    {
        return;
    }
    if (HealthShieldBonus.CurrentValue > float(0))
    {
        ApplyShieldBonus(m_oPawn, HealthShieldBonus.CurrentValue, TRUE, 0.0, Name);
        ApplyHealthBonus(m_oPawn, HealthShieldBonus.CurrentValue, TRUE, 0.0, Name);
    }
    if (MeleeDamageBonus.CurrentValue > float(0))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'MeleeDamage', MeleeDamageBonus.CurrentValue, 0.0, Name, Self, TRUE);
    }
    if (IsEvolvedWithChoice(3))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_ShieldRegenBonus', -Evolve_ShieldRegenBonus, Name, m_oPawn.Controller);
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(MeleeDamageBonus, Evolve_MeleeDamageBonus1);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(HealthShieldBonus, Evolve_HealthShieldBonus1);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(MeleeDamageBonus, Evolve_MeleeDamageBonus2);
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(HealthShieldBonus, Evolve_HealthShieldBonus2);
            break;
        default:
    }
    RecalculateAllPowerInfo();
    ApplyGlobalBonus();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 2;
    PowerStatBars[0].Data = HealthShieldBonus;
    PowerStatBars[0].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_HealthShield;
    PowerStatBars[0].EvolvedBonuses[1] = Evolve_HealthShieldBonus1;
    PowerStatBars[0].EvolvedBonuses[5] = Evolve_HealthShieldBonus2;
    PowerStatBars[1].Data = MeleeDamageBonus;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_MeleeDamage;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_MeleeDamageBonus1;
    PowerStatBars[1].EvolvedBonuses[4] = Evolve_MeleeDamageBonus2;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super.RecalculateAllPowerData(bReset);
    RecalculatePowerData(HealthShieldBonus, bReset);
    RecalculatePowerData(MeleeDamageBonus, bReset);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HealthShieldBonus = {
                         DynamicBonuses = (), 
                         RankBonuses[0] = 0.0, 
                         RankBonuses[1] = 0.100000001, 
                         RankBonuses[2] = 0.0, 
                         RankBonuses[3] = 0.0, 
                         RankBonuses[4] = 0.0, 
                         RankBonuses[5] = 0.0, 
                         BaseValue = 0.150000006, 
                         CurrentValue = 0.0, 
                         Formula = EPowerDataFormula.BonusIsHardValue
                        }
    MeleeDamageBonus = {
                        DynamicBonuses = (), 
                        RankBonuses[0] = 0.0, 
                        RankBonuses[1] = 0.0, 
                        RankBonuses[2] = 0.200000003, 
                        RankBonuses[3] = 0.0, 
                        RankBonuses[4] = 0.0, 
                        RankBonuses[5] = 0.0, 
                        BaseValue = 0.150000006, 
                        CurrentValue = 0.0, 
                        Formula = EPowerDataFormula.BonusIsHardValue
                       }
    Evolve_MeleeDamageBonus1 = 0.300000012
    Evolve_MeleeDamageBonus2 = 0.300000012
    Evolve_HealthShieldBonus1 = 0.150000006
    Evolve_HealthShieldBonus2 = 0.25
    Evolve_MeleeSpreeBonus = 0.75
    Evolve_ShieldRegenBonus = 0.150000006
    Evolve_MeleeSpreeDuration = 30.0
    Evolve_CustomSpreeBonus = 0.25
    Evolve_CustomSpreeDuration = 20.0
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Ranks = ({
              Icon = 79, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $663223, 
              Evolved1Description = $703883, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 79, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $506058, 
              Evolved1Description = $506064, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 79, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $506059, 
              Evolved1Description = $564904, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 79, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $515683, 
              Evolved1Description = $515689, 
              Evolved2Name = $515684, 
              Evolved2Description = $515690
             }, 
             {
              Icon = 79, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $515685, 
              Evolved1Description = $515691, 
              Evolved2Name = $515686, 
              Evolved2Description = $515692
             }, 
             {
              Icon = 79, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $515687, 
              Evolved1Description = $681741, 
              Evolved2Name = $515688, 
              Evolved2Description = $515694
             }
            )
    PowerName = 'MPMeleePassive'
    DisplayName = $663223
    Description = $703883
    Icon = 79
    TalentDescription = $703883
}