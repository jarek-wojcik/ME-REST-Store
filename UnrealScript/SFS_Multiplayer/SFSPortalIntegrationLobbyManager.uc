Class SFSPortalIntegrationLobbyManager extends SFSManager within SFXPawn;

var SFSSpectreIntegrationService spectreService;
var SFSAppearanceManager appearanceManager;
var SFSPortalAsyncLoader asyncLoader;
var SFSCharacterModelStruct PendingCharacter;

public event simulated function HandlePostAdd()
{
    spectreService = Outer.GetModule(Class'SFSSpectreIntegrationService');
    appearanceManager = Outer.GetModule(Class'SFSAppearanceManager');
    asyncLoader = Outer.GetModule(Class'SFSPortalAsyncLoader');
    default.bDebug = TRUE;
    if (spectreService == None || asyncLoader == None)
    {
        log(Self.Name, "Missing required modules ? lobby portal integration will not run", Outer);
        return;
    }
    if (Class'Engine'.static.GetCurrentWorldInfo().bIsLobbyLevel)
    {
        spectreService.RetrieveActiveCharacter(OnCharacterRetrieved);
    }
}
function OnCharacterRetrieved(SFSCharacterModelStruct Character, bool bSuccess)
{
    if (!bSuccess)
    {
        log(Self.Name, "Failed to retrieve active character", Outer);
        return;
    }
    if (Character.VoiceCharId == "")
    {
        log(Self.Name, "No VoiceCharId set ? skipping lobby portal integration", Outer);
        return;
    }
    log(Self.Name, "Preparing lobby kit override: VoiceCharId=" $ Character.VoiceCharId $ " VoiceKitId=" $ Character.VoiceKitId, Outer);
    PendingCharacter = Character;
    asyncLoader.LoadAsync(Character.VoiceCharId, 0, OnVoiceKitLoaded);
}
function OnVoiceKitLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPlayerControllerMP PC;
    local SFXPRIMP PRI;
    local EAsyncLoadType AppLoadType;
    
    PC = SFXPlayerControllerMP(Outer.Controller);
    if (PC == None || PC.LobbyFlow == None)
    {
        log(Self.Name, "No valid PC or LobbyFlow ? aborting lobby kit override", Outer);
        return;
    }
    // 1. Replace the DummyPawn with the correct voice kit pawn.
    log(Self.Name, "Spawning DummyPawn for voice kit: " $ PendingCharacter.VoiceCharId, Outer);
    PC.LobbyFlow.SpawnDummyPawn(PendingCharacter.VoiceCharId);
    // 2. Update the PRI so the server knows which kit to spawn in-match.
    //    SetCharacterData updates the replicated CharacterData struct; SendCharacterDataToServer
    //    replicates it to the server via RPCs. Neither call touches the MP save file.
    PRI = SFXPRIMP(PC.PlayerReplicationInfo);
    if (PRI != None && PendingCharacter.VoiceKitId != "")
    {
        log(Self.Name, "Updating PRI kit to: " $ PendingCharacter.VoiceKitId, Outer);
        PRI.SetCharacterData(PendingCharacter.Name, Name(PendingCharacter.VoiceKitId), stringref(0), 20, 999.0, 0);
        PRI.SendCharacterDataToServer();
    }
    // 3. If an appearance override is set and differs from the voice kit, apply it over the DummyPawn.
    if (PendingCharacter.AppearanceCharID == "" || PendingCharacter.AppearanceCharID == PendingCharacter.VoiceCharId)
    {
        log(Self.Name, "No appearance override needed", Outer);
        return;
    }
    switch (PendingCharacter.AppearancePawnType)
    {
        case "PlayerMP":
            AppLoadType = EAsyncLoadType.ALT_PlayerMP;
            break;
        case "Henchman":
            AppLoadType = EAsyncLoadType.ALT_Henchman;
            break;
        case "Pawn":
            AppLoadType = EAsyncLoadType.ALT_Pawn;
            break;
        default:
            AppLoadType = EAsyncLoadType.ALT_Henchman;
            break;
    }
    log(Self.Name, "Loading appearance override: " $ PendingCharacter.AppearanceCharID $ " (" $ PendingCharacter.AppearancePawnType $ ")", Outer);
    asyncLoader.LoadAppearanceAsync(PendingCharacter.AppearanceCharID, PendingCharacter.bUseHelmet, PendingCharacter.bUseHeadgear, AppLoadType, onAppearanceLoaded);
}
function onAppearanceLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPlayerControllerMP PC;
    local SFXPawn_PlayerMP DummyPawn;
    local SFXPawn appearancePawn;
    local Vector SpawnLocation;
    
    PC = SFXPlayerControllerMP(Outer.Controller);
    if (PC == None || PC.LobbyFlow == None)
    {
        return;
    }
    DummyPawn = PC.LobbyFlow.DummyPawn;
    if (DummyPawn == None)
    {
        log(Self.Name, "DummyPawn is None ? cannot apply appearance override", Outer);
        return;
    }
    SpawnLocation = DummyPawn.location;
    SpawnLocation.Z *= 100.0;
    switch (load.LoadType)
    {
        case EAsyncLoadType.ALT_PlayerMP:
            log(Self.Name, "Spawning appearance pawn (PlayerMP): " $ load.LoadedPlayerMP, Outer);
            appearancePawn = Outer.Spawn(load.LoadedPlayerMP.Class, , , SpawnLocation, , load.LoadedPlayerMP, TRUE);
            break;
        case EAsyncLoadType.ALT_Pawn:
            log(Self.Name, "Spawning appearance pawn (Pawn): " $ load.LoadedPawn, Outer);
            appearancePawn = Outer.Spawn(load.LoadedPawn.Class, , , SpawnLocation, , load.LoadedPawn, TRUE);
            break;
        case EAsyncLoadType.ALT_Henchman:
            log(Self.Name, "Spawning appearance pawn (Henchman): " $ load.LoadedHenchman, Outer);
            appearancePawn = Outer.Spawn(load.LoadedHenchman.Class, , , SpawnLocation, , load.LoadedHenchman, TRUE);
            break;
        default:
    }
    if (appearancePawn != None)
    {
        appearanceManager.CopyAppearanceWithVisuals(appearancePawn, DummyPawn, load.bUsesHeadgear, load.bUsesHelmet);
        appearancePawn.Destroy();
        log(Self.Name, "Appearance override applied to DummyPawn", Outer);
    }
    else
    {
        log(Self.Name, "Failed to spawn appearance pawn ? override not applied", Outer);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bDebug = FALSE
}