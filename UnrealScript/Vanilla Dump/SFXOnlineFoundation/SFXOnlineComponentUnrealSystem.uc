Class SFXOnlineComponentUnrealSystem extends SFXOnlineComponent
    implements(OnlineSystemInterface, ISFXOnlineComponent)
    native
    config(Engine);

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var array<delegate<OnExternalUIChange>> ExternalUIChangeDelegates;
var array<delegate<OnControllerChange>> ControllerChangeDelegates;
var array<TitleFile> TitleManagedFiles;
var array<delegate<OnReadTitleFileComplete>> ReadTitleFileCompleteDelegates;
var array<delegate<OnStorageDeviceChange>> StorageDeviceChangeDelegates;
var array<delegate<OnConnectionStatusChange>> ConnectionStatusChangeDelegates;
var array<delegate<OnConnectionStatusChange>> LinkStatusChangeDelegates;
var delegate<OnLinkStatusChange> __OnLinkStatusChange__Delegate;
var delegate<OnExternalUIChange> __OnExternalUIChange__Delegate;
var delegate<OnControllerChange> __OnControllerChange__Delegate;
var delegate<OnConnectionStatusChange> __OnConnectionStatusChange__Delegate;
var delegate<OnStorageDeviceChange> __OnStorageDeviceChange__Delegate;
var delegate<OnReadTitleFileComplete> __OnReadTitleFileComplete__Delegate;
var config ENetworkNotificationPosition CurrentNotificationPosition;

public native function Name GetAPIName();

public function ENATType GetNATType()
{
    return 1;
}
public native function bool GetTitleFileContents(string Filename, out array<byte> FileContents);

public native function bool HasLinkConnection();

public native function bool IsControllerConnected(int ControllerId);

public delegate function OnConnectionStatusChange(EOnlineServerConnectionStatus ConnectionStatus);

public delegate function OnControllerChange(int ControllerId, bool bIsConnected);

public delegate function OnExternalUIChange(bool bIsOpening);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public delegate function OnLinkStatusChange(bool bIsConnected);

public delegate function OnReadTitleFileComplete(bool bWasSuccessful, string Filename);

public native function OnRelease();

public delegate function OnStorageDeviceChange();

public final native function ProcessExternalUINotification(bool bOpening);

public native function bool ReadTitleFile(string FileToRead);

public native function SetNetworkNotificationPosition(ENetworkNotificationPosition NewPos);

public function AddConnectionStatusChangeDelegate(delegate<OnConnectionStatusChange> ConnectionStatusDelegate)
{
    local int AddIndex;
    
    if (ConnectionStatusChangeDelegates.Find(ConnectionStatusDelegate) == -1)
    {
        AddIndex = ConnectionStatusChangeDelegates.Length;
        ConnectionStatusChangeDelegates.Length = ConnectionStatusChangeDelegates.Length + 1;
        ConnectionStatusChangeDelegates[AddIndex] = ConnectionStatusDelegate;
    }
}
public function AddControllerChangeDelegate(delegate<OnControllerChange> ControllerChangeDelegate)
{
    local int AddIndex;
    
    if (ControllerChangeDelegates.Find(ControllerChangeDelegate) == -1)
    {
        AddIndex = ControllerChangeDelegates.Length;
        ControllerChangeDelegates.Length = ControllerChangeDelegates.Length + 1;
        ControllerChangeDelegates[AddIndex] = ControllerChangeDelegate;
    }
}
public function AddExternalUIChangeDelegate(delegate<OnExternalUIChange> ExternalUIDelegate)
{
    local int AddIndex;
    
    if (ExternalUIChangeDelegates.Find(ExternalUIDelegate) == -1)
    {
        AddIndex = ExternalUIChangeDelegates.Length;
        ExternalUIChangeDelegates.Length = ExternalUIChangeDelegates.Length + 1;
        ExternalUIChangeDelegates[AddIndex] = ExternalUIDelegate;
    }
}
public function AddLinkStatusChangeDelegate(delegate<OnLinkStatusChange> LinkStatusDelegate)
{
    local int AddIndex;
    
    if (LinkStatusChangeDelegates.Find(LinkStatusDelegate) == -1)
    {
        AddIndex = LinkStatusChangeDelegates.Length;
        LinkStatusChangeDelegates.Length = LinkStatusChangeDelegates.Length + 1;
        LinkStatusChangeDelegates[AddIndex] = LinkStatusDelegate;
    }
}
public function AddReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
    if (ReadTitleFileCompleteDelegates.Find(ReadTitleFileCompleteDelegate) == -1)
    {
        ReadTitleFileCompleteDelegates.AddItem(ReadTitleFileCompleteDelegate);
    }
}
public function AddStorageDeviceChangeDelegate(delegate<OnStorageDeviceChange> StorageDeviceChangeDelegate)
{
    if (StorageDeviceChangeDelegates.Find(StorageDeviceChangeDelegate) == -1)
    {
        StorageDeviceChangeDelegates.AddItem(StorageDeviceChangeDelegate);
    }
}
public function ClearConnectionStatusChangeDelegate(delegate<OnConnectionStatusChange> ConnectionStatusDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = ConnectionStatusChangeDelegates.Find(ConnectionStatusDelegate);
    if (RemoveIndex != -1)
    {
        ConnectionStatusChangeDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearControllerChangeDelegate(delegate<OnControllerChange> ControllerChangeDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = ControllerChangeDelegates.Find(ControllerChangeDelegate);
    if (RemoveIndex != -1)
    {
        ControllerChangeDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearExternalUIChangeDelegate(delegate<OnExternalUIChange> ExternalUIDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = ExternalUIChangeDelegates.Find(ExternalUIDelegate);
    if (RemoveIndex != -1)
    {
        ExternalUIChangeDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearLinkStatusChangeDelegate(delegate<OnLinkStatusChange> LinkStatusDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = LinkStatusChangeDelegates.Find(LinkStatusDelegate);
    if (RemoveIndex != -1)
    {
        LinkStatusChangeDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = ReadTitleFileCompleteDelegates.Find(ReadTitleFileCompleteDelegate);
    if (RemoveIndex != -1)
    {
        ReadTitleFileCompleteDelegates.Remove(RemoveIndex, 1);
    }
}
public function ClearStorageDeviceChangeDelegate(delegate<OnStorageDeviceChange> StorageDeviceChangeDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = StorageDeviceChangeDelegates.Find(StorageDeviceChangeDelegate);
    if (RemoveIndex != -1)
    {
        StorageDeviceChangeDelegates.Remove(RemoveIndex, 1);
    }
}
public function ENetworkNotificationPosition GetNetworkNotificationPosition()
{
    return CurrentNotificationPosition;
}
public function EOnlineEnumerationReadState GetTitleFileState(string Filename)
{
    local int FileIndex;
    
    FileIndex = TitleManagedFiles.Find('Filename', Filename);
    if (FileIndex != -1)
    {
        return TitleManagedFiles[FileIndex].AsyncState;
    }
    return 3;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}