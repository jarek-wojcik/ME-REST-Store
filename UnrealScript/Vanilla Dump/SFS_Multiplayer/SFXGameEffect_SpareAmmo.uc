Class SFXGameEffect_SpareAmmo extends SFXGameEffect;

var int AmmoIncrease;

public function OnRemoved()
{
    local SFXWeapon Weapon;
    
    Super.OnRemoved();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.MaxSpareAmmo.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(Weapon.MaxSpareAmmo);
        Weapon.AddAmmo(0);
    }
}
public function OnApplied()
{
    local SFXWeapon Weapon;
    
    Super.OnApplied();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        AmmoIncrease = int(Weapon.MaxSpareAmmo.Value * EffectValue);
        Weapon.MaxSpareAmmo.Bonuses.AddItem(Self);
        Class'SFXGame'.static.ReCalculate(Weapon.MaxSpareAmmo);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}