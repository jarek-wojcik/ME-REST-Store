Class SFXGameEffect_GlobalCooldownBonus extends SFXGameEffect;

var bool bRemoved;

public function OnRemoved()
{
    local BioPawn BP;
    
    bRemoved = TRUE;
    BP = BioPawn(Owner);
    if (BP != None && BP.Controller != None && BP.Controller.PlayerReplicationInfo != None)
    {
        BP.GetModule(Class'SFXModule_GameEffectManager').GlobalCooldownBonus.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(BP.GetModule(Class'SFXModule_GameEffectManager').GlobalCooldownBonus);
    }
}
public function ComputeEffectValue(out float Value)
{
    if (!bRemoved)
    {
        Value += EffectValue;
    }
}
public static function float ComputeTotalEffectValue(float BaseValue, float StackingValue, float NonStackingValue)
{
    return BaseValue * (1.0 + StackingValue + NonStackingValue);
}
public function OnApplied()
{
    local BioPawn BP;
    
    BP = BioPawn(Owner);
    if (BP != None && BP.Controller != None && BP.Controller.PlayerReplicationInfo != None)
    {
        BP.GetModule(Class'SFXModule_GameEffectManager').GlobalCooldownBonus.Bonuses.AddItem(Self);
        Class'SFXGame'.static.ReCalculate(BP.GetModule(Class'SFXModule_GameEffectManager').GlobalCooldownBonus);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}