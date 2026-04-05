Class UIStyle_Combo extends UIStyle_Data
    native;

struct native StyleDataReference 
{
    var STYLE_ID SourceStyleID;
    var UIStyle OwnerStyle;
    var transient UIStyle SourceStyle;
    var UIState SourceState;
    var UIStyle_Data CustomStyleData;
};

var StyleDataReference ImageStyle;
var StyleDataReference TextStyle;

public final native function UIStyle_Image GetComboImageStyle();

public final native function UIStyle_Text GetComboTextStyle();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}