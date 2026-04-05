Class PowerupDataProvider extends InventoryDataProvider
    native
    transient;

public event function bool IsValidDataSourceClass(Class<Object> PotentialDataSourceClass)
{
    local bool bResult;
    
    bResult = Super(UIDynamicDataProvider).IsValidDataSourceClass(PotentialDataSourceClass);
    if (bResult)
    {
        bResult = !ClassIsChildOf(PotentialDataSourceClass, Class'Weapon');
    }
    return bResult;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DataClass = Class'Inventory'
}