Class SFXGUI_Leaderboard extends SFXGUIMovie
    native
    config(UI);

struct native SFXLeaderboardRequestData 
{
    var int PrimaryIndex;
    var int SecondaryIndex;
};

var array<LeaderboardMapGroup> LeaderboardGroups;
var array<RankBypassNotification> Notifications;
var array<LeaderboardRecord> CachedRecords;
var SFXLeaderboardRequestData RequestedData;
var SFXLeaderboardRequestData CurrentData;
var config int RecordsPerRequest;
var config int RowsInTable;
var int SeamlessRankToMoveTo;
var int SeamlessRankToSelect;
var transient float StartTime;

public final native function AddRecords(array<LeaderboardRecord> NewRecords, int NumRanks, int TopRank, int RankToMoveTo, int RankToSelect, bool bFriends);

public final event function AS_AddRecords(const array<LeaderboardRecord> records, int NumRanks, int TopRank, int RankToMoveTo, int RankToSelect, bool bFriends)
{
    ActionScriptVoid("screen.AddRecords");
}
public final event function AS_ClearHeader()
{
    ActionScriptVoid("screen.ClearHeader");
}
public final event function AS_ClearRows()
{
    ActionScriptVoid("screen.ClearRows");
}
public final event function AS_DefineColumns(const array<LeaderboardColumn> columnDefinitions)
{
    ActionScriptVoid("screen.DefineColumns");
}
public final event function AS_SetLeaderboardHeaderText(string sNewTitle)
{
    ActionScriptVoid("screen.SetLeaderboardHeaderText");
}
public final native function CancelLeaderboardRequests();

public final native function ClearRecords();

public final native function Ext_LeaderboardInitalized();

public final native function Ext_NextPrimaryIndex();

public final native function Ext_NextSecondaryIndex();

public final native function Ext_PrevPrimaryIndex();

public final native function Ext_PrevSecondaryIndex();

public final native function Ext_ShowGamerCard(int RowNumber);

public final native function OnCenteredLeaderboardResultsRetrieved(array<LeaderboardColumn> aColumnInfo, array<LeaderboardRecord> aResults, int iTotalRanks, UniqueNetId uidEntity, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public final native function OnLeaderboardResultsRetrieved(array<LeaderboardColumn> aColumnInfo, array<LeaderboardRecord> aResults, int iTotalRanks, UniqueNetId uidEntity, LeaderboardStatsError nErrorCode, optional Pointer pExternalData);

public event function OnStart()
{
    Super.OnStart();
    PlayGuiSound('MPLeaderboardStart');
    SetGameMode(TRUE, 23);
    SetRequiresUIWorld(TRUE);
    Notifications = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentLeaderboard().GetCurrentRankNotificationsArray();
    Class'SFXTelemetryHooks'.static.SendLeaderboardOpened();
    StartTime = oWorldInfo.TimeSeconds;
}
public final native function PopulateLeaderboardCenteredData(int PrimaryIndex, int SecondaryIndex, int nRange, UniqueNetId iPlayerID);

public final native function PopulateLeaderboardFromRank(int PrimaryIndex, int SecondaryIndex, int nRank, int nRange);

public event function OnClose()
{
    Class'SFXTelemetryHooks'.static.SendLeaderboardClosed(oWorldInfo.TimeSeconds - StartTime);
    SetGameMode(FALSE, 23);
    Super.OnClose();
}
public function ExitScreen()
{
    Close();
    PlayGuiSound('MPLeaderboardFinish');
    CancelLeaderboardRequests();
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentLeaderboard().FlushRankNotifications();
}
public final function Ext_CancelLeaderboardRequests()
{
    CancelLeaderboardRequests();
}
public final function Ext_GetLeaderboardDataCentredOnLocalPlayer()
{
    local UniqueNetId iPlayerID;
    
    iPlayerID = GetLP().GetUniqueNetId();
    PopulateLeaderboardCenteredData(CurrentData.PrimaryIndex, CurrentData.SecondaryIndex, RecordsPerRequest, iPlayerID);
}
public final function Ext_GetNewLeaderboardData(int Rank)
{
    SeamlessRankToMoveTo = Rank;
    SeamlessRankToSelect = Rank;
    PopulateLeaderboardFromRank(CurrentData.PrimaryIndex, CurrentData.SecondaryIndex, Rank - RecordsPerRequest / 2, RecordsPerRequest);
}
public function string GetLocalUsername()
{
    return Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentLogin().GetPersonaName();
}
public function bool NeedsNotification(string RecordName)
{
    local int idx;
    
    for (idx = 0; idx < Notifications.Length; ++idx)
    {
        if (Notifications[idx].sEntityName == RecordName)
        {
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RecordsPerRequest = 30
    RowsInTable = 7
    m_bFocusOnStart = TRUE
}