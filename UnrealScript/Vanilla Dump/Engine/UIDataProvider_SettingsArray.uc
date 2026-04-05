Class UIDataProvider_SettingsArray extends UIDataProvider
    implements(UIListElementProvider, UIListElementCellProvider)
    native
    transient;

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var const string ColumnHeaderText;
var array<IdToStringMapping> Values;
var Name SettingsName;
var Settings Settings;
var int SettingsId;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WriteAccessType = EProviderAccessType.ACCESS_WriteAll
}