Class OnlineStatsWrite extends OnlineStats
    native
    abstract;

var const array<StringIdToStringMapping> StatMappings;
var const array<SettingsProperty> Properties;
var array<int> ViewIds;
var array<int> ArbitratedViewIds;
var delegate<OnStatsWriteComplete> __OnStatsWriteComplete__Delegate;
var const int RatingId;

public native function DecrementFloatStat(int StatId, optional float DecBy = 1.0);

public native function DecrementIntStat(int StatId, optional int DecBy = 1);

public native function bool GetStatId(Name StatName, out int StatId);

public native function Name GetStatName(int StatId);

public native function IncrementFloatStat(int StatId, optional float IncBy = 1.0);

public native function IncrementIntStat(int StatId, optional int IncBy = 1);

public delegate function OnStatsWriteComplete();

public native function SetFloatStat(int StatId, float Value);

public native function SetIntStat(int StatId, int Value);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}