Class SFXGameEffect_WeaponMod extends SFXGameEffect;

var SFXWeapon MyWeapon;
var EWeaponStatBars ModStat;

public function OnApplied()
{
    Super.OnApplied();
    MyWeapon = SFXWeapon(Owner);
    if (MyWeapon == None)
    {
        return;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ModStat = EWeaponStatBars.EWeaponStatBar_MAX
}