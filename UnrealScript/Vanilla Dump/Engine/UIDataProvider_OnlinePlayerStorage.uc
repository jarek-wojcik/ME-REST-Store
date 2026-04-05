Class UIDataProvider_OnlinePlayerStorage extends UIDataProvider_OnlinePlayerDataBase
    native
    transient;

struct native PlayerStorageArrayProvider 
{
    var Name PlayerStorageName;
    var int PlayerStorageId;
    var UIDataProvider_OnlinePlayerStorageArray Provider;
};

var array<PlayerStorageArrayProvider> PlayerStorageArrayProviders;
var const Name ProviderName;
var OnlinePlayerStorage Profile;
var bool bWasErrorLastRead;

public function OnLoginChange(byte LocalUserNum)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local PlayerController PC;
    local ELoginStatus LoginStatus;
    local UniqueNetId NetId;
    
    if (int(LocalUserNum) == Player.ControllerId)
    {
        if (Player != None)
        {
            PC = Player.Actor;
            OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
            if (OnlineSub != None && PC != None)
            {
                PlayerInterface = OnlineSub.PlayerInterface;
                if (PlayerInterface != None)
                {
                    LoginStatus = PlayerInterface.GetLoginStatus(byte(Player.ControllerId));
                    PlayerInterface.GetUniquePlayerId(byte(Player.ControllerId), NetId);
                    if (LoginStatus == ELoginStatus.LS_NotLoggedIn || PC.PlayerReplicationInfo.UniqueId != NetId)
                    {
                        Profile.SetToDefaults();
                    }
                }
            }
        }
        RefreshStorageData();
    }
}
public event function OnRegister(LocalPlayer InPlayer)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Super.OnRegister(InPlayer);
    if (Player != None)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (PlayerInterface != None)
            {
                PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
                AddReadCompleteDelegate(PlayerInterface, byte(Player.ControllerId));
                if (ReadData(PlayerInterface, byte(Player.ControllerId), Profile) == FALSE)
                {
                    bWasErrorLastRead = TRUE;
                }
            }
        }
    }
    if (Profile != None)
    {
        Profile.__NotifySettingValueUpdated__Delegate = OnSettingValueUpdated;
    }
}
public event function OnUnregister()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local int ControllerId;
    
    if (Profile != None && Profile.__NotifySettingValueUpdated__Delegate == OnSettingValueUpdated)
    {
        Profile.__NotifySettingValueUpdated__Delegate = None;
    }
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
            ControllerId = Player != None ? Player.ControllerId : 0;
            ClearReadCompleteDelegate(PlayerInterface, byte(ControllerId));
        }
    }
    Super.OnUnregister();
}
public event function bool SaveStorageData()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            return WriteData(PlayerInterface, byte(Player.ControllerId), Profile);
        }
    }
    return FALSE;
}
public function AddReadCompleteDelegate(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
    PlayerInterface.AddReadPlayerStorageCompleteDelegate(LocalUserNum, OnReadStorageComplete);
}
public function ArrayProviderPropertyChanged(UIDataProvider SourceProvider, optional Name PropTag)
{
    local int Index;
    local delegate<OnDataProviderPropertyChange> Subscriber;
    
    for (Index = 0; Index < ProviderChangedNotifies.Length; Index++)
    {
        Subscriber = ProviderChangedNotifies[Index];
        Subscriber(SourceProvider, PropTag);
    }
}
public function ClearReadCompleteDelegate(OnlinePlayerInterface PlayerInterface, byte LocalUserNum)
{
    PlayerInterface.ClearReadPlayerStorageCompleteDelegate(LocalUserNum, OnReadStorageComplete);
}
public function OnReadStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    if (bWasSuccessful)
    {
        if (!bWasErrorLastRead)
        {
            NotifyPropertyChanged();
        }
        else
        {
            OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
            if (OnlineSub != None)
            {
                PlayerInterface = OnlineSub.PlayerInterface;
                if (PlayerInterface != None)
                {
                    bWasErrorLastRead = FALSE;
                    if (ReadData(PlayerInterface, byte(Player.ControllerId), Profile) == FALSE)
                    {
                        bWasErrorLastRead = TRUE;
                    }
                }
            }
        }
    }
    else
    {
        bWasErrorLastRead = TRUE;
    }
}
public function OnSettingValueUpdated(Name SettingName)
{
    local int ProviderIdx;
    local UIDataProvider_OnlinePlayerStorageArray ArrayProvider;
    
    for (ProviderIdx = 0; ProviderIdx < PlayerStorageArrayProviders.Length; ProviderIdx++)
    {
        if (SettingName == PlayerStorageArrayProviders[ProviderIdx].PlayerStorageName)
        {
            ArrayProvider = PlayerStorageArrayProviders[ProviderIdx].Provider;
            ArrayProviderPropertyChanged(ArrayProvider, SettingName);
            break;
        }
    }
}
public function bool ReadData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
    return PlayerInterface.ReadPlayerStorage(LocalUserNum, PlayerStorage);
}
public function RefreshStorageData()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None && int(PlayerInterface.GetLoginStatus(byte(Player.ControllerId))) > 0)
        {
            if (ReadData(PlayerInterface, byte(Player.ControllerId), Profile) == FALSE)
            {
                NotifyPropertyChanged();
            }
        }
    }
}
public function bool WriteData(OnlinePlayerInterface PlayerInterface, byte LocalUserNum, OnlinePlayerStorage PlayerStorage)
{
    return PlayerInterface.WritePlayerStorage(LocalUserNum, PlayerStorage);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ProviderName = 'PlayerStorageData'
    WriteAccessType = EProviderAccessType.ACCESS_WriteAll
}