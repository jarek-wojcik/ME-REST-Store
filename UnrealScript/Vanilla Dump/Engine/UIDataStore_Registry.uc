Class UIDataStore_Registry extends UIDataStore
    native
    transient;

var UIDynamicFieldProvider RegistryDataProvider;

public final function UIDynamicFieldProvider GetDataProvider()
{
    return RegistryDataProvider;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Tag = 'Registry'
    WriteAccessType = EProviderAccessType.ACCESS_WriteAll
}