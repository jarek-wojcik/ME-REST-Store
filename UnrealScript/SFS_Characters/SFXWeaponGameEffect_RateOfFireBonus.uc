Class SFXWeaponGameEffect_RateOfFireBonus extends SFXGameEffect;

public function OnRemoved()
{
    local SFXWeapon Weapon;
    
    Super.OnRemoved();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.RateOfFire.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(Weapon.RateOfFire);
    }
}
public function OnApplied()
{
    local SFXWeapon Weapon;
    
    Super.OnApplied();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.RateOfFire.Bonuses.AddItem(Self);
        Class'SFXGame'.static.ReCalculate(Weapon.RateOfFire);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}