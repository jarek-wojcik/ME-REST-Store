Class SFXPowerCustomAction_JimmyPassive extends SFXPowerCustomAction_HenchmanPassive
    config(Game);

var float Evolve_HealthShieldBonus;
var float Evolve_WeaponDamageBonus;
var float Evolve_PowerDamageBonus;
var float Evolve_ShieldRegenBonus;
var float Evolve_SquadHealthShieldBonus;
var float Evolve_HealthShieldBonus2;
var float Evolve_MeleeDamageBonus;

public function ApplyGlobalBonus()
{
    local BioPawn oSquadMember;
    local SFXModule_GameEffectManager Manager;
    local int Index;
    
    Super.ApplyGlobalBonus();
    if (IsEvolvedWithChoice(2))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_PowerDamageBonus, 0.0, Name, Self);
    }
    if (IsEvolvedWithChoice(3))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_ShieldRegenBonus', Evolve_ShieldRegenBonus, Name, m_oPawn.Controller);
    }
    if (IsEvolvedWithChoice(4))
    {
        for (Index = 0; Index < m_oPawn.Squad.Members.Length; Index++)
        {
            oSquadMember = BioPawn(m_oPawn.Squad.Members[Index]);
            if (oSquadMember != None && oSquadMember != m_oPawn)
            {
                Manager = oSquadMember.GetModule(Class'SFXModule_GameEffectManager');
                if (Manager != None)
                {
                    Manager.RemoveEffectsByCategory(Name);
                    ApplyShieldBonus(oSquadMember, Evolve_SquadHealthShieldBonus, TRUE, 0.0, Name);
                    ApplyHealthBonus(oSquadMember, Evolve_SquadHealthShieldBonus, TRUE, 0.0, Name);
                }
            }
        }
    }
    if (IsEvolvedWithChoice(5))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'MeleeDamage', Evolve_MeleeDamageBonus, 0.0, Name, Self, TRUE);
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(HealthShieldBonus, Evolve_HealthShieldBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(WeaponDamageBonus, Evolve_WeaponDamageBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(HealthShieldBonus, Evolve_SquadHealthShieldBonus);
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
    PowerStatBars[0].EvolvedBonuses[0] = Evolve_HealthShieldBonus;
    PowerStatBars[0].EvolvedBonuses[4] = Evolve_SquadHealthShieldBonus;
    PowerStatBars[0].EvolvedBonuses[5] = Evolve_HealthShieldBonus2;
    PowerStatBars[1].Data = WeaponDamageBonus;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_WeaponDamage;
    PowerStatBars[1].EvolvedBonuses[1] = Evolve_WeaponDamageBonus;
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
    Evolve_HealthShieldBonus = 0.400000006
    Evolve_WeaponDamageBonus = 0.200000003
    Evolve_PowerDamageBonus = 0.200000003
    Evolve_ShieldRegenBonus = -0.200000003
    Evolve_SquadHealthShieldBonus = 0.200000003
    Evolve_HealthShieldBonus2 = 0.400000006
    Evolve_MeleeDamageBonus = 1.0
    HealthShieldBonus = {RankBonuses[1] = 0.200000003, RankBonuses[2] = 0.200000003, BaseValue = 0.200000003}
    WeaponDamageBonus = {RankBonuses[1] = 0.100000001, RankBonuses[2] = 0.100000001, BaseValue = 0.100000001}
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Ranks = ({
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537919, 
              Evolved1Description = $537920, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537923, 
              Evolved1Description = $537948, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537924, 
              Evolved1Description = $537948, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537949, 
              Evolved1Description = $537955, 
              Evolved2Name = $537950, 
              Evolved2Description = $537956
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537951, 
              Evolved1Description = $537957, 
              Evolved2Name = $537952, 
              Evolved2Description = $537958
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537953, 
              Evolved1Description = $537959, 
              Evolved2Name = $537954, 
              Evolved2Description = $537960
             }
            )
    PowerName = 'JimmyPassive'
    PowerCustomActionID = 42
    DisplayName = $537919
    Description = $704191
    Icon = 67
    TalentDescription = $704191
    DisplayInHUD = FALSE
}