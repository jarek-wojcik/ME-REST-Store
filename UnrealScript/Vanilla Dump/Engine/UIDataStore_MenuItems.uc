Class UIDataStore_MenuItems extends UIDataStore_GameResource
    native
    transient
    config(UI);

var const transient native MultiMap_Mirror OptionProviders;
var transient array<UIDataProvider_MenuItem> DynamicProviders;
var const Name CurrentGameSettingsTag;

public native function AppendToSet(Name SetName, int NumOptions);

public native function ClearSet(Name SetName);

public native function GetSet(Name SetName, out array<UIDataProvider_MenuItem> OutProviders);

public event function Registered(LocalPlayer PlayerOwner)
{
    local UIDataStore_OnlineGameSettings GameSettingsDataStore;
    
    Super(UIDataStore).Registered(PlayerOwner);
    GameSettingsDataStore = UIDataStore_OnlineGameSettings(Class'UIRoot'.static.StaticResolveDataStore(Class'UIDataStore_OnlineGameSettings'.default.Tag));
    if (GameSettingsDataStore != None)
    {
        GameSettingsDataStore.AddPropertyNotificationChangeRequest(OnGameSettingsChanged);
    }
}
public event function Unregistered(LocalPlayer PlayerOwner)
{
    local UIDataStore_OnlineGameSettings GameSettingsDataStore;
    
    Super(UIDataStore).Unregistered(PlayerOwner);
    GameSettingsDataStore = UIDataStore_OnlineGameSettings(Class'UIRoot'.static.StaticResolveDataStore(Class'UIDataStore_OnlineGameSettings'.default.Tag));
    if (GameSettingsDataStore != None)
    {
        GameSettingsDataStore.RemovePropertyNotificationChangeRequest(OnGameSettingsChanged);
    }
}
public function OnGameSettingsChanged(UIDataProvider SourceProvider, optional Name PropTag)
{
    local UIDataStore_OnlineGameSettings GameSettingsDataStore;
    
    GameSettingsDataStore = UIDataStore_OnlineGameSettings(SourceProvider);
    if (GameSettingsDataStore != None && PropTag == 'SelectedIndex')
    {
        RefreshSubscribers(CurrentGameSettingsTag, TRUE, Self);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CurrentGameSettingsTag = 'CurrentGameSettings'
    Tag = 'MenuItems'
}