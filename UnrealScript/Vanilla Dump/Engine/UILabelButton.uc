Class UILabelButton extends UIButton
    implements(UIDataStorePublisher)
    native
    placeable
    config(UI);

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var(Data) UIDataStoreBinding CaptionDataSource;
var(Components) const editinline export noclear UIComp_DrawString StringRenderComponent;

public native function ClearBoundDataStores();

public native function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

public final event function string GetCaption()
{
    return StringRenderComponent.GetValue();
}
public final native function string GetDataStoreBinding(optional int BindingIndex = -1);

public final native function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, Name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex);

public final native function bool RefreshSubscriberValue(optional int BindingIndex = -1);

public native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1);

public native function SetCaption(string NewText);

public final native function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1);

public final native function SetTextAlignment(EUIAlignment Horizontal, EUIAlignment Vertical);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    Begin Template Class=UIComp_DrawImage Name=BackgroundImageTemplate
    End Template
    Begin Object Class=UIComp_DrawString Name=LabelStringRenderer
        StringStyle = {DefaultStyleTag = 'DefaultLabelButtonStyle'}
        StyleResolverTag = 'Caption Style'
    End Object
    CaptionDataSource = {
                         MarkupString = "Button Text", 
                         Subscriber = None, 
                         DataStoreName = 'None', 
                         DataStoreField = 'None', 
                         BindingIndex = -1, 
                         ResolvedDataStore = None, 
                         RequiredFieldType = EUIDataProviderFieldType.DATATYPE_Property
                        }
    StringRenderComponent = LabelStringRenderer
    BackgroundImageComponent = BackgroundImageTemplate
    PrimaryStyle = {RequiredStyleClass = Class'UIStyle_Combo', DefaultStyleTag = 'DefaultLabelButtonStyle'}
    EventProvider = WidgetEventComponent
    bSupportsFocusHint = TRUE
}