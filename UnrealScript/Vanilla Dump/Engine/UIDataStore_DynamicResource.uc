Class UIDataStore_DynamicResource extends UIDataStore
    implements(UIListElementProvider)
    native
    transient
    config(Game);

struct native DynamicResourceProviderDefinition 
{
    var config string ProviderClassName;
    var transient Class<UIResourceCombinationProvider> ProviderClass;
    var config Name ProviderTag;
};

var const native noexport Pointer VfTable_IUIListElementProvider;
var const transient native MultiMap_Mirror ResourceProviders;
var config array<DynamicResourceProviderDefinition> ResourceProviderDefinitions;
var transient UIDataProvider_OnlineProfileSettings ProfileProvider;
var transient UIDataStore_GameResource GameResourceDataStore;

public final native function int FindProviderIndexByFieldValue(Name ProviderTag, Name SearchField, const out UIProviderScriptFieldValue ValueToSearchFor);

public final native function int FindProviderTypeIndex(Name ProviderTag);

public final native function Name GenerateProviderAccessTag(int ProviderIndex, int InstanceIndex);

public native function int GetProviderCount(Name ProviderTag);

public final native function bool GetProviderFieldValue(Name ProviderTag, Name SearchField, int ProviderIndex, out UIProviderScriptFieldValue out_FieldValue);

public final native function bool GetResourceProviderFields(Name ProviderTag, out array<Name> ProviderFieldTags);

public final native function bool GetResourceProviders(Name ProviderTag, out array<UIResourceCombinationProvider> out_Providers);

public final native function OnLoginChange(byte LocalUserNum);

public event function Registered(LocalPlayer PlayerOwner)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local UIDataStore_OnlinePlayerData PlayerProfileDS;
    
    Super.Registered(PlayerOwner);
    PlayerProfileDS = UIDataStore_OnlinePlayerData(Class'UIRoot'.static.StaticResolveDataStore(Class'UIDataStore_OnlinePlayerData'.default.Tag, None, PlayerOwner));
    if (PlayerProfileDS != None)
    {
        ProfileProvider = PlayerProfileDS.ProfileProvider;
    }
    GameResourceDataStore = UIDataStore_GameResource(Class'UIRoot'.static.StaticResolveDataStore(Class'UIDataStore_GameResource'.default.Tag, None, PlayerOwner));
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        }
    }
}
public event function Unregistered(LocalPlayer PlayerOwner)
{
    local int TypeIndex;
    local int ProviderIndex;
    local array<UIResourceCombinationProvider> ProviderInstances;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Super.Unregistered(PlayerOwner);
    if (ProfileProvider.Player == PlayerOwner || ProfileProvider.Player == None)
    {
        ProfileProvider = None;
    }
    GameResourceDataStore = None;
    for (TypeIndex = 0; TypeIndex < ResourceProviderDefinitions.Length; TypeIndex++)
    {
        if (GetResourceProviders(ResourceProviderDefinitions[TypeIndex].ProviderTag, ProviderInstances))
        {
            for (ProviderIndex = 0; ProviderIndex < ProviderInstances.Length; ProviderIndex++)
            {
                ProviderInstances[ProviderIndex].ClearProviderReferences();
            }
        }
    }
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Tag = 'DynamicGameResource'
}