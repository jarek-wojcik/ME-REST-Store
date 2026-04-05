Class UIButton extends UIObject
    native
    placeable
    config(UI);

var(Sound) Name ClickedCue;
var(Components) const editinline export noclear UIComp_DrawImage BackgroundImageComponent;

public final function SetImage(Surface NewImage)
{
    if (BackgroundImageComponent != None)
    {
        BackgroundImageComponent.SetImage(NewImage);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    Begin Object Class=UIComp_DrawImage Name=BackgroundImageTemplate
        ImageStyle = {DefaultStyleTag = 'ButtonBackground'}
        StyleResolverTag = 'Background Image Style'
    End Object
    ClickedCue = 'Clicked'
    BackgroundImageComponent = BackgroundImageTemplate
    PrimaryStyle = {RequiredStyleClass = Class'UIStyle_Image', DefaultStyleTag = 'ButtonBackground'}
    bSupportsPrimaryStyle = FALSE
    DefaultStates = (Class'UIState_Enabled', Class'UIState_Disabled', Class'UIState_Focused', Class'UIState_Active', Class'UIState_Pressed')
    EventProvider = WidgetEventComponent
}