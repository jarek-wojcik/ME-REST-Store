Class CameraModifier
    native;

var Camera CameraOwner;
var float AlphaInTime;
var float AlphaOutTime;
var transient float Alpha;
var transient float TargetAlpha;
var bool bDisabled;
var bool bPendingDisable;
var bool bExclusive;
var(Debug) bool bDebug;
var byte Priority;

public event function DisableModifier(optional bool bImmediate)
{
    if (bImmediate)
    {
        bDisabled = TRUE;
        bPendingDisable = FALSE;
    }
    else if (!bDisabled)
    {
        bPendingDisable = TRUE;
    }
}
public function Init();

public native function bool IsDisabled();

public native function bool ModifyCamera(Camera Camera, float DeltaTime, out TPOV OutPOV);

public native function UpdateAlpha(Camera Camera, float DeltaTime);

public function bool AddCameraModifier(Camera Camera)
{
    local int BestIdx;
    local int ModifierIdx;
    local CameraModifier Modifier;
    
    for (ModifierIdx = 0; ModifierIdx < Camera.ModifierList.Length; ModifierIdx++)
    {
        if (Camera.ModifierList[ModifierIdx] == Self)
        {
            return FALSE;
        }
    }
    for (ModifierIdx = 0; ModifierIdx < Camera.ModifierList.Length; ModifierIdx++)
    {
        if (Camera.ModifierList[ModifierIdx].Class == Class)
        {
            Camera.ModifierList[ModifierIdx] = Self;
            CameraOwner = Camera;
            return TRUE;
        }
    }
    BestIdx = 0;
    for (ModifierIdx = 0; ModifierIdx < Camera.ModifierList.Length; ModifierIdx++)
    {
        Modifier = Camera.ModifierList[ModifierIdx];
        if (Modifier == None)
        {
            continue;
        }
        if (int(Priority) <= int(Modifier.Priority))
        {
            if (bExclusive && int(Priority) == int(Modifier.Priority))
            {
                return FALSE;
            }
            break;
        }
        BestIdx++;
    }
    Camera.ModifierList.Insert(BestIdx, 1);
    Camera.ModifierList[BestIdx] = Self;
    CameraOwner = Camera;
    return TRUE;
}
public function EnableModifier()
{
    bDisabled = FALSE;
    bPendingDisable = FALSE;
}
public simulated function bool ProcessViewRotation(Actor ViewTarget, float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot);

public function bool RemoveCameraModifier(Camera Camera)
{
    local int ModifierIdx;
    
    for (ModifierIdx = 0; ModifierIdx < Camera.ModifierList.Length; ModifierIdx++)
    {
        if (Camera.ModifierList[ModifierIdx] == Self)
        {
            Camera.ModifierList.Remove(ModifierIdx, 1);
            return TRUE;
        }
    }
    return FALSE;
}
public function ToggleModifier()
{
    if (bDisabled)
    {
        EnableModifier();
    }
    else
    {
        DisableModifier();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Priority = 127
}