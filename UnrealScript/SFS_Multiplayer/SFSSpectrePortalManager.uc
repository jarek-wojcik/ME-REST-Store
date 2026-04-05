Class SFSSpectrePortalManager extends SFSManager within SFXPawn;

var SFSSpectreIntegrationService spectreService;
var SFSStrikeTeamIntegrationService strikeTeamService;
var SFSAppearanceManager appearanceManager;
var SFSPortalAsyncLoader asyncLoader;
var SFSWeaponManager weaponManager;

public event simulated function HandlePostAdd()
{
    spectreService = Outer.GetModule(Class'SFSSpectreIntegrationService');
    strikeTeamService = Outer.GetModule(Class'SFSStrikeTeamIntegrationService');
    appearanceManager = Outer.GetModule(Class'SFSAppearanceManager');
    asyncLoader = Outer.GetModule(Class'SFSPortalAsyncLoader');
    weaponManager = Outer.GetModule(Class'SFSWeaponManager');
    if (asyncLoader != None)
    {
        initializeSpectre();
    }
}
public function initializeSpectre()
{
    spectreService.RetrieveActiveCharacter(OnCharacterRetrieved);
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
        // Existing weapon mods match target?
        // Existing powers match target?
        // Existing consumables match target?
    }
}
public function onAppearanceLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPawn appearancePawn;
    
    log(Self.Name, "Spawning: " $ load.LoadedPlayerMP.Class $ " - " $ load.LoadedPlayerMP, Outer);
    appearancePawn = Outer.Spawn(load.LoadedPlayerMP.Class, , , , , load.LoadedPlayerMP, TRUE);
    appearanceManager.CopyAppearanceSelf(appearancePawn, "-1", FALSE);
}
public function loadAppearance(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local array<string> archetypeTokens;
    local string appearanceArchetype;
    local string PawnArchetype;
    
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
            log(Self.Name, "Attempting to load appearance: " $ Character.AppearanceCharID, Outer);
            asyncLoader.LoadAsync(Character.AppearanceCharID, 0, onAppearanceLoaded);
        }
    }
    else
    {
        log(Self.Name, "Could not parse Character.AppearanceCharID. Won't apply custom appearance", Outer);
    }
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
        weaponManager.loadAndGiveWeaponAsync(Character.Weapons[i].WeaponID, Character.Weapons[i].Mod1ID, Character.Weapons[i].Mod2ID);
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