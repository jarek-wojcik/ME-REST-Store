Class SFXOnlineComponentBlazeLeaderboard extends SFXOnlineComponentBlaze
    implements(ISFXOnlineComponentLeaderboard)
    native
    config(Game);

struct native LeaderboardNameFormula 
{
    var string Name;
    var bool AppendLocaleCode;
};
struct native LeaderboardScopeDefinition 
{
    var string KeyScope;
    var array<QWord> StartKeyScopeValue;
    var array<QWord> EndKeyScopeValue;
};
struct native LeaderboardId 
{
    var string sLbName;
    var LeaderboardStatScope Scope;
};
struct native unkstructflag BlazeRequest 
{
    var init UniqueNetId pUniquePlayerId;
    var init LeaderboardStatScope Scope;
    var native init Pointer pJobId;
    var native init Pointer pExternalData;
    var init int nRequestedRecordsStartRank;
    var init int nRequestedRecordsRange;
    var init bool bRequestedCenteredData;
    var init bool bRequestedFriendData;
};

var const native noexport Pointer VfTable_IISFXOnlineComponentLeaderboard;
var const native noexport Pointer VfTable_Blaze::BlazeStateEventHandler;
var native array<LeaderboardDefinition> mLeaderboardDefinitions;
var native array<LeaderboardId> mLeaderboardIDs;
var native array<BlazeRequest> mBlazeDataRequests;
var config array<LeaderboardNameFormula> mLeaderboardNames;
var array<delegate<OnGetRankNotificationsCompleted>> RankNotificationCallbacks;
var array<RankBypassNotification> RankBypassNotifications;
var delegate<OnResultsRetrieved> __OnResultsRetrieved__Delegate;
var delegate<OnReadLbListCompleted> __OnReadLbListCompleted__Delegate;
var delegate<OnGetRankNotificationsCompleted> __OnGetRankNotificationsCompleted__Delegate;
var native Pointer mLeaderboardAPI;
var native Pointer mCurrentLeaderboard;
var native Pointer mGlobalLeaderboardView;
var config stringref srRankColumnHeader;
var config stringref srUserColumnHeader;
var config stringref srReplacementGlobalMapName;
var config stringref srFriendsDuplicateSuffix;
var int mLbInfoRetrievedCount;
var int mGlobalLbEntityCount;

public event function AddRankNotificationCallback(delegate<OnGetRankNotificationsCompleted> Callback)
{
    RankNotificationCallbacks.AddItem(Callback);
}
public final native function CancelLeaderboardRequests();

