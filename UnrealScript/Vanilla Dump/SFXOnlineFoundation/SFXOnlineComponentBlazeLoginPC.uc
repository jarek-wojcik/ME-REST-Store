Class SFXOnlineComponentBlazeLoginPC extends SFXOnlineComponentBlazeLogin
    native
    config(Game);

public native function bool HasInternetConnection();

public native function OnOriginClosed();

public native function OnOriginGoesOffline();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}