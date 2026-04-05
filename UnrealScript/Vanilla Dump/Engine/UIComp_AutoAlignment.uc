Class UIComp_AutoAlignment extends UIComponent within UIObject
    native
    editinlinenew;

var(Appearance) EUIAlignment HorzAlignment;
var(Appearance) EUIAlignment VertAlignment;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HorzAlignment = EUIAlignment.UIALIGN_Default
    VertAlignment = EUIAlignment.UIALIGN_Default
}