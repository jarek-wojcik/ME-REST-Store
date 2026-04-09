Class SFXPowerCustomAction_LiaraPassive extends SFXPowerCustomAction_HenchmanPassive
    config(Game);

var float Evolve_PowerCooldownBonus;
var float Evolve_HealthShieldBonus;
var float Evolve_WeaponDamageBonus;
var float Evolve_PowerForceBonus;
var float Evolve_SquadCooldownBonus;
var float Evolve_SingularityCooldownBonus;

public function ApplyGlobalBonus()
{
    local BioPawn oSquadMember;
    local SFXModule_GameEffectManager Manager;
    local int Index;
    
    Super.ApplyGlobalBonus();
    if (IsEvolvedWithChoice(3))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Force', Evolve_PowerForceBonus, 0.0, Name, Self);
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'EffectDuration', Evolve_PowerForceBonus, 0.0, Name, Self);
    }
    if (IsEvolvedWithChoice(2))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_PassiveWeaponDamageBonus', Evolve_WeaponDamageBonus, Name, m_oPawn.Controller);
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
                    oSquadMember.PowerManager.ApplyPowerBonus(oSquadMember, 'CooldownTime', Evolve_SquadCooldownBonus, 0.0, Name, Self, , TRUE, FALSE, FALSE);
                }
            }
        }
    }
    if (IsEvolvedWithChoice(5))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'CooldownTime_Singularity', Evolve_SingularityCooldownBonus, 0.0, Name, Self);
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(PowerCooldownBonus, Evolve_PowerCooldownBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(HealthShieldBonus, Evolve_HealthShieldBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(PowerCooldownBonus, Evolve_SquadCooldownBonus);
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
    PowerStatBars[1].Data = PowerCooldownBonus;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[1].srStatBarDisplayTitle = $585777;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_PowerCooldownBonus;
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
    Evolve_PowerCooldownBonus = 0.400000006
    Evolve_HealthShieldBonus = 0.200000003
    Evolve_WeaponDamageBonus = 0.200000003
    Evolve_PowerForceBonus = 0.300000012
    Evolve_SquadCooldownBonus = 0.100000001
    Evolve_SingularityCooldownBonus = 1.0
    HealthShieldBonus = {RankBonuses[1] = 0.100000001, RankBonuses[2] = 0.100000001, BaseValue = 0.100000001}
    PowerCooldownBonus = {RankBonuses[1] = 0.200000003, RankBonuses[2] = 0.200000003, BaseValue = 0.200000003}
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    Ranks = ({
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537961, 
              Evolved1Description = $537962, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537965, 
              Evolved1Description = $537970, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537966, 
              Evolved1Description = $537970, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537971, 
              Evolved1Description = $537977, 
              Evolved2Name = $537972, 
              Evolved2Description = $537978
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537973, 
              Evolved1Description = $537979, 
              Evolved2Name = $537974, 
              Evolved2Description = $537980
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537975, 
              Evolved1Description = $537981, 
              Evolved2Name = $611700, 
              Evolved2Description = $611701
             }
            )
    PowerName = 'LiaraPassive'
    PowerCustomActionID = 42
    DisplayName = $537961
    Description = $537962
    Icon = 67
    TalentDescription = $537962
    DisplayInHUD = FALSE
}