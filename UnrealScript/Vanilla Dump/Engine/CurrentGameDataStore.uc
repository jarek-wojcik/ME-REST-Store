Class CurrentGameDataStore extends UIDataStore_GameState
    implements(UIListElementProvider)
    native
    transient;

struct native GameDataProviderTypes 
{
    var const Class<GameInfoDataProvider> GameDataProviderClass;
    var const Class<PlayerDataProvider> PlayerDataProviderClass;
    var const Class<TeamDataProvider> TeamDataProviderClass;
};

var const native noexport Pointer VfTable_IUIListElementProvider;
var const GameDataProviderTypes ProviderTypes;
var array<PlayerDataProvider> PlayerData;
var array<TeamDataProvider> TeamData;
var delegate<OnAddTeamProvider> __OnAddTeamProvider__Delegate;
var GameInfoDataProvider GameData;
var transient bool bRefreshPlayerDataProviders;
var transient bool bRefreshTeamDataProviders;

public function bool NotifyGameSessionEnded()
{
    ClearDataProviders();
    return FALSE;
}
public delegate function OnAddTeamProvider(TeamDataProvider Provider);

public function Timer()
{
    if (bRefreshPlayerDataProviders)
    {
        RefreshPlayerDataProviders();
    }
    if (bRefreshTeamDataProviders)
    {
        RefreshTeamDataProviders();
    }
}
public final function AddPlayerDataProvider(PlayerReplicationInfo PRI)
{
    local int ExistingIndex;
    local PlayerDataProvider DataProvider;
    
    if (PRI != None)
    {
        if (GameData != None)
        {
            ExistingIndex = FindPlayerDataProviderIndex(PRI);
            if (ExistingIndex == -1)
            {
                DataProvider = new ProviderTypes.PlayerDataProviderClass;
                if (!DataProvider.BindProviderInstance(PRI))
                {
                }
                else
                {
                    DataProvider.AddPropertyNotificationChangeRequest(PlayerDataProviderPropertyChange);
                    PlayerData[PlayerData.Length] = DataProvider;
                    RefreshSubscribers('Players', TRUE, Self);
                    NotifyTeamChange();
                }
            }
        }
    }
}
public final function AddTeamDataProvider(TeamInfo TI)
{
    local int ExistingIndex;
    local TeamDataProvider DataProvider;
    
    if (TI != None)
    {
        if (GameData != None)
        {
            ExistingIndex = FindTeamDataProviderIndex(TI);
            if (ExistingIndex == -1)
            {
                DataProvider = new ProviderTypes.TeamDataProviderClass;
                if (!DataProvider.BindProviderInstance(TI))
                {
                }
                else
                {
                    TeamData[TI.TeamIndex] = DataProvider;
                    DataProvider.AddPropertyNotificationChangeRequest(TeamDataProviderPropertyChange);
                    NotifyTeamChange();
                    __OnAddTeamProvider__Delegate(DataProvider);
                }
            }
        }
    }
}
public final function ClearDataProviders()
{
    local int i;
    
    if (GameData != None)
    {
        GameData.CleanupDataProvider();
    }
    for (i = 0; i < PlayerData.Length; i++)
    {
        PlayerData[i].CleanupDataProvider();
    }
    for (i = 0; i < TeamData.Length; i++)
    {
        if (TeamData[i] != None)
        {
            TeamData[i].CleanupDataProvider();
        }
    }
    GameData = None;
    PlayerData.Length = 0;
    TeamData.Length = 0;
}
public final function CreateGameDataProvider(GameReplicationInfo GRI)
{
    if (GRI != None)
    {
        GameData = new ProviderTypes.GameDataProviderClass;
        if (!GameData.BindProviderInstance(GRI))
        {
        }
    }
}
public final function int FindPlayerDataProviderIndex(PlayerReplicationInfo PRI)
{
    local int i;
    local int Result;
    
    Result = -1;
    for (i = 0; i < PlayerData.Length; i++)
    {
        if (PlayerData[i].GetDataSource() == PRI)
        {
            Result = i;
            break;
        }
    }
    return Result;
}
public final function int FindTeamDataProviderIndex(TeamInfo TI)
{
    local int i;
    local int Result;
    
    Result = -1;
    for (i = 0; i < TeamData.Length; i++)
    {
        if (TeamData[i] != None && TeamData[i].GetDataSource() == TI)
        {
            Result = i;
            break;
        }
    }
    return Result;
}
public final function PlayerDataProvider GetPlayerDataProvider(PlayerReplicationInfo PRI)
{
    local int Index;
    local PlayerDataProvider Provider;
    
    Index = FindPlayerDataProviderIndex(PRI);
    if (Index != -1)
    {
        Provider = PlayerData[Index];
    }
    return Provider;
}
public final function TeamDataProvider GetTeamDataProvider(TeamInfo TI)
{
    local int Index;
    local TeamDataProvider Provider;
    
    Index = FindTeamDataProviderIndex(TI);
    if (Index != -1)
    {
        Provider = TeamData[Index];
    }
    return Provider;
}
public function NotifyPlayersChanged()
{
    bRefreshPlayerDataProviders = TRUE;
}
public function NotifyTeamChange()
{
    bRefreshTeamDataProviders = TRUE;
}
public function PlayerDataProviderPropertyChange(UIDataProvider SourceProvider, optional Name PropTag)
{
    local int PlayerArrayIndex;
    local int CollectionIndex;
    local EUIDataProviderFieldType ProviderFieldType;
    local bool bInvalidateListItems;
    
    for (PlayerArrayIndex = PlayerData.Length - 1; PlayerArrayIndex >= 0; PlayerArrayIndex--)
    {
        if (SourceProvider == PlayerData[PlayerArrayIndex])
        {
            break;
        }
    }
    CollectionIndex = PlayerArrayIndex;
    if (PlayerArrayIndex != -1)
    {
        if (PropTag != 'None')
        {
            if (SourceProvider.GetProviderFieldType(string(PropTag), ProviderFieldType) && SourceProvider.IsCollectionDataType(ProviderFieldType))
            {
                CollectionIndex = SourceProvider.ParseTagArrayDelimiter(PropTag);
                if (CollectionIndex == -1)
                {
                    bInvalidateListItems = TRUE;
                }
                PropTag = Name("Players;" $ PlayerArrayIndex $ "." $ PropTag);
            }
            else
            {
                PropTag = Name("Players." $ PropTag);
            }
        }
        else
        {
            bInvalidateListItems = TRUE;
        }
    }
    RefreshSubscribers(PropTag, bInvalidateListItems, SourceProvider, CollectionIndex);
}
public function RefreshPlayerDataProviders()
{
    RefreshSubscribers('Players', TRUE, Self);
    bRefreshPlayerDataProviders = FALSE;
}
public function RefreshTeamDataProviders()
{
    local int i;
    
    for (i = 0; i < TeamData.Length; i++)
    {
        if (TeamData[i] != None)
        {
            TeamData[i].RegeneratePlayerLists(PlayerData);
        }
    }
    bRefreshTeamDataProviders = FALSE;
}
public final function RemovePlayerDataProvider(PlayerReplicationInfo PRI)
{
    local int ExistingIndex;
    
    if (PRI != None)
    {
        ExistingIndex = FindPlayerDataProviderIndex(PRI);
        if (ExistingIndex != -1)
        {
            if (PlayerData[ExistingIndex].CleanupDataProvider())
            {
                PlayerData[ExistingIndex].RemovePropertyNotificationChangeRequest(PlayerDataProviderPropertyChange);
                PlayerData.Remove(ExistingIndex, 1);
                RefreshSubscribers('Players', TRUE, Self);
                NotifyTeamChange();
            }
        }
    }
}
public final function RemoveTeamDataProvider(TeamInfo TI)
{
    local int ExistingIndex;
    
    if (TI != None)
    {
        ExistingIndex = FindTeamDataProviderIndex(TI);
        if (ExistingIndex != -1)
        {
            if (TeamData[ExistingIndex].CleanupDataProvider())
            {
                TeamData[ExistingIndex].RemovePropertyNotificationChangeRequest(TeamDataProviderPropertyChange);
                TeamData.Remove(ExistingIndex, 1);
            }
        }
    }
}
public function TeamDataProviderPropertyChange(UIDataProvider SourceProvider, optional Name PropTag)
{
    local int TeamArrayIndex;
    local int CollectionIndex;
    local EUIDataProviderFieldType ProviderFieldType;
    local bool bInvalidateListItems;
    
    for (TeamArrayIndex = TeamData.Length - 1; TeamArrayIndex >= 0; TeamArrayIndex--)
    {
        if (SourceProvider == TeamData[TeamArrayIndex])
        {
            break;
        }
    }
    CollectionIndex = TeamArrayIndex;
    if (TeamArrayIndex != -1)
    {
        if (PropTag != 'None')
        {
            if (SourceProvider.GetProviderFieldType(string(PropTag), ProviderFieldType) && SourceProvider.IsCollectionDataType(ProviderFieldType))
            {
                CollectionIndex = SourceProvider.ParseTagArrayDelimiter(PropTag);
                if (CollectionIndex == -1)
                {
                    bInvalidateListItems = TRUE;
                }
                PropTag = Name("Teams;" $ TeamArrayIndex $ "." $ PropTag);
            }
            else
            {
                PropTag = Name("Teams." $ PropTag);
            }
        }
        else
        {
            bInvalidateListItems = TRUE;
        }
    }
    RefreshSubscribers(PropTag, bInvalidateListItems, SourceProvider, CollectionIndex);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ProviderTypes = {GameDataProviderClass = Class'GameInfoDataProvider', PlayerDataProviderClass = Class'PlayerDataProvider', TeamDataProviderClass = Class'TeamDataProvider'}
    Tag = 'CurrentGame'
}