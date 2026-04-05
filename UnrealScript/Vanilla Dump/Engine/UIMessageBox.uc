Class UIMessageBox extends UIMessageBoxBase
    placeable
    config(UI);

public function SetupDockingRelationships()
{
    Super.SetupDockingRelationships();
    lblTitle.SetDockTarget(0, Self, 0);
    lblTitle.SetDockTarget(1, Self, 1);
    lblTitle.SetDockTarget(2, Self, 2);
    lblMessage.SetDockTarget(0, Self, 0);
    lblMessage.SetDockTarget(1, lblTitle, 3);
    lblMessage.SetDockTarget(2, Self, 2);
    btnbarChoices.SetDockTarget(0, Self, 0);
    btnbarChoices.SetDockTarget(3, Self, 3);
    btnbarChoices.SetDockTarget(2, Self, 2);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=UICalloutButtonPanel Name=ButtonBarTemplate
        Begin Template Class=UIComp_Event Name=WidgetEventComponent
        End Template
        PrivateFlags = 896
        EventProvider = WidgetEventComponent
    End Object
    Begin Template Class=UIComp_Event Name=SceneEventComponent
    End Template
    Begin Object Class=UILabel Name=MessageLabelTemplate
        Begin Template Class=UIComp_DrawString Name=LabelStringRenderer
        End Template
        Begin Template Class=UIComp_Event Name=WidgetEventComponent
        End Template
        StringRenderComponent = LabelStringRenderer
        PrivateFlags = 896
        EventProvider = WidgetEventComponent
    End Object
    Begin Object Class=UILabel Name=TitleLabelTemplate
        Begin Template Class=UIComp_DrawString Name=LabelStringRenderer
        End Template
        Begin Template Class=UIComp_Event Name=WidgetEventComponent
        End Template
        StringRenderComponent = LabelStringRenderer
        PrivateFlags = 896
        EventProvider = WidgetEventComponent
    End Object
    lblTitle = TitleLabelTemplate
    lblMessage = MessageLabelTemplate
    btnbarChoices = ButtonBarTemplate
    Children = (TitleLabelTemplate, MessageLabelTemplate, ButtonBarTemplate)
    EventProvider = SceneEventComponent
}