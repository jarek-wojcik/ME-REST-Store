Class UIDynamicDataProvider extends UIPropertyDataProvider
    implements(UIListElementCellProvider)
    native
    abstract
    transient;

var const native noexport Pointer VfTable_IUIListElementCellProvider;
var const Class<Object> DataClass;
var const transient Object DataSource;

public final native function bool BindProviderInstance(Object DataSourceInstance);

public event function bool CleanupDataProvider()
{
    return UnbindProviderInstance();
}
public event function bool IsValidDataSourceClass(Class<Object> PotentialDataSourceClass)
{
    return TRUE;
}
public event function ProviderInstanceBound(Object DataSourceInstance);

public event function ProviderInstanceUnbound(Object DataSourceInstance);

public final native function bool UnbindProviderInstance();

public final function Object GetDataSource()
{
    return DataSource;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}