Class SFXPowerCustomAction_AshleyPassive extends SFXPowerCustomAction_HenchmanPassive
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
    local SFXModule_GameEffectManager Manager;
    local int Index;
    local SFXWeapon Weapon;
    local SFXWeapon_SniperRifle_Base SniperRifle;
    local SFXWeapon_AssaultRifle_Base AssaultRifle;
    
    Super.ApplyGlobalBonus();
    if (IsEvolvedWithChoice(2))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', Evolve_PowerDamageBonus, 0.0, Name, Self);
    }
    foreach m_oPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        if (IsEvolvedWithChoice(3))
        {
            SniperRifle = SFXWeapon_SniperRifle_Base(Weapon);
            if (SniperRifle == None)
            {
                continue;
            }
            ApplyPermanentGameEffect(SniperRifle, Class'SFXWeaponGameEffect_DamageBonus', Evolve_SniperRifleDamageBonus, Name, m_oPawn.Controller);
        }
        if (IsEvolvedWithChoice(5))
        {
            AssaultRifle = SFXWeapon_AssaultRifle_Base(Weapon);
            if (AssaultRifle == None)
            {
                continue;
            }
            ApplyPermanentGameEffect(AssaultRifle, Class'SFXWeaponGameEffect_DamageBonus', Evolve_AssaultRifleDamageBonus, Name, m_oPawn.Controller);
        }
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
                    ApplyPermanentGameEffect(oSquadMember, Class'SFXGameEffect_PassiveWeaponDamageBonus', Evolve_SquadDamageBonus, Name, oSquadMember.Controller);
                }
            }
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
            AddEvolvedRankBonus(WeaponDamageBonus, Evolve_SquadDamageBonus);
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
    Evolve_WeaponDamageBonus = 0.300000012
    Evolve_HealthShieldBonus = 0.300000012
    Evolve_PowerDamageBonus = 0.200000003
    Evolve_SniperRifleDamageBonus = 0.449999988
    Evolve_SquadDamageBonus = 0.100000001
    Evolve_AssaultRifleDamageBonus = 0.600000024
    HealthShieldBonus = {RankBonuses[1] = 0.150000006, RankBonuses[2] = 0.150000006, BaseValue = 0.150000006}
    WeaponDamageBonus = {RankBonuses[1] = 0.150000006, RankBonuses[2] = 0.150000006, BaseValue = 0.150000006}
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Ranks = ({
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572512, 
              Evolved1Description = $572513, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572518, 
              Evolved1Description = $572523, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572519, 
              Evolved1Description = $572523, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572524, 
              Evolved1Description = $572530, 
              Evolved2Name = $572525, 
              Evolved2Description = $572531
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572526, 
              Evolved1Description = $572532, 
              Evolved2Name = $572527, 
              Evolved2Description = $572533
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $572528, 
              Evolved1Description = $572534, 
              Evolved2Name = $572529, 
              Evolved2Description = $572535
             }
            )
    PowerName = 'AshleyPassive'
    PowerCustomActionID = 42
    DisplayName = $572512
    Description = $572513
    Icon = 67
    TalentDescription = $572513
    DisplayInHUD = FALSE
}