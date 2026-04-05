Class UIDataStore_OnlineGameSettings extends UIDataStore_Settings
    native
    abstract
    transient;

struct native GameSettingsCfg 
{
    var Class<OnlineGameSettings> GameSettingsClass;
    var Name SettingsName;
    var UIDataProvider_Settings Provider;
    var OnlineGameSettings GameSettings;
};

var const array<GameSettingsCfg> GameSettingsCfgList;
var const Class<UIDataProvider_Settings> SettingsProviderClass;
var int SelectedIndex;

public event function bool CreateGame(byte ControllerIndex)
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInterface;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        GameInterface = OnlineSub.GameInterface;
        if (GameInterface != None)
        {
            return GameInterface.CreateOnlineGame(ControllerIndex, 'Game', GameSettingsCfgList[SelectedIndex].GameSettings);
        }
    }
    return FALSE;
}
public event function OnlineGameSettings GetCurrentGameSettings()
{
    return GameSettingsCfgList[SelectedIndex].GameSettings;
}
public event function UIDataProvider_Settings GetCurrentProvider()
{
    return GameSettingsCfgList[SelectedIndex].Provider;
}
public event function MoveToNext()
{
    local int NewIndex;
    
    NewIndex = Min(SelectedIndex + 1, GameSettingsCfgList.Length - 1);
    if (SelectedIndex != NewIndex)
    {
        SetCurrentByIndex(NewIndex);
    }
}
public event function MoveToPrevious()
{
    local int NewIndex;
    
    NewIndex = Max(SelectedIndex - 1, 0);
    if (SelectedIndex != NewIndex)
    {
        SetCurrentByIndex(NewIndex);
    }
}
public final native function OnSettingProviderChanged(UIDataProvider SourceProvider, optional Name SettingsName);

public event function Registered(LocalPlayer PlayerOwner)
{
    local int CfgIndex;
    local UIDataProvider_Settings Provider;
    
    Super(UIDataStore).Registered(PlayerOwner);
    for (CfgIndex = 0; CfgIndex < GameSettingsCfgList.Length; CfgIndex++)
    {
        Provider = GameSettingsCfgList[CfgIndex].Provider;
        if (Provider != None)
        {
            Provider.AddPropertyNotificationChangeRequest(OnSettingProviderChanged, FALSE);
        }
    }
}
public event function SetCurrentByIndex(int NewIndex)
{
    if (NewIndex >= 0 && NewIndex < GameSettingsCfgList.Length)
    {
        SelectedIndex = NewIndex;
        NotifyPropertyChanged('SelectedIndex');
        RefreshSubscribers(, TRUE, GetCurrentProvider());
    }
}
public event function SetCurrentByName(Name SettingsName)
{
    local int Index;
    
    for (Index = 0; Index < GameSettingsCfgList.Length; Index++)
    {
        if (GameSettingsCfgList[Index].SettingsName == SettingsName)
        {
            SetCurrentByIndex(Index);
            return;
        }
    }
}
public event function Unregistered(LocalPlayer PlayerOwner)
{
    local int CfgIndex;
    local UIDataProvider_Settings Provider;
    
    Super(UIDataStore).Unregistered(PlayerOwner);
    for (CfgIndex = 0; CfgIndex < GameSettingsCfgList.Length; CfgIndex++)
    {
        Provider = GameSettingsCfgList[CfgIndex].Provider;
        if (Provider != None)
        {
            Provider.RemovePropertyNotificationChangeRequest(OnSettingProviderChanged);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SettingsProviderClass = Class'UIDataProvider_Settings'
    Tag = 'OnlineGameSettings'
    WriteAccessType = EProviderAccessType.ACCESS_WriteAll
}