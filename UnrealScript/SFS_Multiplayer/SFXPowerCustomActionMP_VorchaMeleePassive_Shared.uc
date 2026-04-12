Class SFXPowerCustomActionMP_VorchaMeleePassive_Shared extends SFXPowerCustomActionMP_MeleePassiveBase
    config(Game);

var config PowerData MovementSpeedBonus;

public function ApplyGlobalBonus()
{
    Super.ApplyGlobalBonus();
    if (Rank < 1.0)
    {
        return;
    }
    if (MovementSpeedBonus.CurrentValue > float(0))
    {
        ApplyPermanentGameEffect(m_oPawn, Class'SFXGameEffect_MovementSpeedBonus', MovementSpeedBonus.CurrentValue, Name, m_oPawn.Controller);
    }
}
public function OnHeavyMeleeKill(Actor oImpacted)
{
    local SFXModule_GameEffectManager Manager;
    
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Manager.RemoveEffectsByCategory(MeleeKillCategory);
    }
    if (IsEvolvedWithChoice(2))
    {
        m_oPawn.PowerManager.ApplyPowerBonus(m_oPawn, 'MeleeDamage', Evolve_MeleeSpreeBonus, Evolve_MeleeSpreeDuration, MeleeKillCategory, Self, TRUE);
    }
    if (IsEvolvedWithChoice(4))
    {
        ApplyTemporaryGameEffect(m_oPawn, Class'SFXGameEffect_WeaponDamageBonus', Evolve_CustomSpreeDuration, Evolve_CustomSpreeBonus, MeleeKillCategory, m_oPawn.Controller);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MovementSpeedBonus = {
                          DynamicBonuses = (), 
                          RankBonuses[0] = 0.0, 
                          RankBonuses[1] = 0.0, 
                          RankBonuses[2] = 0.0, 
                          RankBonuses[3] = 0.0, 
                          RankBonuses[4] = 0.0, 
                          RankBonuses[5] = 0.0, 
                          BaseValue = 0.100000001, 
                          CurrentValue = 0.0, 
                          Formula = EPowerDataFormula.BonusIsHardValue
                         }
    HealthShieldBonus = {RankBonuses[1] = 0.150000006}
    Evolve_HealthShieldBonus1 = 0.200000003
    Evolve_CustomSpreeBonus = 0.300000012
    MeleeDamage = {BaseValue = 250.0}
    HeavyMeleeDamage = {BaseValue = 600.0}
    HeavyMeleeForce = {BaseValue = 850.0}
}