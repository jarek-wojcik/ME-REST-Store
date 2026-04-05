Class SFXTelemetry
    native
    transient
    config(Game);

struct native TelemetryHook 
{
    var Name Name;
    var int ModuleID;
    var int GroupID;
    var int StringID;
    var int CrossParameters;
    var ETelemetryChannel Channel;
};
struct native TelemetryHookConfig 
{
    var string Name;
    var string Module;
    var string Group;
    var string String;
    var string CrossParameters;
    var string Channel;
};

var config array<TelemetryHookConfig> ConfigHooks;
var config array<int> BlacklistPlotsInt;
var config array<int> BlacklistPlotsFloat;
var config array<int> BlacklistPlotsBool;
var native Object Hooks;
var SFXTelemetryGameSession GameSession;
var config bool bEnable;
var bool bCachedCollectionEnabledInProfile;
var bool bInitialized;

public static final native function int FStringToFourCC(const out string s4CharID);

public static final native function string GenerateUniqueClassId(Object Object);

public static final native function string GenerateUniqueClassIdFromString(const out string FullFriendlyName);

public event function Guid GetCharacterID(BioPawn Pawn)
{
    local Guid Id;
    local SFXPawn_Player PlayerPawn;
    
    PlayerPawn = SFXPawn_Player(Pawn);
    if (PlayerPawn != None)
    {
        Id = PlayerPawn.CharacterGUID;
    }
    return Id;
}
public static final native function SFXTelemetryGameSession GetInstanceGameSession();

public final event function InitConnectionDelegates()
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    local ISFXOnlineComponentTelemetry oOnlineTelemetry;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        oOnlineTelemetry = oOnlineSubsystem.GetComponentTelemetry();
        if (oOnlineTelemetry != None)
        {
            oOnlineTelemetry.RegisterConnectionDelegates(IsCollectionEnabled, OnAuthenticate, OnDisconnect);
        }
    }
}
public final native function bool IsCollectionEnabled();

public final function OnAuthenticate()
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    local ISFXOnlineComponentLogin oLogin;
    local OnlinePlayerInterface PlayerInterface;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        oLogin = oOnlineSubsystem.GetComponentLogin();
        if (oLogin != None)
        {
            if (int(oLogin.GetLoginStatus()) >= 1)
            {
                SendProfileDependentTelemetry(byte(oLogin.GetActiveUserIndex()));
            }
        }
        PlayerInterface = oOnlineSubsystem.PlayerInterface;
        if (PlayerInterface != None)
        {
            PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        }
    }
}
public final native function OnDisconnect(int Error, int PreviousState, int NewState, const string SessionId);

public final function OnLoginChange(byte LocalUserNum)
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    local ISFXOnlineComponentLogin oLogin;
    local OnlinePlayerInterface PlayerInterface;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        oLogin = oOnlineSubsystem.GetComponentLogin();
        if (oLogin != None)
        {
            if (oLogin.GetActiveUserIndex() == int(LocalUserNum))
            {
                PlayerInterface = oOnlineSubsystem.PlayerInterface;
                if (PlayerInterface != None)
                {
                    PlayerInterface.AddReadProfileSettingsCompleteDelegate(LocalUserNum, SendTelemetryOnProfileReadComplete);
                }
            }
        }
    }
}
public static final native function SendAchievement(int AchievementId);

public static final native function SendArray(Name HookName, const array<TelemetryAttribute> Attributes);

public static final native function SendBool(Name HookName, const bool B);

public final native function SendCachedDisconnectEvent();

public static final native function SendFloat(Name HookName, const float F);

public static final native function SendInt(Name HookName, const int i);

public final native function SendLanguageOverrideSettings();

public static final native function SendName(Name HookName, Name N);

public static final native function SendString(Name HookName, const string S);

public static final native function SendVoid(Name HookName);

