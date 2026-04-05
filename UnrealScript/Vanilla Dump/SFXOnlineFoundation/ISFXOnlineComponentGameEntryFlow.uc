Class ISFXOnlineComponentGameEntryFlow extends ISFXOnlineComponent
    native
    abstract;

public event function SetLoginState(SFXOnlineUIState loginState);

public function bool ActivateConnectFlow();

public function ActivateConnectToMapFlow(string mapPackageName, optional bool fromGalaxyMap = FALSE, optional SFXOnlineGameDifficulty Difficulty = 0, optional int objectiveMode = 0);

public function ActivateInviteFlow(const out OnlineGameSearchResult InviteResult);

public function ActivateMPLobbyAccessFlow();

public function SFXOnlineGameSettings GetDeferredGameSettings();

public function bool IsInConnectToMapFlow();

public function bool IsInGalaxyMapFlow();

public function bool IsInvitedUserActive(const out UniqueNetId invitedId);

public function bool IsWaitingForKitSelect();

public function OnConnectToMapFlowCompleted(optional bool Success = TRUE);

public function OnKitDeployed(bool Success);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}