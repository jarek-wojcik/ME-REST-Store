Class SFXGameEffect_HealthBonus extends SFXGameEffect;

var float PercentHealthBonus;
var bool bEffectValueIsPercent;

public function OnRemoved()
{
    local SFXModule_Damage DmgModule;
    local ScaledFloat MaxHealth;
    
    Super.OnRemoved();
    if (Owner != None)
    {
        DmgModule = Owner.GetModule(Class'SFXModule_Damage');
        if (DmgModule != None)
        {
            MaxHealth = DmgModule.GetMaxHealthStats();
            MaxHealth.Bonuses.RemoveItem(Self);
            Class'SFXGame'.static.ReCalculate(MaxHealth);
            DmgModule.SetMaxHealth(MaxHealth);
            DmgModule.SetCurrentHealth(FClamp(DmgModule.GetCurrentHealth(), DmgModule.GetCurrentHealth(), MaxHealth.Value), TRUE);
        }
    }
}
public function ComputeCustomEffectValue(out float Value)
{
    Value += PercentHealthBonus;
}
public function OnApplied()
{
    local SFXModule_Damage DmgModule;
    local float fBaseMaxHealth;
    local ScaledFloat MaxHealth;
    
    Super.OnApplied();
    if (Owner != None)
    {
        DmgModule = Owner.GetModule(Class'SFXModule_Damage');
        if (DmgModule != None)
        {
            MaxHealth = DmgModule.GetMaxHealthStats();
            fBaseMaxHealth = Lerp(MaxHealth.X, MaxHealth.Y, float(MaxHealth.Level / MaxHealth.MaxLevel));
            if (fBaseMaxHealth > float(0))
            {
                if (bEffectValueIsPercent)
                {
                    PercentHealthBonus = EffectValue;
                }
                else
                {
                    PercentHealthBonus = EffectValue / fBaseMaxHealth;
                }
                MaxHealth.Bonuses.AddItem(Self);
                Class'SFXGame'.static.ReCalculate(MaxHealth);
                MaxHealth.Value = float(int(MaxHealth.Value + 0.5));
                DmgModule.SetMaxHealth(MaxHealth);
                if (bEffectValueIsPercent)
                {
                    DmgModule.SetCurrentHealth(DmgModule.GetCurrentHealth() + EffectValue * fBaseMaxHealth, TRUE);
                }
                else
                {
                    DmgModule.SetCurrentHealth(DmgModule.GetCurrentHealth() + EffectValue, TRUE);
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BonusFormula = EBonusFormula.BonusFormula_Custom
}