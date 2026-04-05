Class UIStyle extends UIRoot within UISkin
    native
    perobjectconfig;

var(UIStyle) const localized string StyleName;
var const string StyleGroupName;
var const Class<UIStyle_Data> StyleDataClass;
var const transient native Object StateDataMap;
var STYLE_ID StyleID;
var Name StyleTag;

public final event function UIStyle_Data GetDefaultStyle()
{
    return GetStyleForStateByClass(Class'UIState_Enabled');
}
public final native function UIStyle_Data GetStyleForState(UIState StateObject);

public final native function UIStyle_Data GetStyleForStateByClass(Class<UIState> StateClass);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StyleName = "Default Style"
}