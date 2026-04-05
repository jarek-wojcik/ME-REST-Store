Class UIScrollbarButton extends UIButton within UIScrollbar
    native
    config(UI);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    Begin Template Class=UIComp_DrawImage Name=BackgroundImageTemplate
    End Template
    BackgroundImageComponent = BackgroundImageTemplate
    DockTargets = {bLockWidthWhenDocked = TRUE, bLockHeightWhenDocked = TRUE}
    PrivateFlags = 47
    EventProvider = WidgetEventComponent
}