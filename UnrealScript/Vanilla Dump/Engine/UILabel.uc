Class UILabel extends UIObject
    implements(UIDataStoreSubscriber, UIStringRenderer)
    native
    placeable
    config(UI);

var const native noexport Pointer VfTable_IUIDataStoreSubscriber;
var const native noexport Pointer VfTable_IUIStringRenderer;
var(Data) UIDataStoreBinding DataSource;
var(Components) const editinline export noclear UIComp_DrawString StringRenderComponent;
var(Components) const editinline export UIComp_DrawImage LabelBackground;

public final native function ClearBoundDataStores();

public final native function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

public final native function string GetDataStoreBinding(optional int BindingIndex = -1);

public function string GetValue()
{
    return StringRenderComponent.GetValue();
}
public final native function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, Name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex);

public final native function bool RefreshSubscriberValue(optional int BindingIndex = -1);

public final native function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1);

public final native function SetTextAlignment(EUIAlignment Horizontal, EUIAlignment Vertical);

public final native function SetValue(string NewText);

public final function IgnoreMarkup(bool bShouldIgnoreMarkup)
{
    StringRenderComponent.bIgnoreMarkup = bShouldIgnoreMarkup;
}
public final function SetArrayValue(array<string> ValueArray)
{
    local string Str;
    
    JoinArray(ValueArray, Str, "\n", FALSE);
    SetValue(Str);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    Begin Object Class=UIComp_DrawString Name=LabelStringRenderer
    End Object
    DataSource = {
                  MarkupString = "Initial Label Text", 
                  Subscriber = None, 
                  DataStoreName = 'None', 
                  DataStoreField = 'None', 
                  BindingIndex = -1, 
                  ResolvedDataStore = None, 
                  RequiredFieldType = EUIDataProviderFieldType.DATATYPE_Property
                 }
    StringRenderComponent = LabelStringRenderer
    PrimaryStyle = {RequiredStyleClass = Class'UIStyle_Combo'}
    bSupportsPrimaryStyle = FALSE
    Position = {Value[2] = 100.0, Value[3] = 40.0, ScaleType[2] = EPositionEvalType.EVALPOS_PixelOwner, ScaleType[3] = EPositionEvalType.EVALPOS_PixelOwner}
    EventProvider = WidgetEventComponent
}