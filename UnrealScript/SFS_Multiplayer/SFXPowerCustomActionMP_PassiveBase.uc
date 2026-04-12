Class SFXPowerCustomActionMP_PassiveBase extends SFXPowerCustomAction_PassivePower
    config(Game);

var PowerData PowerDamageBonus;
var PowerData WeaponDamageBonus;
var PowerData WeightCapacityBonus;
var array<ELoadoutWeapons> WeaponWeightClasses;
var float Evolve_WeaponDamageBonus1;
var float Evolve_PowerDamageBonus1;
var float Evolve_WeightCapacityBonus;
var float Evolve_PowerDamageBonus2;
var float Evolve_HeadShotBonus;
var float Evolve_WeaponEncumbranceBonus;
var float Evolve_WeaponDamageBonus2;

public function ApplyGlobalBonus()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_WeaponWeightModifier WeaponWeight;
    
    Super.ApplyGlobalBonus();
    if (Rank < float(1))
    {
        return;
    }
    if (WeaponDamageBonus.CurrentValue > float(0))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_WeaponDamageBonus', WeaponDamageBonus.CurrentValue, Name, m_oPawn.Controller);
    }
    if (PowerDamageBonus.CurrentValue > float(0))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', PowerDamageBonus.CurrentValue, 0.0, Name, Self);
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Force', PowerDamageBonus.CurrentValue, 0.0, Name, Self);
    }
    if (WeightCapacityBonus.CurrentValue > float(0))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_WeightCapacity', WeightCapacityBonus.CurrentValue, Name, m_oPawn.Controller);
    }
    if (IsEvolvedWithChoice(3))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_PartBasedDamageBonus', Evolve_HeadShotBonus, Name, m_oPawn.Controller);
    }
    if (IsEvolvedWithChoice(4) && WeaponWeightClasses.Length > 0)
    {
        Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            WeaponWeight = SFXGameEffect_WeaponWeightModifier(Manager.CreateEffect(Class'SFXGameEffect_WeaponWeightModifier', Name, 0.0, 2, -Evolve_WeaponEncumbranceBonus, m_oPawn.Controller));
            if (WeaponWeight != None)
            {
                WeaponWeight.WeaponClasses = WeaponWeightClasses;
                WeaponWeight.OnApplied();
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
            AddEvolvedRankBonus(WeaponDamageBonus, Evolve_WeaponDamageBonus1);
            break;
        case EEvolveChoice.EvolveChoice2:
            AddEvolvedRankBonus(PowerDamageBonus, Evolve_PowerDamageBonus1);
            AddEvolvedRankBonus(WeightCapacityBonus, Evolve_WeightCapacityBonus);
            break;
        case EEvolveChoice.EvolveChoice3:
            AddEvolvedRankBonus(PowerDamageBonus, Evolve_PowerDamageBonus2);
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            break;
        case EEvolveChoice.EvolveChoice6:
            AddEvolvedRankBonus(WeaponDamageBonus, Evolve_WeaponDamageBonus2);
            break;
        default:
    }
    RecalculateAllPowerInfo();
    ApplyGlobalBonus();
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 3;
    PowerStatBars[0].Data = WeaponDamageBonus;
    PowerStatBars[0].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_WeaponDamage;
    PowerStatBars[0].EvolvedBonuses[0] = Evolve_WeaponDamageBonus1;
    PowerStatBars[0].EvolvedBonuses[5] = Evolve_WeaponDamageBonus2;
    PowerStatBars[1].Data = PowerDamageBonus;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_Percent;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_PowerDamage;
    PowerStatBars[1].EvolvedBonuses[1] = Evolve_PowerDamageBonus1;
    PowerStatBars[1].EvolvedBonuses[2] = Evolve_PowerDamageBonus2;
    PowerStatBars[2].Data = WeightCapacityBonus;
    PowerStatBars[2].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[2].srDisplayTotalToken = StatBarToken_RawValue;
    PowerStatBars[2].srStatBarDisplayTitle = StatBarTitle_WeightCapacity;
    PowerStatBars[2].EvolvedBonuses[1] = Evolve_WeightCapacityBonus;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(WeaponDamageBonus, bReset);
    RecalculatePowerData(PowerDamageBonus, bReset);
    RecalculatePowerData(WeightCapacityBonus, bReset);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Ranks = ({
              Icon = 0, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $0, 
              Evolved1Description = $0, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $677158, 
              Evolved1Description = $677159, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $677160, 
              Evolved1Description = $677161, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $677162, 
              Evolved1Description = $677163, 
              Evolved2Name = $677164, 
              Evolved2Description = $677165
             }, 
             {
              Icon = 67, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $677167, 
              Evolved1Description = $677166, 
              Evolved2Name = $677172, 
              Evolved2Description = $677178
             }
            )
    PowerName = 'MPPassive'
    PowerCustomActionID = 42
    Icon = 67
    DisplayInHUD = FALSE
}