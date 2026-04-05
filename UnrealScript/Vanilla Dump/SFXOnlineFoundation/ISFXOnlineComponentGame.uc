Class ISFXOnlineComponentGame extends ISFXOnlineComponent
    native
    abstract;

public native function AllowMatchmaking(bool bAllow, bool bUpdateServer);

public native function int GetPlayerCount();

public event function SFXOnlineGameSettings GetSFXGameSettings();

public native function bool IsHostMigrationInProgress();

public native function bool IsInvalidHost();

public native function bool IsPlaying();

public native function bool IsReadyForConnections();

public native function bool KickPlayer(UniqueNetId PlayerID);

public native function LeaveGame();

public function bool OnConnectionError();

public native function bool OnHostAddressResolved();

public native function bool PerformCallRestrictedFunction();

public native function SetCallRestrictedFunctionMode(bool bEnable);

public function SetHostViabilityEnabled(bool Enabled);

public event function SetMPDLCInfo(out array<MPDLCInfo> allAvailableDLCs);

public event function SetMultiplayerTargetVersion(int protocolVersion);

public event function SetServerMatchMakingRulesVersion(int serverRulesVersion);

public native function UpdateGameProtocolVersion();

public function GetMultiplayer_MissingDLCs(out array<MPDLCInfo> missingDLCs, bool bInvitee);

public function bool IsOnLatestMultiplayerVersion();

public function bool WasKickedOutOfGame();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}