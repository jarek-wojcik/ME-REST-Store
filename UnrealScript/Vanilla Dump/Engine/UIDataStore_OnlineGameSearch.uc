Class UIDataStore_OnlineGameSearch extends UIDataStore_Remote
    implements(UIListElementProvider, UIListElementCellProvider)
    native
    abstract
    transient;

struct native GameSearchCfg 
{
    var array<UIDataProvider_Settings> SearchResults;
    var Class<OnlineGameSearch> GameSearchClass;
    var Class<OnlineGameSettings> DefaultGameSettingsClass;
    var Class<UIDataProvider_Settings> SearchResultsProviderClass;
    var Name SearchName;
    var UIDataProvider_Settings DesiredSettingsProvider;
    var OnlineGameSearch Search;
};

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var const array<GameSearchCfg> GameSearchCfgList;
var const Name SearchResultsName;
var OnlineGameInterface GameInterface;
var OnlineSubsystem OnlineSub;
var int SelectedIndex;
var int ActiveSearchIndex;

public native function BuildSearchResults();

public event function OnlineGameSearch GetActiveGameSearch()
{
    if (ActiveSearchIndex >= 0 && ActiveSearchIndex < GameSearchCfgList.Length)
    {
        return GameSearchCfgList[ActiveSearchIndex].Search;
    }
    return None;
}
public event function OnlineGameSearch GetCurrentGameSearch()
{
    if (SelectedIndex >= 0 && SelectedIndex < GameSearchCfgList.Length)
    {
        return GameSearchCfgList[SelectedIndex].Search;
    }
    return None;
}
public event function bool GetSearchResultFromIndex(int ListIndex, out OnlineGameSearchResult Result)
{
    if (ListIndex >= 0 && ListIndex < GameSearchCfgList[SelectedIndex].Search.Results.Length)
    {
        Result = GameSearchCfgList[SelectedIndex].Search.Results[ListIndex];
        return TRUE;
    }
    return FALSE;
}
public event function Init()
{
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        GameInterface = OnlineSub.GameInterface;
        if (GameInterface != None)
        {
            GameInterface.AddFindOnlineGamesCompleteDelegate(OnSearchComplete);
        }
    }
}
public event function MoveToNext(optional bool bInvalidateExistingSearchResults = TRUE)
{
    SelectedIndex = Min(SelectedIndex + 1, GameSearchCfgList.Length - 1);
    if (!bInvalidateExistingSearchResults || !InvalidateCurrentSearchResults())
    {
        RefreshSubscribers(SearchResultsName, TRUE, GameSearchCfgList[SelectedIndex].DesiredSettingsProvider);
    }
}
public event function MoveToPrevious(optional bool bInvalidateExistingSearchResults = TRUE)
{
    SelectedIndex = Max(SelectedIndex - 1, 0);
    if (!bInvalidateExistingSearchResults || !InvalidateCurrentSearchResults())
    {
        RefreshSubscribers(SearchResultsName, TRUE, GameSearchCfgList[SelectedIndex].DesiredSettingsProvider);
    }
}
public event function SetCurrentByIndex(int NewIndex, optional bool bInvalidateExistingSearchResults = TRUE)
{
    if (NewIndex >= 0 && NewIndex < GameSearchCfgList.Length)
    {
        SelectedIndex = NewIndex;
        if (!bInvalidateExistingSearchResults || !InvalidateCurrentSearchResults())
        {
            RefreshSubscribers(SearchResultsName, TRUE, GameSearchCfgList[SelectedIndex].DesiredSettingsProvider);
        }
    }
}
public event function SetCurrentByName(Name SearchName, optional bool bInvalidateExistingSearchResults = TRUE)
{
    local int Index;
    
    Index = FindSearchConfigurationIndex(SearchName);
    if (Index != -1)
    {
        SelectedIndex = Index;
        if (!bInvalidateExistingSearchResults || !InvalidateCurrentSearchResults())
        {
            RefreshSubscribers(SearchResultsName, TRUE, GameSearchCfgList[SelectedIndex].DesiredSettingsProvider);
        }
    }
}
public event function bool ShowHostGamercard(byte ControllerIndex, int ListIndex)
{
    local OnlinePlayerInterfaceEx PlayerExt;
    local OnlineGameSettings Game;
    
    if (ListIndex >= 0 && ListIndex < GameSearchCfgList[SelectedIndex].Search.Results.Length)
    {
        if (OnlineSub != None)
        {
            PlayerExt = OnlineSub.PlayerInterfaceEx;
            if (PlayerExt != None)
            {
                Game = GameSearchCfgList[SelectedIndex].Search.Results[ListIndex].GameSettings;
                return PlayerExt.ShowGamerCardUI(ControllerIndex, Game.OwningPlayerId);
            }
        }
    }
}
public event function bool SubmitGameSearch(byte ControllerIndex, optional bool bInvalidateExistingSearchResults = TRUE)
{
    if (OnlineSub != None)
    {
        if (GameInterface != None)
        {
            if (bInvalidateExistingSearchResults || ActiveSearchIndex == SelectedIndex)
            {
                InvalidateCurrentSearchResults();
            }
            if (ActiveSearchIndex == -1 || !GameSearchCfgList[ActiveSearchIndex].Search.bIsSearchInProgress)
            {
                ActiveSearchIndex = SelectedIndex;
            }
            if (OverrideQuerySubmission(ControllerIndex, GameSearchCfgList[ActiveSearchIndex].Search))
            {
                return TRUE;
            }
            InvalidateCurrentSearchResults();
            return GameInterface.FindOnlineGames(ControllerIndex, GameSearchCfgList[ActiveSearchIndex].Search);
        }
    }
    return FALSE;
}
public function ClearAllSearchResults()
{
    local int OriginalActiveIndex;
    local int GameTypeIndex;
    
    OriginalActiveIndex = ActiveSearchIndex;
    if (GameInterface != None)
    {
        for (GameTypeIndex = 0; GameTypeIndex < GameSearchCfgList.Length; GameTypeIndex++)
        {
            ActiveSearchIndex = GameTypeIndex;
            if (GameInterface.FreeSearchResults(GameSearchCfgList[GameTypeIndex].Search))
            {
                BuildSearchResults();
                continue;
            }
        }
    }
    ActiveSearchIndex = OriginalActiveIndex;
}
public function int FindSearchConfigurationIndex(Name SearchTag)
{
    local int Index;
    
    for (Index = 0; Index < GameSearchCfgList.Length; Index++)
    {
        if (GameSearchCfgList[Index].SearchName == SearchTag)
        {
            return Index;
        }
    }
    return -1;
}
public function bool InvalidateCurrentSearchResults()
{
    local OnlineGameSearch ActiveSearch;
    local bool bResult;
    
    ActiveSearch = GetActiveGameSearch();
    if (ActiveSearch != None)
    {
        if (GameInterface.FreeSearchResults(ActiveSearch))
        {
            BuildSearchResults();
            RefreshSubscribers(SearchResultsName, TRUE, GameSearchCfgList[SelectedIndex].DesiredSettingsProvider);
            bResult = TRUE;
        }
    }
    return bResult;
}
public function OnSearchComplete(bool bWasSuccessful)
{
    if (bWasSuccessful)
    {
        BuildSearchResults();
        NotifyPropertyChanged(SearchResultsName);
        RefreshSubscribers(SearchResultsName, FALSE, GameSearchCfgList[ActiveSearchIndex].DesiredSettingsProvider);
    }
}
protected function bool OverrideQuerySubmission(byte ControllerId, OnlineGameSearch Search)
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SearchResultsName = 'SearchResults'
    ActiveSearchIndex = -1
    Tag = 'OnlineGameSearch'
    WriteAccessType = EProviderAccessType.ACCESS_WriteAll
}