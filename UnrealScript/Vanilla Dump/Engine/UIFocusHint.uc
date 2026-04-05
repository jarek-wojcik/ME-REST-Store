Class UIFocusHint extends UILabel
    config(UI);

public event function RemovedFromParent(UIScreenObject WidgetOwner)
{
    Super(UIScreenObject).RemovedFromParent(WidgetOwner);
    ClearDockTargets();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_DrawString Name=LabelStringRenderer
        AutoSizeParameters[0] = {bAutoSizeEnabled = TRUE}
        AutoSizeParameters[1] = {bAutoSizeEnabled = TRUE}
    End Template
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    StringRenderComponent = LabelStringRenderer
    DockTargets = {bLockWidthWhenDocked = TRUE}
    EventProvider = WidgetEventComponent
}