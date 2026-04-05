Class SFXOnlineComponentGameFlow extends SFXOnlineComponent
    implements(ISFXOnlineComponent)
    native
    config(Engine);

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var const config array<Name> m_TestStateNames;
var const config array<Name> m_TestInputNames;
var Name m_Substate;
var float m_TimeElapsedInState;
var const config float m_LobbyLongWaitingTime;
var const config float m_GameLongActionTime;
var JoinFailureReason m_JoinFailureReason;
var SFXOnlineGameStatus m_MatchMakingTimeStatus;

public event function bool DebugTestInput(Name InputType)
{
    return FALSE;
}
public event function bool DebugValidateStates(optional bool writeToFile = TRUE)
{
    return TRUE;
}
public native function Name GetAPIName();

public event function string GetStateStr()
{
    local string sTimeInGame;
    local WorldInfo WI;
    
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI != None && GM_IsInMultiplayerGame() && WI.NetMode == ENetMode.NM_ListenServer)
    {
        sTimeInGame = " (" $ m_MatchMakingTimeStatus $ ")";
    }
    return GetStateName() $ sTimeInGame;
}
public event function bool GM_CancelSearch()
{
    return FALSE;
}
public event function bool GM_HasCreatedGame()
{
    return FALSE;
}
public event function bool GM_HasFailedConnecting()
{
    return FALSE;
}
public event function bool GM_HasFailedConnecting_QM()
{
    return FALSE;
}
public event function bool GM_HasFailedJoiningFullGame()
{
    return FALSE;
}
public event function bool GM_HasFailedJoiningGameMissingDLCInvitee()
{
    return FALSE;
}
public event function bool GM_HasFailedJoiningGameMissingDLCInviter()
{
    return FALSE;
}
public event function bool GM_HasFailedJoiningGameProtocolMismatch()
{
    return FALSE;
}
public event function bool GM_HasFailedJoiningInviterLeft()
{
    return FALSE;
}
public event function bool GM_HasJoinedGame()
{
    return FALSE;
}
public event function bool GM_IsConnectionErrorSilent()
{
    return FALSE;
}
public event function bool GM_IsInInviteFlow()
{
    return FALSE;
}
public event function bool GM_IsInMPMapAction()
{
    return FALSE;
}
public event function bool GM_IsInMultiplayerFlow()
{
    return FALSE;
}
public event function bool GM_IsInMultiplayerGame()
{
    return FALSE;
}
public event function bool GM_IsLeavingGame()
{
    return FALSE;
}
public event function bool GM_OnCreateGameSent()
{
    return FALSE;
}
public event function bool GM_OnDisconnect()
{
    return FALSE;
}
public event function bool GM_OnEnterMPFlow()
{
    return FALSE;
}
public event function bool GM_OnEnterMPGameplay()
{
    return FALSE;
}
public event function bool GM_OnEnterMPGameResults()
{
    return FALSE;
}
public event function bool GM_OnExitMPFlow()
{
    return FALSE;
}
public event function bool GM_OnGameCreated(bool bSuccess)
{
    return FALSE;
}
public event function bool GM_OnGameJoined(bool bSuccess)
{
    return FALSE;
}
public event function bool GM_OnGameJoinFailure(JoinFailureReason Reason)
{
    return FALSE;
}
public event function bool GM_OnHostAddressResolved()
{
    return FALSE;
}
public event function bool GM_OnHostMigrationEnded(bool bInLobby)
{
    return FALSE;
}
public event function bool GM_OnHostMigrationStarted(bool bLocalPlayerIsHost)
{
    return FALSE;
}
public event function bool GM_OnInviteAborted()
{
    return FALSE;
}
public event function bool GM_OnInviteAccepted(bool invitedInactiveUser)
{
    return FALSE;
}
public event function bool GM_OnInviteErrorNotified()
{
    return FALSE;
}
public event function bool GM_OnInviteProceed()
{
    return FALSE;
}
public event function bool GM_OnLeaveGame()
{
    return FALSE;
}
public event function bool GM_OnLeaveGameComplete()
{
    return FALSE;
}
public event function bool GM_OnNetworkErrorDismissed()
{
    return FALSE;
}
public event function bool GM_OnP2PConnectionFailure()
{
    return FALSE;
}
public event function bool GM_OnProfileSelected()
{
    return FALSE;
}
public event function bool GM_OnQuickMatchSent()
{
    return FALSE;
}
public event function bool GM_OnQuickMatchUpdate(SFXOnlineEvent_QuickMatch qmEvent)
{
    return FALSE;
}
public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

public function GM_OnTick(SFXOnlineEvent oEvent);

