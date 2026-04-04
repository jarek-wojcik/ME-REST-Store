Class SFXGameEffect_ConstraintDmgBonus extends SFXGameEffect;

public function OnRemoved()
{
    local SFXWeapon Weapon;
    
    Super.OnRemoved();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.HeadshotDamageMultiplier.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(Weapon.HeadshotDamageMultiplier);
    }
}
public function OnApplied()
{
    local SFXWeapon Weapon;
    
    Super.OnApplied();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.HeadshotDamageMultiplier.Bonuses.AddItem(Self);
        Class'SFXGame'.static.ReCalculate(Weapon.HeadshotDamageMultiplier);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}