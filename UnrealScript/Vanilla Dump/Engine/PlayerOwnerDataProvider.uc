Class PlayerOwnerDataProvider extends PlayerDataProvider
    native
    transient;

var transient PlayerDataProvider PlayerData;

public event function bool CleanupDataProvider()
{
    if (Super(UIDynamicDataProvider).CleanupDataProvider())
    {
        PlayerData = None;
        return TRUE;
    }
    return FALSE;
}
public function SetPlayerDataProvider(PlayerDataProvider NewPlayerData)
{
    local Object PRI;
    
    if (NewPlayerData != None)
    {
        PRI = NewPlayerData.GetDataSource();
        if (PRI != None)
        {
            BindProviderInstance(PRI);
        }
    }
    PlayerData = NewPlayerData;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}