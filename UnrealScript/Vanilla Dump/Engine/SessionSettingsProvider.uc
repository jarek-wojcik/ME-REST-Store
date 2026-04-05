Class SessionSettingsProvider extends UISettingsProvider within UIDataStore_SessionSettings
    native
    abstract
    transient;

var const Class<UISettingsClient> ProviderClientClass;
var const Class<Object> ProviderClientMetaClass;
var const transient Class<Object> ProviderClient;

public final native function bool BindProviderClient(Class<Object> DataSourceClass);

public event function bool CleanupDataProvider()
{
    if (ProviderClient != None)
    {
        return UnbindProviderClient();
    }
    return FALSE;
}
public event function bool IsValidDataSourceClass(Class<Object> PotentialDataSourceClass)
{
    return TRUE;
}
public event function ProviderClientBound(Class<Object> DataSourceClass);

public event function ProviderClientUnbound(Class<Object> DataSourceClass);

public final native function bool UnbindProviderClient();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ProviderClientClass = Class'UISettingsClient'
    ProviderTag = 'SessionSettingsProvider'
}