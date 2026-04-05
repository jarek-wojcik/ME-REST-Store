Class UIWeaponSummary extends UIResourceDataProvider
    perobjectconfig
    transient
    config(Game);

var config string ClassPathName;
var const config localized string FriendlyName;
var const config localized string WeaponDescription;
var config bool bIsDisabled;

public event function bool IsProviderDisabled()
{
    return bIsDisabled;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}