Class SFXGameEffect_PassiveWeaponBonus extends SFXGameEffect;

public function OnRemoved()
{
    local BioPawn oPawn;
    local SFXWeapon Weapon;
    
    Super.OnRemoved();
    oPawn = BioPawn(Owner);
    if (oPawn != None)
    {
        foreach oPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            ApplyBonus(Weapon, TRUE);
        }
    }
}
public function ApplyBonus(SFXWeapon Weapon, optional bool bRemove);

public function OnApplied()
{
    local BioPawn oPawn;
    local SFXWeapon Weapon;
    
    Super.OnApplied();
    oPawn = BioPawn(Owner);
    if (oPawn != None)
    {
        foreach oPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            ApplyBonus(Weapon);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}