Class SFXSFHandler_PCPersonalization extends SFXSFHandler_Personalization
    config(UI);

var bool bRotationEnabled;

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_MOUSE_BUTTON_RIGHT:
            bRotationEnabled = TRUE;
            stParam.Type = ASParamTypes.ASParam_Boolean;
            stParam.bVar = TRUE;
            lstParams.AddItem(stParam);
            oPanel.InvokeMethodArgs("DissableMouseEvents", lstParams);
            SetMouseShown(FALSE);
            break;
        case BioGuiEvents.BIOGUI_EVENT_MOUSE_BUTTON_RIGHT_RELEASE:
            bRotationEnabled = FALSE;
            stParam.Type = ASParamTypes.ASParam_Boolean;
            stParam.bVar = FALSE;
            lstParams.AddItem(stParam);
            oPanel.InvokeMethodArgs("DissableMouseEvents", lstParams);
            SetMouseShown(TRUE);
            m_nRotating = 0;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_MOUSE_X:
            if (bRotationEnabled)
            {
                if (fValue < -0.0000999999975)
                {
                    m_nRotating = 1;
                }
                else if (fValue > 0.0000999999975)
                {
                    m_nRotating = -1;
                }
                else
                {
                    m_nRotating = 0;
                }
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_B_RELEASE:
            oPanel.InvokeMethod("ClosePersonalizationGUI");
            break;
        default:
    }
    return Super.HandleInputEvent(Event, fValue);
}
public event function Update(float fDeltaT)
{
    SetMouseShown(TRUE);
    Super.Update(fDeltaT);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScreenLayout = GUILayout.GUILayout_PC
}