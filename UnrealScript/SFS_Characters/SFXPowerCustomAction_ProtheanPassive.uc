Class SFXPowerCustomAction_ProtheanPassive extends SFXPowerCustomAction_HenchmanPassive
    config(Game);

var float Evolve_HealthShieldBonus;
var float Evolve_WeaponDamageBonus;
var float Evolve_PowerDamageBonus;
var float Evolve_SquadDamageDurationForceBonus;
var float Evolve_ShieldRegenBonus;

public function ApplyGlobalBonus()
{
    local BioPawn oSquadMember;
    local SFXModule_GameEffectManager Manager;
    local int Index;
    
    Super.ApplyGlobalBonus();
    for (Index = 0; Index < m_oPawn.Squad.Members.Length; Index++)
    {
        oSquadMember = BioPawn(m_oPawn.Squad.Members[Index]);
        if (oSquadMember != None && oSquadMember != m_oPawn)
        {
            Manager = oSquadMember.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None && oSquadMember.PowerManager != None)
            {
                Manager.RemoveEffectsByCategory(Name);
                if (IsEvolvedWithChoice(4))
                {
                    oSquadMember.PowerManager.ApplyPowerBonus(oSquadMember, 'Damage', Evolve_SquadDamageDurationForceBonus, 0.0, Name, Self);
                    oSquadMember.PowerManager.ApplyPowerBonus(oSquadMember, 'EffectDuration', Evolve_SquadDamageDurationForceBonus, 0.0, Name, Self);
                    oSquadMember.PowerManager.ApplyPowerBonus(oSquadMember, 'Force', Evolve_SquadDamageDurationForceBonus, 0.0, Name, Self);
                    continue;
                }
                if (IsEvolvedWithChoice(5))
                {
                    Manager.CreateAndApplyEffect(Class'SFXGameEffect_ShieldRegenBonus', Name, 0.0, 2, -Evolve_ShieldRegenBonus, m_oPawn.Controller);
                }
            }
        }
    }
    if (IsEvolvedWithChoice(4))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'EffectDuration', Evolve_SquadDamageDurationForceBonus, 0.0, Name, Self);
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Force', Evolve_SquadDamageDurationForceBonus, 0.0, Name, Self);
    }
    else if (IsEvolvedWithChoice(5))
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
            AddEvolvedRankBonus(PowerDamageBonus, Evolve_PowerDamageBonus);
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(PowerDamageBonus, Evolve_SquadDamageDurationForceBonus);
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
    PowerStatBars[1].EvolvedBonuses[3] = Evolve_PowerDamageBonus;
    PowerStatBars[1].EvolvedBonuses[4] = Evolve_SquadDamageDurationForceBonus;
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
    Evolve_PowerDamageBonus = 0.400000006
    Evolve_SquadDamageDurationForceBonus = 0.100000001
    Evolve_ShieldRegenBonus = 0.200000003
    HealthShieldBonus = {RankBonuses[1] = 0.100000001, RankBonuses[2] = 0.100000001, BaseValue = 0.100000001}
    PowerDamageBonus = {RankBonuses[1] = 0.200000003, RankBonuses[2] = 0.200000003, BaseValue = 0.200000003}
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Ranks = ({
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $716452, 
              Evolved1Description = $716451, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537923, 
              Evolved1Description = $717210, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537923, 
              Evolved1Description = $717211, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $506058, 
              Evolved1Description = $717212, 
              Evolved2Name = $537950, 
              Evolved2Description = $717213
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $537950, 
              Evolved1Description = $717214, 
              Evolved2Name = $537951, 
              Evolved2Description = $717215
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $193067, 
              Evolved1Description = $717216, 
              Evolved2Name = $193067, 
              Evolved2Description = $717217
             }
            )
    PowerName = 'ProtheanPassive'
    PowerCustomActionID = 42
    DisplayName = $716452
    Description = $716451
    Icon = 67
    TalentDescription = $716451
    DisplayInHUD = FALSE
}