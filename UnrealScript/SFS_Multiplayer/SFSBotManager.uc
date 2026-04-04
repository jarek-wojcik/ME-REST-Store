Class SFSBotManager extends SFSManager within SFXPawn;

struct BotTemplate 
{
    var string Archetype;
    var Name Kit;
    var int Id;
    var bool bCustomLook;
    var bool bFemale;
    var bool bEnemyPawn;
    var botType botType;
    var bool bHasAIController;
    var MPCharacterData MPCharacterData;
};
struct BotAsyncLoad 
{
    var string AiToLoad;
    var string ArchetypeToLoad;
    var SFXPawn_PlayerMP LoadedArchetype;
    var SFXPawn LoadedEnemyArchetype;
    var SFXPawn_Henchman LoadedHenchamnArchetype;
    var EAsyncLoadStatus BotLoadStatus;
    var BotTemplate BotTemplate;
    var int BotIndex;
    var int Team;
    var bool Processed;
    var bool isLoaded;
    var int retries;
};
enum botType
{
    MPKit,
    Enemy,
    Henchman,
    Other,
};

var BioWorldInfo BWI;
var BioPlayerController PC;
var array<SFXPawn> AllBots;
var array<BotAsyncLoad> AsyncAssetLoads;
var SFXGameInfoMP Gimp;
var float CheckDelay;
var SFSBotLoadoutContainer BotLoadoutManager;
var SFSSpawnManager SpawnManager;
var int BotLevel;
var array<string> BotNamesFemale;
var array<string> BotNamesMale;
var array<BotTemplate> BotArchetypes;
var array<MPCharacterData> BotData;
var bool bUseBotData;
var BotTemplate defaultTemplate;
var Name botGroup;
var int maxBots;
var bool limitBotAmount;
var string BotNotFound;
var string BotLimitReached;
var string AutoBotAIControllerName;
var bool bBotDebugLogging;
var LinearColor BotNameColor;
var int henchmenIndexStart;
var int maxRetries;
var bool b_spawnDebugLogging;

