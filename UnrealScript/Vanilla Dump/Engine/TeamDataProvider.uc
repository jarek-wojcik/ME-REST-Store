Class TeamDataProvider extends UIDynamicDataProvider
    implements(UIListElementProvider)
    native
    transient;

var const native noexport Pointer VfTable_IUIListElementProvider;
var array<PlayerDataProvider> Players;
var const Name PlayerListFieldName;

public function RegeneratePlayerLists(array<PlayerDataProvider> AllPlayers)
{
    local int PlayerIdx;
    local PlayerReplicationInfo PRI;
    
    Players.Length = 0;
    for (PlayerIdx = 0; PlayerIdx < AllPlayers.Length; PlayerIdx++)
    {
        PRI = PlayerReplicationInfo(AllPlayers[PlayerIdx].GetDataSource());
        if (PRI != None && PRI.Team != None && PRI.Team == DataSource)
        {
            Players[Players.Length] = AllPlayers[PlayerIdx];
        }
    }
    NotifyPropertyChanged(PlayerListFieldName);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PlayerListFieldName = 'Players'
    DataClass = Class'TeamInfo'
}