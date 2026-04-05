Class OnlineGameplayEvents
    native;

struct native PlayerEvent 
{
    var Vector EventLocation;
    var float EventTime;
    var int PlayerIndexAndYaw;
    var int PlayerPitchAndRoll;
};
struct native GameplayEvent 
{
    var int PlayerEventAndTarget;
    var int EventNameAndDesc;
};
struct native PlayerInformation 
{
    var UniqueNetId UniqueId;
    var string ControllerName;
    var string PlayerName;
    var int LastPlayerEventIdx;
    var bool bIsBot;
};

var const array<PlayerInformation> PlayerList;
var const array<string> EventDescList;
var const array<Name> EventNames;
var const array<GameplayEvent> GameplayEvents;
var const array<PlayerEvent> PlayerEvents;
var const string GameplaySessionStartTime;
var const Guid GameplaySessionID;
var const bool bGameplaySessionInProgress;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}