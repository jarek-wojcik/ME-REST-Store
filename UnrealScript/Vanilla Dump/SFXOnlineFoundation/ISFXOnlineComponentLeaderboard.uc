Class ISFXOnlineComponentLeaderboard extends ISFXOnlineComponent
    native
    abstract;

struct native unkstructflag RankBypassNotification 
{
    var init string sEntityName;
    var init bool bBeatenByMe;
};
struct native unkstructflag LeaderboardMapGroup 
{
    var init string MapName;
    var init array<LeaderboardDefinition> Entries;
};
struct native unkstructflag LeaderboardDefinition 
{
    var init string sPrettyName;
    var init int nID;
    var init bool bFriends;
};

var delegate<OnReadLbListCompleted> __OnReadLbListCompleted__Delegate;
var delegate<OnGetRankNotificationsCompleted> __OnGetRankNotificationsCompleted__Delegate;
var delegate<OnResultsRetrieved> __OnResultsRetrieved__Delegate;

public event function AddRankNotificationCallback(delegate<OnGetRankNotificationsCompleted> Callback);

public final native function CancelLeaderboardRequests();

public native function FlushRankNotifications();

public final native function int GetFriendLeaderboardData(int pLbId, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public final native function int GetLeaderboardCenteredData(int pLbId, UniqueNetId nPlayerId, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public final native function int GetLeaderboardData(int pLbId, int nRankStart, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public final native function bool GetLeaderboardDefinitions(out array<LeaderboardDefinition> aLBDefinitions);

public final native function bool GetLeaderboardDefinitionTable(out array<LeaderboardMapGroup> aLBDefTableRows);

public native function GetRankNotifications();

public delegate function OnGetRankNotificationsCompleted(array<RankBypassNotification> RankBypassNotificationArray);

public delegate function OnReadLbListCompleted(byte errorCode);

public delegate function OnResultsRetrieved(array<LeaderboardColumn> aColumnInfo, array<LeaderboardRecord> aResults, int iTotalRanks, UniqueNetId uidEntity, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public final native function ReadLeaderboardList(delegate<OnReadLbListCompleted> funcReadLbListCompleted, out array<int> jobIds);

public event function RemoveRankNotificationCallback(delegate<OnGetRankNotificationsCompleted> Callback);

public final native function RequestLeaderboardCenteredData(LeaderboardDefinition LeaderboardDef, UniqueNetId nPlayerId, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public final native function RequestLeaderboardData(LeaderboardDefinition LeaderboardDef, int nRankStart, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public final native function RequestReadLeaderboardList();

public final native function int ShowGamerCardForRecord(byte LocalUserNum, const out LeaderboardRecord Record);

public function array<RankBypassNotification> GetCurrentRankNotificationsArray();

public function bool HasNotificationsAvailable();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}