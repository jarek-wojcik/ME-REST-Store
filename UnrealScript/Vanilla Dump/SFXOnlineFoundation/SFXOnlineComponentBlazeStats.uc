Class SFXOnlineComponentBlazeStats extends SFXOnlineComponentBlaze
    implements(ISFXOnlineComponentStats, OnlineStatsInterface)
    native
    config(Engine);

struct native unkstructflag BlazeStatsRequest 
{
    var init UniqueNetId pUniquePlayerId;
    var init LeaderboardStatScope Scope;
    var native init Pointer pJobId;
    var native init Pointer pExternalData;
    var init int nRequestedRecordsRange;
};

var const native noexport Pointer VfTable_IISFXOnlineComponentStats;
var const native noexport Pointer VfTable_Blaze::BlazeStateEventHandler;
var native array<string> mStatsGroupNames;
var native array<BlazeStatsRequest> mBlazeStatsRequests;
var array<delegate<OnFlushOnlineStatsComplete>> FlushOnlineStatsCompleteDelegates;
var delegate<OnResultsRetrieved> __OnResultsRetrieved__Delegate;
var delegate<OnReadStatsGroupListCompleted> __OnReadStatsGroupListCompleted__Delegate;
var delegate<OnGetRankNotifications> __OnGetRankNotifications__Delegate;
var delegate<OnFlushOnlineStatsComplete> __OnFlushOnlineStatsComplete__Delegate;
var delegate<OnReadOnlineStatsComplete> __OnReadOnlineStatsComplete__Delegate;
var delegate<OnRegisterHostStatGuidComplete> __OnRegisterHostStatGuidComplete__Delegate;
var native Pointer mStatsAPI;
var SFXOnlineJobGameReporting mGameReportingJob;
var config stringref srRankColumnHeader;
var config stringref srUserColumnHeader;

private final event function SFXOnlineJobGameReporting CreateJobGameReporting(OnlineStatsWrite StatsWrite)
{
    return Class'SFXOnlineJobGameReporting'.static.CreateJob(GameReportingCallback, StatsWrite);
}
private final event function SFXOnlineJobGetStatsGroupList CreateJobGetStatsGroupList()
{
    return Class'SFXOnlineJobGetStatsGroupList'.static.CreateGetStatsGroupListJob();
}
public native function bool FlushOnlineStats(Name SessionName);

private final function GameReportingCallback(OnlineJobErrorCode eError, int nJob)
{
    local bool Success;
    local delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsDelegate;
    
    Success = eError == OnlineJobErrorCode.OJEC_None;
    foreach FlushOnlineStatsCompleteDelegates(FlushOnlineStatsDelegate, )
    {
        FlushOnlineStatsDelegate('Game', Success);
    }
}
public native function Name GetAPIName();

public native function int GetFriendsStatsData(out LeaderboardStatScope oScope, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public native function bool GetStatsGroupNames(out array<string> aStatsGroupNames);

public delegate function OnFlushOnlineStatsComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnGetRankNotifications(byte errorCode);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public delegate function OnReadOnlineStatsComplete(bool bWasSuccessful);

public delegate function OnReadStatsGroupListCompleted(byte errorCode);

public delegate function OnRegisterHostStatGuidComplete(bool bWasSuccessful);

public native function OnRelease();

public delegate function OnResultsRetrieved(array<LeaderboardColumn> aColumnInfo, array<LeaderboardRecord> aResults, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public final native function int ReadStatsGroupList(delegate<OnReadStatsGroupListCompleted> funcReadStatsGroupListCompleted);

public final native function RequestReadStatsGroupList();

public native function bool WriteOnlineStats(Name SessionName, UniqueNetId Player, OnlineStatsWrite StatsWrite);

public function AddFlushOnlineStatsCompleteDelegate(delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsCompleteDelegate)
{
    if (FlushOnlineStatsCompleteDelegates.Find(FlushOnlineStatsCompleteDelegate) == -1)
    {
        FlushOnlineStatsCompleteDelegates.AddItem(FlushOnlineStatsCompleteDelegate);
    }
}
public function AddReadOnlineStatsCompleteDelegate(delegate<OnReadOnlineStatsComplete> ReadOnlineStatsCompleteDelegate);

public function AddRegisterHostStatGuidCompleteDelegate(delegate<OnRegisterHostStatGuidComplete> RegisterHostStatGuidCompleteDelegate);

public function ClearFlushOnlineStatsCompleteDelegate(delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsCompleteDelegate)
{
    FlushOnlineStatsCompleteDelegates.RemoveItem(FlushOnlineStatsCompleteDelegate);
}
public function ClearReadOnlineStatsCompleteDelegate(delegate<OnReadOnlineStatsComplete> ReadOnlineStatsCompleteDelegate);

public function ClearRegisterHostStatGuidCompleteDelegateDelegate(delegate<OnRegisterHostStatGuidComplete> RegisterHostStatGuidCompleteDelegate);

public function FreeStats(OnlineStatsRead StatsRead);

public function string GetClientStatGuid();

public function string GetHostStatGuid();

public function bool ReadOnlineStats(const out array<UniqueNetId> Players, OnlineStatsRead StatsRead);

public function bool ReadOnlineStatsByRank(OnlineStatsRead StatsRead, optional int StartIndex = 1, optional int NumToRead = 100);

public function bool ReadOnlineStatsByRankAroundPlayer(byte LocalUserNum, OnlineStatsRead StatsRead, optional int NumRows = 10);

public function bool ReadOnlineStatsForFriends(byte LocalUserNum, OnlineStatsRead StatsRead);

public function bool RegisterHostStatGuid(const out string HostStatGuid);

public function bool RegisterStatGuid(UniqueNetId PlayerID, const out string ClientStatGuid);

public function bool WriteOnlinePlayerScores(Name SessionName, int LeaderboardId, const out array<OnlinePlayerScore> PlayerScores);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    srRankColumnHeader = $638070
    srUserColumnHeader = $638071
}