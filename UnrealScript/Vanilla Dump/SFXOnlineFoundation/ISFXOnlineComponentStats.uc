Class ISFXOnlineComponentStats extends ISFXOnlineComponent
    native
    abstract;

var delegate<OnReadStatsGroupListCompleted> __OnReadStatsGroupListCompleted__Delegate;
var delegate<OnResultsRetrieved> __OnResultsRetrieved__Delegate;

public native function int GetFriendsStatsData(out LeaderboardStatScope oScope, int nRankRange, delegate<OnResultsRetrieved> funcResultsRetrieved, optional Pointer pExternalData);

public delegate function OnReadStatsGroupListCompleted(byte errorCode);

public delegate function OnResultsRetrieved(array<LeaderboardColumn> aColumnInfo, array<LeaderboardRecord> aResults, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public final native function int ReadStatsGroupList(delegate<OnReadStatsGroupListCompleted> funcReadStatsGroupListCompleted);

public final native function RequestReadStatsGroupList();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}