Class UIImage extends UIObject
    implements(UIDataStorePublisher)
    native
    placeable
    config(UI);

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var(Data) UIDataStoreBinding ImageDataSource;
var(Components) const editinline export noclear UIComp_DrawImage ImageComponent;

public final native function ClearBoundDataStores();

public final native function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

public final native function string GetDataStoreBinding(optional int BindingIndex = -1);

public final native function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, Name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex);

public final native function bool RefreshSubscriberValue(optional int BindingIndex = -1);

public final native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1);

public final native function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1);

public final function SetValue(Surface NewImage)
{
    ImageComponent.SetImage(NewImage);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=UIComp_DrawImage Name=ImageComponentTemplate
    End Object
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    ImageDataSource = {
                       MarkupString = "", 
                       Subscriber = None, 
                       DataStoreName = 'None', 
                       DataStoreField = 'None', 
                       BindingIndex = -1, 
                       ResolvedDataStore = None, 
                       RequiredFieldType = EUIDataProviderFieldType.DATATYPE_Property
                      }
    ImageComponent = ImageComponentTemplate
    PrimaryStyle = {RequiredStyleClass = Class'UIStyle_Image', DefaultStyleTag = 'DefaultImageStyle'}
    bSupportsPrimaryStyle = FALSE
    Position = {Value[2] = 50.0, Value[3] = 50.0, ScaleType[2] = EPositionEvalType.EVALPOS_PixelOwner, ScaleType[3] = EPositionEvalType.EVALPOS_PixelOwner}
    EventProvider = WidgetEventComponent
}