public event simulated function HandlePostAdd()
{
    //This essentially works like an initialization method.
    log(Self.Name, "Added SFSBotManager to " $ Outer, Outer);
    BWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    Gimp = SFXGameInfoMP(Class'Engine'.static.GetCurrentWorldInfo().Game);
    BotLoadoutManager = new (Self) Class'SFSBotLoadoutContainer';
    SpawnManager = new (Self) Class'SFSSpawnManager';
}
public function HandleEvent(SFSEvent E)
{
    local int iBotId;
    
    iBotId = int(E.botId);
    switch (E.eType)
    {
        case SFSEventType.EVT_AddBot:
            log(Self.Name, "Adding bot : " $ E.botId, Outer);
            SpawnBot(iBotId, 0);
            break;
        case SFSEventType.EVT_AddEnemy:
            log(Self.Name, "Adding enemy : " $ E.botId, Outer);
            SpawnBot(iBotId, 1);
            break;
        case SFSEventType.EVT_BotDied:
            //Bots are immortal now
            //respawnBot(E.eventSource, iBotId);
            break;
        case SFSEventType.EVT_ListBots:
            listBots();
            break;
        case SFSEventType.EVT_RemoveBot:
            RemoveBot(int(E.botId));
            break;
        case SFSEventType.EVT_ListBotTypes:
            listBotArchetypes();
            break;
        case SFSEventType.EVT_RemoveBotLimit:
            removeBotLimit();
            break;
        case SFSEventType.EVT_DebugBotAI:
            toggleDebugLogging();
            break;
        default:
    }
}
public final event function SpawnBot(int BotIndex, int Team, optional bool overrideBotLimit = FALSE)
{
    local BotTemplate BotTemplate;
    
    BotTemplate = getBotArchetype(BotIndex);
    if (BotTemplate.Archetype == "")
    {
        log(Self.Name, BotNotFound $ BotIndex, Outer);
        getConsole().OutputText(BotNotFound $ BotIndex);
        return;
    }
    if (!overrideBotLimit && AllBots.Length >= maxBots && limitBotAmount)
    {
        log(Self.Name, BotLimitReached $ BotTemplate.Archetype, Outer);
        getConsole().OutputText(BotLimitReached $ BotTemplate.Archetype);
        return;
    }
    log(Self.Name, "Beginning async bot load", Outer);
    // Branch based on whether this is an enemy pawn or player pawn
    AsyncAssetLoads.AddItem(initiateAsyncLoad(BotTemplate, BotIndex, Team));
    // Use appropriate timer based on pawn type
    Outer.SetTimer(CheckDelay, TRUE, 'CheckAndSpawnAsyncLoad', Self);
    BWI.SetAutoBotsEnabled(FALSE);
}
public function CheckAndSpawnAsyncLoad()
{
    local BotAsyncLoad botLoad;
    local SFXAI_Core botAI;
    local SFXPawn BotPawn;
    local int botLoadIndex;
    local SFSEvent Event;
    
    log(Self.Name, "CheckAndSpawnAsyncLoad", Outer);
    //"We only process one item from this list at a time, staggering the bot spawns checkDelay amount apart.";
    if (AsyncAssetLoads.Length == 0)
    {
        Outer.ClearTimer('CheckAndSpawnAsyncLoad', Self);
        return;
    }
    foreach AsyncAssetLoads(botLoad, botLoadIndex)
    {
        botLoad = CheckLoaded(botLoad, botLoadIndex);
        if (botLoad.isLoaded && !botLoad.Processed)
        {
            if (!botLoad.Processed)
            {
                BotPawn = getBotPawn(botLoad);
                botAI = getAIController(botLoad, BotPawn);
                if (botAI == None)
                {
                    log(Self.Name, "Could Not create AI: " $ botLoad.AiToLoad, Outer);
                    continue;
                }
                if (BotPawn == None)
                {
                    log(Self.Name, "Could Not create Pawn: " $ botLoad.ArchetypeToLoad, Outer);
                    continue;
                }
                ConfigureBot(BotPawn, botAI, Outer, botLoad.BotTemplate, botLoad.BotIndex, botLoad.Team);
                AllBots.AddItem(BotPawn);
                AsyncAssetLoads.Remove(botLoadIndex, 1);
                if (SFXPawn_Henchman(BotPawn) != None && BioPlayerController(Outer.Controller).GameModeManager2 != None)
                {
                    //This is for testing vocalisations on the bot.
                    //log(Self.Name, "PC.GameModeManager2: " $ BioPlayerController(Outer.Controller).GameModeManager2, Outer);
                    //log(Self.Name, "PC.GameModeManager2.ShouldPlayVocalizations: " $ BioPlayerController(Outer.Controller).GameModeManager2.ShouldPlayVocalizations(), Outer);
                    //SFXGRI(BWI.GRI).TriggerVocalizationEvent(5, BotPawn, Outer, , , TRUE);
                }
                Event = new (Outer) Class'SFSEvent';
                Event.eType = SFSEventType.EVT_BotSpawned;
                Event.mInstigator = BotPawn;
                Event.botId = botLoad.BotIndex $ "";
                Class'SFSCore'.static.AddSFSEvent(Event, Outer);
            }
        }
    }
}
public function BotAsyncLoad CheckLoaded(BotAsyncLoad BotAsyncLoad, int botLoadIndex)
{
    BotAsyncLoad.isLoaded = BotAsyncLoad.BotLoadStatus == EAsyncLoadStatus.ASYNC_LOAD_COMPLETE;
    if (!BotAsyncLoad.isLoaded)
    {
        switch (BotAsyncLoad.BotTemplate.botType)
        {
            case botType.MPKit:
                BotAsyncLoad.LoadedArchetype = SFXPawn_PlayerMP(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(BotAsyncLoad.ArchetypeToLoad, Class'SFXPawn_PlayerMP', BotAsyncLoad.BotLoadStatus));
                BotAsyncLoad.isLoaded = BotAsyncLoad.BotLoadStatus == EAsyncLoadStatus.ASYNC_LOAD_COMPLETE;
                break;
            case botType.Henchman:
                BotAsyncLoad.LoadedHenchamnArchetype = SFXPawn_Henchman(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(BotAsyncLoad.ArchetypeToLoad, Class'SFXPawn_Henchman', BotAsyncLoad.BotLoadStatus));
                BotAsyncLoad.isLoaded = BotAsyncLoad.BotLoadStatus == EAsyncLoadStatus.ASYNC_LOAD_COMPLETE;
                break;
            case botType.Enemy:
                BotAsyncLoad.LoadedEnemyArchetype = SFXPawn(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(BotAsyncLoad.ArchetypeToLoad, Class'SFXPawn', BotAsyncLoad.BotLoadStatus));
                BotAsyncLoad.isLoaded = BotAsyncLoad.BotLoadStatus == EAsyncLoadStatus.ASYNC_LOAD_COMPLETE;
                break;
            default:
        }
    }
    log(Self.Name, "CheckLoaded", Outer);
    if (b_spawnDebugLogging)
    {
        log(Self.Name, getDebugMessage(BotAsyncLoad), Outer);
    }
    AsyncAssetLoads[botLoadIndex].retries = AsyncAssetLoads[botLoadIndex].retries + 1;
    if (AsyncAssetLoads[botLoadIndex].retries >= maxRetries)
    {
        log(Self.Name, "BotAsyncLoad " $ botLoadIndex $ " has reached maximum retries", Outer);
        AsyncAssetLoads.Remove(botLoadIndex, 1);
    }
    return BotAsyncLoad;
}
public function BotAsyncLoad initiateAsyncLoad(BotTemplate BotTemplate, int BotIndex, int Team)
{
    local BotAsyncLoad AsyncAssetLoad;
    
    AsyncAssetLoad.Processed = FALSE;
    AsyncAssetLoad.BotIndex = BotIndex;
    AsyncAssetLoad.Team = Team;
    AsyncAssetLoad.BotTemplate = BotTemplate;
    AsyncAssetLoad.ArchetypeToLoad = BotTemplate.Archetype;
    AsyncAssetLoad.retries = 0;
    switch (BotTemplate.botType)
    {
        case botType.MPKit:
            AsyncAssetLoad.LoadedArchetype = SFXPawn_PlayerMP(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncAssetLoad.ArchetypeToLoad, Class'SFXPawn_PlayerMP', AsyncAssetLoad.BotLoadStatus));
            break;
        case botType.Henchman:
            AsyncAssetLoad.LoadedHenchamnArchetype = SFXPawn_Henchman(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncAssetLoad.ArchetypeToLoad, Class'SFXPawn_Henchman', AsyncAssetLoad.BotLoadStatus));
            break;
        case botType.Enemy:
            AsyncAssetLoad.LoadedEnemyArchetype = SFXPawn(Class'SFXEngine'.static.LoadSeekFreeObjectAsync(AsyncAssetLoad.ArchetypeToLoad, Class'SFXPawn', AsyncAssetLoad.BotLoadStatus));
            break;
        default:
    }
    return AsyncAssetLoad;
}
public function SFXAI_Core getAIController(BotAsyncLoad BotAsyncLoad, SFXPawn EnemyPawn)
{
    local SFXAI_Core AI;
    local Class<AIController> AIControllerClass;
    
    switch (BotAsyncLoad.BotTemplate.botType)
    {
        case botType.MPKit:
            log(Self.Name, "getAIController", Outer);
            AI = SFXAI_Core(Gimp.Spawn(Class'SFXAI_Bot', , , PC.location, PC.Rotation));
            log(Self.Name, "getAIController - AI Spawned!", Outer);
            if (SFXAI_Bot(AI) != None)
            {
                SFXAI_Bot(AI).PlayerPawn = Outer;
                SFXAI_Bot(AI).botId = BotAsyncLoad.BotIndex;
            }
            break;
        case botType.Henchman:
            log(Self.Name, "getAIController", Outer);
            AI = SFXAI_Core(Gimp.Spawn(Class'SFXAI_Bot', , , PC.location, PC.Rotation));
            log(Self.Name, "getAIController - AI Spawned!", Outer);
            if (SFXAI_Bot(AI) != None)
            {
                SFXAI_Bot(AI).PlayerPawn = Outer;
                SFXAI_Bot(AI).botId = BotAsyncLoad.BotIndex;
            }
            break;
        case botType.Enemy:
            log(Self.Name, "getEnemyAIController", Outer);
            if (EnemyPawn == None)
            {
                log(Self.Name, "getEnemyAIController - EnemyPawn is None!", Outer);
                return None;
            }
            // If the pawn has its own AI controller, use that instead
            if (BotAsyncLoad.BotTemplate.bHasAIController)
            {
                AIControllerClass = EnemyPawn.default.ControllerClass;
                log(Self.Name, "getEnemyAIController - Using pawn's default ControllerClass: " $ AIControllerClass, Outer);
                if (AIControllerClass != None)
                {
                    AI = SFXAI_Core(Gimp.Spawn(AIControllerClass, , , PC.location, PC.Rotation));
                }
            }
            //Return none if couldn't spawn from pawn's controller class
            if (AI == None)
            {
                log(Self.Name, "could not spawn the default controller- aborting spawning the bot", Outer);
                return None;
            }
            break;
        default:
    }
    log(Self.Name, "Get AI Controller - AI: " $ AI $ " Class: " $ AI.Class, Outer);
    return AI;
}
public function SFXPawn getBotPawn(BotAsyncLoad BotAsyncLoad)
{
    local SFXPawn_PlayerMP PlayerArchetype;
    local SFXPawn_PlayerMP AIPawn;
    local SFXPawn_Henchman HenchmanPawn;
    local SFXPawn AIPawnNonMP;
    local Actor EnemyArchetype;
    local SFXPawn Output;
    
    switch (BotAsyncLoad.BotTemplate.botType)
    {
        case botType.MPKit:
            PlayerArchetype = BotAsyncLoad.LoadedArchetype;
            PlayerArchetype.CustomizationMP = None;
            AIPawn = Gimp.Spawn(PlayerArchetype.Class, , , , , PlayerArchetype, TRUE);
            AIPawn.Kit = BotAsyncLoad.BotTemplate.Kit;
            Output = AIPawn;
            log(Self.Name, "getBotPawn AIPawn: " $ AIPawn.Class $ " Archetype: " $ PlayerArchetype.Class, Outer);
            break;
        case botType.Henchman:
            HenchmanPawn = Gimp.Spawn(BotAsyncLoad.LoadedHenchamnArchetype.Class, , , , , BotAsyncLoad.LoadedHenchamnArchetype, TRUE);
            Output = HenchmanPawn;
            log(Self.Name, "getBotPawn HenchmanPawn: " $ BotAsyncLoad.LoadedHenchamnArchetype.Class, Outer);
            break;
        case botType.Enemy:
            EnemyArchetype = BotAsyncLoad.LoadedEnemyArchetype;
            if (EnemyArchetype == None)
            {
                log(Self.Name, "getEnemyBotPawn - EnemyArchetype is None!", Outer);
                return None;
            }
            // Spawn the enemy pawn using its class and archetype
            Output = Gimp.Spawn(Class<SFXPawn>(EnemyArchetype.Class), , , , , EnemyArchetype, TRUE);
            log(Self.Name, "getEnemyBotPawn EnemyPawn: " $ Output $ " Class: " $ Output.Class $ " Archetype: " $ EnemyArchetype.Class, Outer);
            break;
        default:
    }
    return Output;
}
public function ConfigureBot(SFXPawn AIPawn, SFXAI_Core AI, SFXPawn PlayerPawn, BotTemplate BotTemplate, int BotIndex, int Team)
{
    log(Self.Name, "ConfigureBot with team " $ Team, Outer);
    AssignBotName(AI, BotTemplate);
    AssignBotTeam(AI, AIPawn, PlayerPawn, Team);
    if (Team == 0)
    {
        ModifyBasicVariables(AIPawn, AI, BotTemplate, BotIndex);
    }
    if (SFXPawn_PlayerMP(AIPawn) != None)
    {
        ModifyImpactSounds(SFXPawn_PlayerMP(AIPawn));
        ModifyBotPowers(SFXPawn_PlayerMP(AIPawn), default.BotLevel);
        //ModifyBotLoadout(SFXPawn_PlayerMP(AIPawn));
        ModifyBotWeapons(AIPawn);
        ModifyDamageModule(SFXPawn_PlayerMP(AIPawn));
        //Class'BotHudManager'.static.AddBotHudImage(SFXPawn_PlayerMP(AIPawn));
        //This removes melee and sync kills from list of actions the bots can experience.
        AIPawn.SupportedSyncActions.Remove(0, AIPawn.SupportedSyncActions.Length);
        //Class'OutspectresGameEffectsManagerMP'.static.ApplyBotEffects(AIPawn);
    }
    if (SFXPawn_Henchman(AIPawn) != None)
    {
        generateHenchmanWeapons(SFXPawn_Henchman(AIPawn));
        AutoLevelUpHenchman(SFXPawn_Henchman(AIPawn), 40);
    }
    SetLocation(PlayerPawn, AIPawn, AI);
}
public final function removeBotLimit()
{
    limitBotAmount = FALSE;
}
public final function listBots()
{
    local Console Console;
    local SFXPawn Bot;
    
    Console = getConsole();
    foreach AllBots(Bot, )
    {
        Console.OutputText("Bot ID: " $ Bot.Controller.PlayerReplicationInfo.PlayerID $ " Name: " $ Bot.Name);
    }
}
public final function toggleDebugLogging()
{
    local SFXPawn Bot;
    local SFXAI_Bot botAI;
    
    foreach AllBots(Bot, )
    {
        botAI = SFXAI_Bot(Bot.Controller);
        if (botAI == None)
        {
            continue;
        }
        if (bBotDebugLogging)
        {
            botAI.bDebugLoggingEnabled = FALSE;
            botAI.StopDebugLogging();
            bBotDebugLogging = FALSE;
        }
        else
        {
            botAI.bDebugLoggingEnabled = TRUE;
            botAI.StartDebugLogging();
            bBotDebugLogging = TRUE;
        }
    }
}
public final function listBotArchetypes()
{
    local Console Console;
    local BotTemplate BotTemplate;
    local int Index;
    
    Index = 0;
    Console = getConsole();
    foreach BotArchetypes(BotTemplate, )
    {
        Console.OutputText(Index $ " | Kit Name: " $ BotTemplate.Kit);
        Index++;
    }
}
public final function RemoveAllBots()
{
    local SFXPawn Bot;
    
    foreach AllBots(Bot, )
    {
        RemoveBot(Bot.Controller.PlayerReplicationInfo.PlayerID);
    }
}
public final function RemoveBot(int Id)
{
    local SFXPawn Bot;
    
    foreach AllBots(Bot, )
    {
        log(Self.Name, "Bot: " $ Bot $ " Controlled by: " $ Bot.Controller $ " with ID: " $ Bot.Controller.PlayerReplicationInfo.PlayerID, Outer);
        if (Bot.Controller.PlayerReplicationInfo.PlayerID == Id)
        {
            log(Self.Name, "Removing Bot: " $ Bot $ " Controlled by: " $ Bot.Controller $ " with ID: " $ Bot.Controller.PlayerReplicationInfo.PlayerID, Outer);
            AllBots.RemoveItem(Bot);
            Bot.Controller.Destroy();
            Bot.Destroy();
            break;
        }
    }
}
public final function KillBot(int Id)
{
    local SFXEngine Engine;
    local BioWorldInfo World;
    local SFXPawn Bot;
    
    log(Self.Name, "Attempting to kill bot at id: " $ Id, Outer);
    foreach AllBots(Bot, )
    {
        if (Bot.Controller.PlayerReplicationInfo.PlayerID == Id)
        {
            log(Self.Name, "Killing Bot: " $ Bot $ " Controlled by: " $ Bot.Controller $ " with ID: " $ Bot.Controller.PlayerReplicationInfo.PlayerID, Outer);
            Bot.bIsDowned = TRUE;
            Bot.GotoState('Downed', , , );
            break;
        }
    }
}
public function BotTemplate getBotArchetype(int BotIndex)
{
    local BotTemplate Result;
    local int femaleMale;
    local array<BotTemplate> archetypeList;
    local int ArchetypeIndex;
    
    log(Self.Name, "getBotArchetype", Outer);
    if (BotIndex < 0)
    {
        ArchetypeIndex = Rand(default.BotArchetypes.Length);
        log(Self.Name, "OutspectresBotManagerAsync: Fetching Random Bot Archetype ID-" $ ArchetypeIndex, Outer);
        Result = BotArchetypes[ArchetypeIndex];
    }
    else if (BotIndex <= default.BotArchetypes.Length - 1)
    {
        log(Self.Name, "OutspectresBotManagerAsync: Fetching Bot Archetype ID- " $ BotIndex, Outer);
        Result = BotArchetypes[BotIndex];
    }
    log(Self.Name, "OutspectresBotManagerAsync: BotArchetype fetched: " $ Result.Archetype, Outer);
    return Result;
}
public function AssignBotName(SFXAI_Core AI, BotTemplate BotTemplate)
{
    local string PlayerName;
    local array<string> NameList;
    local SFXPawn existingBot;
    local int i;
    
    log(Self.Name, "AssignBotName", Outer);
    if (BotTemplate.bFemale)
    {
        NameList = default.BotNamesFemale;
    }
    else
    {
        NameList = default.BotNamesMale;
    }
    //"Try to find an unassigned name 10 times.";
    for (i = 0; i < 10; i++)
    {
        PlayerName = NameList[Rand(NameList.Length)];
        if (!NameTaken(PlayerName))
        {
            break;
        }
    }
    AI.PlayerReplicationInfo.SetPlayerName(PlayerName);
}
public final function bool NameTaken(string BotName)
{
    local SFXPawn existingBot;
    local array<SFXPawn> Bots;
    
    log(Self.Name, "NameTaken", Outer);
    foreach AllBots(existingBot, )
    {
        if (existingBot.Controller.PlayerReplicationInfo.PlayerName == BotName)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function AssignBotTeam(SFXAI_Core AI, SFXPawn AIPawn, SFXPawn PlayerPawn, int Team)
{
    local BioBaseSquad PlayerSquad;
    local SFXSquadCombatMP EnemySquad;
    local SFXWave_Horde ActiveHordeWave;
    
    log(Self.Name, "AssignBotTeam " $ Team, Outer);
    if (Team == 0)
    {
        log(Self.Name, "AssignBotTeam", Outer);
        AIPawn.PlayerReplicationInfo.bBot = TRUE;
        AIPawn.PlayerReplicationInfo.Group = default.botGroup;
        PlayerSquad = PlayerPawn.Squad;
        PlayerSquad.AddMember(AIPawn, FALSE);
    }
    else
    {
        ActiveHordeWave = SFXWave_Horde(SFXGRI(Outer.WorldInfo.GRI).WaveCoordinator.GetWaveOfType('SFXWave_Horde'));
        log(Self.Name, "ActiveHordeWave: " $ ActiveHordeWave.Name, Outer);
        EnemySquad = SFXSquadCombatMP(ActiveHordeWave.EnemySquad);
        log(Self.Name, "EnemySquad: " $ EnemySquad.Name, Outer);
        if (EnemySquad != None)
        {
            log(Self.Name, "Adding Enemy to squad", Outer);
            EnemySquad.AddMember(AIPawn, TRUE);
        }
        AIPawn.bDisableVocEvents = TRUE;
    }
    AI.SetTeam(Team);
}
public function ModifyBasicVariables(SFXPawn AIPawn, SFXAI_Core AI, BotTemplate BotTemplate, int BotIndex)
{
    local SFXPawn_PlayerMP AIPawnMP;
    local SFXModule UseModule;
    local SFSBotUseModule botUseModule;
    
    log(Self.Name, "ModifyBasicVariables", Outer);
    AI.Possess(AIPawn, FALSE);
    if (SFXAI_Bot(AI) != None)
    {
        SFXAI_Bot(AI).StartDebugLogging();
    }
    AI.bGodMode = TRUE;
    AIPawn.m_bMin1Health = TRUE;
    AIPawn.m_fPowerUsePercent = 1.0;
    AIPawn.bReplicateHealthToAll = TRUE;
    AIPawn.bPreventPermanentDeath = FALSE;
    AIPawn.bDisableVocEvents = FALSE;
    AIPawn.bCanBeEaten = FALSE;
    AI.PlayerReplicationInfo.bBot = TRUE;
    AI.PlayerReplicationInfo.Group = default.botGroup;
    AI.PlayerReplicationInfo.PlayerID = getBotId();
    AI.PlayerReplicationInfo.OldName = "" $ BotIndex;
    if (SFXPawn_PlayerMP(AIPawn) != None)
    {
        AIPawnMP = SFXPawn_PlayerMP(AIPawn);
        AIPawnMP.ReviveSound = None;
        AIPawnMP.bValidExecutionTarget = FALSE;
        AIPawnMP.fPermaDeathTimer = 100000.0;
        AIPawnMP.RegularNametagColor = default.BotNameColor;
        AIPawnMP.fPostResInvulnerability = 10.0;
        AIPawnMP.fReviveRange = -1.0;
        AIPawnMP.fTimeToRevive = 1000000.0;
        AIPawnMP.MeleedVoc = None;
        // "This should prevent the bots from being sync killed";
        // Class'ArrayUtilsMP'.static.clearNameArray(AIPawnMP.SupportedSyncActions);
    }
    if (SFXPawn_PlayerMP(AIPawn) != None || SFXPawn_Henchman(AIPawn) != None)
    {
        foreach AIPawn.Modules(UseModule, )
        {
            if (SFXSimpleUseModule(UseModule) != None || SFXModule_MarkerPlayer(UseModule) != None)
            {
                AIPawn.Modules.RemoveItem(UseModule);
            }
        }
    }
    // Apply the bot use module which makes it follow on use
    botUseModule = new (AIPawn) Class'SFSBotUseModule';
    AIPawn.Modules.AddItem(botUseModule);
    botUseModule.ModuleOwner = AIPawn;
    botUseModule.HandlePostAdd();
    //botUseModule.HandlePostBeginPlay();
    printArrayContents(Self.Name, Outer, AIPawn.Modules, "botModules");
}
public function ModifyImpactSounds(SFXPawn_Player AIPawn)
{
    log(Self.Name, "ModifyImpactSounds", Outer);
    AIPawn.ImpactSound = None;
    AIPawn.ShieldImpactSound = None;
}
public function ModifyBotLoadout(SFXPawn_PlayerMP AIPawn)
{
    log(BotLoadoutManager.Name, "is not null", Outer);
    log(AIPawn.Name, "is not null", Outer);
    log(Self.Name, "ModifyBotLoadout", Outer);
    BotLoadoutManager.ModifyBotLoadout(AIPawn);
}
public function generateHenchmanWeapons(SFXPawn_Henchman henchPawn)
{
    local SFXWeapon henchmanWeapon;
    local Class<SFXWeapon> WeaponClass;
    
    log(Self.Name, "henchPawn.bCombatPawn: " $ henchPawn.bCombatPawn, Outer);
    foreach henchPawn.Loadout.Weapons(WeaponClass, )
    {
        henchmanWeapon = SFXWeapon(henchPawn.CreateInventory(WeaponClass));
        //Also give them a bit more damage on the weapons
        henchmanWeapon.DamageHench = 2.5;
        henchPawn.SetWeaponImmediately(henchmanWeapon);
    }
    log(Self.Name, "henchmanWeapon: " $ henchmanWeapon, Outer);
    henchPawn.SetActiveWeapon(henchmanWeapon);
    henchPawn.Weapon = henchmanWeapon;
    henchPawn.SetupWeaponAnimations(henchmanWeapon, None);
}
public function ModifyBotWeapons(SFXPawn AIPawn)
{
    local SFXWeapon oWeapon;
    local Class<SFXWeapon> oWeaponClass;
    
    log(Self.Name, "ModifyBotWeapons", Outer);
    if (AIPawn != None && AIPawn.InvManager != None)
    {
        foreach AIPawn.InvManager.InventoryActors(Class'SFXWeapon', oWeapon)
        {
            log(Self.Name, "Modifying Bot Weapon: " $ oWeapon, Outer);
            oWeapon.bCanThrow = FALSE;
        }
    }
    foreach AIPawn.Loadout.Weapons(oWeaponClass, )
    {
        oWeaponClass.default.bCanThrow = FALSE;
    }
}
public function ModifyBotPowers(SFXPawn_Player inPawn, int Level)
{
    local int XPNeededForCurrentLevel;
    local SFXPawn_Player PlayerPawn;
    local int NewPlayerLevel;
    local int PlayerLevel;
    local int XPForNextLevel;
    local float CurrentXP;
    local SFXGRI GRI;
    
    log(Self.Name, "ModifyBotPowers", Outer);
    PlayerPawn = inPawn;
    PlayerPawn.AutoLevelUpInfo = PlayerPawn.PlayerClass.default.AutoLevelUpInfo;
    if (!Class'BioLevelUpSystem'.static.GetXPNeededForLevel(Level, XPNeededForCurrentLevel))
    {
        return;
    }
    PlayerPawn.TotalXP = float(XPNeededForCurrentLevel);
    CurrentXP = PlayerPawn.TotalXP;
    PlayerLevel = PlayerPawn.CharacterLevel;
    GRI = SFXGRI(PlayerPawn.WorldInfo.GRI);
    NewPlayerLevel = PlayerLevel;
    if (PlayerLevel >= 1 && Class'BioLevelUpSystem'.static.GetXPNeededForLevel(PlayerLevel + 1, XPForNextLevel))
    {
        while (CurrentXP >= float(XPForNextLevel))
        {
            ++NewPlayerLevel;
            if (Class'BioLevelUpSystem'.static.GetXPNeededForLevel(NewPlayerLevel + 1, XPForNextLevel) == FALSE)
            {
                break;
            }
        }
        if (Class'BioLevelUpSystem'.static.LevelUpBioPawn(PlayerPawn, NewPlayerLevel))
        {
            PlayerPawn.CharacterLevel = NewPlayerLevel;
        }
        if (GRI != None && GRI.DifficultyHandler != None)
        {
            GRI.DifficultyHandler.bNeedsUpdate = TRUE;
            GRI.DifficultyHandler.Update();
        }
    }
    Class'BioLevelUpSystem'.static.AutoLevelUpPowers(PlayerPawn);
}
public function AutoLevelUpHenchman(SFXPawn_Henchman henchPawn, int Level)
{
    local SFXPowerCustomActionBase iterator;
    
    henchPawn.CharacterLevel = Level;
    henchPawn.AutoLevelUpInfo = henchPawn.default.AutoLevelUpInfo;
    Class'BioLevelUpSystem'.static.AutoLevelUpPowers(henchPawn);
    foreach henchPawn.PowerManager.Powers(iterator, )
    {
        log(Self.Name, "Power and Rank " $ iterator.Name $ " " $ iterator.Rank, Outer);
    }
}
public function ModifyDamageModule(SFXPawn_Player AIPawn)
{
    local SFXModule_DamagePlayer AIDamageModule;
    
    log(Self.Name, "ModifyDamageModule", Outer);
    AIDamageModule = AIPawn.GetModule(Class'SFXModule_DamagePlayer');
    if (AIDamageModule != None)
    {
        log(Self.Name, "Modifying Bot Damage Module", Outer);
        AIDamageModule.WwiseComponent = None;
        AIDamageModule.CE_BleedOut = None;
        AIDamageModule.MIC_Bleedout = None;
        AIDamageModule.BleedOutEventPair = None;
        AIDamageModule.BleedOutRTPC = "";
        AIDamageModule.BleedoutStartThreshold = -10000.0;
        AIDamageModule.InitialBleedoutPct = -10000.0;
    }
}
public function SetLocation(SFXPawn PlayerPawn, SFXPawn AIPawn, SFXAI_Core AI)
{
    local SpawnPoint SpawnPoint;
    
    log(Self.Name, "SetLocation", Outer);
    SpawnPoint = SpawnManager.findSpawnPoint(AI, PlayerPawn);
    log(Self.Name, "Setting location of: " $ AIPawn $ " as " $ SpawnPoint.location, Outer);
    AI.SetLocation(SpawnPoint.location, );
    AI.SetRotation(SpawnPoint.Rotation);
    AIPawn.SetLocation(SpawnPoint.location, );
    AIPawn.SetRotation(SpawnPoint.Rotation);
}
public function int getBotId()
{
    local SFXEngine Engine;
    local BioWorldInfo World;
    local BioCheatManagerNonNative cheats;
    local SFXPawn Bot;
    local SFXAI_Core AI;
    local array<Actor> Actors;
    local int Index;
    
    log(Self.Name, "getBotId", Outer);
    Index = 1;
    if (AllBots.Length == 0)
    {
        log(Self.Name, "BotIndex " $ Index, Outer);
        return Index;
    }
    foreach AllBots(Bot, )
    {
        Index++;
    }
    log(Self.Name, "BotIndex " $ Index, Outer);
    return Index;
}
public function respawnBot(Actor Source, int botId)
{
    local SFXPawn deadBot;
    
    //This function is no longer necessary, as the bots are immortal.
    deadBot = SFXPawn(Source);
    if (deadBot != None)
    {
        RemoveBot(deadBot.Controller.PlayerReplicationInfo.PlayerID);
        SpawnBot(botId, 0);
    }
}
public function string getDebugMessage(BotAsyncLoad BotAsyncLoad)
{
    local string DebugMessage;
    
    DebugMessage = "BotAsyncLoad";
    DebugMessage $= "\n\tAItoLoad: " $ BotAsyncLoad.AiToLoad;
    DebugMessage $= "\n\tArchetypeToLoad: " $ BotAsyncLoad.ArchetypeToLoad;
    DebugMessage $= "\n\tLoadedArchetype: " $ BotAsyncLoad.LoadedArchetype;
    DebugMessage $= "\n\tLoadedArchetype Class: " $ BotAsyncLoad.LoadedArchetype.Class;
    DebugMessage $= "\n\tLoadedArchetype Object Archetype: " $ BotAsyncLoad.LoadedArchetype.ObjectArchetype;
    DebugMessage $= "\n\tLoadedArchetype Object Archetype Class: " $ BotAsyncLoad.LoadedArchetype.ObjectArchetype.Class;
    DebugMessage $= "\n\tLoadedHenchmanArchetype: " $ BotAsyncLoad.LoadedHenchamnArchetype.Class;
    DebugMessage $= "\n\tLoadedHenchmanArchetype Class: " $ BotAsyncLoad.LoadedHenchamnArchetype.Class.Class;
    DebugMessage $= "\n\tLoadedHenchmanArchetype Object Archetype: " $ BotAsyncLoad.LoadedHenchamnArchetype.Class.ObjectArchetype;
    DebugMessage $= "\n\tLoadedHenchmanArchetype Object Archetype Class: " $ BotAsyncLoad.LoadedHenchamnArchetype.Class.ObjectArchetype.Class;
    DebugMessage $= "\n\tLoadedEnemyArchetype: " $ BotAsyncLoad.LoadedEnemyArchetype;
    DebugMessage $= "\n\tBotLoadStatus: " $ BotAsyncLoad.BotLoadStatus;
    DebugMessage $= "\n\tBotTemplate: " $ BotAsyncLoad.BotTemplate.Archetype;
    DebugMessage $= "\n\tBotTemplate.bEnemyPawn: " $ BotAsyncLoad.BotTemplate.bEnemyPawn;
    DebugMessage $= "\n\tBotTemplate.bHasAIController: " $ BotAsyncLoad.BotTemplate.bHasAIController;
    DebugMessage $= "\n\tBotIndex: " $ BotAsyncLoad.BotIndex;
    DebugMessage $= "\n\tRetries: " $ BotAsyncLoad.retries;
    DebugMessage $= "\n\tProcessed: " $ BotAsyncLoad.Processed;
    DebugMessage $= "\n\tisLoaded: " $ BotAsyncLoad.isLoaded;
    return DebugMessage;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ListenedEventTypes = (SFSEventType.EVT_AddBot, 
                          SFSEventType.EVT_BotDied, 
                          SFSEventType.EVT_ListBots, 
                          SFSEventType.EVT_RemoveBot, 
                          SFSEventType.EVT_ListBotTypes, 
                          SFSEventType.EVT_RemoveBotLimit, 
                          SFSEventType.EVT_DebugBotAI, 
                          SFSEventType.EVT_AddEnemy
                         )
    CheckDelay = 1.0
    maxRetries = 10
    BotNameColor = {R = 0.5, G = 1.0, B = 0.5, A = 1.0}
    bUseBotData = FALSE
    bBotDebugLogging = FALSE
    b_spawnDebugLogging = FALSE
    maxBots = 16
    limitBotAmount = TRUE
    botGroup = 'AddedBots'
    BotLevel = 20
    defaultTemplate = {Archetype = "Char_Enemies.Archetypes.Cerberus.Centurion", bEnemyPawn = TRUE}
    BotNotFound = "Bot Template not found for index: "
    BotLimitReached = "Max Bots Amount Reached, cannot spawn bot: "
    AutoBotAIControllerName = "BotAI.SFXAI_Bot"
    henchmenIndexStart = 83
    BotData = ({
                Tint1ID = 45, 
                Tint2ID = 46, 
                PatternID = 1, 
                PatternColorID = 7, 
                PhongID = 7, 
                EmissiveID = 28, 
                SkinToneID = 9
               }
              )
    BotArchetypes = ({Archetype = "BioChar_MPPlayers.Archetypes.Adept.HumanFemale_Adept", Kit = 'AdeptHumanFemale', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Engineer.HumanFemale_Engineer", Kit = 'EngineerHumanFemale', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Infiltrator.HumanFemale_Infiltrator", Kit = 'InfiltratorHumanFemale', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Sentinel.HumanFemale_Sentinel", Kit = 'SentinelHumanFemale', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Soldier.HumanFemale_Soldier", Kit = 'SoldierHumanFemale', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Vanguard.HumanFemale_Vanguard", Kit = 'VanguardHumanFemale', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Adept.Asari_Adept", Kit = 'AdeptAsari', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Engineer.Quarian_Engineer", Kit = 'EngineerQuarian', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Vanguard.Asari_Vanguard2", Kit = 'VanguardAsari', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Adept.HumanMale_Adept", Kit = 'AdeptHumanMale', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Engineer.HumanMale_Engineer", Kit = 'EngineerHumanMale', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Infiltrator.HumanMale_Infiltrator", Kit = 'InfiltratorHumanMale', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Sentinel.HumanMale_Sentinel", Kit = 'SentinelHumanMale', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Soldier.HumanMale_Soldier", Kit = 'SoldierHumanMale', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Vanguard.HumanMale_Vanguard", Kit = 'VanguardHumanMale', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Adept.Drell_Adept2", Kit = 'AdeptDrell', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Engineer.Salarian_Engineer2", Kit = 'EngineerSalarian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Infiltrator.Salarian_Infiltrator", Kit = 'InfiltratorSalarian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Infiltrator.Quarian_Infiltrator2", Kit = 'InfiltratorQuarian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Sentinel.Turian_Sentinel", Kit = 'SentinelTurian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Sentinel.Krogan_Sentinel", Kit = 'SentinelKrogan', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Soldier.Krogan_Soldier", Kit = 'SoldierKrogan', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Soldier.Turian_Soldier2", Kit = 'SoldierTurian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Vanguard.Drell_Vanguard", Kit = 'VanguardDrell', botType = botType.MPKit}, 
                     {Archetype = "BioChar_MPPlayers.Archetypes.Soldier.HumanMale_SoldierBF3", Kit = 'SoldierHumanMaleBF3', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP1_MPPlayers.Archetypes.AsariCommando_Adept", Kit = 'AdeptAsariCommando', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP1_MPPlayers.Archetypes.Geth_Engineer", Kit = 'EngineerGeth', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP1_MPPlayers.Archetypes.Geth_Infiltrator", Kit = 'InfiltratorGeth', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP1_MPPlayers.Archetypes.Batarian_Soldier", Kit = 'SoldierBatarian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP1_MPPlayers.Archetypes.Batarian_Sentinel", Kit = 'SentinelBatarian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP1_MPPlayers.Archetypes.Krogan_Vanguard", Kit = 'VanguardKrogan', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP2_MPPlayers.Archetypes.VorchaMale_Soldier", Kit = 'SoldierVorcha', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP2_MPPlayers.Archetypes.VorchaMale_Sentinel", Kit = 'SentinelVorcha', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP2_MPPlayers.Archetypes.QuarianMale_Engineer", Kit = 'EngineerQuarianMale', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP2_MPPlayers.Archetypes.QuarianMale_Infiltrator", Kit = 'InfiltratorQuarianMale', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP2_MPPlayers.Archetypes.CerberusMale_Adept", Kit = 'AdeptHumanMaleCerberus', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP2_MPPlayers.Archetypes.CerberusMale_Vanguard", Kit = 'VanguardHumanMaleCerberus', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP3_MPPlayers.Engineer_N7", Kit = 'EngineerN7', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP3_MPPlayers.Infiltrator_N7", Kit = 'InfiltratorN7', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP3_MPPlayers.Adept_N7", Kit = 'AdeptN7', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP3_MPPlayers.Vanguard_N7", Kit = 'VanguardN7', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP3_MPPlayers.Soldier_N7", Kit = 'SoldierN7', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP3_MPPlayers.Sentinel_N7", Kit = 'SentinelN7', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Engineer_Volus", Kit = 'EngineerVolus', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Adept2_Volus", Kit = 'AdeptVolus', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Soldier_N7_Turian", Kit = 'N7SoldierTurian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Infiltrator_N7_Turian", Kit = 'N7InfiltratorTurian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Adept_Krogan", Kit = 'AdeptKrogan', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Engineer_Turian", Kit = 'EngineerTurian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Infiltrator_Drell", Kit = 'InfiltratorDrell', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Sentinel_Volus", Kit = 'SentinelVolus', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Soldier_Geth", Kit = 'SoldierGeth', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Vanguard_Volus", Kit = 'VanguardVolus', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Adept_Batarian", Kit = 'AdeptBatarian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Engineer_Vorcha", Kit = 'EngineerVorcha', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Soldier_MQuarian", Kit = 'SoldierMQuarian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Vanguard_Batarian", Kit = 'VanguardBatarian', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Infiltrator_Asari", Kit = 'InfiltratorAsari', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP4_MPPlayers.Sentinel_Asari", Kit = 'SentinelAsari', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP5_MPPlayers.Soldier_GethDestroyer", Kit = 'SoldierGethDestroyer', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP5_MPPlayers.Adept_Collector", Kit = 'AdeptCollector', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP5_MPPlayers.Sentinel_KroganWarlord", Kit = 'SentinelKroganWarlord', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP5_MPPlayers.Engineer_Merc", Kit = 'EngineerMerc', botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP5_MPPlayers.Vanguard_TurianFemale", Kit = 'VanguardTurianFemale', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "BioChar_DLC_MP5_MPPlayers.Infiltrator_Fembot", Kit = 'InfiltratorFembot', bFemale = TRUE, botType = botType.MPKit}, 
                     {Archetype = "Char_Enemies.Archetypes.Cerberus.Centurion", Kit = 'Cerberus Centurion', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Cerberus.Engineer", Kit = 'Cerberus Engineer', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Cerberus.AssaultTrooper", Kit = 'Cerberus Assault Trooper', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Cerberus.Guardian", Kit = 'Cerberus Guardian', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Cerberus.Nemesis", Kit = 'Cerberus Nemesis', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Cerberus.Atlas", Kit = 'Cerberus Atlas', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Cerberus.Phantom", Kit = 'Cerberus Phantom', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Geth.GethTrooper", Kit = 'Geth Trooper', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Geth.GethRocketTrooper", Kit = 'Geth Rocket Trooper', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Geth.GethPyro", Kit = 'Geth Pyro', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Geth.GethHunter", Kit = 'Geth Hunter', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Geth.GethPrime", Kit = 'Geth Prime', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Reapers.Cannibal", Kit = 'Cannibal', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Reapers.Marauder", Kit = 'Marauder', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Reapers.Brute", Kit = 'Brute', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Reapers.Banshee", Kit = 'Banshee', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Reapers.Husk", Kit = 'Husk', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_Enemies.Archetypes.Reapers.Ravager", Kit = 'Ravager', botType = botType.Enemy, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimJack", Kit = 'Jack', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimGarrus", Kit = 'Garrus', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimTali", Kit = 'Tali', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimWrex", Kit = 'Wrex', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimMiranda", Kit = 'Miranda', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimKaidan", Kit = 'Kaidan', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimJacob", Kit = 'Jacob', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimAshley", Kit = 'Ashley', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimEDI", Kit = 'EDI', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimGrunt", Kit = 'Grunt', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimKasumi", Kit = 'Kasumi', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimLiara", Kit = 'Liara', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimJames", Kit = 'James', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimSamara", Kit = 'Samara', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimJavik", Kit = 'Javik', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_SimHenchmen.SimZaeed", Kit = 'Zaeed', botType = botType.Henchman, bHasAIController = TRUE}, 
                     {Archetype = "Char_Henchmen.Archetypes.Kaidan.VariantB.KaidanB_EX_Combat", Kit = 'Kaidan alternative look', botType = botType.Henchman, bHasAIController = TRUE}
                    )
    BotNamesFemale = ("AdmiralBison", 
                      "Furia", 
                      "Revan", 
                      "Joanna", 
                      "Ikora Rey", 
                      "Mara Sov", 
                      "Petra Venj", 
                      "Megan Foster", 
                      "Yennefer", 
                      "Mission Vao", 
                      "Bastila Shan", 
                      "Juhani", 
                      "Brianna", 
                      "Visas Marr", 
                      "Mira", 
                      "Morrigan", 
                      "Leliana", 
                      "Wynne", 
                      "Karlach", 
                      "Shadowheart", 
                      "Lae'zel", 
                      "Jaheira", 
                      "Minthara", 
                      "Isabela", 
                      "Aveline Vallen", 
                      "Merrill", 
                      "Cassandra", 
                      "Sera", 
                      "Vivienne", 
                      "Josephine", 
                      "Valta"
                     )
    BotNamesMale = ("AdmiralBison", 
                    "Revan", 
                    "Saint-14", 
                    "Zavala", 
                    "Cayde-7", 
                    "Uldren Sov", 
                    "Corvo Attano", 
                    "Geralt of Rivia", 
                    "s1mple", 
                    "Fernando Alonso", 
                    "Jason Bourne", 
                    "Ethan Hunt", 
                    "James Bond", 
                    "Atton Rand", 
                    "Canderous Ordo", 
                    "Carth Onasi", 
                    "Bao-Dur", 
                    "Mical", 
                    "Alistair", 
                    "Oghren", 
                    "Shale", 
                    "Sten", 
                    "Zevran", 
                    "Halsin", 
                    "Astarion", 
                    "Gale", 
                    "Wyll", 
                    "Minsc", 
                    "Anders", 
                    "Fenris", 
                    "Sebastian Vael", 
                    "Varric", 
                    "Blackwall", 
                    "Iron Bull", 
                    "Cole", 
                    "Solas", 
                    "Dorian Pavus", 
                    "Cullen Rutherford", 
                    "Renn"
                   )
}