Class SFSSpectrePortalManager extends SFSManager within SFXPawn;

var SFSSpectreIntegrationService spectreService;
var SFSStrikeTeamIntegrationService strikeTeamService;
var SFSAppearanceManager appearanceManager;
var SFSPortalAsyncLoader asyncLoader;

public event simulated function HandlePostAdd()
{
    spectreService = Outer.GetModule(Class'SFSSpectreIntegrationService');
    strikeTeamService = Outer.GetModule(Class'SFSStrikeTeamIntegrationService');
    appearanceManager = Outer.GetModule(Class'SFSAppearanceManager');
    asyncLoader = Outer.GetModule(Class'SFSPortalAsyncLoader');
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
        log(Self.Name, "--- Weapon 1 ---", Outer);
        log(Self.Name, "  WeaponID: " $ Character.Weapon1.WeaponID, Outer);
        log(Self.Name, "  Mod1ID: " $ Character.Weapon1.Mod1ID, Outer);
        log(Self.Name, "  Mod2ID: " $ Character.Weapon1.Mod2ID, Outer);
        if (Character.bHasWeapon2)
        {
            log(Self.Name, "--- Weapon 2 ---", Outer);
            log(Self.Name, "  WeaponID: " $ Character.Weapon2.WeaponID, Outer);
            log(Self.Name, "  Mod1ID: " $ Character.Weapon2.Mod1ID, Outer);
            log(Self.Name, "  Mod2ID: " $ Character.Weapon2.Mod2ID, Outer);
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
        //Checks
        if (!appearanceMatch(Character, Outer))
        {
            log(Self.Name, "Attempting to load appearance: " $ Character.AppearanceCharID, Outer);
            asyncLoader.LoadAsync(Character.AppearanceCharID, 0, onAppearanceLoaded);
        }
        // Existing weapons match target?
        // Existing weapon mods match target?
        // Existing powers match target?
        // Existing consumables match target?
    }
}
public function onAppearanceLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPawn appearancePawn;
    
    appearancePawn = Outer.Spawn(load.LoadedPlayerMP.Class, , , , , load.LoadedPlayerMP, TRUE);
    appearanceManager.CopyAppearanceSelf(appearancePawn, "-1", FALSE);
}
public function bool appearanceMatch(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local array<string> archetypeTokens;
    local string appearanceArchetype;
    local string PawnArchetype;
    
    //If there's no appareance ID then there's no need to load the appearance class;
    if (Character.AppearanceCharID == "")
    {
        return TRUE;
    }
    Class'SFSArrayUtility'.static.SplitStringIntoParts(Character.AppearanceCharID, ".", archetypeTokens);
    if (archetypeTokens.Length > 0)
    {
        appearanceArchetype = archetypeTokens[archetypeTokens.Length - 1];
        PawnArchetype = string(SFXPawn_PlayerMP(Pawn).ObjectArchetype.Name);
        log(Self.Name, "appearanceArchetype: " $ appearanceArchetype, Outer);
        log(Self.Name, "PawnArchetype: " $ PawnArchetype, Outer);
        if (PawnArchetype == appearanceArchetype)
        {
            return TRUE;
        }
    }
    else
    {
        log(Self.Name, "Could not parse Character.AppearanceCharID. Won't apply custom appearance", Outer);
        return TRUE;
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}