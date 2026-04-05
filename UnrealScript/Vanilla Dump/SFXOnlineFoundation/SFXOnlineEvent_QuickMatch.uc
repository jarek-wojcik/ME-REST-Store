Class SFXOnlineEvent_QuickMatch extends SFXOnlineEvent
    native;

enum SFXOnlineQuickMatchOutcome
{
    SFXONLINE_MATCHMAKER_IN_PROGRESS,
    SFXONLINE_MATCHMAKER_CREATE,
    SFXONLINE_MATCHMAKER_JOIN,
    SFXONLINE_MATCHMAKER_SEARCH_TIMEOUT,
    SFXONLINE_MATCHMAKER_FAILED,
};

var SFXOnlineGameSettings GameToCreate;
var int GameId;
var SFXOnlineQuickMatchOutcome SearchOutcome;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EventType = SFXOnlineEventType.SFXONLINE_EVENT_QUICKMATCH
}