Class BioSFHandler_PCPauseMenu extends BioSFHandler_BrowserWheel
    config(UI);

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_X:
            vInput.X = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_Y:
            vInput.Y = fValue;
            break;
        default:
            return Super.HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public event function OnPanelAdded()
{
    Super.OnPanelAdded();
    oPanel.m_bUseThumbstickAsDPad = TRUE;
    SetMouseShown(TRUE);
}
public function OnPanelRemoved()
{
    SetMouseShown(FALSE);
}
public function ExitConfirm(bool bAPressed, int nContext)
{
    if (bAPressed)
    {
        oWorldInfo.ConsoleCommand("Exit");
    }
}
public function ExitGame()
{
    local BioSFHandler_MessageBox oMsgBox;
    local BioMessageBoxOptionalParams stParams;
    
    oMsgBox = GetSFXUIController().CreateMessageBox(GetPC());
    oMsgBox.SetInputDelegate(ExitConfirm);
    stParams.srAText = srConfirm;
    stParams.srBText = srCancel;
    oMsgBox.DisplayMessageBox(srExitConfirm, stParams);
    PlayGuiSound('BrowserSelectMenu');
}
public function MainMenuConfirm(bool bAPressed, int nContext)
{
    if (bAPressed)
    {
        GetSFXUIController().HackReloadMainMenu();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXPowerLevelUpHelper Name=oHelper
    End Template
    m_Helper = oHelper
    ScreenLayout = GUILayout.GUILayout_PC
}