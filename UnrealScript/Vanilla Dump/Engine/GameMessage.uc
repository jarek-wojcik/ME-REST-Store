Class GameMessage extends LocalMessage;

var const localized string SwitchLevelMessage;
var const localized string LeftMessage;
var const localized string FailedTeamMessage;
var const localized string FailedPlaceMessage;
var const localized string FailedSpawnMessage;
var const localized string EnteredMessage;
var const localized string MaxedOutMessage;
var const localized string ArbitrationMessage;
var const localized string OvertimeMessage;
var const localized string GlobalNameChange;
var const localized string NewTeamMessage;
var const localized string NewTeamMessageTrailer;
var const localized string NoNameChange;
var const localized string VoteStarted;
var const localized string VotePassed;
var const localized string MustHaveStats;
var const localized string CantBeSpectator;
var const localized string CantBePlayer;
var const localized string BecameSpectator;
var const localized string NewPlayerMessage;
var const localized string KickWarning;
var const localized string NewSpecMessage;
var const localized string SpecEnteredMessage;

public static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    switch (Switch)
    {
        case 0:
            return default.OvertimeMessage;
            break;
        case 1:
            if (RelatedPRI_1 == None)
            {
                return default.NewPlayerMessage;
            }
            return RelatedPRI_1.PlayerName $ default.EnteredMessage;
            break;
        case 2:
            if (RelatedPRI_1 == None)
            {
                return "";
            }
            return RelatedPRI_1.OldName @ default.GlobalNameChange @ RelatedPRI_1.PlayerName;
            break;
        case 3:
            if (RelatedPRI_1 == None)
            {
                return "";
            }
            if (OptionalObject == None)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName @ default.NewTeamMessage @ TeamInfo(OptionalObject).GetHumanReadableName() $ default.NewTeamMessageTrailer;
            break;
        case 4:
            if (RelatedPRI_1 == None)
            {
                return "";
            }
            return RelatedPRI_1.PlayerName $ default.LeftMessage;
            break;
        case 5:
            return default.SwitchLevelMessage;
            break;
        case 6:
            return default.FailedTeamMessage;
            break;
        case 7:
            return default.MaxedOutMessage;
            break;
        case 8:
            return default.NoNameChange;
            break;
        case 9:
            return RelatedPRI_1.PlayerName @ default.VoteStarted;
            break;
        case 10:
            return default.VotePassed;
            break;
        case 11:
            return default.MustHaveStats;
            break;
        case 12:
            return default.CantBeSpectator;
            break;
        case 13:
            return default.CantBePlayer;
            break;
        case 14:
            return RelatedPRI_1.PlayerName @ default.BecameSpectator;
            break;
        case 15:
            return default.KickWarning;
            break;
        case 16:
            if (RelatedPRI_1 == None)
            {
                return default.NewSpecMessage;
            }
            return RelatedPRI_1.PlayerName $ default.SpecEnteredMessage;
            break;
        default:
    }
    return "";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SwitchLevelMessage = "Switching Levels"
    LeftMessage = " left the game."
    FailedTeamMessage = "Could not find team for player"
    FailedPlaceMessage = "Could not find a starting spot"
    FailedSpawnMessage = "Could not spawn player"
    EnteredMessage = " entered the game."
    MaxedOutMessage = "Server is already at capacity."
    ArbitrationMessage = "The session has already started."
    OvertimeMessage = "Score tied at the end of regulation. Sudden Death Overtime!!!"
    GlobalNameChange = "changed name to"
    NewTeamMessage = "is now on"
    NoNameChange = "Name is already in use."
    VoteStarted = "started a vote."
    VotePassed = "Vote passed."
    MustHaveStats = "Must have stats enabled to join this server."
    CantBeSpectator = "Sorry, you cannot become a spectator at this time."
    CantBePlayer = "Sorry, you cannot become an active player at this time."
    BecameSpectator = "became a spectator."
    NewPlayerMessage = "A new player entered the game."
    KickWarning = "You are about to be kicked for idling!"
    NewSpecMessage = "A spectator entered the game/"
    SpecEnteredMessage = " joined as a spectator."
}