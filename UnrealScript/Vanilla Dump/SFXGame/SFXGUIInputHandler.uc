Class SFXGUIInputHandler
    native
    config(UI);

struct native SFXInputEventCooldownStruct 
{
    var float fCooldown;
    var BioGuiEvents EventId;
};

var array<SFXInputEventCooldownStruct> m_aInputEventCooldowns;
var config string BannedChars;
var native Pointer m_pEngine;
var Vector2D MousePositionOverride;
var config float UDLRInitialCooldown;
var config float UDLRHeldCooldown;
var config int RTT_HitCheckDistance_UU;
var BioGuiEvents m_eLastUDLREvent;
var BioThumbstickDir m_nLStickX;
var BioThumbstickDir m_nLStickY;

public final native function AddCooldown(byte nEvent, float fTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BannedChars = "\\/:*?\"<>|¤"
    MousePositionOverride = {X = -99999.0, Y = -99999.0}
    UDLRInitialCooldown = 0.349999994
    UDLRHeldCooldown = 0.125
    RTT_HitCheckDistance_UU = 5000
}