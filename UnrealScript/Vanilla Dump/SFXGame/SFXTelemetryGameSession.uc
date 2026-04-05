Class SFXTelemetryGameSession
    native
    transient
    config(Game);

var const native noexport Pointer VfTable_FTickableObject;
var const native noexport Pointer VfTable_FCallbackEventDevice;
var Double CareerTime;
var Double GameTime;
var Double SessionTime;
var Double IdleTime;
var QWord MatchID;
var string MapName;
var string Career;
var string Base64_CharacterID;
var config array<string> SessionStartMapExclusion;
var Name ChunkName;
var int Difficulty;
var int MPDifficulty;
var float MatchStartTime;
var int RoundID;
var int EnemyType;
var int TotalCredits;
var int TotalScore;
var int TotalSupplyDrops;
var float StoreOpenedTime;
var int StoreOpenCreditsSpent;
var int StoreOpenCashSpent;
var bool bStarted;
var bool bSentBootHooks;
var bool bSentBugSentryHook;
var bool bRandomMap;
var bool bRandomEnemy;
var bool bPrivateGame;
var bool bPlayerHasMic;
var bool bPlayerUsedMic;

public static final native function Encode64_GUID(const out Guid i_guid, out string o_Base64Result);

public event function SendClientMPSessionStart()
{
    local SFXPRI PRI;
    
    PRI = SFXPRI(Class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().PlayerReplicationInfo);
    if (PRI != None)
    {
        PRI.SendTelemetryForWeapons();
    }
    Class'SFXTelemetryHooks'.static.SendPlayersMuted();
}
public event function SendServerMPSessionEnd()
{
    local SFXEngine Engine;
    local SFXMatchResultsData MatchResultsData;
    local WorldInfo WorldInfo;
    local SFXTelemetryGameSession TelemetryGameSession;
    
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    TelemetryGameSession = Class'SFXTelemetry'.static.GetInstanceGameSession();
    if (TelemetryGameSession != None && WorldInfo != None && Engine != None)
    {
        MatchResultsData = Engine.MPSaveManager.GetMPMatchResultsData();
        Class'SFXTelemetryHooks'.static.SendServerMPSessionEnd(MatchResultsData.TotalSquadCredits, MatchResultsData.TotalSquadXP, MatchResultsData.CurrentMatchData.Waves, MatchResultsData.CurrentMatchData.bResult, SFXGRI(WorldInfo.GRI).NumPlayersInGame(), MatchResultsData.ExtractedPlayerIDs.Length, TelemetryGameSession.TotalSupplyDrops);
    }
}
public event function SendServerMPSessionStart()
{
    local WorldInfo WorldInfo;
    
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    Class'SFXTelemetryHooks'.static.SendServerMPSessionStart(SFXGRI(WorldInfo.GRI).NumPlayersInGame(), bRandomMap, bRandomEnemy, bPrivateGame);
}
public final function SetMPMatchSettings(bool RandomMap, bool RandomEnemy, bool PrivateGame, int NewDifficulty, int NewEnemyType)
{
    bRandomMap = RandomMap;
    bRandomEnemy = RandomEnemy;
    bPrivateGame = PrivateGame;
    MPDifficulty = NewDifficulty;
    EnemyType = NewEnemyType;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SessionStartMapExclusion = ("BioP_Char")
}