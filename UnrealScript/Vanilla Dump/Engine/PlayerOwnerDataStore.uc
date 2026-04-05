Class PlayerOwnerDataStore extends UIDataStore_GameState
    native
    transient;

struct native PlayerDataProviderTypes 
{
    var const Class<PlayerOwnerDataProvider> PlayerOwnerDataProviderClass;
    var const Class<CurrentWeaponDataProvider> CurrentWeaponDataProviderClass;
    var const Class<WeaponDataProvider> WeaponDataProviderClass;
    var const Class<PowerupDataProvider> PowerupDataProviderClass;
};

var const PlayerDataProviderTypes ProviderTypes;
var array<WeaponDataProvider> WeaponList;
var array<PowerupDataProvider> PowerupList;
var PlayerOwnerDataProvider PlayerData;
var CurrentWeaponDataProvider CurrentWeapon;

public function bool NotifyGameSessionEnded()
{
    ClearDataProviders();
    return Super.NotifyGameSessionEnded();
}
public final function ClearDataProviders()
{
    local int i;
    
    if (PlayerData != None)
    {
        PlayerData.CleanupDataProvider();
    }
    if (CurrentWeapon != None)
    {
        CurrentWeapon.CleanupDataProvider();
    }
    for (i = 0; i < WeaponList.Length; i++)
    {
        WeaponList[i].CleanupDataProvider();
    }
    for (i = 0; i < PowerupList.Length; i++)
    {
        PowerupList[i].CleanupDataProvider();
    }
    PlayerData = None;
    CurrentWeapon = None;
    WeaponList.Length = 0;
    PowerupList.Length = 0;
}
public function SetPlayerDataProvider(PlayerDataProvider NewPlayerData)
{
    if (NewPlayerData != None)
    {
        if (PlayerData != None)
        {
            PlayerData.CleanupDataProvider();
        }
        PlayerData = new ProviderTypes.PlayerOwnerDataProviderClass;
    }
    if (PlayerData != None)
    {
        PlayerData.SetPlayerDataProvider(NewPlayerData);
        RefreshSubscribers();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ProviderTypes = {PlayerOwnerDataProviderClass = Class'PlayerOwnerDataProvider', CurrentWeaponDataProviderClass = Class'CurrentWeaponDataProvider', WeaponDataProviderClass = Class'WeaponDataProvider', PowerupDataProviderClass = Class'PowerupDataProvider'}
    Tag = 'PlayerOwner'
}