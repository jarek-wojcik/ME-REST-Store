Class OnlineSubsystem
    native
    abstract
    config(Engine);

struct native OnlinePartyMember 
{
    var const UniqueNetId UniqueId;
    var const QWord Data1;
    var const QWord Data2;
    var const string NickName;
    var const transient native Pointer SessionInfo;
    var const int TitleId;
    var const bool bIsLocal;
    var const bool bIsInPartyVoice;
    var const bool bIsTalking;
    var const bool bIsInGameSession;
    var const byte LocalUserNum;
    var const ENATType NatType;
};
enum EOnlineNewsType
{
    ONT_Unknown,
    ONT_GameNews,
    ONT_ContentAnnouncements,
    ONT_Misc,
};
struct native AchievementDetails 
{
    var const string AchievementName;
    var const string Description;
    var const string HowTo;
    var const int Id;
    var Surface Image;
    var const int GamerPoints;
    var const bool bIsSecret;
    var const bool bWasAchievedOnline;
    var const bool bWasAchievedOffline;
};
struct native NamedSession 
{
    var array<OnlineRegistrant> Registrants;
    var array<OnlineArbitrationRegistrant> ArbitrationRegistrants;
    var const transient native Pointer SessionInfo;
    var Name SessionName;
    var OnlineGameSettings GameSettings;
};
struct native CommunityContentMetadata 
{
    var array<SettingsProperty> MetadataItems;
    var int ContentType;
};
struct native CommunityContentFile 
{
    var UniqueNetId Owner;
    var string LocalFilePath;
    var int ContentId;
    var int FileId;
    var int ContentType;
    var int FileSize;
    var int DownloadCount;
    var float AverageRating;
    var int RatingCount;
    var int LastRatingGiven;
};
struct native TitleFile 
{
    var string Filename;
    var array<byte> Data;
    var EOnlineEnumerationReadState AsyncState;
    
    structdefaultproperties
    {
        Data = ""
    }
};
struct native NamedInterfaceDef 
{
    var string InterfaceClassName;
    var Name InterfaceName;
};
struct native NamedInterface 
{
    var Name InterfaceName;
    var Object InterfaceObject;
};
struct native OnlineFriendMessage 
{
    var UniqueNetId SendingPlayerId;
    var string SendingPlayerNick;
    var string Message;
    var bool bIsFriendInvite;
    var bool bIsGameInvite;
    var bool bWasAccepted;
    var bool bWasDenied;
};
struct native RemoteTalker 
{
    var UniqueNetId TalkerId;
    var bool bWasTalking;
    var bool bIsTalking;
    var bool bIsRegistered;
};
struct native LocalTalker 
{
    var bool bHasVoice;
    var bool bHasNetworkedVoice;
    var bool bIsRecognizingSpeech;
    var bool bWasTalking;
    var bool bIsTalking;
    var bool bIsRegistered;
};
enum EOnlineAccountCreateStatus
{
    OACS_CreateSuccessful,
    OACS_UnknownError,
    OACS_InvalidUserName,
    OACS_InvalidPassword,
    OACS_InvalidUniqueUserName,
    OACS_UniqueUserNameInUse,
    OACS_ServiceUnavailable,
};
struct native OnlinePlayerScore 
{
    var UniqueNetId PlayerID;
    var int TeamID;
    var int Score;
};
enum ELanBeaconState
{
    LANB_NotUsingLanBeacon,
    LANB_Hosting,
    LANB_Searching,
};
struct SpeechRecognizedWord 
{
    var int WordId;
    var string WordText;
    var float Confidence;
};
struct native OnlineArbitrationRegistrant extends OnlineRegistrant 
{
    var const QWord MachineId;
    var const int Trustworthiness;
};
struct native OnlineRegistrant 
{
    var const UniqueNetId PlayerNetId;
};
enum ENATType
{
    NAT_Unknown,
    NAT_Open,
    NAT_Moderate,
    NAT_Strict,
};
enum EOnlineServerConnectionStatus
{
    OSCS_NotConnected,
    OSCS_Connected,
    OSCS_ConnectionDropped,
    OSCS_NoNetworkConnection,
    OSCS_ServiceUnavailable,
    OSCS_UpdateRequired,
    OSCS_ServersTooBusy,
    OSCS_DuplicateLoginDetected,
    OSCS_InvalidUser,
};
struct native OnlineContent 
{
    var string FriendlyName;
    var string ContentPath;
    var array<string> ContentPackages;
    var array<string> ContentFiles;
    var int UserIndex;
};
struct native OnlineFriend 
{
    var const UniqueNetId UniqueId;
    var const QWord SessionId;
    var const string NickName;
    var const string PresenceInfo;
    var const bool bIsOnline;
    var const bool bIsPlaying;
    var const bool bIsPlayingThisGame;
    var const bool bIsJoinable;
    var const bool bHasVoiceSupport;
    var bool bHaveInvited;
    var const bool bHasInvitedYou;
    var const EOnlineFriendState FriendState;
};
enum EOnlineFriendState
{
    OFS_Offline,
    OFS_Online,
    OFS_Away,
    OFS_Busy,
};
enum EOnlineEnumerationReadState
{
    OERS_NotStarted,
    OERS_InProgress,
    OERS_Done,
    OERS_Failed,
};
enum EOnlineGameState
{
    OGS_NoSession,
    OGS_Pending,
    OGS_Starting,
    OGS_InProgress,
    OGS_Ending,
    OGS_Ended,
};
enum ENetworkNotificationPosition
{
    NNP_TopLeft,
    NNP_TopCenter,
    NNP_TopRight,
    NNP_CenterLeft,
    NNP_Center,
    NNP_CenterRight,
    NNP_BottomLeft,
    NNP_BottomCenter,
    NNP_BottomRight,
};
struct native FriendsQuery 
{
    var UniqueNetId UniqueId;
    var bool bIsFriend;
};
enum EFeaturePrivilegeLevel
{
    FPL_Disabled,
    FPL_EnabledFriendsOnly,
    FPL_Enabled,
};
enum ELoginStatus
{
    LS_NotLoggedIn,
    LS_UsingLocalProfile,
    LS_LoggedIn,
};
struct native UniqueNetId 
{
    var QWord Uid;
};

