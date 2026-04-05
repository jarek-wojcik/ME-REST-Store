Class BioSFHandler_PCNewCharacter extends BioSFHandler_NewCharacter
    native
    config(GuiResources);

const CONST_PasteCode = 23;
const CONST_CopyCode = 22;
const CONST_SetCustomName = 19;

var float fScrollValueMouse;
var float fLookAtThresholdAhead;
var float fLookAtThreshold;
var float fLookAtLimit;
var bool bHeadLookEnabled;

public native function ClipboardCopy(string sString);

public native function string ClipboardPaste();

public function HandleEvent(byte nCommand, const out array<string> lstArguments)
{
    local string szName;
    
    switch (nCommand)
    {
        case 19:
            if (lstArguments.Length < 1)
            {
                szName = "";
            }
            else
            {
                szName = lstArguments[0];
            }
            if (m_bMaleSelected)
            {
                m_sMaleName = szName;
            }
            else
            {
                m_sFemaleName = szName;
            }
            SetCustomName(m_sMaleName, m_sFemaleName);
            break;
        case 22:
            ClipboardCopy(sCustomFaceCode);
            break;
        case 23:
            ApplyNewCode(ClipboardPaste());
            SetSliderPositions();
            UpdateCode();
            break;
        default:
    }
    Super.HandleEvent(nCommand, lstArguments);
}
public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_MOUSE_BUTTON_RIGHT:
            bHeadLookEnabled = TRUE;
            fLookAtUpDownValue = 0.0;
            fLookAtLeftRightValue = 0.0;
            stParam.Type = ASParamTypes.ASParam_Boolean;
            stParam.bVar = TRUE;
            lstParams.AddItem(stParam);
            oPanel.InvokeMethodArgs("DissableMouseEvents", lstParams);
            SetMouseShown(FALSE);
            break;
        case BioGuiEvents.BIOGUI_EVENT_MOUSE_BUTTON_RIGHT_RELEASE:
            bHeadLookEnabled = FALSE;
            fLookAtUpDownValue = 0.0;
            fLookAtLeftRightValue = 0.0;
            stParam.Type = ASParamTypes.ASParam_Boolean;
            stParam.bVar = FALSE;
            lstParams.AddItem(stParam);
            oPanel.InvokeMethodArgs("DissableMouseEvents", lstParams);
            SetMouseShown(TRUE);
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_MOUSE_Y:
            if (bHeadLookEnabled)
            {
                HandleLookAtUpDownMouse(fValue);
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_MOUSE_X:
            if (bHeadLookEnabled)
            {
                HandleLookAtLeftRightMouse(fValue);
            }
            break;
        default:
    }
    return Super.HandleInputEvent(Event, fValue);
}
public event function Update(float fDeltaT)
{
    if (!bHeadLookEnabled)
    {
        SetMouseShown(TRUE);
    }
    Super.Update(fDeltaT);
}
public function HandleLookAtLeftRight(float fValue);

public function HandleLookAtLeftRightMouse(float fValue)
{
    if (!bZoomedInOnFace)
    {
        return;
    }
    fLookAtLeftRightValue += fValue;
    fLookAtLeftRightValue = FClamp(fLookAtLeftRightValue, -fLookAtLimit, fLookAtLimit);
}
public function HandleLookAtUpDown(float fValue);

public function HandleLookAtUpDownMouse(float fValue)
{
    if (!bZoomedInOnFace)
    {
        return;
    }
    fLookAtUpDownValue += fValue;
    fLookAtUpDownValue = FClamp(fLookAtUpDownValue, -fLookAtLimit, fLookAtLimit);
}
public function UpdateLookAtTarget()
{
    local float LookThreshold;
    
    if (bZoomedInOnFace)
    {
        if (CurrentLookAtTarget == NewCharacterLookAtTarget.NCLAT_Ahead)
        {
            LookThreshold = fLookAtThresholdAhead;
        }
        else
        {
            LookThreshold = fLookAtThreshold;
        }
        if (Abs(fLookAtUpDownValue) > Abs(fLookAtLeftRightValue))
        {
            if (fLookAtUpDownValue < -LookThreshold)
            {
                NextLookAtTarget = CurrentLookAtTarget == NewCharacterLookAtTarget.NCLAT_Up ? NewCharacterLookAtTarget.NCLAT_Ahead : NewCharacterLookAtTarget.NCLAT_Down;
            }
            else if (fLookAtUpDownValue > LookThreshold)
            {
                NextLookAtTarget = CurrentLookAtTarget == NewCharacterLookAtTarget.NCLAT_Down ? NewCharacterLookAtTarget.NCLAT_Ahead : NewCharacterLookAtTarget.NCLAT_Up;
            }
        }
        else if (fLookAtLeftRightValue < -LookThreshold)
        {
            NextLookAtTarget = CurrentLookAtTarget == NewCharacterLookAtTarget.NCLAT_Right ? NewCharacterLookAtTarget.NCLAT_Ahead : NewCharacterLookAtTarget.NCLAT_Left;
        }
        else if (fLookAtLeftRightValue > LookThreshold)
        {
            NextLookAtTarget = CurrentLookAtTarget == NewCharacterLookAtTarget.NCLAT_Left ? NewCharacterLookAtTarget.NCLAT_Ahead : NewCharacterLookAtTarget.NCLAT_Right;
        }
    }
    Super.UpdateLookAtTarget();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioMorphFaceFrontEnd Name=MorphEditor0
    End Template
    fLookAtThresholdAhead = 110.0
    fLookAtThreshold = 40.0
    fLookAtLimit = 200.0
    m_oBioMorphFrontEnd = MorphEditor0
    ScreenLayout = GUILayout.GUILayout_PC
}