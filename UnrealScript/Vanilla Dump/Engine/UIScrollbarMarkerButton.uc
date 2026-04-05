Class UIScrollbarMarkerButton extends UIScrollbarButton within UIScrollbar
    native
    config(UI);

var delegate<OnButtonDragged> __OnButtonDragged__Delegate;

public delegate function OnButtonDragged(UIScrollbarMarkerButton Sender, int PlayerIndex);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_DrawImage Name=BackgroundImageTemplate
        StyleResolverTag = 'MarkerStyle'
    End Template
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    BackgroundImageComponent = BackgroundImageTemplate
    EventProvider = WidgetEventComponent
}