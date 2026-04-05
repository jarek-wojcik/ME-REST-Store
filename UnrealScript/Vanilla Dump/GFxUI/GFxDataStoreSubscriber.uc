Class GFxDataStoreSubscriber
    implements(UIDataStorePublisher)
    native;

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var GFxMovie movie;

public final native function ClearBoundDataStores();

public final native function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

public final native function string GetDataStoreBinding(optional int BindingIndex = -1);

public final native function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, Name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex);

public final native function bool RefreshSubscriberValue(optional int BindingIndex = -1);

public native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1);

public final native function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1);

public final native function PublishValues();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}