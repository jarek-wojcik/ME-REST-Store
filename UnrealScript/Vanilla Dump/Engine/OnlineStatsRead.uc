Class OnlineStatsRead extends OnlineStats
    native
    abstract;

struct native ColumnMetaData 
{
    var const localized string ColumnName;
    var const Name Name;
    var const int Id;
};
struct native OnlineStatsRow 
{
    var const UniqueNetId PlayerID;
    var const SettingsData Rank;
    var const string NickName;
    var array<OnlineStatsColumn> Columns;
};
struct native OnlineStatsColumn 
{
    var SettingsData StatValue;
    var int ColumnNo;
};

var const array<int> ColumnIds;
var array<OnlineStatsRow> Rows;
var const array<ColumnMetaData> ColumnMappings;
var const string ViewName;
var int ViewId;
var const int SortColumnId;
var const int TotalRowsInView;
var const int TitleId;

public native function AddPlayer(string PlayerName, UniqueNetId PlayerID);

public native function bool GetFloatStatValueForPlayer(UniqueNetId PlayerID, int StatColumnNo, out float StatValue);

public native function bool GetIntStatValueForPlayer(UniqueNetId PlayerID, int StatColumnNo, out int StatValue);

public native function int GetRankForPlayer(UniqueNetId PlayerID);

public event function OnReadComplete();

public native function bool SetFloatStatValueForPlayer(UniqueNetId PlayerID, int StatColumnNo, float StatValue);

public native function bool SetIntStatValueForPlayer(UniqueNetId PlayerID, int StatColumnNo, int StatValue);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}