Class SFSWeaponManager extends SFSManager within SFXPawn;

function HandleEvent(SFSEvent E)
{
    switch (E.eType)
    {
        case SFSEventType.EVT_GiveWeaponCommand:
            log(Self.Name, "Giving Weapon : " $ E.sValue, Outer);
            loadAndGiveWeapon(E.sValue);
            break;
        default:
    }
}
function loadAndGiveWeapon(string weaponPath)
{
    local Class<SFXWeapon> WeaponClass;
    local SFXWeapon NewWeapon;
    local SFXHeavyWeapon HeavyWeapon;
    local SFXPawn OwnerPawn;
    
    // Get the owner pawn (the SFXPawn this manager is within)
    OwnerPawn = SFXPawn(Outer);
    if (OwnerPawn == None)
    {
        log("Error: OwnerPawn is None", 'SFSWeaponManager', );
        return;
    }
    
    // Load the weapon class from the path
    WeaponClass = Class<SFXWeapon>(Class'SFXEngine'.static.LoadSeekFreeObjectBlocking(weaponPath, Class'Class'));
    
    if (WeaponClass == None)
    {
        log("Error: Failed to load weapon class from path: " $ weaponPath, 'SFSWeaponManager', );
        return;
    }
    
    // Create the weapon and add it to pawn's inventory
    NewWeapon = SFXWeapon(OwnerPawn.CreateInventory(WeaponClass));
    
    if (NewWeapon == None)
    {
        log("Error: Failed to create weapon", 'SFSWeaponManager', );
        return;
    }
    
    // Give ammo based on weapon type
    HeavyWeapon = SFXHeavyWeapon(NewWeapon);
    if (HeavyWeapon != None)
    {
        // Heavy weapons use a reverse ammo counter (AmmoUsedCount)
        // AddHeavyAmmo subtracts from AmmoUsedCount, giving us more available ammo
        HeavyWeapon.AddHeavyAmmo(10000);
        log("Added heavy weapon ammo for: " $ weaponPath, 'SFSWeaponManager', );
    }
    else
    {
        // Regular weapons use CurrentSpareAmmo
        NewWeapon.CurrentSpareAmmo = NewWeapon.GetMaxSpareAmmo();
        log("Set spare ammo to max for: " $ weaponPath, 'SFSWeaponManager', );
    }
    
    // Equip the weapon immediately
    OwnerPawn.SetWeaponImmediately(NewWeapon);
    
    log("Successfully gave and equipped weapon: " $ weaponPath, 'SFSWeaponManager', );
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ListenedEventTypes = (SFSEventType.EVT_GiveWeaponCommand)
}