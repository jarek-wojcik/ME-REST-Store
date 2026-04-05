Class UIDataStore_SessionSettings extends UIDataStore_Settings
    native
    transient
    config(Game);

var const config array<string> SessionSettingsProviderClassNames;
var const transient array<Class<SessionSettingsProvider>> SessionSettingsProviderClasses;
var transient array<SessionSettingsProvider> SessionSettings;

public function bool NotifyGameSessionEnded()
{
    ClearDataProviders();
    return Super(UIDataStore).NotifyGameSessionEnded();
}
public final function ClearDataProviders()
{
    local int i;
    
    for (i = 0; i < SessionSettings.Length; i++)
    {
        SessionSettings[i].CleanupDataProvider();
    }
    SessionSettings.Length = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Tag = 'GameSettings'
}