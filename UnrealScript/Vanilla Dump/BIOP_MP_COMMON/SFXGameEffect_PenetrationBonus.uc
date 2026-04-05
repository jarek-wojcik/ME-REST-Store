Class SFXGameEffect_PenetrationBonus extends SFXGameEffect_WeaponMod;

public function OnRemoved()
{
    Super(SFXGameEffect).OnRemoved();
    if (MyWeapon != None)
    {
        MyWeapon.PenetrationBonus.Bonuses.RemoveItem(Self);
        MyWeapon.ScaleWeapon();
    }
}
public function OnApplied()
{
    Super.OnApplied();
    if (MyWeapon != None)
    {
        MyWeapon.PenetrationBonus.Bonuses.AddItem(Self);
        MyWeapon.ScaleWeapon();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}