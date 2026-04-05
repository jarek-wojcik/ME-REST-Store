Class SFXOnlineComponentBlazeGameXenon extends SFXOnlineComponentBlazeGame
    native
    config(Engine);

var const native noexport Pointer VfTable_Blaze::PlatformManagerXb360Listener;
var config float m_CallRestrictedFunctionPeriod;
var float m_NextAllowedRestrictedFunctionCallTime;
var bool m_CallRestrictedFunctionMode;

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

public native function bool PerformCallRestrictedFunction();

public native function SetCallRestrictedFunctionMode(bool bEnable);

public native function SetPlatformPresence(bool presencePrivate);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}