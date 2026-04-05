Class ISFXOnlineComponent extends Interface
    native
    abstract;

public native function Name GetAPIName();

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}