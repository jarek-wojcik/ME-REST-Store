Class SFXGameEffect_ArmorPiercingBonus extends SFXGameEffect;

public function OnRemoved()
{
    local SFXWeapon Weapon;
    
    Super.OnRemoved();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.ArmorPiercing.Bonuses.RemoveItem(Self);
        Class'SFXGame'.static.ReCalculate(Weapon.ArmorPiercing);
    }
}
public function OnApplied()
{
    local SFXWeapon Weapon;
    
    Super.OnApplied();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.ArmorPiercing.Bonuses.AddItem(Self);
        Class'SFXGame'.static.ReCalculate(Weapon.ArmorPiercing);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}