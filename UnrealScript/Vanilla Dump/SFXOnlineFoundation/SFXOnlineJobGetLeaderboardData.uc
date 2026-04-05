Class SFXOnlineJobGetLeaderboardData extends SFXOnlineJob
    native
    config(Game);

var UniqueNetId mPlayerId;
var LeaderboardStatScope Scope;
var delegate<OnJobCompletion> __OnJobCompletion__Delegate;
var delegate<OnResultsRetrieved> __OnResultsRetrieved__Delegate;
var native Pointer ExternalData;
var int nLeaderboardId;
var int nRankStart;
var int nRankRange;
var bool bCenteredLeaderboard;
var bool bFriendLeaderboard;

public static event function SFXOnlineJobGetLeaderboardData CreateCenteredLeaderboardJob(int LeaderboardId, UniqueNetId PlayerID, int RankRange, delegate<OnResultsRetrieved> ResultsRetrievedDelegate, optional Pointer pExternalData)
{
    local SFXOnlineJobGetLeaderboardData Job;
    
    Job = new Class'SFXOnlineJobGetLeaderboardData';
    Job.nLeaderboardId = LeaderboardId;
    Job.mPlayerId = PlayerID;
    Job.nRankRange = RankRange;
    Job.__OnJobCompletion__Delegate = Job.JobCompleted;
    Job.__OnResultsRetrieved__Delegate = ResultsRetrievedDelegate;
    Job.bCenteredLeaderboard = TRUE;
    Job.bFriendLeaderboard = FALSE;
    Job.ExternalData = pExternalData;
    return Job;
}
public static event function SFXOnlineJobGetLeaderboardData CreateFriendLeaderboardJob(int LeaderboardId, delegate<OnResultsRetrieved> ResultsRetrievedDelegate, optional Pointer pExternalData)
{
    local SFXOnlineJobGetLeaderboardData Job;
    
    Job = new Class'SFXOnlineJobGetLeaderboardData';
    Job.nLeaderboardId = LeaderboardId;
    Job.__OnJobCompletion__Delegate = Job.JobCompleted;
    Job.__OnResultsRetrieved__Delegate = ResultsRetrievedDelegate;
    Job.bCenteredLeaderboard = FALSE;
    Job.bFriendLeaderboard = TRUE;
    Job.ExternalData = pExternalData;
    return Job;
}
public static event function SFXOnlineJobGetLeaderboardData CreateFriendStatsDataJob(LeaderboardStatScope oScope, int RankRange, delegate<OnResultsRetrieved> ResultsRetrievedDelegate, optional Pointer pExternalData)
{
    local SFXOnlineJobGetLeaderboardData Job;
    
    Job = new Class'SFXOnlineJobGetLeaderboardData';
    Job.Scope = oScope;
    Job.nRankRange = RankRange;
    Job.__OnJobCompletion__Delegate = Job.JobCompleted;
    Job.__OnResultsRetrieved__Delegate = ResultsRetrievedDelegate;
    Job.bCenteredLeaderboard = FALSE;
    Job.bFriendLeaderboard = FALSE;
    Job.ExternalData = pExternalData;
    return Job;
}
public static event function SFXOnlineJobGetLeaderboardData CreateLeaderboardJob(int LeaderboardId, int RankStart, int RankRange, delegate<OnResultsRetrieved> ResultsRetrievedDelegate, optional Pointer pExternalData)
{
    local SFXOnlineJobGetLeaderboardData Job;
    
    Job = new Class'SFXOnlineJobGetLeaderboardData';
    Job.nLeaderboardId = LeaderboardId;
    Job.nRankStart = RankStart;
    Job.nRankRange = RankRange;
    Job.__OnJobCompletion__Delegate = Job.JobCompleted;
    Job.__OnResultsRetrieved__Delegate = ResultsRetrievedDelegate;
    Job.bCenteredLeaderboard = FALSE;
    Job.bFriendLeaderboard = FALSE;
    Job.ExternalData = pExternalData;
    return Job;
}
public native function JobCompleted(array<LeaderboardColumn> aColumInfo, array<LeaderboardRecord> aResults, int iTotalRanks, UniqueNetId uidEntity, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public delegate function OnJobCompletion(array<LeaderboardColumn> aColumInfo, array<LeaderboardRecord> aResults, int iTotalRanks, UniqueNetId uidEntity, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public delegate function OnResultsRetrieved(array<LeaderboardColumn> aColumInfo, array<LeaderboardRecord> aResults, int iTotalRanks, UniqueNetId uidEntity, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public native function bool DoExecute();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RescheduleCount = 3
    JobCategory = OnlineJobCategory.OJC_Leaderboards
    JobType = OnlineJobType.OJT_GetLeaderboardData
}