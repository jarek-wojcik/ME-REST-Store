Class SFXOnlineComponentAvatarAwardXenon extends SFXOnlineComponent
    implements(ISFXOnlineComponent)
    native;

var const native noexport Pointer VfTable_IISFXOnlineComponent;

public native function Name GetAPIName();

public final native function Grant(byte LocalUserNum, int AvatarAwardId);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}