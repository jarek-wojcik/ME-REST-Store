Class UIDataProvider_MenuItem extends UIResourceDataProvider
    native
    perobjectconfig
    transient
    config(UI);

enum EMenuOptionType
{
    MENUOT_ComboReadOnly,
    MENUOT_ComboNumeric,
    MENUOT_CheckBox,
    MENUOT_Slider,
    MENUOT_Spinner,
    MENUOT_EditBox,
    MENUOT_CollectionCheckBox,
    MENUOT_CollapsingList,
};

var config array<Name> OptionSet;
var config string DataStoreMarkup;
var config string DescriptionMarkup;
var const config localized string FriendlyName;
var string CustomFriendlyName;
var const config localized string Description;
var config array<Name> SchemaCellFields;
var const string IniName;
var config UIRangeData RangeData;
var config Name RequiredGameMode;
var config int EditBoxMaxLength;
var config bool bEditableCombo;
var config bool bNumericCombo;
var config bool bKeyboardOrMouseOption;
var config bool bOnlineOnly;
var config bool bOfflineOnly;
var(UIDataProvider_MenuItem) bool bSearchAllInis;
var config bool bRemoveOn360;
var config bool bRemoveOnPC;
var config bool bRemoveOnPS3;
var config EMenuOptionType OptionType;
var config EEditBoxCharacterSet EditboxAllowedChars;

public final native function bool IsFiltered();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}