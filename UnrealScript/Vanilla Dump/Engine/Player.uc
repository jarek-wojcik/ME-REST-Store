Class Player
    native
    transient
    config(Engine);

var const native noexport Pointer VfTable_FExec;
var const transient PlayerController Actor;
var const int CurrentNetSpeed;
var globalconfig int ConfiguredInternetSpeed;
var globalconfig int ConfiguredLanSpeed;
var config float PP_DesaturationMultiplier;
var config float PP_HighlightsMultiplier;
var config float PP_MidTonesMultiplier;
var config float PP_ShadowsMultiplier;

public native function SwitchController(PlayerController PC);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ConfiguredInternetSpeed = 10000
    ConfiguredLanSpeed = 20000
    PP_HighlightsMultiplier = 1.0
    PP_MidTonesMultiplier = 1.0
}