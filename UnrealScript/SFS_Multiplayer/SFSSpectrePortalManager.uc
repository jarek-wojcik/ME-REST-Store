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
var SFSCharacterModelStruct ActiveCharacter;
var bool bPausedWaveTimer;
var bool bPausedFirstWave;

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
        logCharacter(Character);
        ActiveCharacter = Character;
        if (MissionParamsManager != None && MissionParamsManager.WaveCoordinator != None)
        {
            if (MissionParamsManager.WaveCoordinator.IsTimerActive('StartNewWave'))
            {
                MissionParamsManager.WaveCoordinator.ClearTimer('StartNewWave');
                bPausedFirstWave = TRUE;
                bPausedWaveTimer = TRUE;
                log(Self.Name, "Paused StartNewWave timer until character load completes", Outer);
            }
            else if (MissionParamsManager.WaveCoordinator.IsTimerActive('AdvanceToNextWave'))
            {
                MissionParamsManager.WaveCoordinator.ClearTimer('AdvanceToNextWave');
                bPausedFirstWave = FALSE;
                bPausedWaveTimer = TRUE;
                log(Self.Name, "Paused AdvanceToNextWave timer until character load completes", Outer);
            }
        }
        //Appearance Manager generates the first event in the chain.
        appearanceManager.loadAppearance(Character, Outer);
    }
}
function HandleEvent(SFSEvent E)
{
    local SFSEvent ActiveCharLoadedEvent;
    
    switch (E.sValue)
    {
        case Class'SFSGenericEventConstants'.default.AppearanceLoaded_Event:
            log(Self.Name, "Appearance Loaded", Outer);
            weaponManager.LoadWeapons(ActiveCharacter, Outer);
            MissionParamsManager.ApplyMissionSettings();
            break;
        case Class'SFSGenericEventConstants'.default.WeaponsLoaded_Event:
            log(Self.Name, "Weapons Loaded", Outer);
            PowerManager.LoadPowers(ActiveCharacter, Outer);
            weaponManager.RemoveWeaponsNotInCharacter(ActiveCharacter, Outer);
            break;
        case Class'SFSGenericEventConstants'.default.PowersLoaded_Event:
            log(Self.Name, "Powers Loaded", Outer);
            ConsumableManager.ApplyConsumables(ActiveCharacter, Outer);
            PowerManager.AddPowerSockets(Outer);
            break;
        case Class'SFSGenericEventConstants'.default.ConsumablesLoaded_Event:
            log(Self.Name, "Consumables Loaded", Outer);
            CustomActionsManager.MigrateCustomActions(ActiveCharacter, Outer);
            break;
        case Class'SFSGenericEventConstants'.default.CustomActionsMigrated_Event:
            log(Self.Name, "Custom Actions Migrated - Full Character Loaded", Outer);
            if (bPausedWaveTimer && MissionParamsManager != None && MissionParamsManager.WaveCoordinator != None)
            {
                if (bPausedFirstWave)
                {
                    MissionParamsManager.WaveCoordinator.SetTimer(0.0100000007, FALSE, 'StartNewWave', );
                    log(Self.Name, "Resumed StartNewWave timer", Outer);
                }
                else
                {
                    MissionParamsManager.WaveCoordinator.SetTimer(0.0100000007, FALSE, 'AdvanceToNextWave', );
                    log(Self.Name, "Resumed AdvanceToNextWave timer", Outer);
                }
                bPausedWaveTimer = FALSE;
            }
            ActiveCharLoadedEvent = new (Outer) Class'SFSEvent';
            ActiveCharLoadedEvent.sValue = Class'SFSGenericEventConstants'.default.ActiveCharacterLoaded_Event;
            AddSFSEvent(ActiveCharLoadedEvent, Outer);
            break;
        default:
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
public final function logCharacter(SFSCharacterModelStruct Character)
{
    local int i;
    
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
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ListenedEventTypes = (SFSEventType.EVT_Generic)
    bDebug = FALSE
}