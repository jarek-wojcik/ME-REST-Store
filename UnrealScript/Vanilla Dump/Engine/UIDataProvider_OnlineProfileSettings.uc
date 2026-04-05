Class UIDataProvider_OnlineProfileSettings extends UIDataProvider_OnlinePlayerStorage
    native
    transient;

public function AddReadCompleteDelegate(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
    PlayerInterface.AddReadProfileSettingsCompleteDelegate(LocalUserNum, OnReadStorageComplete);
}
public function ClearReadCompleteDelegate(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
    PlayerInterface.ClearReadProfileSettingsCompleteDelegate(LocalUserNum, OnReadStorageComplete);
}
public function bool ReadData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
    return PlayerInterface.ReadProfileSettings(LocalUserNum, OnlineProfileSettings(PlayerStorage));
}
public function bool WriteData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
    return PlayerInterface.WriteProfileSettings(LocalUserNum, OnlineProfileSettings(PlayerStorage));
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ProviderName = 'ProfileData'
}