public function MatchMakingTimeStatusUpdate(SFXOnlineGameStatus NewStatus)
{
    local SFXOnlineEvent_Integer oTimeStatusChangeEvent;
    
    if (Class'WorldInfo'.static.GetWorldInfo().NetMode == ENetMode.NM_ListenServer)
    {
        oTimeStatusChangeEvent = new Class'SFXOnlineEvent_Integer';
        oTimeStatusChangeEvent.SetEventType(3);
        oTimeStatusChangeEvent.SetStatus(2);
        oTimeStatusChangeEvent.IsUnique = FALSE;
        oTimeStatusChangeEvent.SetInteger(int(NewStatus));
        NotifyEventObject(oTimeStatusChangeEvent);
        m_MatchMakingTimeStatus = NewStatus;
        m_TimeElapsedInState = 0.0;
    }
}

state MMS_ShowNetworkError extends MatchMakingMState 
{
    public event function bool GM_OnNetworkErrorDismissed()
    {
        GotoState('MMS_Inactive', , , );
        return TRUE;
    }
    public event function bool GM_OnExitMPFlow()
    {
        GotoState('MMS_Inactive', , , );
        return TRUE;
    }
    
    stop;
};
state MMS_HostMigrating extends MMS_ClientState 
{
    public event function bool GM_OnHostMigrationEnded(bool bInLobby)
    {
        GotoState(bInLobby ? 'MMS_LobbyHost' : 'MMS_MapBeingPlayedAsHost', , , );
        return TRUE;
    }
    public event function bool GM_IsWaitingForNetwork()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_ResolvingHostAddress_Invite extends MMS_ClientState 
{
    public event function bool GM_IsInInviteFlow()
    {
        return TRUE;
    }
    public event function bool GM_OnHostAddressResolved()
    {
        GotoState('MMS_ConnectingToHost_Invite', , , );
        return TRUE;
    }
    public event function bool GM_IsWaitingForNetwork()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_AcceptedInvite extends MMS_ClientState 
{
    public event function bool GM_IsInInviteFlow()
    {
        return TRUE;
    }
    public event function bool GM_OnGameJoinFailure(JoinFailureReason Reason)
    {
        m_JoinFailureReason = Reason;
        GotoState('MMS_FailJoiningGame', , , );
        return TRUE;
    }
    public event function bool GM_OnGameJoined(bool bSuccess)
    {
        GotoState(bSuccess ? 'MMS_ResolvingHostAddress_Invite' : 'MMS_Inactive', , , );
        return bSuccess;
    }
    public event function bool GM_IsWaitingForNetwork()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_ResolvingInvite_InactiveUser extends MMS_Invite 
{
    public event function bool GM_IsConnectionErrorSilent()
    {
        return TRUE;
    }
    public event function bool GM_OnProfileSelected()
    {
        GotoState('MMS_ResolvingInvite', , , );
        return TRUE;
    }
    public event function bool GM_OnDisconnect()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_ResolvingInvite extends MMS_Invite 
{
    
    stop;
};
state MMS_Invite extends MatchMakingMState 
{
    public event function bool GM_OnLeaveGameComplete()
    {
        return TRUE;
    }
    public event function bool GM_IsInInviteFlow()
    {
        return TRUE;
    }
    public event function bool GM_OnInviteAborted()
    {
        GotoState('MMS_Inactive', , , );
        return TRUE;
    }
    
    stop;
};
state MMS_LeavingGame extends MatchMakingMState 
{
    public event function bool GM_IsInMultiplayerGame()
    {
        return FALSE;
    }
    public event function bool GM_OnLeaveGame()
    {
        return FALSE;
    }
    public event function bool GM_IsLeavingGame()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_MapBeingPlayedAsClient extends MMS_ClientConnected 
{
    public event function bool GM_OnEnterMPGameResults()
    {
        GotoState('MMS_LobbyClient', , , );
        return Super.GM_OnEnterMPGameResults();
    }
    public event function bool GM_IsInMPMapAction()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_ConnectingToHost_Migration extends MMS_ConnectingToHost 
{
    public event function bool GM_OnHostMigrationStarted(bool bLocalPlayerIsHost)
    {
        return TRUE;
    }
    
    stop;
};
state MMS_ConnectingToHost_Invite extends MMS_ConnectingToHost 
{
    public event function bool GM_IsInInviteFlow()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_ConnectingToHost_QM extends MMS_ConnectingToHost 
{
    public event function bool GM_OnLeaveGameComplete()
    {
        GotoState('MMS_FailConnecting_QM', , , );
        return TRUE;
    }
    public event function bool GM_OnP2PConnectionFailure()
    {
        GotoState('MMS_FailConnecting_QM', , , );
        return TRUE;
    }
    
    stop;
};
state MMS_ConnectingToHost extends MMS_ClientState 
{
    public event function bool GM_OnLeaveGameComplete()
    {
        GotoState('MMS_FailJoiningGame', , , );
        return TRUE;
    }
    public event function bool GM_OnP2PConnectionFailure()
    {
        GotoState('MMS_FailJoiningGame', , , );
        return TRUE;
    }
    public event function bool GM_HasJoinedGame()
    {
        return TRUE;
    }
    public event function bool GM_CancelSearch()
    {
        GotoState('MMS_PreMatch', , , );
        return TRUE;
    }
    public event function bool GM_OnHostMigrationEnded(bool bInLobby)
    {
        GotoState(bInLobby ? 'MMS_LobbyClient' : 'MMS_MapBeingPlayedAsClient', , , );
        return TRUE;
    }
    public event function bool GM_OnHostMigrationStarted(bool bLocalPlayerIsHost)
    {
        return FALSE;
    }
    public event function bool GM_OnEnterMPGameplay()
    {
        GotoState('MMS_MapBeingPlayedAsClient', , , );
        return Super.GM_OnEnterMPGameplay();
    }
    public event function bool GM_OnEnterMPFlow()
    {
        GotoState('MMS_LobbyClient', , , );
        return Super.GM_OnEnterMPFlow();
    }
    public event function bool GM_IsWaitingForNetwork()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_ResolvingHostAddress_Migration extends MMS_ResolvingHostAddress 
{
    public event function bool GM_OnHostAddressResolved()
    {
        GotoState('MMS_ConnectingToHost_Migration', , , );
        return TRUE;
    }
    
    stop;
};
state MMS_ResolvingHostAddress_QM extends MMS_ResolvingHostAddress 
{
    public event function bool GM_CancelSearch()
    {
        GotoState('MMS_PreMatch', , , );
        return TRUE;
    }
    public event function bool GM_OnHostAddressResolved()
    {
        GotoState('MMS_ConnectingToHost_QM', , , );
        return TRUE;
    }
    
    stop;
};
state MMS_ResolvingHostAddress extends MMS_ClientState 
{
    public event function bool GM_IsWaitingForNetwork()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_FailConnecting_QM extends MMS_ClientState 
{
    public event function bool GM_OnQuickMatchSent()
    {
        GotoState('MMS_QuickMatchSent', , , );
        return TRUE;
    }
    public event function bool GM_HasFailedConnecting_QM()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_FailJoiningGame extends MMS_ClientState 
{
    public event function bool GM_HasFailedConnecting()
    {
        return TRUE;
    }
    public event function bool GM_OnInviteErrorNotified()
    {
        GotoState('MMS_Inactive', , , );
        return TRUE;
    }
    public event function bool GM_HasFailedJoiningGameMissingDLCInviter()
    {
        return m_JoinFailureReason == JoinFailureReason.JFR_MissingDLCInviter;
    }
    public event function bool GM_HasFailedJoiningGameMissingDLCInvitee()
    {
        return m_JoinFailureReason == JoinFailureReason.JFR_MissingDLCInvitee;
    }
    public event function bool GM_HasFailedJoiningGameProtocolMismatch()
    {
        return m_JoinFailureReason == JoinFailureReason.JFR_ProtocolMismatch;
    }
    public event function bool GM_HasFailedJoiningInviterLeft()
    {
        return m_JoinFailureReason == JoinFailureReason.JFR_InviterLeft;
    }
    public event function bool GM_HasFailedJoiningFullGame()
    {
        return m_JoinFailureReason == JoinFailureReason.JFR_GameFull;
    }
    
    stop;
};
state MMS_JoinConnectionFailed extends MMS_ClientState 
{
    public event function bool GM_HasFailedConnecting()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_LobbyClient extends MMS_ClientConnected 
{
    public event function bool GM_OnLeaveGameComplete()
    {
        GotoState('MMS_JoinConnectionFailed', , , );
        return TRUE;
    }
    public event function bool GM_OnEnterMPGameplay()
    {
        GotoState('MMS_MapBeingPlayedAsClient', , , );
        return Super.GM_OnEnterMPGameplay();
    }
    public event function bool GM_HasJoinedGame()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_ClientConnected extends MMS_ClientState 
{
    public event function bool GM_OnHostMigrationStarted(bool bLocalPlayerIsHost)
    {
        GotoState(bLocalPlayerIsHost ? 'MMS_HostMigrating' : 'MMS_ResolvingHostAddress_Migration', , , );
        return TRUE;
    }
    
    stop;
};
state MMS_ClientState extends MatchMakingMState 
{
    public event function bool GM_OnHostMigrationStarted(bool bLocalPlayerIsHost)
    {
        GotoState(bLocalPlayerIsHost ? 'MMS_HostMigrating' : 'MMS_ResolvingHostAddress_QM', , , );
        return TRUE;
    }
    
    stop;
};
state MMS_MapBeingPlayedAsHost extends MatchMakingMState 
{
    public event function bool GM_OnEnterMPGameResults()
    {
        GotoState('MMS_LobbyHost', , , );
        return Super.GM_OnEnterMPGameResults();
    }
    public event function bool GM_IsInMPMapAction()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_LobbyHost extends MatchMakingMState 
{
    public event function bool GM_OnEnterMPGameplay()
    {
        GotoState('MMS_MapBeingPlayedAsHost', , , );
        return Super.GM_OnEnterMPGameplay();
    }
    public event function bool GM_HasCreatedGame()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_CreateGameSent extends MMS_MatchRequestSent 
{
    
    stop;
};
state MMS_QuickMatchSent extends MMS_MatchRequestSent 
{
    public event function bool GM_OnGameJoined(bool bSuccess)
    {
        GotoState(bSuccess ? 'MMS_ResolvingHostAddress_QM' : 'MMS_Inactive', , , );
        return bSuccess;
    }
    
    stop;
};
state MMS_MatchRequestSent extends MatchMakingMState 
{
    public event function bool GM_CancelSearch()
    {
        GotoState('MMS_PreMatch', , , );
        return TRUE;
    }
    public event function bool GM_OnGameCreated(bool bSuccess)
    {
        if (bSuccess)
        {
            GotoState('MMS_LobbyHost', , , );
        }
        else
        {
            GotoState('MMS_PreMatch', , , );
        }
        return TRUE;
    }
    public event function bool GM_IsWaitingForNetwork()
    {
        return TRUE;
    }
    
    stop;
};
state MMS_PreMatch extends MatchMakingMState 
{
    public event function bool GM_OnExitMPFlow()
    {
        GotoState('MMS_Inactive', , , );
        return TRUE;
    }
    public event function bool GM_IsInMultiplayerGame()
    {
        return FALSE;
    }
    public event function bool GM_OnCreateGameSent()
    {
        GotoState('MMS_CreateGameSent', , , );
        return TRUE;
    }
    public event function bool GM_OnQuickMatchSent()
    {
        GotoState('MMS_QuickMatchSent', , , );
        return TRUE;
    }
    
    stop;
};
auto state MMS_Inactive extends MatchMakingMState 
{
    public event function bool GM_OnEnterMPFlow()
    {
        GotoState('MMS_PreMatch', , , );
        return Super.GM_OnEnterMPFlow();
    }
    public event function bool GM_IsInMultiplayerFlow()
    {
        return FALSE;
    }
    public event function bool GM_IsInMultiplayerGame()
    {
        return FALSE;
    }
    public event function bool GM_OnDisconnect()
    {
        return FALSE;
    }
    public event function bool GM_OnCreateGameSent()
    {
        GotoState('MMS_CreateGameSent', , , );
        return TRUE;
    }
    public event function bool GM_OnQuickMatchSent()
    {
        GotoState('MMS_QuickMatchSent', , , );
        return TRUE;
    }
    
    stop;
};
state MatchMakingMState 
{
    public function GM_OnTick(SFXOnlineEvent oEvent)
    {
        if (GM_IsInMultiplayerGame() && Class'WorldInfo'.static.GetWorldInfo().NetMode == ENetMode.NM_ListenServer)
        {
            m_TimeElapsedInState += SFXOnlineEvent_Tick(oEvent).DeltaTime;
            switch (m_MatchMakingTimeStatus)
            {
                case SFXOnlineGameStatus.SFXONLINE_IN_LOBBY:
                    if (m_TimeElapsedInState >= m_LobbyLongWaitingTime)
                    {
                        MatchMakingTimeStatusUpdate(2);
                    }
                    break;
                case SFXOnlineGameStatus.SFXONLINE_IN_GAME_STARTING:
                    if (m_TimeElapsedInState >= m_GameLongActionTime)
                    {
                        MatchMakingTimeStatusUpdate(4);
                    }
                    break;
                default:
            }
        }
    }
    public event function bool GM_OnEnterMPGameResults()
    {
        MatchMakingTimeStatusUpdate(5);
        return TRUE;
    }
    public event function bool GM_OnEnterMPFlow()
    {
        MatchMakingTimeStatusUpdate(1);
        return TRUE;
    }
    public event function bool GM_OnEnterMPGameplay()
    {
        MatchMakingTimeStatusUpdate(3);
        return TRUE;
    }
    public event function bool GM_OnInviteProceed()
    {
        GotoState('MMS_AcceptedInvite', , , );
        return TRUE;
    }
    public event function bool GM_IsInMultiplayerFlow()
    {
        return TRUE;
    }
    public event function bool GM_IsInMultiplayerGame()
    {
        return TRUE;
    }
    public event function bool GM_OnInviteAccepted(bool invitedInactiveUser)
    {
        if (invitedInactiveUser)
        {
            GotoState('MMS_ResolvingInvite_InactiveUser', , , );
        }
        else
        {
            GotoState('MMS_ResolvingInvite', , , );
        }
        return TRUE;
    }
    public event function bool GM_OnDisconnect()
    {
        GotoState('MMS_ShowNetworkError', , , );
        return TRUE;
    }
    public event function bool GM_OnQuickMatchUpdate(SFXOnlineEvent_QuickMatch qmEvent)
    {
        if (qmEvent.SearchOutcome == SFXOnlineQuickMatchOutcome.SFXONLINE_MATCHMAKER_FAILED || qmEvent.SearchOutcome == SFXOnlineQuickMatchOutcome.SFXONLINE_MATCHMAKER_SEARCH_TIMEOUT)
        {
            GotoState('MMS_PreMatch', , , );
        }
        return TRUE;
    }
    public event function bool GM_OnLeaveGameComplete()
    {
        GotoState('MMS_PreMatch', , , );
        return TRUE;
    }
    public event function bool GM_OnLeaveGame()
    {
        GotoState('MMS_LeavingGame', , , );
        return TRUE;
    }
    public event function bool GM_IsWaitingForNetwork()
    {
        return FALSE;
    }
    public event function BeginState(Name nmPrevious)
    {
        if (GM_IsWaitingForNetwork())
        {
            NotifyEventType(25);
        }
        else
        {
            NotifyEventType(26);
        }
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_TestStateNames = ('MMS_Inactive', 
                        'MMS_PreMatch', 
                        'MMS_QuickMatchSent', 
                        'MMS_CreateGameSent', 
                        'MMS_LobbyHost', 
                        'MMS_MapBeingPlayedAsHost', 
                        'MMS_LobbyClient', 
                        'MMS_JoinConnectionFailed', 
                        'MMS_FailJoiningGame', 
                        'MMS_FailConnecting_QM', 
                        'MMS_ResolvingHostAddress_QM', 
                        'MMS_ConnectingToHost_QM', 
                        'MMS_ConnectingToHost_Invite', 
                        'MMS_MapBeingPlayedAsClient', 
                        'MMS_LeavingGame', 
                        'MMS_ResolvingInvite', 
                        'MMS_ResolvingInvite_InactiveUser', 
                        'MMS_AcceptedInvite', 
                        'MMS_ResolvingHostAddress_Invite', 
                        'MMS_HostMigrating', 
                        'MMS_ShowNetworkError'
                       )
    m_TestInputNames = ('GM_OnEnterMPFlow', 
                        'GM_OnEnterMPGameplay', 
                        'GM_OnEnterMPGameResults', 
                        'GM_OnExitMPFlow', 
                        'GM_OnQuickMatchSent', 
                        'GM_OnCreateGameSent', 
                        'GM_OnGameCreated', 
                        'GM_OnLeaveGame', 
                        'GM_OnLeaveGameComplete', 
                        'GM_OnHostAddressResolved', 
                        'GM_OnInviteAccepted', 
                        'GM_OnInviteAborted', 
                        'GM_OnInviteProceed', 
                        'GM_OnInviteErrorNotified', 
                        'GM_OnGameJoined', 
                        'GM_OnGameJoinFailure', 
                        'GM_CancelSearch', 
                        'GM_OnQuickMatchUpdate', 
                        'GM_OnDisconnect', 
                        'GM_OnP2PConnectionFailure', 
                        'GM_OnNetworkErrorDismissed', 
                        'GM_OnProfileSelected', 
                        'GM_OnHostMigrationStarted', 
                        'GM_OnHostMigrationEnded'
                       )
    m_LobbyLongWaitingTime = 120.0
    m_GameLongActionTime = 90.0
    EventSubscriberTable = ({EventCallback = 'GM_OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}, 
                            {EventCallback = 'GM_OnQuickMatchUpdate', EventType = SFXOnlineEventType.SFXONLINE_EVENT_QUICKMATCH}
                           )
}