public static function AddAttributeToArray(out array<TelemetryAttribute> Attributes, ETelemetryAttributeType Type, string Key, optional const out string sData, optional int nData, optional float fData, optional bool bData, optional Name nmData)
{
    local int N;
    local string sTemp;
    
    N = Attributes.Length;
    Attributes.Add(1);
    Attributes[N].Type = Type;
    Attributes[N].Key = Class'SFXTelemetry'.static.FStringToFourCC(Key);
    switch (Type)
    {
        case ETelemetryAttributeType.AttributeType_String:
            Attributes[N].sData = sData;
            break;
        case ETelemetryAttributeType.AttributeType_Int:
            Attributes[N].nData = nData;
            break;
        case ETelemetryAttributeType.AttributeType_Float:
            Attributes[N].fData = fData;
            break;
        case ETelemetryAttributeType.AttributeType_Bool:
            Attributes[N].bData = bData;
            break;
        case ETelemetryAttributeType.AttributeType_ClassName:
            Attributes[N].Type = ETelemetryAttributeType.AttributeType_String;
            sTemp = string(nmData);
            Attributes[N].sData = GenerateUniqueClassIdFromString(sTemp);
            break;
        default:
    }
}
public function SendProfileDependentTelemetry(byte LocalUserNum)
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    local ISFXOnlineComponentLogin oLogin;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        oLogin = oOnlineSubsystem.GetComponentLogin();
        if (oLogin != None)
        {
            if (oLogin.GetActiveUserIndex() == int(LocalUserNum))
            {
                SendLanguageOverrideSettings();
                SendCachedDisconnectEvent();
            }
        }
    }
}
public final function SendTelemetryOnProfileReadComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    local ISFXOnlineComponentLogin oLogin;
    local OnlinePlayerInterface PlayerInterface;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (bWasSuccessful && oOnlineSubsystem != None)
    {
        oLogin = oOnlineSubsystem.GetComponentLogin();
        if (oLogin != None)
        {
            if (oLogin.GetActiveUserIndex() == int(LocalUserNum))
            {
                SendProfileDependentTelemetry(LocalUserNum);
                PlayerInterface = oOnlineSubsystem.PlayerInterface;
                if (PlayerInterface != None)
                {
                    PlayerInterface.ClearReadProfileSettingsCompleteDelegate(LocalUserNum, SendTelemetryOnProfileReadComplete);
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ConfigHooks = ({
                    Name = "TelemetryHook_Test_Anon", 
                    Module = "TEST", 
                    Group = "TEST", 
                    String = "TEST", 
                    CrossParameters = "", 
                    Channel = "anonymous"
                   }, 
                   {
                    Name = "TelemetryHook_Test_Auth", 
                    Module = "TEST", 
                    Group = "TEST", 
                    String = "TEST", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_LanguageOverrides", 
                    Module = "BOOT", 
                    Group = "SESS", 
                    String = "OLNG", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_OutOfMemory", 
                    Module = "SYST", 
                    Group = "CRSH", 
                    String = "MOOM", 
                    CrossParameters = "PlayerLocation, Map", 
                    Channel = "anonymous"
                   }, 
                   {
                    Name = "TelemetryHook_PlotState", 
                    Module = "PROG", 
                    Group = "PLOT", 
                    String = "PSTC", 
                    CrossParameters = "CareerID", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Disconnect", 
                    Module = "ONLN", 
                    Group = "BLAZ", 
                    String = "DCON", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_SquadCommand", 
                    Module = "GAME", 
                    Group = "CBAT", 
                    String = "SCMD", 
                    CrossParameters = "Map, Difficulty, CharacterClassKit, CharacterLevel", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_SelectHenchman", 
                    Module = "GAME", 
                    Group = "GUIS", 
                    String = "SHCH", 
                    CrossParameters = "Map, Difficulty, CharacterClassKit, CharacterLevel", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_SelectWeapon", 
                    Module = "GAME", 
                    Group = "CBAT", 
                    String = "PSWW", 
                    CrossParameters = "PlayerLocation, Map, Mode", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Death", 
                    Module = "GAME", 
                    Group = "DEFT", 
                    String = "DETH", 
                    CrossParameters = "PlayerLocation, Map, Mode, Difficulty, CareerTime, GameTime, SessionTime, MatchID, RoundID, CareerID, Henchmen, Gender, CharacterClassKit, CharacterLevel", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_OutOfAmmo", 
                    Module = "GAME", 
                    Group = "CBAT", 
                    String = "OAMO", 
                    CrossParameters = "PlayerLocation, Map, CareerTime, Mode", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_OutOfFuel", 
                    Module = "GAME", 
                    Group = "GMAP", 
                    String = "EOOF", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Credits", 
                    Module = "GAME", 
                    Group = "ECON", 
                    String = "CRED", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_LevelUp", 
                    Module = "PROG", 
                    Group = "LEVL", 
                    String = "LVUP", 
                    CrossParameters = "PlayerLocation, Map, CareerTime", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_AutoLevelUp", 
                    Module = "PROG", 
                    Group = "LEVL", 
                    String = "AUTO", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Conversation", 
                    Module = "PROG", 
                    Group = "CONV", 
                    String = "ENDS", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_ConvInterrupt", 
                    Module = "PROG", 
                    Group = "CONV", 
                    String = "INTP", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Option_GameStart", 
                    Module = "GAME", 
                    Group = "OPTN", 
                    String = "STRT", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Option_Change", 
                    Module = "GAME", 
                    Group = "OPTN", 
                    String = "CHNG", 
                    CrossParameters = "PlayerLocation, Map", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Option_GameCompletion", 
                    Module = "GAME", 
                    Group = "OPTN", 
                    String = "ENDG", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_CodexUpTime", 
                    Module = "GAME", 
                    Group = "GUIS", 
                    String = "CODX", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_PlayerAppearanceChange", 
                    Module = "CHAR", 
                    Group = "PAPP", 
                    String = "CHNG", 
                    CrossParameters = "PlayerLocation, Map, CareerTime", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_DLC_Notified", 
                    Module = "PDLC", 
                    Group = "NOTI", 
                    String = "GCNO", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Invite_ProtocolMismatch", 
                    Module = "ONLN", 
                    Group = "BLAZ", 
                    String = "MMFP", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_NewGame", 
                    Module = "MISC", 
                    Group = "CARE", 
                    String = "NEWG", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_SaveGame", 
                    Module = "MISC", 
                    Group = "CARE", 
                    String = "SAVE", 
                    CrossParameters = "PlayerLocation, Map, Difficulty, CareerTime, GameTime, SessionTime", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_LoadGame", 
                    Module = "MISC", 
                    Group = "CARE", 
                    String = "LOAD", 
                    CrossParameters = "PlayerLocation, Map, GameTime, SessionTime", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_LoadGameFromDemo", 
                    Module = "MISC", 
                    Group = "CARE", 
                    String = "LGFD", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_CompleteGame", 
                    Module = "MISC", 
                    Group = "CARE", 
                    String = "ENDS", 
                    CrossParameters = "SessionTime, GameTime, CareerTime, Difficulty, CareerID, CharacterClassKit, CharacterLevel", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Kinect", 
                    Module = "GAME", 
                    Group = "KNCT", 
                    String = "CONF", 
                    CrossParameters = "SessionTime", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_KinectStatus", 
                    Module = "GAME", 
                    Group = "KNCT", 
                    String = "STAT", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_LoadingScreenTimedOut", 
                    Module = "GAME", 
                    Group = "LOAD", 
                    String = "TIMD", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_BugSentry", 
                    Module = "BOOT", 
                    Group = "STRY", 
                    String = "SEID", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_BootSession", 
                    Module = "BOOT", 
                    Group = "SESS", 
                    String = "STRT", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_GameSessionStart", 
                    Module = "GAME", 
                    Group = "SESS", 
                    String = "STRT", 
                    CrossParameters = "Mode, CareerTime, Difficulty, EnemyType, GameTime, SessionTime, Map, MatchID, CareerID, CharacterClassKit, CharacterLevel, N7, Gender", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_GameSessionEnd", 
                    Module = "GAME", 
                    Group = "SESS", 
                    String = "ENDS", 
                    CrossParameters = "Mode, CareerTime, Difficulty, EnemyType, GameTime, SessionTime, Map, MatchID, CareerID, CharacterClassKit, CharacterLevel, N7, RoundID, MatchTime", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_Milestone", 
                    Module = "TLM3", 
                    Group = "GPRG", 
                    String = "MILE", 
                    CrossParameters = "SessionTime, GameTime, CareerTime, Difficulty, Map, CareerID, CharacterClassKit, CharacterLevel", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_Achievement", 
                    Module = "PROG", 
                    Group = "ACHI", 
                    String = "XXXX", 
                    CrossParameters = "SessionTime, GameTime, CareerTime, Difficulty, Mode, PlayerLocation, Map, CharacterClassKit, CharacterLevel", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_PDLC_Usage", 
                    Module = "PDLC", 
                    Group = "LOAD", 
                    String = "MODU", 
                    CrossParameters = "Mode, Difficulty, SessionTime", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_SettingsSoftware", 
                    Module = "HDWR", 
                    Group = "PCSW", 
                    String = "OSYS", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_SettingsSoftware_TamperDetection", 
                    Module = "HDWR", 
                    Group = "PCSW", 
                    String = "TMPD", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_SettingsHardware_CPU", 
                    Module = "HDWR", 
                    Group = "PCHW", 
                    String = "CPUX", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_SettingsHardware_Video", 
                    Module = "HDWR", 
                    Group = "PCHW", 
                    String = "VIDO", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_SettingsHardware_Display", 
                    Module = "HDWR", 
                    Group = "PCHW", 
                    String = "DISP", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_SettingsHardware_ExResolution", 
                    Module = "HDWR", 
                    Group = "PCHW", 
                    String = "ERES", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_SettingsHardware_Memory", 
                    Module = "HDWR", 
                    Group = "PCHW", 
                    String = "RAMX", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_SettingsHardware_Storage", 
                    Module = "HDWR", 
                    Group = "PCHW", 
                    String = "STOR", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_SettingsHardware_EyeFinity", 
                    Module = "HDWR", 
                    Group = "EYEF", 
                    String = "SETT", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_Std_SettingsHardware_EyeFinity_Monitor", 
                    Module = "HDWR", 
                    Group = "EYEF", 
                    String = "DISP", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_OriginClosed", 
                    Module = "GAME", 
                    Group = "ORIG", 
                    String = "CLOS", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_RP_Purchased", 
                    Module = "GAME", 
                    Group = "RFRC", 
                    String = "PRCH", 
                    CrossParameters = "N7, MPTimePlayed, MPGamesPlayed", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_RP_CardDrop", 
                    Module = "GAME", 
                    Group = "RFRC", 
                    String = "CDRP", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_SupplyDrop_Pickup", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "SDPK", 
                    CrossParameters = "Map, Difficulty, EnemyType, GameTime, SessionTime, MatchID, RoundID", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_Credits", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "CRED", 
                    CrossParameters = "Map, Difficulty, EnemyType, GameTime, SessionTime, MatchID, CharacterClassKit, CharacterLevel, N7, RoundID, MPTimePlayed, MPGamesPlayed", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_CharacterPrestiged", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "PRES", 
                    CrossParameters = "N7,  MPTimePlayed, MPGamesPlayed", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MPHOST_WaveComplete", 
                    Module = "GAME", 
                    Group = "HOST", 
                    String = "WAVE", 
                    CrossParameters = "Map, Difficulty, EnemyType, GameTime, SessionTime, MatchID, MatchTime", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MPHOST_SupplyDrop_Dropped", 
                    Module = "GAME", 
                    Group = "HOST", 
                    String = "SDDP", 
                    CrossParameters = "Map, Difficulty, EnemyType, GameTime, SessionTime, MatchID, RoundID", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MPHOST_MatchSettings", 
                    Module = "GAME", 
                    Group = "HOST", 
                    String = "MSET", 
                    CrossParameters = "Map, Difficulty, EnemyType, MatchID", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MPHOST_MatchResults", 
                    Module = "GAME", 
                    Group = "HOST", 
                    String = "MRES", 
                    CrossParameters = "Map, Difficulty, EnemyType, GameTime, SessionTime, MatchID, RoundID", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MPHOST_PlayerKickedByVote", 
                    Module = "GAME", 
                    Group = "HOST", 
                    String = "KIPL", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MPHOST_HostMigration", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "HOMI", 
                    CrossParameters = "MatchTime", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_KickVote", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "KIVO", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_Quickplay", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "QKPL", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_HostNew", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "HONW", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_LevelUp", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "LVUP", 
                    CrossParameters = "Map, Difficulty, EnemyType, GameTime, SessionTime, MatchID, CharacterClassKit, N7, MPTimePlayed, MPGamesPlayed", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_LoadoutWeapon", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "WEPS", 
                    CrossParameters = "Map, Difficulty, EnemyType, GameTime, MatchID, CharacterClassKit, CharacterLevel, N7, MPTimePlayed, MPGamesPlayed", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_LoadoutConsumable", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "MACO", 
                    CrossParameters = "Map, Difficulty, EnemyType, GameTime, MatchID, CharacterClassKit, CharacterLevel, N7, MPTimePlayed, MPGamesPlayed", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_Consumable", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "CONS", 
                    CrossParameters = "Map, Difficulty, EnemyType, GameTime, SessionTime, MatchID, CharacterClassKit, CharacterLevel, N7, RoundID", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_Invite", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "INVI", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_Mute", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "MUTE", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_MP_Connection", 
                    Module = "GAME", 
                    Group = "MULT", 
                    String = "CONN", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_StoreOpened", 
                    Module = "GAME", 
                    Group = "GUIS", 
                    String = "STOP", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_StoreClosed", 
                    Module = "GAME", 
                    Group = "GUIS", 
                    String = "STCL", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_LeaderboardOpened", 
                    Module = "GAME", 
                    Group = "GUIS", 
                    String = "LBOP", 
                    CrossParameters = "N7, MPTimePlayed, MPGamesPlayed", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_LeaderboardClosed", 
                    Module = "GAME", 
                    Group = "GUIS", 
                    String = "LBCL", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_PurchaseOffer", 
                    Module = "GAME", 
                    Group = "COMM", 
                    String = "PUOF", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_PurchaseComplete", 
                    Module = "GAME", 
                    Group = "COMM", 
                    String = "PUCO", 
                    CrossParameters = "", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_GAW_ZoneIncrease", 
                    Module = "GAME", 
                    Group = "GAWI", 
                    String = "ZONE", 
                    CrossParameters = "Map, Difficulty, EnemyType, MatchID, RoundID", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_GAW_IncrementAsset", 
                    Module = "GAME", 
                    Group = "GAWI", 
                    String = "IAST", 
                    CrossParameters = "Map, Difficulty, EnemyType, MatchID, RoundID", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_GAW_UnlockAsset", 
                    Module = "GAME", 
                    Group = "GAWI", 
                    String = "ASST", 
                    CrossParameters = "Map, Difficulty, CareerID", 
                    Channel = ""
                   }, 
                   {
                    Name = "TelemetryHook_GAW_EndGameOptions", 
                    Module = "GAME", 
                    Group = "GAWI", 
                    String = "ENDG", 
                    CrossParameters = "Map, Difficulty, CareerID, CharacterLevel, GameTime, CareerTime", 
                    Channel = ""
                   }
                  )
    BlacklistPlotsInt = (1, 
                         9, 
                         41, 
                         50, 
                         174, 
                         180, 
                         181, 
                         225, 
                         476, 
                         10161, 
                         10162, 
                         10164, 
                         10209, 
                         10251, 
                         10267, 
                         10457, 
                         10486, 
                         10640, 
                         10641, 
                         10642, 
                         10643, 
                         10644
                        )
    BlacklistPlotsFloat = (1, 
                           3, 
                           8, 
                           9, 
                           10, 
                           11, 
                           12, 
                           13, 
                           14, 
                           20, 
                           10041, 
                           10042
                          )
    BlacklistPlotsBool = (556, 17700, 21801)
    bEnable = TRUE
}