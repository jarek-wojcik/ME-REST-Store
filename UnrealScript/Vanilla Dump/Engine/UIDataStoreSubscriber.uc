Class UIDataStoreSubscriber extends Interface
    native
    abstract;

public native function ClearBoundDataStores();

public native function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

public native function string GetDataStoreBinding(optional int BindingIndex = -1);

public native function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, Name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex);

public native function bool RefreshSubscriberValue(optional int BindingIndex = -1);

public native function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}