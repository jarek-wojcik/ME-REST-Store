Class SFXPowerCustomAction_KaidenPassive extends SFXPowerCustomAction_HenchmanPassive
    config(Game);

var float Evolve_WeaponDamageBonus;
var float Evolve_HealthShieldBonus;
var float Evolve_BioticPowerDamageBonus;
var float Evolve_TechPowerDamageBonus;
var float Evolve_SquadPowerDamageBonus;
var float Evolve_SquadShieldRechargeBonus;

public function ApplyGlobalBonus()
{
    local BioPawn oSquadMember;
    local SFXModule_GameEffectManager Manager;
    local int Index;
    
    Super.ApplyGlobalBonus();
    if (IsEvolvedWithChoice(0))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_PassiveWeaponDamageBonus', Evolve_WeaponDamageBonus, Name, m_oPawn.Controller);
    }
    if (IsEvolvedWithChoice(2))
    {
        Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None && m_oPawn.PowerManager != None)
        {
            m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_BioticPowerDamageBonus, 0.0, Name, Self, , TRUE, FALSE, FALSE, FALSE);
        }
    }
    if (IsEvolvedWithChoice(3))
    {
        Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None && m_oPawn.PowerManager != None)
        {
            m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_TechPowerDamageBonus, 0.0, Name, Self, , FALSE, TRUE, FALSE, FALSE);
        }
    }
    if (IsEvolvedWithChoice(4))
    {
        for (Index = 0; Index < m_oPawn.Squad.Members.Length; Index++)
        {
            oSquadMember = BioPawn(m_oPawn.Squad.Members[Index]);
            if (oSquadMember == None || oSquadMember.PowerManager == None)
            {
                continue;
            }
            oSquadMember.PowerManager.ApplyPowerBonus(oSquadMember, 'Damage', Evolve_SquadPowerDamageBonus, 0.0, Name, Self, , TRUE, TRUE, FALSE, FALSE);
        }
    }
    if (IsEvolvedWithChoice(5))
    {
        for (Index = 0; Index < m_oPawn.Squad.Members.Length; Index++)
        {
            oSquadMember = BioPawn(m_oPawn.Squad.Members[Index]);
            if (oSquadMember == None)
            {
                continue;
            }
            Manager = oSquadMember.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager == None)
            {
                continue;
            }
            Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_ShieldRegenBonus', Name);
            ApplyPermanentGameEffect(oSquadMember, Class'SFXGameEffect_ShieldRegenBonus', -Evolve_SquadShieldRechargeBonus, Name, m_oPawn.Controller);
        }
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(HealthShieldBonus, Evolve_HealthShieldBonus);
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
    Evolve_WeaponDamageBonus = 0.200000003
    Evolve_HealthShieldBonus = 0.300000012
    Evolve_BioticPowerDamageBonus = 0.300000012
    Evolve_TechPowerDamageBonus = 0.300000012
    Evolve_SquadPowerDamageBonus = 0.100000001
    Evolve_SquadShieldRechargeBonus = 0.150000006
    HealthShieldBonus = {RankBonuses[1] = 0.150000006, RankBonuses[2] = 0.150000006, BaseValue = 0.150000006}
    PowerDamageBonus = {RankBonuses[1] = 0.150000006, RankBonuses[2] = 0.150000006, BaseValue = 0.150000006}
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Ranks = ({
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572512, 
              Evolved1Description = $579350, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572518, 
              Evolved1Description = $579408, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572519, 
              Evolved1Description = $579408, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $579409, 
              Evolved1Description = $579415, 
              Evolved2Name = $579410, 
              Evolved2Description = $579416
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $579411, 
              Evolved1Description = $579417, 
              Evolved2Name = $579412, 
              Evolved2Description = $579418
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $579413, 
              Evolved1Description = $579419, 
              Evolved2Name = $579414, 
              Evolved2Description = $579420
             }
            )
    PowerName = 'KaidenPassive'
    PowerCustomActionID = 42
    DisplayName = $572512
    Description = $579350
    Icon = 67
    TalentDescription = $579350
    DisplayInHUD = FALSE
}