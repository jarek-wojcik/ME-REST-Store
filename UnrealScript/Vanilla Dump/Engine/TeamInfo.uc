Class TeamInfo extends ReplicationInfo
    native
    nativereplication;

var const localized databinding string TeamName;
var databinding int Size;
var databinding float Score;
var repnotify databinding int TeamIndex;
var databinding Color TeamColor;

public event simulated function Destroyed()
{
    local TeamInfo OtherTeam;
    
    Super(Actor).Destroyed();
    if (WorldInfo.GRI != None)
    {
        foreach DynamicActors(Class'TeamInfo', OtherTeam, )
        {
            if (OtherTeam != Self && OtherTeam.TeamIndex == TeamIndex)
            {
                WorldInfo.GRI.SetTeam(TeamIndex, OtherTeam);
                break;
            }
        }
    }
    UnbindTeamDataProvider();
}
public simulated native function byte GetTeamNum();

public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'TeamIndex')
    {
        if (WorldInfo.GRI != None)
        {
            WorldInfo.GRI.SetTeam(TeamIndex, Self);
        }
    }
    else
    {
        Super(Actor).ReplicatedEvent(VarName);
    }
}
public simulated function string GetHumanReadableName()
{
    return TeamName;
}
public function bool AddToTeam(Controller Other)
{
    if (Other == None)
    {
        return FALSE;
    }
    if (Other.PlayerReplicationInfo == None)
    {
        ScriptTrace();
        return FALSE;
    }
    Size++;
    Other.PlayerReplicationInfo.SetPlayerTeam(Self);
    return TRUE;
}
public simulated function CurrentGameDataStore GetCurrentGameDS()
{
    local DataStoreClient DSClient;
    local CurrentGameDataStore Result;
    
    DSClient = Class'UIInteraction'.static.GetDataStoreClient();
    if (DSClient != None)
    {
        Result = CurrentGameDataStore(DSClient.FindDataStore('CurrentGame'));
        if (Result == None)
        {
        }
    }
    return Result;
}
public simulated function Color GetHUDColor()
{
    return TeamColor;
}
public function Color GetTextColor()
{
    return TeamColor;
}
public function RemoveFromTeam(Controller Other)
{
    Size--;
    if (Other != None && Other.PlayerReplicationInfo != None)
    {
        Other.PlayerReplicationInfo.SetPlayerTeam(None);
    }
}
public simulated function UnbindTeamDataProvider()
{
    local CurrentGameDataStore CurrentGameData;
    
    CurrentGameData = GetCurrentGameDS();
    CurrentGameData.RemoveTeamDataProvider(Self);
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        Score;
    if (bNetInitial && Role == ENetRole.ROLE_Authority)
        TeamName, TeamIndex;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TeamName = "Team"
    TeamIndex = -1
    TeamColor = {B = 64, G = 64, R = 255, A = 255}
    NetUpdateFrequency = 2.0
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}