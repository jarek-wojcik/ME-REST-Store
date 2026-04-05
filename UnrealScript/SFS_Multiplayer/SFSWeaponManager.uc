Class SFSWeaponManager extends SFSManager within SFXPawn;

var Vector binlocation;
var Vector tossForce;
var SFSPortalAsyncLoader asyncLoader;

public event simulated function HandlePostAdd()
{
    asyncLoader = Outer.GetModule(Class'SFSPortalAsyncLoader');
}
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
function exchangeWeapons(SFXPawn OtherPawn)
{
    local SFXWeapon otherPawnWeapon;
    local SFXWeapon outerWeapon;
    
    outerWeapon = SFXWeapon(Outer.Weapon);
    otherPawnWeapon = SFXWeapon(OtherPawn.Weapon);
    //Get rid of the weapons
    OtherPawn.InvManager.RemoveFromInventory(otherPawnWeapon);
    Outer.InvManager.RemoveFromInventory(outerWeapon);
    // Add weapons to the pawns
    Outer.InvManager.AddInventory(otherPawnWeapon);
    OtherPawn.InvManager.AddInventory(outerWeapon);
    //Set the weapons    
    Outer.SetWeaponImmediately(otherPawnWeapon);
    OtherPawn.SetWeaponImmediately(outerWeapon);
}
function loadAndGiveWeapon(string weaponPath)
{
    local Class<SFXWeapon> WeaponClass;
    local SFXWeapon NewWeapon;
    local SFXHeavyWeapon HeavyWeapon;
    local SFXPawn OwnerPawn;
    
    // Get the owner pawn (the SFXPawn this manager is within)
    OwnerPawn = Outer;
    if (OwnerPawn == None)
    {
        log(Self.Name, "Error: OwnerPawn is None", Outer);
        return;
    }
    // Load the weapon class from the path
    WeaponClass = Class<SFXWeapon>(Class'SFXEngine'.static.LoadSeekFreeObjectBlocking(weaponPath, Class'Class'));
    if (WeaponClass == None)
    {
        log(Self.Name, "Error: Failed to load weapon class from path: " $ weaponPath, Outer);
        return;
    }
    // Create the weapon and add it to pawn's inventory
    WeaponClass.default.DefaultFireMode = FireModes.FireMode_FullAuto;
    NewWeapon = SFXWeapon(OwnerPawn.CreateInventory(WeaponClass));
    if (NewWeapon == None)
    {
        log(Self.Name, "Error: Failed to create weapon", Outer);
        return;
    }
    // Give ammo based on weapon type
    HeavyWeapon = SFXHeavyWeapon(NewWeapon);
    if (HeavyWeapon != None)
    {
        // Heavy weapons use a reverse ammo counter (AmmoUsedCount)
        // AddHeavyAmmo subtracts from AmmoUsedCount, giving us more available ammo
        HeavyWeapon.AddHeavyAmmo(10000);
        log(Self.Name, "Added heavy weapon ammo for: " $ weaponPath, Outer);
    }
    else
    {
        // Regular weapons use CurrentSpareAmmo
        NewWeapon.CurrentSpareAmmo = NewWeapon.GetMaxSpareAmmo();
        log(Self.Name, "Set spare ammo to max for: " $ weaponPath, Outer);
    }
    // Equip the weapon immediately
    OwnerPawn.SetWeaponImmediately(NewWeapon);
    log(Self.Name, "Successfully gave and equipped weapon: " $ weaponPath, Outer);
}
function loadAndGiveWeaponAsync(string weaponPath, string Mod1ID, string Mod2ID)
{
    if (asyncLoader == None)
    {
        log(Self.Name, "Error: asyncLoader is None, cannot async load weapon: " $ weaponPath, Outer);
        return;
    }
    log(Self.Name, "Async loading weapon: " $ weaponPath, Outer);
    asyncLoader.LoadWeaponAsync(weaponPath, Mod1ID, Mod2ID, OnWeaponLoaded);
}
function OnWeaponLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXWeapon NewWeapon;
    local SFXModule_WeaponModManager ModManager;
    
    if (load.LoadedWeapon == None)
    {
        log(Self.Name, "Error: Failed to async load weapon: " $ load.AssetToLoad, Outer);
        return;
    }
    NewWeapon = SFXWeapon(Owner.CreateInventory(load.LoadedWeapon));
    if (NewWeapon == None)
    {
        log(Self.Name, "Error: Failed to create weapon from async load: " $ load.AssetToLoad, Outer);
        return;
    }
    NewWeapon.CurrentSpareAmmo = NewWeapon.GetMaxSpareAmmo();
    NewWeapon.WeaponLevel = NewWeapon.MaxLevel;
    //Remove the sniper rifle un-zoomed penalty
    if (SFXWeapon_SniperRifle_Base(NewWeapon) != None)
    {
        SFXWeapon_SniperRifle_Base(NewWeapon).SniperRifleDamagePenalty = 1.0;
    }
    log(Self.Name, "Successfully gave and equipped weapon (async): " $ load.AssetToLoad $ " at level " $ NewWeapon.WeaponLevel, Outer);
    ModManager = NewWeapon.GetModule(Class'SFXModule_WeaponModManager');
    if (ModManager != None)
    {
        ModManager.RemoveAllMods();
    }
    if (load.Mod1ID != "")
    {
        log(Self.Name, "Queuing async load for mod1: " $ load.Mod1ID $ " on " $ load.AssetToLoad, Outer);
        asyncLoader.LoadModAsync(load.Mod1ID, NewWeapon, OnWeaponModLoaded);
    }
    if (load.Mod2ID != "")
    {
        log(Self.Name, "Queuing async load for mod2: " $ load.Mod2ID $ " on " $ load.AssetToLoad, Outer);
        asyncLoader.LoadModAsync(load.Mod2ID, NewWeapon, OnWeaponModLoaded);
    }
}
function OnWeaponModLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXModule_WeaponModManager ModManager;
    
    if (load.LoadedWeaponMod == None)
    {
        log(Self.Name, "Error: Failed to async load weapon mod: " $ load.AssetToLoad, Outer);
        return;
    }
    if (load.targetWeapon == None)
    {
        log(Self.Name, "Error: TargetWeapon is None for mod: " $ load.AssetToLoad, Outer);
        return;
    }
    ModManager = load.targetWeapon.GetModule(Class'SFXModule_WeaponModManager');
    if (ModManager == None)
    {
        log(Self.Name, "Warning: No SFXModule_WeaponModManager on weapon for mod: " $ load.AssetToLoad, Outer);
        return;
    }
    log(Self.Name, "Applying mod: " $ load.AssetToLoad $ " to " $ load.targetWeapon, Outer);
    ModManager.AddMod(load.LoadedWeaponMod, 5);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ListenedEventTypes = (SFSEventType.EVT_GiveWeaponCommand)
    binlocation = {X = 0.0, Y = 0.0, Z = 0.0}
    tossForce = {X = 0.0, Y = 0.0, Z = 10000.0}
}