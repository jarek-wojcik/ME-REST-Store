Class SFXGUIValue_HUDPowerIcon extends SFXGUIValue_PowerIcon within GFxMovie
    native;

public final native function CheckCooldownState();

public native function ClearIcon();

public native function CooldownComplete();

public native function string GetInfoTextPath();

public final event function Name GetMappedHenchmanPower(BioPawn pHenchPawn)
{
    if (SFXPawn_Henchman(pHenchPawn) != None)
    {
        return SFXPawn_Henchman(pHenchPawn).m_nmMappedPower;
    }
    return 'None';
}
public native function string GetStatePath(optional SFXPowerWheelPowerState ePathState = 8);

public native function Map(SFXPowerWheelMapButtonIcon eMapIcon);

public final native function PowerUsed(SFXPowerCustomActionBase pUsedPower);

public final native function SetBaseIconVisibility(bool bMakeVisible);

public native function SetIcon(int nNewIcon, const string sIconResourcePath);

public final native function SetToDefaultHenchIcon(BioPawn pPowerPawn);

public native function UpdateCooldown(optional bool bForceUpdate = FALSE);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}