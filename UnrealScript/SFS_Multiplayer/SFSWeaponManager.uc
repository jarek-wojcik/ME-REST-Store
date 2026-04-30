Class SFSWeaponManager extends SFSManager within SFXPawn;

var Vector binlocation;
var Vector tossForce;
var SFSPortalAsyncLoader asyncLoader;
var SFSGenericStringQueue weaponLoad_queue;

public event simulated function HandlePostAdd()
{
    asyncLoader = Outer.GetModule(Class'SFSPortalAsyncLoader');
    weaponLoad_queue = new (Self) Class'SFSGenericStringQueue';
    weaponLoad_queue.queueEmptyEventString = Class'SFSGenericEventConstants'.default.WeaponsLoaded_Event;
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
public function LoadWeapons(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local int i;
    local array<string> pathTokens;
    local string WeaponClassName;
    local SFXWeapon existingWeapon;
    local bool bAlreadyHasWeapon;
    
    // Load any Character weapons the pawn doesn't already have
    for (i = 0; i < Character.WeaponCount; i++)
    {
        if (Character.Weapons[i].WeaponID == "")
        {
            continue;
        }
        Class'SFSArrayUtility'.static.SplitStringIntoParts(Character.Weapons[i].WeaponID, ".", pathTokens);
        if (pathTokens.Length == 0)
        {
            log(Self.Name, "Error: Could not parse WeaponID: " $ Character.Weapons[i].WeaponID, Outer);
            continue;
        }
        WeaponClassName = pathTokens[pathTokens.Length - 1];
        bAlreadyHasWeapon = FALSE;
        foreach Pawn.InvManager.InventoryActors(Class'SFXWeapon', existingWeapon)
        {
            log(Self.Name, "Comparing existing: " $ existingWeapon.Class.Name $ " vs target: " $ WeaponClassName, Outer);
            if (string(existingWeapon.Class.Name) == WeaponClassName)
            {
                bAlreadyHasWeapon = TRUE;
                break;
            }
        }
        if (bAlreadyHasWeapon)
        {
            log(Self.Name, "Pawn already has weapon, removing before reload: " $ WeaponClassName, Outer);
            Pawn.InvManager.RemoveFromInventory(existingWeapon);
            existingWeapon.Destroy();
        }
        log(Self.Name, "Requesting async load for weapon: " $ Character.Weapons[i].WeaponID, Outer);
        loadAndGiveWeaponAsync(Character.Weapons[i].WeaponID, Character.Weapons[i].Mod1ID, Character.Weapons[i].Mod2ID, Character.Weapons[i].FireMode, Character.Weapons[i].bRemoveScope);
    }
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
function loadAndGiveWeaponAsync(string weaponPath, string Mod1ID, string Mod2ID, string WeaponFireMode, bool bRemoveScope)
{
    if (asyncLoader == None)
    {
        log(Self.Name, "Error: asyncLoader is None, cannot async load weapon: " $ weaponPath, Outer);
        return;
    }
    log(Self.Name, "Async loading weapon: " $ weaponPath, Outer);
    weaponLoad_queue.addItem(weaponPath);
    asyncLoader.LoadWeaponAsync(weaponPath, Mod1ID, Mod2ID, WeaponFireMode, bRemoveScope, OnWeaponLoaded);
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
    if (Class<SFXHeavyWeapon>(load.LoadedWeapon) == None)
    {
        changeFireMode(load.LoadedWeapon, load.WeaponFireMode);
    }
    else
    {
        adjustHeavyWeapon(Class<SFXHeavyWeapon>(load.LoadedWeapon));
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
        HandleSniperRifles(SFXWeapon_SniperRifle_Base(NewWeapon), load);
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
    weaponLoad_queue.popItem(load.AssetToLoad);
    Owner.SetWeaponImmediately(NewWeapon);
}
function HandleSniperRifles(SFXWeapon_SniperRifle_Base SniperRifle, SFSGenericAsyncLoad load)
{
    SniperRifle.SniperRifleDamagePenalty = 1.0;
    if (load.bRemoveScope && SniperRifle.AimModes.Length > 0)
    {
        SniperRifle.AimModes[0].bScoped = FALSE;
        SniperRifle.AimModes[0].ZoomFOV = 39.4300003;
        SniperRifle.GUIZoomReticleClass = Class'SFXGUI_CrosshairReticle';
        // CombatTightAim and AimbackTightAim are SFXCameraMode_SniperAim instances
        // (bFirstPerson = TRUE) which hide the character. Clear that flag so the
        // camera stays in 3rd-person while zoomed, matching how AR zoom behaves.
        if (SniperRifle.CameraSetup != None)
        {
            if (SniperRifle.CameraSetup.CombatTightAim != None)
            {
                SniperRifle.CameraSetup.CombatTightAim.bFirstPerson = FALSE;
            }
            if (SniperRifle.CameraSetup.AimbackTightAim != None)
            {
                SniperRifle.CameraSetup.AimbackTightAim.bFirstPerson = FALSE;
            }
        }
        log(Self.Name, "Removed scope (bScoped=false, ZoomFOV reset, reticle=crosshair, bFirstPerson=false) for: " $ load.AssetToLoad, Outer);
    }
}
public final function RemoveWeaponsNotInCharacter(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local int i;
    local array<string> pathTokens;
    local SFXWeapon existingWeapon;
    local bool bWeaponInCharacter;
    local array<SFXWeapon> weaponsToRemove;
    
    foreach Pawn.InvManager.InventoryActors(Class'SFXWeapon', existingWeapon)
    {
        bWeaponInCharacter = FALSE;
        for (i = 0; i < Character.WeaponCount; i++)
        {
            if (Character.Weapons[i].WeaponID == "")
            {
                continue;
            }
            Class'SFSArrayUtility'.static.SplitStringIntoParts(Character.Weapons[i].WeaponID, ".", pathTokens);
            if (pathTokens.Length > 0 && string(existingWeapon.Class.Name) == pathTokens[pathTokens.Length - 1])
            {
                bWeaponInCharacter = TRUE;
                break;
            }
        }
        if (!bWeaponInCharacter)
        {
            if (string(existingWeapon.Class.Name) == "sfxweapon_heavy_consumablerocketlauncher")
            {
                continue;
            }
            log(Self.Name, "Weapon not in character, queuing for removal: " $ existingWeapon.Class.Name, Outer);
            weaponsToRemove.AddItem(existingWeapon);
        }
    }
    for (i = 0; i < weaponsToRemove.Length; i++)
    {
        Pawn.InvManager.RemoveFromInventory(weaponsToRemove[i]);
        weaponsToRemove[i].Destroy();
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
function adjustHeavyWeapon(Class<SFXHeavyWeapon> HeavyWeaponClass)
{
    //Heavy weapons were not balanced for multiplayer so adjusting them a little bit.
    HeavyWeaponClass.default.Damage.X *= 1.5;
    HeavyWeaponClass.default.Damage.Y *= 1.5;
    HeavyWeaponClass.default.MaxSpareAmmo.X *= 2.0;
    HeavyWeaponClass.default.MaxSpareAmmo.Y *= 2.0;
    HeavyWeaponClass.default.MaxSpareAmmo.Value *= 2.0;
}
function changeFireMode(Class<SFXWeapon> WeaponClass, string FireMode)
{
    local FireModes eFireMode;
    
    //Changes the Fire Mode of the equipped weapon. Tweaks RoF, RpB and Damage depending on the change to the RoF.
    switch (FireMode)
    {
        case "Semi":
            eFireMode = FireModes.FireMode_SemiAuto;
            break;
        case "FullAuto":
            eFireMode = FireModes.FireMode_FullAuto;
            break;
        case "Burst":
            eFireMode = FireModes.FireMode_Burst;
            break;
        default:
            eFireMode = FireModes.FireMode_None;
            break;
    }
    if (eFireMode == FireModes.FireMode_None || int(WeaponClass.default.DefaultFireMode) == int(eFireMode))
    {
        return;
    }
    else
    {
        WeaponClass.default.DefaultFireMode = eFireMode;
    }
    log(Self.Name, "Applying FireMode: " $ eFireMode $ " to " $ WeaponClass, Outer);
    switch (eFireMode)
    {
        case FireModes.FireMode_Burst:
            WeaponClass.default.RoundsPerBurst = 3.0;
            WeaponClass.default.RateOfFire.X *= 2.75;
            WeaponClass.default.RateOfFire.Y *= 2.75;
            break;
        case FireModes.FireMode_FullAuto:
            WeaponClass.default.RateOfFire.X *= 1.25;
            WeaponClass.default.RateOfFire.Y *= 1.25;
            WeaponClass.default.Damage.X *= 0.800000012;
            WeaponClass.default.Damage.Y *= 0.800000012;
            break;
        case FireModes.FireMode_SemiAuto:
            WeaponClass.default.Damage.X *= 1.25;
            WeaponClass.default.Damage.Y *= 1.25;
            break;
        default:
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ListenedEventTypes = (SFSEventType.EVT_GiveWeaponCommand)
    binlocation = {X = 0.0, Y = 0.0, Z = 0.0}
    tossForce = {X = 0.0, Y = 0.0, Z = 10000.0}
}