var const native noexport Pointer VfTable_FTickableObject;
var array<NamedInterface> NamedInterfaces;
var config array<NamedInterfaceDef> NamedInterfaceDefs;
var const array<NamedSession> Sessions;
var OnlineAccountInterface AccountInterface;
var OnlinePlayerInterface PlayerInterface;
var OnlinePlayerInterfaceEx PlayerInterfaceEx;
var OnlineSystemInterface SystemInterface;
var OnlineGameInterface GameInterface;
var OnlineContentInterface ContentInterface;
var OnlineVoiceInterface VoiceInterface;
var OnlineStatsInterface StatsInterface;
var OnlineNewsInterface NewsInterface;
var OnlinePartyChatInterface PartyChatInterface;
var config int BuildIdOverride;
var config float AsyncMinCompletionTime;
var config bool bUseBuildIdOverride;

public static final native function bool AreUniqueNetIdsEqual(const out UniqueNetId NetIdA, const out UniqueNetId NetIdB);

public event function Exit();

public native function int GetBioDynamicBuildVersion();

public native function int GetBioStaticBuildVersion();

public native function int GetBuildUniqueId();

public event function Object GetNamedInterface(Name InterfaceName)
{
    local int InterfaceIndex;
    
    InterfaceIndex = NamedInterfaces.Find('InterfaceName', InterfaceName);
    if (InterfaceIndex != -1)
    {
        return NamedInterfaces[InterfaceIndex].InterfaceObject;
    }
    return None;
}
public static final native function int GetNumSupportedLogins();

public event native function bool Init();

public event function bool PostInit()
{
    return TRUE;
}
public event function bool SetAccountInterface(Object NewInterface)
{
    AccountInterface = OnlineAccountInterface(NewInterface);
    return AccountInterface != None;
}
public event function bool SetContentInterface(Object NewInterface)
{
    ContentInterface = OnlineContentInterface(NewInterface);
    return ContentInterface != None;
}
public event function bool SetGameInterface(Object NewInterface)
{
    GameInterface = OnlineGameInterface(NewInterface);
    return GameInterface != None;
}
public event function SetNamedInterface(Name InterfaceName, Object NewInterface)
{
    local int InterfaceIndex;
    
    InterfaceIndex = NamedInterfaces.Find('InterfaceName', InterfaceName);
    if (InterfaceIndex == -1)
    {
        InterfaceIndex = NamedInterfaces.Length;
        NamedInterfaces.Length = NamedInterfaces.Length + 1;
        NamedInterfaces[InterfaceIndex].InterfaceName = InterfaceName;
    }
    NamedInterfaces[InterfaceIndex].InterfaceObject = NewInterface;
}
public event function bool SetNewsInterface(Object NewInterface)
{
    NewsInterface = OnlineNewsInterface(NewInterface);
    return NewsInterface != None;
}
public event function bool SetPartyChatInterface(Object NewInterface)
{
    PartyChatInterface = OnlinePartyChatInterface(NewInterface);
    return PartyChatInterface != None;
}
public event function bool SetPlayerInterface(Object NewInterface)
{
    PlayerInterface = OnlinePlayerInterface(NewInterface);
    return PlayerInterface != None;
}
public event function bool SetPlayerInterfaceEx(Object NewInterface)
{
    PlayerInterfaceEx = OnlinePlayerInterfaceEx(NewInterface);
    return PlayerInterfaceEx != None;
}
public event function bool SetStatsInterface(Object NewInterface)
{
    StatsInterface = OnlineStatsInterface(NewInterface);
    return StatsInterface != None;
}
public event function bool SetSystemInterface(Object NewInterface)
{
    SystemInterface = OnlineSystemInterface(NewInterface);
    return SystemInterface != None;
}
public event function bool SetVoiceInterface(Object NewInterface)
{
    VoiceInterface = OnlineVoiceInterface(NewInterface);
    return VoiceInterface != None;
}
public static final native function bool StringToUniqueNetId(string UniqueNetIdString, out UniqueNetId out_UniqueId);

public static final native function string UniqueNetIdToString(const out UniqueNetId IdToConvert);

public static function DumpGameSettings(const OnlineGameSettings GameSettings)
{
}
public static function DumpNetIds(const out array<UniqueNetId> Players, string DebugLabel);

public function DumpSessionState()
{
    local int Index;
    local int PlayerIndex;
    local UniqueNetId NetId;
    local UniqueNetId ZeroId;
    
    NetId = ZeroId;
    ZeroId = NetId;
    for (Index = 0; Index < Sessions.Length; Index++)
    {
        DumpGameSettings(Sessions[Index].GameSettings);
        for (PlayerIndex = 0; PlayerIndex < Sessions[Index].Registrants.Length; PlayerIndex++)
        {
            NetId = Sessions[Index].Registrants[PlayerIndex].PlayerNetId;
        }
        for (PlayerIndex = 0; PlayerIndex < Sessions[Index].ArbitrationRegistrants.Length; PlayerIndex++)
        {
            NetId = Sessions[Index].ArbitrationRegistrants[PlayerIndex].PlayerNetId;
        }
    }
}
public function DumpVoiceRegistration();

public function SetDebugSpewLevel(int DebugSpewLevel);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}