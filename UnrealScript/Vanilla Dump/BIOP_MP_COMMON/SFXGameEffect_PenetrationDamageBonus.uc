Class SFXGameEffect_PenetrationDamageBonus extends SFXGameEffect_WeaponMod;

public function OnRemoved()
{
    Super(SFXGameEffect).OnRemoved();
    if (MyWeapon != None)
    {
        MyWeapon.PenetrationDamageBonus.Bonuses.RemoveItem(Self);
        MyWeapon.ScaleWeapon();
    }
}
public function ComputeCustomEffectValue(out float Value)
{
    if (Value < 1.0)
    {
        Value = FMax(Value, 1.0 + EffectValue);
    }
    else
    {
        Value = 1.0 + EffectValue;
    }
}
public function OnApplied()
{
    Super.OnApplied();
    if (MyWeapon != None)
    {
        MyWeapon.PenetrationDamageBonus.Bonuses.AddItem(Self);
        MyWeapon.ScaleWeapon();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BonusFormula = EBonusFormula.BonusFormula_Custom
}