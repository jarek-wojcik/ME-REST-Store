Class ISFXOnlineComponentGameFlow extends ISFXOnlineComponent
    native
    abstract;

enum JoinFailureReason
{
    JFR_Unknown,
    JFR_GameFull,
    JFR_InviterLeft,
    JFR_ProtocolMismatch,
    JFR_MissingDLCInviter,
    JFR_MissingDLCInvitee,
};

public event function bool DebugValidateStates(optional bool writeToFile = TRUE);

public event function string GetStateStr();

public event function bool GM_HasCreatedGame();

public event function bool GM_HasFailedConnecting_QM();

public event function bool GM_HasFailedJoiningFullGame();

public event function bool GM_HasFailedJoiningGameMissingDLCInvitee();

public event function bool GM_HasFailedJoiningGameMissingDLCInviter();

public event function bool GM_HasFailedJoiningGameProtocolMismatch();

public event function bool GM_HasFailedJoiningInviterLeft();

public event function bool GM_HasJoinedGame();

public event function bool GM_IsConnectionErrorSilent();

public event function bool GM_IsInMPMapAction();

public event function bool GM_IsInMultiplayerFlow();

public event function bool GM_IsInMultiplayerGame();

public event function bool GM_IsLeavingGame();

public event function bool GM_OnCreateGameSent();

public event function bool GM_OnDisconnect();

public event function bool GM_OnEnterMPFlow();

public event function bool GM_OnEnterMPGameplay();

public event function bool GM_OnEnterMPGameResults();

public event function bool GM_OnExitMPFlow();

public event function bool GM_OnGameCreated(bool bSuccess);

public event function bool GM_OnGameJoined();

public event function bool GM_OnHostAddressResolved();

public event function bool GM_OnHostMigrationEnded(bool bInLobby);

public event function bool GM_OnHostMigrationStarted(bool bLocalPlayerIsHost);

public event function bool GM_OnInviteAborted();

public event function bool GM_OnInviteAccepted(bool invitedInactiveUser);

public event function bool GM_OnInviteErrorNotified();

public event function bool GM_OnInviteProceed();

public event function bool GM_OnLeaveGame();

public event function bool GM_OnLeaveGameComplete();

public event function bool GM_OnNetworkErrorDismissed();

public event function bool GM_OnP2PConnectionFailure();

public event function bool GM_OnProfileSelected();

public event function bool GM_OnQuickMatchSent();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}