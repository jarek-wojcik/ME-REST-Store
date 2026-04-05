Class UIDataStore_InputAlias extends UIDataStore_StringBase
    native
    transient
    config(Input);

struct native UIDataStoreInputAlias 
{
    var config UIInputKeyData PlatformInputKeys[3];
    var config Name AliasName;
};
struct native UIInputKeyData 
{
    var config string ButtonFontMarkupString;
    var config RawInputKeyEventData InputKeyData;
};

var config array<UIDataStoreInputAlias> InputAliases;
var const transient native Object InputAliasLookupMap;

public final native function int FindInputAliasIndex(Name DesiredAlias);

public final native function string GetAliasFontMarkup(Name DesiredAlias, optional EInputPlatformType OverridePlatform = 3);

public final native function string GetAliasFontMarkupByIndex(int AliasIndex, optional EInputPlatformType OverridePlatform = 3);

public final native function bool GetAliasInputKeyData(out RawInputKeyEventData out_InputKeyData, Name DesiredAlias, optional EInputPlatformType OverridePlatform = 3);

public final native function bool GetAliasInputKeyDataByIndex(out RawInputKeyEventData out_InputKeyData, int AliasIndex, optional EInputPlatformType OverridePlatform = 3);

public final native function Name GetAliasInputKeyName(Name DesiredAlias, optional EInputPlatformType OverridePlatform = 3);

public final native function Name GetAliasInputKeyNameByIndex(int AliasIndex, optional EInputPlatformType OverridePlatform = 3);

public final native function bool HasAliasMappingForPlatform(Name DesiredAlias, EInputPlatformType DesiredPlatform);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Tag = 'ButtonCallouts'
}