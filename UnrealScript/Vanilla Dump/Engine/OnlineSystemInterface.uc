Class OnlineSystemInterface extends Interface
    abstract;

var delegate<OnExternalUIChange> __OnExternalUIChange__Delegate;
var delegate<OnControllerChange> __OnControllerChange__Delegate;
var delegate<OnConnectionStatusChange> __OnConnectionStatusChange__Delegate;
var delegate<OnStorageDeviceChange> __OnStorageDeviceChange__Delegate;
var delegate<OnReadTitleFileComplete> __OnReadTitleFileComplete__Delegate;
var delegate<OnLinkStatusChange> __OnLinkStatusChange__Delegate;

public function ENATType GetNATType();

public function bool GetTitleFileContents(string Filename, out array<byte> FileContents);

public function bool HasLinkConnection();

public function bool IsControllerConnected(int ControllerId);

public delegate function OnConnectionStatusChange(EOnlineServerConnectionStatus ConnectionStatus);

public delegate function OnControllerChange(int ControllerId, bool bIsConnected);

public delegate function OnExternalUIChange(bool bIsOpening);

public delegate function OnLinkStatusChange(bool bIsConnected);

public delegate function OnReadTitleFileComplete(bool bWasSuccessful, string Filename);

public delegate function OnStorageDeviceChange();

public function bool ReadTitleFile(string FileToRead);

public function SetNetworkNotificationPosition(ENetworkNotificationPosition NewPos);

public function AddConnectionStatusChangeDelegate(delegate<OnConnectionStatusChange> ConnectionStatusDelegate);

public function AddControllerChangeDelegate(delegate<OnControllerChange> ControllerChangeDelegate);

public function AddExternalUIChangeDelegate(delegate<OnExternalUIChange> ExternalUIDelegate);

public function AddLinkStatusChangeDelegate(delegate<OnLinkStatusChange> LinkStatusDelegate);

public function AddReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate);

public function AddStorageDeviceChangeDelegate(delegate<OnStorageDeviceChange> StorageDeviceChangeDelegate);

public function ClearConnectionStatusChangeDelegate(delegate<OnConnectionStatusChange> ConnectionStatusDelegate);

public function ClearControllerChangeDelegate(delegate<OnControllerChange> ControllerChangeDelegate);

public function ClearExternalUIChangeDelegate(delegate<OnExternalUIChange> ExternalUIDelegate);

public function ClearLinkStatusChangeDelegate(delegate<OnLinkStatusChange> LinkStatusDelegate);

public function ClearReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate);

public function ClearStorageDeviceChangeDelegate(delegate<OnStorageDeviceChange> StorageDeviceChangeDelegate);

public function ENetworkNotificationPosition GetNetworkNotificationPosition();

public function EOnlineEnumerationReadState GetTitleFileState(string Filename);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}