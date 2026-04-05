Class SFXPowerCustomAction_EDIPassive extends SFXPowerCustomAction_HenchmanPassive
    config(Game);

var float Evolve_HealthShieldBonus;
var float Evolve_WeaponDamageBonus;
var float Evolve_PowerDamageBonus;
var float Evolve_SquadTechDamageDurationBonus;
var float Evolve_TechDamageBonus;
var float Evolve_ShieldRegenBonus;

public function ApplyGlobalBonus()
{
    local BioPawn oSquadMember;
    local SFXModule_GameEffectManager Manager;
    local int Index;
    
    Super.ApplyGlobalBonus();
    if (IsEvolvedWithChoice(3))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_TechDamageBonus, 0.0, Name, Self, , FALSE, TRUE, FALSE, FALSE);
    }
    if (IsEvolvedWithChoice(4))
    {
        for (Index = 0; Index < m_oPawn.Squad.Members.Length; Index++)
        {
            oSquadMember = BioPawn(m_oPawn.Squad.Members[Index]);
            if (oSquadMember != None && oSquadMember != m_oPawn)
            {
                Manager = oSquadMember.GetModule(Class'SFXModule_GameEffectManager');
                if (Manager != None && oSquadMember.PowerManager != None)
                {
                    Manager.RemoveEffectsByCategory(Name);
                    oSquadMember.PowerManager.ApplyPowerBonus(oSquadMember, 'Damage', Evolve_SquadTechDamageDurationBonus, 0.0, Name, Self, , FALSE, TRUE, FALSE, FALSE);
                    oSquadMember.PowerManager.ApplyPowerBonus(oSquadMember, 'EffectDuration', Evolve_SquadTechDamageDurationBonus, 0.0, Name, Self, , FALSE, TRUE, FALSE, FALSE);
                }
            }
        }
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_SquadTechDamageDurationBonus, 0.0, Name, Self, , FALSE, TRUE, FALSE, FALSE);
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'EffectDuration', Evolve_SquadTechDamageDurationBonus, 0.0, Name, Self, , FALSE, TRUE, FALSE, FALSE);
    }
    if (IsEvolvedWithChoice(5))
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
            AddEvolvedRankBonus(PowerDamageBonus, Evolve_PowerDamageBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(HealthShieldBonus, Evolve_HealthShieldBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            AddEvolvedRankBonus(WeaponDamageBonus, Evolve_WeaponDamageBonus);
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
    ApplyGlobalBonus();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 2;
    PowerStatBars[0].Data = HealthShieldBonus;
    PowerStatBars[0].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_HealthShield;
    PowerStatBars[0].EvolvedBonuses[1] = Evolve_HealthShieldBonus;
    PowerStatBars[1].Data = PowerDamageBonus;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_PowerDamage;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_PowerDamageBonus;
}
public function ResetPower()
{
    local BioPawn oSquadMember;
    local SFXModule_GameEffectManager Manager;
    local int Index;
    
    Super(SFXPowerCustomAction_PassivePower).ResetPower();
    for (Index = 0; Index < m_oPawn.Squad.Members.Length; Index++)
    {
        oSquadMember = BioPawn(m_oPawn.Squad.Members[Index]);
        if (oSquadMember != None && oSquadMember != m_oPawn)
        {
            Manager = oSquadMember.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None)
            {
                Manager.RemoveEffectsByCategory(Name);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Evolve_HealthShieldBonus = 0.200000003
    Evolve_WeaponDamageBonus = 0.200000003
    Evolve_PowerDamageBonus = 0.200000003
    Evolve_SquadTechDamageDurationBonus = 0.100000001
    Evolve_TechDamageBonus = 0.300000012
    Evolve_ShieldRegenBonus = 0.200000003
    HealthShieldBonus = {RankBonuses[1] = 0.100000001, RankBonuses[2] = 0.100000001, BaseValue = 0.100000001}
    PowerDamageBonus = {RankBonuses[1] = 0.200000003, RankBonuses[2] = 0.200000003, BaseValue = 0.200000003}
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Ranks = ({
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $663213, 
              Evolved1Description = $624374, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624375, 
              Evolved1Description = $624376, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624375, 
              Evolved1Description = $624376, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537951, 
              Evolved1Description = $572532, 
              Evolved2Name = $624378, 
              Evolved2Description = $624379
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624380, 
              Evolved1Description = $624381, 
              Evolved2Name = $690877, 
              Evolved2Description = $690878
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624382, 
              Evolved1Description = $624383, 
              Evolved2Name = $690879, 
              Evolved2Description = $690880
             }
            )
    PowerName = 'EDIPassive'
    PowerCustomActionID = 42
    DisplayName = $663213
    Description = $704189
    Icon = 67
    TalentDescription = $704189
    DisplayInHUD = FALSE
}