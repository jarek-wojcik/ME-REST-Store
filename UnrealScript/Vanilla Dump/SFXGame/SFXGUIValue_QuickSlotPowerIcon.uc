Class SFXGUIValue_QuickSlotPowerIcon extends SFXGUIValue_PowerIcon within GFxMovie
    native;

public native function ClearIcon();

public native function Flash();

public native function string GetInfoTextPath();

public native function string GetStatePath(optional SFXPowerWheelPowerState ePathState = 8);

public native function Map(SFXPowerWheelMapButtonIcon eMapIcon);

public native function SetStateDisplay();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}