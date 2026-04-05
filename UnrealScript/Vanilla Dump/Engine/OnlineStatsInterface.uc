Class OnlineStatsInterface extends Interface
    abstract;

var delegate<OnFlushOnlineStatsComplete> __OnFlushOnlineStatsComplete__Delegate;
var delegate<OnRegisterHostStatGuidComplete> __OnRegisterHostStatGuidComplete__Delegate;
var delegate<OnReadOnlineStatsComplete> __OnReadOnlineStatsComplete__Delegate;

public function bool FlushOnlineStats(Name SessionName);

public delegate function OnFlushOnlineStatsComplete(Name SessionName, bool bWasSuccessful);

public delegate function OnReadOnlineStatsComplete(bool bWasSuccessful);

public delegate function OnRegisterHostStatGuidComplete(bool bWasSuccessful);

public function bool WriteOnlineStats(Name SessionName, UniqueNetId Player, OnlineStatsWrite StatsWrite);

public function AddFlushOnlineStatsCompleteDelegate(delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsCompleteDelegate);

public function AddReadOnlineStatsCompleteDelegate(delegate<OnReadOnlineStatsComplete> ReadOnlineStatsCompleteDelegate);

public function AddRegisterHostStatGuidCompleteDelegate(delegate<OnRegisterHostStatGuidComplete> RegisterHostStatGuidCompleteDelegate);

public function ClearFlushOnlineStatsCompleteDelegate(delegate<OnFlushOnlineStatsComplete> FlushOnlineStatsCompleteDelegate);

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
}