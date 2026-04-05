Class UIDataProvider_Settings extends UIDynamicDataProvider
    native
    transient;

struct native SettingsArrayProvider 
{
    var Name SettingsName;
    var int SettingsId;
    var UIDataProvider_SettingsArray Provider;
};

var array<SettingsArrayProvider> SettingsArrayProviders;
var Settings Settings;
var bool bIsAListRow;

public event function ProviderInstanceBound(Object DataSourceInstance)
{
    local Settings SettingsObject;
    
    Super.ProviderInstanceBound(DataSourceInstance);
    SettingsObject = Settings(DataSourceInstance);
    if (SettingsObject != None)
    {
        SettingsObject.__NotifySettingValueUpdated__Delegate = OnSettingValueUpdated;
        SettingsObject.__NotifyPropertyValueUpdated__Delegate = OnSettingValueUpdated;
    }
}
public event function ProviderInstanceUnbound(Object DataSourceInstance)
{
    local Settings SettingsObject;
    
    Super.ProviderInstanceBound(DataSourceInstance);
    SettingsObject = Settings(DataSourceInstance);
    if (SettingsObject != None)
    {
        if (SettingsObject.__NotifySettingValueUpdated__Delegate == OnSettingValueUpdated)
        {
            SettingsObject.__NotifySettingValueUpdated__Delegate = None;
        }
        if (SettingsObject.__NotifyPropertyValueUpdated__Delegate == OnSettingValueUpdated)
        {
            SettingsObject.__NotifyPropertyValueUpdated__Delegate = None;
        }
    }
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
public function OnSettingValueUpdated(Name SettingName)
{
    local int ProviderIdx;
    local UIDataProvider_SettingsArray ArrayProvider;
    
    if (!bIsAListRow)
    {
        for (ProviderIdx = 0; ProviderIdx < SettingsArrayProviders.Length; ProviderIdx++)
        {
            if (SettingName == SettingsArrayProviders[ProviderIdx].SettingsName)
            {
                ArrayProvider = SettingsArrayProviders[ProviderIdx].Provider;
                ArrayProviderPropertyChanged(ArrayProvider, SettingName);
                break;
            }
        }
    }
    else
    {
        NotifyPropertyChanged(SettingName);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WriteAccessType = EProviderAccessType.ACCESS_WriteAll
}