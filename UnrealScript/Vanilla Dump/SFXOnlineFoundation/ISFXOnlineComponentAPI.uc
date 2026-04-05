Class ISFXOnlineComponentAPI extends ISFXOnlineComponent
    native
    abstract;

public native function int GetCurrentTime();

public native function bool Idle();

public native function ResetLocale();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}