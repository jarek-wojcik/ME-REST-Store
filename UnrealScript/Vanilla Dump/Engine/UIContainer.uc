Class UIContainer extends UIObject
    native
    hidedropdown
    config(UI);

var(Components) editinline export UIComp_AutoAlignment AutoAlignment;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    EventProvider = WidgetEventComponent
}