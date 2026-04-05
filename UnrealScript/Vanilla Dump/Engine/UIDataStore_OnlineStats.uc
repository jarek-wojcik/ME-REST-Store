Class UIDataStore_OnlineStats extends UIDataStore_Remote
    implements(UIListElementProvider, UIListElementCellProvider)
    native
    abstract
    transient;

enum EStatsFetchType
{
    SFT_Player,
    SFT_CenteredOnPlayer,
    SFT_Friends,
    SFT_TopRankings,
};
struct native RankMetaData 
{
    var const localized string RankColumnName;
    var const Name RankName;
};
struct native PlayerNickMetaData 
{
    var const localized string PlayerNickColumnName;
    var const Name PlayerNickName;
};

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var const PlayerNickMetaData PlayerNickData;
var const RankMetaData RankNameMetaData;
var array<Class<OnlineStatsRead>> StatsReadClasses;
var array<OnlineStatsRead> StatsReadObjects;
var const Name StatsReadName;
var const Name TotalRowsName;
var OnlineStatsInterface StatsInterface;
var OnlinePlayerInterface PlayerInterface;
var OnlineStatsRead StatsRead;
var EStatsFetchType CurrentReadType;

public event function Init()
{
    local OnlineSubsystem OnlineSub;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        StatsInterface = OnlineSub.StatsInterface;
        PlayerInterface = OnlineSub.PlayerInterface;
        StatsInterface.AddReadOnlineStatsCompleteDelegate(OnReadComplete);
    }
}
public function OnReadComplete(bool bWasSuccessful)
{
    if (bWasSuccessful)
    {
        SortResultsByRank();
    }
    NotifyPropertyChanged();
    RefreshSubscribers();
}
public event function bool RefreshStats(byte ControllerIndex)
{
    local array<UniqueNetId> Players;
    local UniqueNetId PlayerID;
    
    SetStatsReadInfo();
    StatsInterface.FreeStats(StatsRead);
    OnReadComplete(TRUE);
    switch (CurrentReadType)
    {
        case EStatsFetchType.SFT_Player:
            PlayerInterface.GetUniquePlayerId(ControllerIndex, PlayerID);
            Players[0] = PlayerID;
            if (StatsInterface.ReadOnlineStats(Players, StatsRead) == FALSE)
            {
                return FALSE;
            }
            return TRUE;
        case EStatsFetchType.SFT_CenteredOnPlayer:
            if (StatsInterface.ReadOnlineStatsByRankAroundPlayer(ControllerIndex, StatsRead, 10) == FALSE)
            {
                return FALSE;
            }
            return TRUE;
        case EStatsFetchType.SFT_Friends:
            if (StatsInterface.ReadOnlineStatsForFriends(ControllerIndex, StatsRead) == FALSE)
            {
                return FALSE;
            }
            return TRUE;
        case EStatsFetchType.SFT_TopRankings:
            if (StatsInterface.ReadOnlineStatsByRank(StatsRead) == FALSE)
            {
                return FALSE;
            }
            return TRUE;
        default:
    }
}
public event function bool ShowGamercard(byte ConrollerIndex, int ListIndex)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerExt;
    local UniqueNetId PlayerID;
    
    if (ListIndex >= 0 && ListIndex < StatsRead.Rows.Length)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerExt = OnlineSub.PlayerInterfaceEx;
            if (PlayerExt != None)
            {
                PlayerID = StatsRead.Rows[ListIndex].PlayerID;
                return PlayerExt.ShowGamerCardUI(ConrollerIndex, PlayerID);
            }
        }
    }
}
public native function SortResultsByRank();

public function SetStatsReadInfo()
{
    StatsRead = StatsReadObjects[0];
    CurrentReadType = EStatsFetchType.SFT_Player;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PlayerNickData = {PlayerNickColumnName = "Player Nick", PlayerNickName = 'Player Nick'}
    RankNameMetaData = {RankColumnName = "Rank", RankName = 'Rank'}
    StatsReadName = 'StatsReadResults'
    TotalRowsName = 'TotalRows'
    Tag = 'OnlineStats'
}