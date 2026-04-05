Class SFXOnlineEvent_PlatformKeyboardUI extends SFXOnlineEvent
    native;

var init string Response;
var string TitleText;
var string DescriptionText;
var string DefaultText;
var native Pointer ResponseBuffer;
var bool ShouldValidate;
var bool RouteThroughConsole;
var byte LocalUserNum;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    IsUnique = FALSE
    EventType = SFXOnlineEventType.SFXONLINE_EVENT_PLATFORM_UI_KEYBOARD
}