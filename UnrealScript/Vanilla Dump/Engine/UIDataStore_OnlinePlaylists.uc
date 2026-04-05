Class UIDataStore_OnlinePlaylists extends UIDataStore
    implements(UIListElementProvider)
    native
    transient
    config(Game);

const UNRANKEDPROVIDERTAG = "PlaylistsUnranked";
const RANKEDPROVIDERTAG = "PlaylistsRanked";

var const native noexport Pointer VfTable_IUIListElementProvider;
var config string ProviderClassName;
var const array<UIResourceDataProvider> RankedDataProviders;
var const array<UIResourceDataProvider> UnRankedDataProviders;
var transient Class<UIResourceDataProvider> ProviderClass;

public final native function int FindProviderIndexByFieldValue(Name ProviderTag, Name SearchField, const out UIProviderScriptFieldValue ValueToSearchFor);

public final native function bool GetPlaylistProvider(Name ProviderTag, int ProviderIndex, out UIResourceDataProvider out_Provider);

public native function int GetProviderCount(Name ProviderTag);

public final native function bool GetProviderFieldValue(Name ProviderTag, Name SearchField, int ProviderIndex, out UIProviderScriptFieldValue out_FieldValue);

public final native function bool GetResourceProviderFields(Name ProviderTag, out array<Name> ProviderFieldTags);

public final native function bool GetResourceProviders(Name ProviderTag, out array<UIResourceDataProvider> out_Providers);

public static function OnlinePlaylistProvider GetOnlinePlaylistProvider(Name ProviderTag, int PlaylistId, optional out int ProviderIndex)
{
    local UIDataStore_OnlinePlaylists PlaylistDS;
    local UIProviderScriptFieldValue Value;
    local UIResourceDataProvider PlaylistProvider;
    
    ProviderIndex = -1;
    PlaylistDS = UIDataStore_OnlinePlaylists(Class'UIRoot'.static.StaticResolveDataStore(Class'UIDataStore_OnlinePlaylists'.default.Tag));
    if (PlaylistDS != None)
    {
        Value.PropertyTag = 'PlaylistId';
        Value.PropertyType = EUIDataProviderFieldType.DATATYPE_Property;
        Value.StringValue = string(PlaylistId);
        ProviderIndex = PlaylistDS.FindProviderIndexByFieldValue(ProviderTag, 'PlaylistId', Value);
        if (ProviderIndex != -1)
        {
            PlaylistDS.GetPlaylistProvider(ProviderTag, ProviderIndex, PlaylistProvider);
        }
    }
    return OnlinePlaylistProvider(PlaylistProvider);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Tag = 'OnlinePlaylists'
}