Class UISettingsProvider extends UIPropertyDataProvider
    native
    abstract
    transient;

var const Name ProviderTag;

public event function bool CleanupDataProvider()
{
    return TRUE;
}
public function LoadPropertyValue(Name PropertyName, UIObject Widget);

public function bool OnModifiedProperty(Name PropertyName, UIObject Widget);

public function SavePropertyValue(Name PropertyName, UIObject Widget);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ProviderTag = 'SettingsProvider'
}