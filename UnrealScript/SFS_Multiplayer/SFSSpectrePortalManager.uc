Class SFSSpectrePortalManager extends SFSManager within SFXPawn;

var SFSSpectreIntegrationService spectreService;
var SFSStrikeTeamIntegrationService strikeTeamService;
var SFSAppearanceManager appearanceManager;
var SFSPortalAsyncLoader asyncLoader;
var SFSWeaponManager weaponManager;
var SFSPowerManager PowerManager;
var SFSConsumableManager ConsumableManager;
var SFSCustomActionsManager CustomActionsManager;
var SFSMissionParamsManager MissionParamsManager;

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
    MissionParamsManager = Outer.GetModule(Class'SFSMissionParamsManager');
    if (asyncLoader != None && !Class'Engine'.static.GetCurrentWorldInfo().bIsLobbyLevel)
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
        log(Self.Name, "Id: " $ Character.Id, Outer);
        log(Self.Name, "SortOrder: " $ Character.SortOrder, Outer);
        log(Self.Name, "TeamId: " $ Character.TeamId, Outer);
        log(Self.Name, "Active: " $ Character.bActive, Outer);
        log(Self.Name, "Name: " $ Character.Name, Outer);
        log(Self.Name, "PreferredSpecies: " $ Character.PreferredSpecies, Outer);
        log(Self.Name, "VoiceCharId: " $ Character.VoiceCharId, Outer);
        log(Self.Name, "CharacterID: " $ Character.CharacterID, Outer);
        log(Self.Name, "AppearanceCharID: " $ Character.AppearanceCharID, Outer);
        log(Self.Name, "AppearancePawnType: " $ Character.AppearancePawnType, Outer);
        log(Self.Name, "UseHelmet: " $ Character.bUseHelmet $ ", UseHeadgear: " $ Character.bUseHeadgear, Outer);
        log(Self.Name, "DodgeCharId: " $ Character.DodgeCharId, Outer);
        log(Self.Name, "HeavyMeleeCharId: " $ Character.HeavyMeleeCharId, Outer);
        log(Self.Name, "LightMeleeCharId: " $ Character.LightMeleeCharId, Outer);
        log(Self.Name, "Level: " $ Character.Level $ ", XP: " $ Character.XP, Outer);
        log(Self.Name, "ShieldType: " $ Character.ShieldType, Outer);
        log(Self.Name, "SkillPoints: " $ Character.SkillPoints, Outer);
        log(Self.Name, "--- Skill Levels ---", Outer);
        log(Self.Name, "  Pistols: " $ Character.SkillLevel_Pistols $ ", SMGs: " $ Character.SkillLevel_SMGs $ ", AssaultRifles: " $ Character.SkillLevel_AssaultRifles, Outer);
        log(Self.Name, "  Shotguns: " $ Character.SkillLevel_Shotguns $ ", SniperRifles: " $ Character.SkillLevel_SniperRifles $ ", MeleeCombat: " $ Character.SkillLevel_MeleeCombat, Outer);
        log(Self.Name, "  Gadgets: " $ Character.SkillLevel_Gadgets $ ", Tech: " $ Character.SkillLevel_Tech $ ", Biotics: " $ Character.SkillLevel_Biotics, Outer);
        log(Self.Name, "  Barrier: " $ Character.SkillLevel_Barrier $ ", Shielding: " $ Character.SkillLevel_Shielding $ ", SpectreTraining: " $ Character.SkillLevel_SpectreTraining, Outer);
        log(Self.Name, "--- Weapons (Count: " $ Character.WeaponCount $ ") ---", Outer);
        for (i = 0; i < Character.WeaponCount; i++)
        {
            log(Self.Name, "  Weapon " $ i $ " - WeaponID: " $ Character.Weapons[i].WeaponID, Outer);
            log(Self.Name, "    Mod1ID: " $ Character.Weapons[i].Mod1ID $ ", Mod2ID: " $ Character.Weapons[i].Mod2ID $ ", FireMode: " $ Character.Weapons[i].FireMode, Outer);
        }
        log(Self.Name, "--- Powers (Count: " $ Character.PowerCount $ ") ---", Outer);
        for (i = 0; i < Character.PowerCount; i++)
        {
            log(Self.Name, "  Power " $ i $ " - ID: " $ Character.Powers[i].PowerID $ ", Rank: " $ Character.Powers[i].Rank $ ", KitID: " $ Character.Powers[i].KitID, Outer);
            log(Self.Name, "    Evo0: " $ Character.Powers[i].Evo0 $ ", Evo1: " $ Character.Powers[i].Evo1 $ ", Evo2: " $ Character.Powers[i].Evo2, Outer);
        }
        if (Character.bHasBorrowedPower)
        {
            log(Self.Name, "--- Borrowed Power ---", Outer);
            log(Self.Name, "  PowerID: " $ Character.BorrowedPower.PowerID $ ", Rank: " $ Character.BorrowedPower.Rank $ ", KitID: " $ Character.BorrowedPower.KitID, Outer);
            log(Self.Name, "  Evo0: " $ Character.BorrowedPower.Evo0 $ ", Evo1: " $ Character.BorrowedPower.Evo1 $ ", Evo2: " $ Character.BorrowedPower.Evo2, Outer);
        }
        log(Self.Name, "--- Inventory ---", Outer);
        log(Self.Name, "  ArmorConsumable: " $ Character.Inventory.ArmorConsumableID, Outer);
        log(Self.Name, "  WeaponConsumable: " $ Character.Inventory.WeaponConsumableID, Outer);
        log(Self.Name, "  AmmoConsumable: " $ Character.Inventory.AmmoConsumableID, Outer);
        log(Self.Name, "  GearConsumable: " $ Character.Inventory.GearConsumableID, Outer);
        log(Self.Name, "=== End Character Info ===", Outer);
        // Spectre Loading Methods
        if (loadAppearance(Character, Outer))
        {
            MissionParamsManager.ApplyMissionSettings();
            LoadWeapons(Character, Outer);
            PowerManager.LoadPowers(Character, Outer);
            LoadConsumables(Character, Outer);
            CustomActionsManager.MigrateCustomActions(Character, Outer);
            RemoveWeaponsNotInCharacter(Character, Outer);
        }
    }
}
public function bool loadAppearance(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local array<string> archetypeTokens;
    local string appearanceArchetype;
    local string PawnArchetype;
    local Name currentKit;
    local EAsyncLoadType LoadType;
    
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
        currentKit = SFXPRIMP(SFXPawn_PlayerMP(Pawn).PlayerReplicationInfo).GetCharacterKit();
        log(Self.Name, "appearanceArchetype: " $ appearanceArchetype, Outer);
        log(Self.Name, "PawnArchetype: " $ PawnArchetype, Outer);
        if (PawnArchetype != appearanceArchetype)
        {
            log(Self.Name, "Current Kit: " $ currentKit $ " voice kit: " $ Character.VoiceKitId, Outer);
            if (string(currentKit) != Character.VoiceKitId)
            {
                loadVoiceKit(Character.VoiceKitId, SFXPawn_PlayerMP(Pawn));
                return FALSE;
            }
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
        return TRUE;
    }
    else
    {
        log(Self.Name, "Could not parse Character.AppearanceCharID. Won't apply custom appearance", Outer);
        return TRUE;
    }
}
public function loadVoiceKit(string VoiceKitId, SFXPawn_PlayerMP Pawn)
{
    local BioPlayerController PC;
    
    log(Self.Name, "Calling Set Kit: ", Outer);
    if (Pawn == None)
    {
        return;
    }
    PC = BioPlayerController(Pawn.Controller);
    if (PC == None || PC.WorldInfo.Game == None)
    {
        return;
    }
    if (SFXPRIMP(PC.PlayerReplicationInfo) != None)
    {
        SFXPRIMP(PC.PlayerReplicationInfo).SetCharacterKit(Name(VoiceKitId));
        SFXPRIMP(PC.PlayerReplicationInfo).SendCharacterDataToServer();
        //Outer.WorldInfo.Game.RestartPlayer(PC);
        RestartPlayerCustom(PC, PC.WorldInfo, PC.WorldInfo.Game);
        Pawn.SetLocation(Pawn.Anchor.location, );
        Pawn.SetRotation(Pawn.Anchor.Rotation);
    }
}
public function RestartPlayerCustom(BioPlayerController NewPlayer, WorldInfo WorldInfo, GameInfo GameInfo)
{
    local Pawn oPawn;
    local NavigationPoint StartSpot;
    local int TeamNum;
    local int idx;
    local array<SequenceObject> Events;
    local SeqEvent_PlayerSpawned SpawnedEvent;
    
    if (WorldInfo.NetMode != ENetMode.NM_DedicatedServer && WorldInfo.NetMode != ENetMode.NM_ListenServer)
    {
        return;
    }
    oPawn = NewPlayer.Pawn;
    oPawn.SetHidden(TRUE);
    NewPlayer.UnPossess();
    oPawn.Destroy();
    TeamNum = NewPlayer.PlayerReplicationInfo == None || NewPlayer.PlayerReplicationInfo.Team == None ? 255 : NewPlayer.PlayerReplicationInfo.Team.TeamIndex;
    if (NewPlayer.Pawn == None)
    {
        NewPlayer.Pawn = GameInfo.SpawnDefaultPawnFor(NewPlayer, StartSpot);
    }
    else
    {
        NewPlayer.Pawn.SetAnchor(StartSpot);
        if (PlayerController(NewPlayer) != None)
        {
            PlayerController(NewPlayer).TimeMargin = -0.100000001;
            StartSpot.AnchoredPawn = None;
        }
        NewPlayer.Pawn.LastStartSpot = PlayerStart(StartSpot);
        NewPlayer.Pawn.LastStartTime = WorldInfo.TimeSeconds;
        NewPlayer.Possess(NewPlayer.Pawn, FALSE);
        NewPlayer.Pawn.PlayTeleportEffect(TRUE, TRUE);
        NewPlayer.ClientSetRotation(NewPlayer.Pawn.Rotation, TRUE);
        SetPlayerDefaults(NewPlayer.Pawn);
    }
}
public function SetPlayerDefaults(Pawn PlayerPawn)
{
    PlayerPawn.AirControl = PlayerPawn.default.AirControl;
    PlayerPawn.GroundSpeed = PlayerPawn.default.GroundSpeed;
    PlayerPawn.WaterSpeed = PlayerPawn.default.WaterSpeed;
    PlayerPawn.AirSpeed = PlayerPawn.default.AirSpeed;
    PlayerPawn.Acceleration = PlayerPawn.default.Acceleration;
    PlayerPawn.AccelRate = PlayerPawn.default.AccelRate;
    PlayerPawn.JumpZ = PlayerPawn.default.JumpZ;
    PlayerPawn.PhysicsVolume.ModifyPlayer(PlayerPawn);
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
        weaponManager.loadAndGiveWeaponAsync(Character.Weapons[i].WeaponID, Character.Weapons[i].Mod1ID, Character.Weapons[i].Mod2ID, Character.Weapons[i].FireMode, Character.Weapons[i].bRemoveScope);
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
private final function ChangeShields(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local SFXShield_Base existingShield;
    local SFXShield_Base newShield;
    local float savedMaxShields;
    local Class<SFXShield_Base> desiredShieldClass;
    
    if (Pawn == None || Pawn.InvManager == None)
    {
        log(Self.Name, "ChangeShields: Pawn or InvManager is None, skipping", Outer);
        return;
    }
    if (Character.ShieldType == "Barrier")
    {
        //desiredShieldClass = Class'SFXShield_Biotic_Player'; //Need to add these two classes to the package.
    }
    else
    {
        //Remove this one classes added.
        desiredShieldClass = None;
        //desiredShieldClass = Class'SFXShield_Energy_Player';
    }
    if (desiredShieldClass == None)
    {
        return;
    }
    log(Self.Name, "ChangeShields: ShieldType=" $ Character.ShieldType $ ", desiredClass=" $ desiredShieldClass.Name, Outer);
    existingShield = SFXShield_Base(Pawn.InvManager.FindInventoryType(Class'SFXShield_Base', TRUE));
    if (existingShield != None)
    {
        if (existingShield.Class == desiredShieldClass)
        {
            log(Self.Name, "ChangeShields: Correct shield already equipped, no change needed", Outer);
            return;
        }
        savedMaxShields = existingShield.GetMaxShields();
        log(Self.Name, "ChangeShields: Removing existing shield " $ existingShield.Class.Name $ ", savedMaxShields=" $ savedMaxShields, Outer);
        Pawn.InvManager.RemoveFromInventory(existingShield);
        existingShield.Destroy();
    }
    else
    {
        log(Self.Name, "ChangeShields: No existing shield found, creating fresh", Outer);
    }
    newShield = SFXShield_Base(Pawn.CreateInventory(desiredShieldClass));
    if (newShield != None)
    {
        if (savedMaxShields > 0.0)
        {
            newShield.InitializeMaxShields(savedMaxShields);
        }
        log(Self.Name, "ChangeShields: New shield created: " $ newShield.Class.Name, Outer);
    }
    else
    {
        log(Self.Name, "ChangeShields: ERROR - Failed to create shield of class " $ desiredShieldClass.Name, Outer);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}