Class SFXPowerCustomAction_HenchmanPassive extends SFXPowerCustomAction_PassivePower
    config(Game);

var PowerData HealthShieldBonus;
var PowerData WeaponDamageBonus;
var PowerData PowerDamageBonus;
var PowerData PowerCooldownBonus;

public function ApplyGlobalBonus()
{
    Super.ApplyGlobalBonus();
    if (Rank < float(1))
    {
        return;
    }
    if (HealthShieldBonus.CurrentValue > float(0))
    {
        ApplyShieldBonus(m_oPawn, HealthShieldBonus.CurrentValue, TRUE, 0.0, Name);
        ApplyHealthBonus(m_oPawn, HealthShieldBonus.CurrentValue, TRUE, 0.0, Name);
    }
    if (WeaponDamageBonus.CurrentValue > float(0))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_PassiveWeaponDamageBonus', WeaponDamageBonus.CurrentValue, Name, m_oPawn.Controller);
    }
    if (PowerCooldownBonus.CurrentValue > float(0))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'CooldownTime', PowerCooldownBonus.CurrentValue, 0.0, Name, Self);
    }
    if (PowerDamageBonus.CurrentValue > float(0))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'Damage', PowerDamageBonus.CurrentValue, 0.0, Name, Self);
    }
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(HealthShieldBonus, bReset);
    RecalculatePowerData(WeaponDamageBonus, bReset);
    RecalculatePowerData(PowerDamageBonus, bReset);
    RecalculatePowerData(PowerCooldownBonus, bReset);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HealthShieldBonus = {
                         DynamicBonuses = (), 
                         RankBonuses[0] = 0.0, 
                         RankBonuses[1] = 0.0, 
                         RankBonuses[2] = 0.0, 
                         RankBonuses[3] = 0.0, 
                         RankBonuses[4] = 0.0, 
                         RankBonuses[5] = 0.0, 
                         BaseValue = 0.0, 
                         CurrentValue = 0.0, 
                         Formula = EPowerDataFormula.BonusIsHardValue
                        }
    WeaponDamageBonus = {
                         DynamicBonuses = (), 
                         RankBonuses[0] = 0.0, 
                         RankBonuses[1] = 0.0, 
                         RankBonuses[2] = 0.0, 
                         RankBonuses[3] = 0.0, 
                         RankBonuses[4] = 0.0, 
                         RankBonuses[5] = 0.0, 
                         BaseValue = 0.0, 
                         CurrentValue = 0.0, 
                         Formula = EPowerDataFormula.BonusIsHardValue
                        }
    PowerDamageBonus = {
                        DynamicBonuses = (), 
                        RankBonuses[0] = 0.0, 
                        RankBonuses[1] = 0.0, 
                        RankBonuses[2] = 0.0, 
                        RankBonuses[3] = 0.0, 
                        RankBonuses[4] = 0.0, 
                        RankBonuses[5] = 0.0, 
                        BaseValue = 0.0, 
                        CurrentValue = 0.0, 
                        Formula = EPowerDataFormula.BonusIsHardValue
                       }
    PowerCooldownBonus = {
                          DynamicBonuses = (), 
                          RankBonuses[0] = 0.0, 
                          RankBonuses[1] = 0.0, 
                          RankBonuses[2] = 0.0, 
                          RankBonuses[3] = 0.0, 
                          RankBonuses[4] = 0.0, 
                          RankBonuses[5] = 0.0, 
                          BaseValue = 0.0, 
                          CurrentValue = 0.0, 
                          Formula = EPowerDataFormula.BonusIsHardValue
                         }
}