Class GameInfoDataProvider extends UIDynamicDataProvider
    native
    transient;

var GameReplicationInfo GameDataSource;

public event function ProviderInstanceBound(Object DataSourceInstance)
{
    local GameReplicationInfo GRI;
    
    GRI = GameReplicationInfo(DataSourceInstance);
    if (GRI != None)
    {
        GameDataSource = GRI;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DataClass = Class'GameReplicationInfo'
}