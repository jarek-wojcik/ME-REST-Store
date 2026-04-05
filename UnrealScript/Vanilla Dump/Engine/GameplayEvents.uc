Class GameplayEvents
    native
    abstract;

struct native PawnClassEventData 
{
    var string PawnClassName;
};
struct native ProjectileClassEventData 
{
    var string ProjectileClassName;
};
struct native DamageClassEventData 
{
    var string DamageClassName;
};
struct native WeaponClassEventData 
{
    var string WeaponClassName;
};
struct native GameplayEventMetaData 
{
    var const Name EventName;
    var const int EventId;
    var const int MaxValue;
    var const EPropertyValueMappingType MappingType;
};
struct native PlayerInformationNew 
{
    var string ControllerName;
    var string PlayerName;
    var bool bIsBot;
};
struct native TeamInformation 
{
    var string TeamName;
    var int TeamIndex;
    var Color TeamColor;
    var int MaxSize;
};
struct native GameSessionInformation 
{
    var string Language;
    var const string GameplaySessionTimestamp;
    var const string GameplaySessionID;
    var const string GameClassName;
    var const string MapName;
    var const string MapURL;
    var int AppTitleID;
    var int PlatformType;
    var const float GameplaySessionStartTime;
    var const float GameplaySessionEndTime;
    var const bool bGameplaySessionInProgress;
};
struct native GameplayEventsHeader 
{
    var const int EngineVersion;
    var const int StatsWriterVersion;
    var const int StreamOffset;
    var const int FooterOffset;
    var const int TotalStreamSize;
    var const int FileSize;
};

var GameSessionInformation CurrentSessionInfo;
var const string StatsFileName;
var const array<PlayerInformationNew> PlayerList;
var const array<TeamInformation> TeamList;
var array<GameplayEventMetaData> SupportedEvents;
var array<WeaponClassEventData> WeaponClassArray;
var array<DamageClassEventData> DamageClassArray;
var array<ProjectileClassEventData> ProjectileClassArray;
var array<PawnClassEventData> PawnClassArray;
var array<string> ActorArray;
var array<string> SoundCueArray;
var const native Pointer Archive;
var GameplayEventsHeader Header;

public function CloseStatsFile();

public function string GetFilename()
{
    return StatsFileName;
}
public function bool OpenStatsFile(string Filename);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SupportedEvents = ({EventName = 'UNKNOWN', EventId = -1, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'MATCH STARTED', EventId = 0, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'MATCH ENDED', EventId = 1, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'ROUND STARTED', EventId = 2, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'ROUND ENDED', EventId = 3, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'MATCH WON', EventId = 4, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'MATCH LOST', EventId = 5, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'GAME TYPE', EventId = 6, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'GAME OPTIONS', EventId = 7, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'MAP NAME', EventId = 8, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'GAME SCORE', EventId = 9, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'TEAM FORMED', EventId = 50, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'TEAM SCORE UPDATE', EventId = 51, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'PLAYER LOGGED IN', EventId = 100, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'PLAYER LOGGED OUT', EventId = 101, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'PLAYER KILLED', EventId = 104, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'PLAYER TEAM CHANGE', EventId = 106, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'PLAYER SPAWNED', EventId = 102, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'PLAYER LOCATIONS', EventId = 105, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'KILL STREAK', EventId = 107, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'RECORD PLAYER WIN/LOSS', EventId = 103, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'WEAPON DAMAGE', EventId = 150, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'MELEE DAMAGE', EventId = 151, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'WEAPON FIRED', EventId = 152, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'NORMAL KILL', EventId = 200, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'MEMORY USAGE', EventId = 35, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'NETWORK USAGE IN', EventId = 37, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'NETWORK USAGE OUT', EventId = 38, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'Ping', EventId = 39, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}, 
                       {EventName = 'FRAME RATE', EventId = 36, MaxValue = 1, MappingType = EPropertyValueMappingType.PVMT_RawValue}
                      )
}