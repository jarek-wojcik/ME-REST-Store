Class SFXPowerCustomAction_TaliPassive extends SFXPowerCustomAction_HenchmanPassive
    config(Game);

var float Evolve_HealthShieldBonus;
var float Evolve_WeaponDamageBonus;
var float Evolve_PowerRechargeSpeedBonus;
var float Evolve_SquadTechRechargeSpeedBonus;
var float Evolve_TechForceBonus;
var float Evolve_TechDurationBonus;
var float Evolve_DroneCooldownBonus;

public function ApplyGlobalBonus()
{
    local BioPawn oSquadMember;
    local SFXModule_GameEffectManager Manager;
    local int Index;
    
    Super.ApplyGlobalBonus();
    if (IsEvolvedWithChoice(3))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_TechForceBonus, 0.0, Name, Self, , FALSE, TRUE, FALSE, FALSE);
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'EffectDuration', Evolve_TechDurationBonus, 0.0, Name, Self, , FALSE, TRUE, FALSE, FALSE);
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
                    oSquadMember.PowerManager.ApplyPowerBonus(oSquadMember, 'CooldownTime', Evolve_SquadTechRechargeSpeedBonus, 0.0, Name, Self, , FALSE, TRUE, FALSE, FALSE);
                }
            }
        }
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'CooldownTime', Evolve_SquadTechRechargeSpeedBonus, 0.0, Name, Self, , FALSE, TRUE, FALSE, FALSE);
    }
    if (IsEvolvedWithChoice(5))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'DroneCooldown', Evolve_DroneCooldownBonus, 0.0, Name, Self);
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(PowerCooldownBonus, Evolve_PowerRechargeSpeedBonus);
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
    PowerStatBars[1].Data = PowerCooldownBonus;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[1].srStatBarDisplayTitle = $585777;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_PowerRechargeSpeedBonus;
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
    Evolve_PowerRechargeSpeedBonus = 0.400000006
    Evolve_SquadTechRechargeSpeedBonus = 0.100000001
    Evolve_TechForceBonus = 0.300000012
    Evolve_TechDurationBonus = 0.300000012
    Evolve_DroneCooldownBonus = 0.5
    HealthShieldBonus = {RankBonuses[0] = 0.100000001, RankBonuses[1] = 0.100000001, RankBonuses[2] = 0.100000001}
    PowerCooldownBonus = {RankBonuses[0] = 0.200000003, RankBonuses[1] = 0.200000003, RankBonuses[2] = 0.200000003}
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Ranks = ({
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $690872, 
              Evolved1Description = $624372, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624362, 
              Evolved1Description = $624363, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624362, 
              Evolved1Description = $624363, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624364, 
              Evolved1Description = $624365, 
              Evolved2Name = $624366, 
              Evolved2Description = $624367
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624368, 
              Evolved1Description = $624369, 
              Evolved2Name = $690873, 
              Evolved2Description = $690874
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $624370, 
              Evolved1Description = $624371, 
              Evolved2Name = $690875, 
              Evolved2Description = $690876
             }
            )
    PowerName = 'TaliPassive'
    PowerCustomActionID = 42
    DisplayName = $690872
    Description = $704192
    Icon = 67
    TalentDescription = $704192
    DisplayInHUD = FALSE
}