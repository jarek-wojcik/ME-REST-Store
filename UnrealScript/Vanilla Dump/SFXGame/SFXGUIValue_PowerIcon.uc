Class SFXGUIValue_PowerIcon extends GFxValue within GFxMovie
    native;

struct native SFXPowerWheelButtonIcon 
{
    var string sPath;
    var SFXPowerWheelMapButtonIcon eIcon;
};
enum SFXPowerWheelPowerState
{
    PWPS_Selectable,
    PWPS_Selected,
    PWPS_Inactive,
    PWPS_Activated,
    PWPS_Overload,
    PWPS_EmptySelectable,
    PWPS_EmptySelected,
    PWPS_NotSuggested,
    PWPS_STATE_COUNT,
};
enum SFXPowerWheelMapButtonIcon
{
    PWBI_Icon_NONE,
    PWBI_FaceButtonTop,
    PWBI_FaceButtonLeft,
    PWBI_DPadLeft,
    PWBI_DPadRight,
    PWBI_ShoulderLeft,
    PWBI_ShoulderRight,
    PWBI_TriggerLeft,
    PWBI_TriggerRight,
    PWBI_ICON_COUNT,
};

var string m_aPowerStatePaths[8];
var SFXPowerWheelButtonIcon oMappedIcon;
var string sPath;
var string sID;
var string sIconResource;
var string sName;
var string sDescription;
var string sMappedBGPath;
var string CurrentInfoText;
var Name nmPowerName;
var float fBoundary;
var SFXPowerCustomActionBase pPower;
var BioPawn pPawn;
var int nIcon;
var int nCooldownValue;
var bool bHenchIcon;
var bool bDirty;
var bool bSelected;
var bool bVisible;
var bool bDelayedFlash;
var bool bMapped;
var bool bDragHover;
var bool FlashWhenTextChanges;
var SFXPowerWheelPowerState eState;
var SFXPowerWheelPowerState eDesiredState;

public final native function Activate();

public final event function AS_BeginDragging()
{
    ActionScriptVoid("BeginDragging");
}
public final event function string AS_GetDropTarget()
{
    return ActionScriptString("GetDropTarget");
}
public final event function AS_StopDragging()
{
    ActionScriptVoid("StopDragging");
}
public final event function Cleanup()
{
    pPower = None;
    pPawn = None;
}
public native function ClearIcon();

public native function CooldownComplete();

public final native function bool EvaluateForTarget(Actor pTarget, out string sOutInfo);

public native function Flash();

public final native function int GetCooldownPercentage();

public native function string GetInfoTextPath();

public native function string GetStatePath(optional SFXPowerWheelPowerState ePathState = 8);

public final native function Hide();

public final native function bool IsUsable();

public final native function MadeVisible(bool bIconIsRendering);

public native function Map(SFXPowerWheelMapButtonIcon eMapIcon);

public final native function SetDragHover(bool bHover);

public final native function SetHover(bool bHover, bool bSkipTransition);

public native function SetIcon(int nNewIcon, const string sIconResourcePath);

public final native function SetPower(SFXPowerCustomActionBase pNewPower);

public final native function SetSelected(bool bSelect);

public final native function SetState(SFXPowerWheelPowerState eNewState, optional bool bForceUpdate = FALSE);

public native function SetStateDisplay();

public final native function TickCooldown();

public native function UpdateCooldown(optional bool bForceUpdate = FALSE);

public final native function UpdateDisplay();

public final native function UpdateInfoText();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aPowerStatePaths[0] = "selectable"
    m_aPowerStatePaths[1] = "selected"
    m_aPowerStatePaths[2] = "inactive"
    m_aPowerStatePaths[3] = "activated"
    m_aPowerStatePaths[4] = "overload"
    m_aPowerStatePaths[5] = "emptyUnselected"
    m_aPowerStatePaths[6] = "emptySelected"
    m_aPowerStatePaths[7] = "notSuggested"
    eState = SFXPowerWheelPowerState.PWPS_EmptySelectable
}