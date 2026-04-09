Class SFXPowerCustomAction_GarrusPassive extends SFXPowerCustomAction_HenchmanPassive
    config(Game);

var float Evolve_WeaponDamageBonus;
var float Evolve_HealthShieldBonus;
var float Evolve_PowerDamageBonus;
var float Evolve_SniperRifleDamageBonus;
var float Evolve_SquadDamageBonus;
var float Evolve_AssaultRifleDamageBonus;

public function ApplyGlobalBonus()
{
    local BioPawn oSquadMember;
    local int Index;
    local SFXWeapon Weapon;
    local SFXWeapon_SniperRifle_Base SniperRifle;
    local SFXWeapon_AssaultRifle_Base AssaultRifle;
    local SFXModule_GameEffectManager Manager;
    
    Super.ApplyGlobalBonus();
    foreach m_oPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        if (IsEvolvedWithChoice(5))
        {
            SniperRifle = SFXWeapon_SniperRifle_Base(Weapon);
            if (SniperRifle == None)
            {
                continue;
            }
            Manager = SniperRifle.GetModule(Class'SFXModule_GameEffectManager');
            Manager.RemoveEffectsByTypeAndCategory(Class'SFXWeaponGameEffect_DamageBonus', Name);
            ApplyPermanentGameEffect(SniperRifle, Class'SFXWeaponGameEffect_DamageBonus', Evolve_SniperRifleDamageBonus, Name, m_oPawn.Controller);
        }
        if (IsEvolvedWithChoice(3))
        {
            AssaultRifle = SFXWeapon_AssaultRifle_Base(Weapon);
            if (AssaultRifle == None)
            {
                continue;
            }
            Manager = AssaultRifle.GetModule(Class'SFXModule_GameEffectManager');
            Manager.RemoveEffectsByTypeAndCategory(Class'SFXWeaponGameEffect_DamageBonus', Name);
            ApplyPermanentGameEffect(AssaultRifle, Class'SFXWeaponGameEffect_DamageBonus', Evolve_AssaultRifleDamageBonus, Name, m_oPawn.Controller);
        }
    }
    if (IsEvolvedWithChoice(2))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_PowerDamageBonus, 0.0, Name);
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
            oSquadMember.PowerManager.ApplyPowerBonus(oSquadMember, 'Damage', Evolve_SquadDamageBonus, 0.0, Name, Self, , FALSE, FALSE, TRUE, FALSE);
        }
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(WeaponDamageBonus, Evolve_WeaponDamageBonus);
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
    PowerStatBars[1].Data = WeaponDamageBonus;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_WeaponDamage;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_WeaponDamageBonus;
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
    Evolve_WeaponDamageBonus = 0.400000006
    Evolve_HealthShieldBonus = 0.200000003
    Evolve_PowerDamageBonus = 0.200000003
    Evolve_SniperRifleDamageBonus = 0.600000024
    Evolve_SquadDamageBonus = 0.100000001
    Evolve_AssaultRifleDamageBonus = 0.5
    HealthShieldBonus = {RankBonuses[1] = 0.100000001, RankBonuses[2] = 0.100000001, BaseValue = 0.100000001}
    WeaponDamageBonus = {RankBonuses[1] = 0.200000003, RankBonuses[2] = 0.200000003, BaseValue = 0.200000003}
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Ranks = ({
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573513, 
              Evolved1Description = $573514, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573517, 
              Evolved1Description = $573522, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573518, 
              Evolved1Description = $573522, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573523, 
              Evolved1Description = $573529, 
              Evolved2Name = $573524, 
              Evolved2Description = $573530
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573525, 
              Evolved1Description = $573531, 
              Evolved2Name = $573526, 
              Evolved2Description = $573532
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $573527, 
              Evolved1Description = $573534, 
              Evolved2Name = $573528, 
              Evolved2Description = $573533
             }
            )
    PowerName = 'GarrusPassive'
    PowerCustomActionID = 42
    DisplayName = $573513
    Description = $704190
    Icon = 67
    TalentDescription = $704190
    DisplayInHUD = FALSE
}