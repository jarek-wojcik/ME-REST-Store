Class SFXWeaponGameEffect_DamageBonus extends SFXGameEffect;

public function OnRemoved()
{
    local SFXWeapon Weapon;
    
    Super.OnRemoved();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.Damage.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(Weapon.Damage);
    }
}
public function OnApplied()
{
    local SFXWeapon Weapon;
    
    Super.OnApplied();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.Damage.Bonuses.AddItem(Self);
        Class'SFXGame'.static.ReCalculate(Weapon.Damage);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}