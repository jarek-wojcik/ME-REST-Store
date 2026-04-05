Class UIDataStore_GameResource extends UIDataStore
    implements(UIListElementProvider)
    native
    transient
    config(Game);

struct native GameResourceDataProvider 
{
    var config string ProviderClassName;
    var transient Class<UIResourceDataProvider> ProviderClass;
    var config Name ProviderTag;
    var config bool bExpandProviders;
};

var const native noexport Pointer VfTable_IUIListElementProvider;
var const transient native MultiMap_Mirror ListElementProviders;
var config array<GameResourceDataProvider> ElementProviderTypes;

public final native function int FindProviderIndexByFieldValue(Name ProviderTag, Name SearchField, const out UIProviderScriptFieldValue ValueToSearchFor);

public final native function int FindProviderTypeIndex(Name ProviderTag);

public final native function Name GenerateProviderAccessTag(int ProviderIndex, int InstanceIndex);

public native function int GetProviderCount(Name ProviderTag);

public final native function bool GetProviderFieldValue(Name ProviderTag, Name SearchField, int ProviderIndex, out UIProviderScriptFieldValue out_FieldValue);

public final native function bool GetResourceProviderFields(Name ProviderTag, out array<Name> ProviderFieldTags);

public final native function bool GetResourceProviders(Name ProviderTag, out array<UIResourceDataProvider> out_Providers);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Tag = 'GameResources'
}