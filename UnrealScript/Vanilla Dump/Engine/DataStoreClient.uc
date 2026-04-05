Class DataStoreClient extends UIRoot
    native
    config(Engine);

struct native transient PlayerDataStoreGroup 
{
    var const transient init array<UIDataStore> DataStores;
    var const transient init LocalPlayer PlayerOwner;
};

var config array<string> GlobalDataStoreClasses;
var const array<UIDataStore> GlobalDataStores;
var config array<string> PlayerDataStoreClassNames;
var const array<Class<UIDataStore>> PlayerDataStoreClasses;
var const array<PlayerDataStoreGroup> PlayerDataStores;

public final native function coerce UIDataStore CreateDataStore(Class<UIDataStore> DataStoreClass);

public final native function UIDataStore FindDataStore(Name DataStoreTag, optional LocalPlayer PlayerOwner);

public final native function int FindPlayerDataStoreIndex(LocalPlayer PlayerOwner);

public final native function GetAvailableDataStores(UIScene CurrentScene, out array<UIDataStore> out_DataStores);

public final event function NotifyGameSessionEnded()
{
    local int i;
    local int DataStoreIndex;
    local array<UIDataStore> DataStoreArray;
    
    DataStoreArray = GlobalDataStores;
    for (DataStoreIndex = 0; DataStoreIndex < DataStoreArray.Length; DataStoreIndex++)
    {
        if (DataStoreArray[DataStoreIndex].NotifyGameSessionEnded())
        {
            UnregisterDataStore(DataStoreArray[DataStoreIndex]);
        }
    }
    for (i = PlayerDataStores.Length - 1; i >= 0; i--)
    {
        DataStoreArray = PlayerDataStores[i].DataStores;
        for (DataStoreIndex = 0; DataStoreIndex < DataStoreArray.Length; DataStoreIndex++)
        {
            DataStoreArray[DataStoreIndex].NotifyGameSessionEnded();
            UnregisterDataStore(DataStoreArray[DataStoreIndex]);
        }
    }
}
public final native function bool RegisterDataStore(UIDataStore DataStore, optional LocalPlayer PlayerOwner);

public final native function bool UnregisterDataStore(UIDataStore DataStore);

public final function DebugDumpDataStoreInfo(bool bVerbose);

public final function Class<UIDataStore> FindDataStoreClass(Class<UIDataStore> RequiredMetaClass)
{
    local int i;
    local Class<UIDataStore> Result;
    
    for (i = 0; i < GlobalDataStores.Length; i++)
    {
        if (GlobalDataStores[i].IsA(RequiredMetaClass.Name))
        {
            Result = GlobalDataStores[i].Class;
            break;
        }
    }
    if (Result == None)
    {
        for (i = 0; i < PlayerDataStoreClasses.Length; i++)
        {
            if (ClassIsChildOf(PlayerDataStoreClasses[i], RequiredMetaClass))
            {
                Result = PlayerDataStoreClasses[i];
                break;
            }
        }
    }
    return Result;
}
public final function GetPlayerDataStoreClasses(out array<Class<UIDataStore>> out_DataStoreClasses)
{
    out_DataStoreClasses = PlayerDataStoreClasses;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GlobalDataStoreClasses = ("Engine.UIDataStore_Images", 
                              "Engine.UIDataStore_GameResource", 
                              "Engine.CurrentGameDataStore", 
                              "Engine.UIDataStore_Fonts", 
                              "Engine.UIDataStore_Color", 
                              "Engine.UIDataStore_Gamma", 
                              "Engine.UIDataStore_Registry", 
                              "Engine.UIDataStore_InputAlias"
                             )
    PlayerDataStoreClassNames = ("Engine.PlayerOwnerDataStore", "Engine.UIDataStore_OnlinePlayerData")
}