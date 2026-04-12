Class SFSSpectrePortalManager extends SFSManager within SFXPawn;

var SFSSpectreIntegrationService spectreService;
var SFSStrikeTeamIntegrationService strikeTeamService;
var SFSAppearanceManager appearanceManager;
var SFSPortalAsyncLoader asyncLoader;
var SFSWeaponManager weaponManager;
var SFSPowerManager PowerManager;
var SFSConsumableManager ConsumableManager;
var SFSCustomActionsManager CustomActionsManager;

public event simulated function HandlePostAdd()
{
    spectreService = Outer.GetModule(Class'SFSSpectreIntegrationService');
    strikeTeamService = Outer.GetModule(Class'SFSStrikeTeamIntegrationService');
    appearanceManager = Outer.GetModule(Class'SFSAppearanceManager');
    asyncLoader = Outer.GetModule(Class'SFSPortalAsyncLoader');
    weaponManager = Outer.GetModule(Class'SFSWeaponManager');
    PowerManager = Outer.GetModule(Class'SFSPowerManager');
    ConsumableManager = Outer.GetModule(Class'SFSConsumableManager');
    CustomActionsManager = Outer.GetModule(Class'SFSCustomActionsManager');
    if (asyncLoader != None)
    {
        spectreService.RetrieveActiveCharacter(OnCharacterRetrieved);
    }
}
function OnCharacterRetrieved(SFSCharacterModelStruct Character, bool bSuccess)
{
    local int i;
    
    if (bSuccess)
    {
        log(Self.Name, "=== Character Retrieved ===", Outer);
        log(Self.Name, "Character ID: " $ Character.Id, Outer);
        log(Self.Name, "Character Name: " $ Character.Name, Outer);
        log(Self.Name, "Character base class: " $ Character.CharacterID, Outer);
        log(Self.Name, "Character Appearance class: " $ Character.AppearanceCharID, Outer);
        log(Self.Name, "Character Uses Helmet: " $ Character.bUseHelmet, Outer);
        log(Self.Name, "Character Uses Headgear: " $ Character.bUseHeadgear, Outer);
        log(Self.Name, "--- Weapons (Count: " $ Character.WeaponCount $ ") ---", Outer);
        for (i = 0; i < Character.WeaponCount; i++)
        {
            log(Self.Name, "  Weapon " $ i $ " - WeaponID: " $ Character.Weapons[i].WeaponID, Outer);
            log(Self.Name, "    Mod1ID: " $ Character.Weapons[i].Mod1ID $ ", Mod2ID: " $ Character.Weapons[i].Mod2ID, Outer);
        }
        log(Self.Name, "--- Powers (Count: " $ Character.PowerCount $ ") ---", Outer);
        for (i = 0; i < Character.PowerCount; i++)
        {
            log(Self.Name, "  Power " $ i $ " - ID: " $ Character.Powers[i].PowerID $ ", Rank: " $ Character.Powers[i].Rank, Outer);
            log(Self.Name, "    Evo0: " $ Character.Powers[i].Evo0 $ ", Evo1: " $ Character.Powers[i].Evo1 $ ", Evo2: " $ Character.Powers[i].Evo2, Outer);
        }
        if (Character.bHasBorrowedPower)
        {
            log(Self.Name, "--- Borrowed Power ---", Outer);
            log(Self.Name, "  PowerID: " $ Character.BorrowedPower.PowerID $ ", Rank: " $ Character.BorrowedPower.Rank, Outer);
            log(Self.Name, "  Evo0: " $ Character.BorrowedPower.Evo0 $ ", Evo1: " $ Character.BorrowedPower.Evo1 $ ", Evo2: " $ Character.BorrowedPower.Evo2, Outer);
        }
        log(Self.Name, "--- Inventory ---", Outer);
        log(Self.Name, "  ArmorConsumable: " $ Character.Inventory.ArmorConsumableID, Outer);
        log(Self.Name, "  WeaponConsumable: " $ Character.Inventory.WeaponConsumableID, Outer);
        log(Self.Name, "  AmmoConsumable: " $ Character.Inventory.AmmoConsumableID, Outer);
        log(Self.Name, "  GearConsumable: " $ Character.Inventory.GearConsumableID, Outer);
        log(Self.Name, "=== End Character Info ===", Outer);
        // Spectre Loading Methods
        loadAppearance(Character, Outer);
        LoadWeapons(Character, Outer);
        PowerManager.LoadPowers(Character, Outer);
        LoadConsumables(Character, Outer);
    }
}
public function loadAppearance(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local array<string> archetypeTokens;
    local string appearanceArchetype;
    local string PawnArchetype;
    local EAsyncLoadType LoadType;
    
    //If there's no appareance ID then there's no need to load the appearance class;
    if (Character.AppearanceCharID == "")
    {
        return;
    }
    Class'SFSArrayUtility'.static.SplitStringIntoParts(Character.AppearanceCharID, ".", archetypeTokens);
    if (archetypeTokens.Length > 0)
    {
        appearanceArchetype = archetypeTokens[archetypeTokens.Length - 1];
        PawnArchetype = string(SFXPawn_PlayerMP(Pawn).ObjectArchetype.Name);
        log(Self.Name, "appearanceArchetype: " $ appearanceArchetype, Outer);
        log(Self.Name, "PawnArchetype: " $ PawnArchetype, Outer);
        if (PawnArchetype != appearanceArchetype)
        {
            switch (Character.AppearancePawnType)
            {
                case "PlayerMP":
                    LoadType = EAsyncLoadType.ALT_PlayerMP;
                    break;
                case "Henchman":
                    LoadType = EAsyncLoadType.ALT_Henchman;
                    break;
                case "Pawn":
                    LoadType = EAsyncLoadType.ALT_Pawn;
                    break;
                default:
            }
            log(Self.Name, "Attempting to load appearance: " $ Character.AppearanceCharID $ " with load type " $ LoadType, Outer);
            asyncLoader.LoadAppearanceAsync(Character.AppearanceCharID, Character.bUseHelmet, Character.bUseHeadgear, LoadType, onAppearanceLoaded);
        }
    }
    else
    {
        log(Self.Name, "Could not parse Character.AppearanceCharID. Won't apply custom appearance", Outer);
    }
}
public function onAppearanceLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPawn appearancePawn;
    local Vector appearanceCharLocation;
    
    appearanceCharLocation = Owner.location;
    appearanceCharLocation.Z *= 100.0;
    switch (load.LoadType)
    {
        case EAsyncLoadType.ALT_PlayerMP:
            log(Self.Name, "Spawning: " $ load.LoadedPlayerMP.Class $ " - " $ load.LoadedPlayerMP, Outer);
            appearancePawn = Outer.Spawn(load.LoadedPlayerMP.Class, , , appearanceCharLocation, , load.LoadedPlayerMP, TRUE);
            break;
        case EAsyncLoadType.ALT_Pawn:
            log(Self.Name, "Spawning: " $ load.LoadedPawn.Class $ " - " $ load.LoadedPawn, Outer);
            appearancePawn = Outer.Spawn(load.LoadedPawn.Class, , , appearanceCharLocation, , load.LoadedPawn, TRUE);
            break;
        case EAsyncLoadType.ALT_Henchman:
            log(Self.Name, "Spawning: " $ load.LoadedHenchman.Class $ " - " $ load.LoadedHenchman, Outer);
            appearancePawn = Outer.Spawn(load.LoadedHenchman.Class, , , appearanceCharLocation, , load.LoadedHenchman, TRUE);
            break;
        default:
    }
    appearanceManager.CopyAppearanceWithVisuals(appearancePawn, Owner, load.bUsesHeadgear, load.bUsesHelmet);
    appearancePawn.Destroy();
}
public function LoadConsumables(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    if (ConsumableManager == None)
    {
        log(Self.Name, "Error: ConsumableManager is None, cannot load consumables", Outer);
        return;
    }
    ConsumableManager.ApplyConsumables(Character, Pawn);
}
public function LoadWeapons(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local int i;
    local array<string> pathTokens;
    local string WeaponClassName;
    local SFXWeapon existingWeapon;
    local bool bAlreadyHasWeapon;
    
    if (weaponManager == None || asyncLoader == None)
    {
        log(Self.Name, "Error: weaponManager or asyncLoader is None, cannot load weapons", Outer);
        return;
    }
    RemoveWeaponsNotInCharacter(Character, Pawn);
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
        weaponManager.loadAndGiveWeaponAsync(Character.Weapons[i].WeaponID, Character.Weapons[i].Mod1ID, Character.Weapons[i].Mod2ID, Character.Weapons[i].FireMode);
    }
}
private final function RemoveWeaponsNotInCharacter(SFSCharacterModelStruct Character, SFXPawn Pawn)
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

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}