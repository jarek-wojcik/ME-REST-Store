Class SFXWeaponGameEffect_AccuracyBonus extends SFXGameEffect;

public function OnRemoved()
{
    local SFXWeapon Weapon;
    local SFXWeapon_Shotgun_Base Shotgun;
    
    Super.OnRemoved();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.MinAimError.Bonuses.RemoveItem(Self);
        Weapon.MaxAimError.Bonuses.RemoveItem(Self);
        Weapon.MinZoomAimError.Bonuses.RemoveItem(Self);
        Weapon.MaxZoomAimError.Bonuses.RemoveItem(Self);
        Weapon.AccFirePenalty.Bonuses.RemoveItem(Self);
        Weapon.ZoomAccFirePenalty.Bonuses.RemoveItem(Self);
        Weapon.AI_AccCone_Min.Bonuses.RemoveItem(Self);
        Weapon.AI_AccCone_Max.Bonuses.RemoveItem(Self);
        Shotgun = SFXWeapon_Shotgun_Base(Weapon);
        if (Shotgun != None)
        {
            Shotgun.AccuracyBonus.Bonuses.RemoveItem(Self);
            Shotgun.ZoomAccuracyBonus.Bonuses.RemoveItem(Self);
        }
        Weapon.ScaleWeapon();
    }
}
public function OnApplied()
{
    local SFXWeapon Weapon;
    local SFXWeapon_Shotgun_Base Shotgun;
    
    Super.OnApplied();
    Weapon = SFXWeapon(Owner);
    if (Weapon != None)
    {
        Weapon.MinAimError.Bonuses.AddItem(Self);
        Weapon.MaxAimError.Bonuses.AddItem(Self);
        Weapon.MinZoomAimError.Bonuses.AddItem(Self);
        Weapon.MaxZoomAimError.Bonuses.AddItem(Self);
        Weapon.AccFirePenalty.Bonuses.AddItem(Self);
        Weapon.ZoomAccFirePenalty.Bonuses.AddItem(Self);
        Weapon.AI_AccCone_Min.Bonuses.AddItem(Self);
        Weapon.AI_AccCone_Max.Bonuses.AddItem(Self);
        Shotgun = SFXWeapon_Shotgun_Base(Weapon);
        if (Shotgun != None)
        {
            Shotgun.AccuracyBonus.Bonuses.AddItem(Self);
            Shotgun.ZoomAccuracyBonus.Bonuses.AddItem(Self);
        }
        Weapon.ScaleWeapon();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}