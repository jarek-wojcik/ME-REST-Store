Class OnlineGameSearch extends Settings
    native;

struct native OnlineGameSearchQuery 
{
    var array<OnlineGameSearchORClause> OrClauses;
    var array<OnlineGameSearchSortClause> SortClauses;
};
struct native OnlineGameSearchORClause 
{
    var array<OnlineGameSearchParameter> OrParams;
};
struct native OnlineGameSearchSortClause 
{
    var Name ObjectPropertyName;
    var int EntryId;
    var EOnlineGameSearchEntryType EntryType;
    var EOnlineGameSearchSortType SortType;
};
enum EOnlineGameSearchSortType
{
    OGSSO_Ascending,
    OGSSO_Descending,
};
struct native OnlineGameSearchParameter 
{
    var Name ObjectPropertyName;
    var int EntryId;
    var EOnlineGameSearchEntryType EntryType;
    var EOnlineGameSearchComparisonType ComparisonType;
};
enum EOnlineGameSearchComparisonType
{
    OGSCT_Equals,
    OGSCT_NotEquals,
    OGSCT_GreaterThan,
    OGSCT_GreaterThanEquals,
    OGSCT_LessThan,
    OGSCT_LessThanEquals,
};
enum EOnlineGameSearchEntryType
{
    OGSET_Property,
    OGSET_LocalizedSetting,
    OGSET_ObjectProperty,
};
struct native NamedObjectProperty 
{
    var string ObjectPropertyValue;
    var Name ObjectPropertyName;
};
struct native OverrideSkill 
{
    var array<UniqueNetId> Players;
    var array<Double> Mus;
    var array<Double> Sigmas;
    var int LeaderboardId;
};
struct native OnlineGameSearchResult 
{
    var const native Pointer PlatformData;
    var const OnlineGameSettings GameSettings;
};

var OverrideSkill ManualSkillOverride;
var const OnlineGameSearchQuery FilterQuery;
var const array<OnlineGameSearchResult> Results;
var array<NamedObjectProperty> NamedProperties;
var string AdditionalSearchCriteria;
var Class<OnlineGameSettings> GameSettingsClass;
var LocalizedStringSetting Query;
var int MaxSearchResults;
var int PingBucketSize;
var databinding bool bIsLanQuery;
var databinding bool bUsesArbitration;
var const bool bIsSearchInProgress;

public event native function SortSearchResults();

public function SetSkillOverride(int LeaderboardId, const out array<UniqueNetId> Players)
{
    ManualSkillOverride.LeaderboardId = LeaderboardId;
    ManualSkillOverride.Players = Players;
    ManualSkillOverride.Mus.Length = 0;
    ManualSkillOverride.Sigmas.Length = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GameSettingsClass = Class'OnlineGameSettings'
    MaxSearchResults = 25
    PingBucketSize = 50
}