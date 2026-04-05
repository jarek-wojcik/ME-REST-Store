Class OnlineGameSettings extends Settings
    native;

var const QWord ServerNonce;
var UniqueNetId OwningPlayerId;
var databinding string OwningPlayerName;
var databinding int NumPublicConnections;
var databinding int NumPrivateConnections;
var databinding int NumOpenPublicConnections;
var databinding int NumOpenPrivateConnections;
var databinding int PingInMs;
var databinding float MatchQuality;
var const int BuildUniqueId;
var databinding bool bShouldAdvertise;
var databinding bool bIsLanMatch;
var databinding bool bUsesStats;
var databinding bool bAllowJoinInProgress;
var databinding bool bAllowInvites;
var databinding bool bUsesPresence;
var databinding bool bAllowJoinViaPresence;
var databinding bool bAllowJoinViaPresenceFriendsOnly;
var databinding bool bUsesArbitration;
var databinding bool bAntiCheatProtected;
var const bool bWasFromInvite;
var databinding bool bIsDedicated;
var const bool bHasSkillUpdateInProgress;
var const databinding EOnlineGameState GameState;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bShouldAdvertise = TRUE
    bUsesStats = TRUE
    bAllowJoinInProgress = TRUE
    bAllowInvites = TRUE
    bUsesPresence = TRUE
    bAllowJoinViaPresence = TRUE
}