private final event function SFXOnlineJobGetLeaderboardData CreateJobGetFriendLeaderboardData(int nLBID, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData)
{
    return Class'SFXOnlineJobGetLeaderboardData'.static.CreateFriendLeaderboardJob(nLBID, funcResultsRetrieved, pExternalData);
}
private final event function SFXOnlineJobGetLeaderboardData CreateJobGetLeaderboardCenteredData(int nLBID, UniqueNetId nPlayerId, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData)
{
    return Class'SFXOnlineJobGetLeaderboardData'.static.CreateCenteredLeaderboardJob(nLBID, nPlayerId, nRankRange, funcResultsRetrieved, pExternalData);
}
private final event function SFXOnlineJobGetLeaderboardData CreateJobGetLeaderboardData(int nLBID, int nRankStart, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData)
{
    return Class'SFXOnlineJobGetLeaderboardData'.static.CreateLeaderboardJob(nLBID, nRankStart, nRankRange, funcResultsRetrieved, pExternalData);
}
private final event function SFXOnlineJobGetLeaderboardList CreateJobGetLeaderboardList()
{
    return Class'SFXOnlineJobGetLeaderboardList'.static.CreateGetLeaderboardListJob();
}
private final event function SFXOnlineJobGetLeaderboardData CreateJobGetStatsData(LeaderboardStatScope oScope, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData)
{
    return Class'SFXOnlineJobGetLeaderboardData'.static.CreateFriendStatsDataJob(oScope, nRankRange, funcResultsRetrieved, pExternalData);
}
public final native function FlushNotificationsFriendLeaderboardCb(array<LeaderboardColumn> aColumnInfo, array<LeaderboardRecord> aResults, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public native function FlushRankNotifications();

public native function Name GetAPIName();

public final native function int GetFriendLeaderboardData(int pLbId, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public native function int GetLeaderboard(int pLbId, int nRecordsStartRank, int nRecordsRange, bool bCenteredData, bool bFriendData, UniqueNetId pPlayerId, optional Pointer pExternalData);

public final native function int GetLeaderboardCenteredData(int pLbId, UniqueNetId nPlayerId, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public final native function int GetLeaderboardData(int pLbId, int nRankStart, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public final native function bool GetLeaderboardDefinitions(out array<LeaderboardDefinition> aLBDefinitions);

public final native function bool GetLeaderboardDefinitionTable(out array<LeaderboardMapGroup> aLBDefTableRows);

public native function GetRankNotifications();

private final function OnDisconnect(SFXOnlineEvent OnlineEvent)
{
    CancelLeaderboardRequests();
}
public delegate function OnGetRankNotificationsCompleted(array<RankBypassNotification> RankBypassNotificationArray);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public delegate function OnReadLbListCompleted(byte errorCode);

public native function OnRelease();

public delegate function OnResultsRetrieved(array<LeaderboardColumn> aColumnInfo, array<LeaderboardRecord> aResults, int iTotalRanks, UniqueNetId uidEntity, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public final native function RankNotificationFriendLeaderboardCb(array<LeaderboardColumn> aColumnInfo, array<LeaderboardRecord> aResults, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public final native function ReadLeaderboardList(delegate<OnReadLbListCompleted> funcReadLbListCompleted, out array<int> jobIds);

public event function RemoveRankNotificationCallback(delegate<OnGetRankNotificationsCompleted> Callback)
{
    RankNotificationCallbacks.RemoveItem(Callback);
}
public final native function RequestFriendLeaderboardData(delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public final native function RequestLeaderboardCenteredData(LeaderboardDefinition LeaderboardDef, UniqueNetId nPlayerId, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public final native function RequestLeaderboardData(LeaderboardDefinition LeaderboardDef, int nRankStart, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public final native function RequestReadLeaderboardList();

public final native function int ShowGamerCardForRecord(byte LocalUserNum, const out LeaderboardRecord Record);

private final event function TriggerEmptyCallback(LeaderboardStatsError nErrorCode)
{
    local array<LeaderboardColumn> aColumns;
    local array<LeaderboardRecord> aLeaderboardRecords;
    local int iTotalRanks;
    local UniqueNetId uidCenteredEntity;
    local Pointer pData;
    
    if (__OnResultsRetrieved__Delegate != None)
    {
        aColumns.Length = 0;
        aLeaderboardRecords.Length = 0;
        iTotalRanks = 0;
        __OnResultsRetrieved__Delegate(aColumns, aLeaderboardRecords, iTotalRanks, uidCenteredEntity, nErrorCode, pData);
        __OnResultsRetrieved__Delegate = None;
    }
}
public function array<RankBypassNotification> GetCurrentRankNotificationsArray()
{
    return RankBypassNotifications;
}
public function bool HasNotificationsAvailable()
{
    return RankBypassNotifications.Length > 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    mLeaderboardNames = ({Name = "N7RatingGlobal", AppendLocaleCode = FALSE}, 
                         {Name = "N7Rating", AppendLocaleCode = TRUE}
                        )
    srRankColumnHeader = $638070
    srUserColumnHeader = $638071
    srReplacementGlobalMapName = $660729
    srFriendsDuplicateSuffix = $679061
    EventSubscriberTable = ({EventCallback = 'OnDisconnect', EventType = SFXOnlineEventType.SFXONLINE_EVENT_PLATFORM_DISCONNECT}
                           )
}