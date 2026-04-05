Class BioSFHandler_MessageBox extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

enum SFXWeaponPickupUIOption
{
    WEAPPICKUP_AddToInventory,
    WEAPPICKUP_OpenInventory,
    WEAPPICKUP_Equip,
};

var delegate<InputCallback> __InputCallback__Delegate;
var delegate<UpdateCallback> __UpdateCallback__Delegate;
var delegate<UpdateCallbackEx> __UpdateCallbackEx__Delegate;
var delegate<ChoiceDialogCallback> __ChoiceDialogCallback__Delegate;
var delegate<WeaponChoiceCallback> __WeaponChoiceCallback__Delegate;
var int nInputCallbackContext;
var transient float m_fRScrollValue;
var transient float m_fHintTimeRemaining;
var config stringref WeaponPickupUITitle;
var config stringref WeaponPickupAddToInventoryText;
var config stringref WeaponPickupOpenInventoryText;
var config stringref WeaponPickupEquipText;
var bool bHandleInput;
var transient bool bShowMouse;
var transient bool m_bIsModal;
var transient bool m_bForcePlayersOnly;
var transient bool m_bInitialPlayersOnly;
var transient bool m_bCached;
var transient bool m_bForceVisible;
var transient bool m_bDisplayingHint;
var transient bool m_bCurrentlyActive;
var transient bool m_bPausedPriorToWeaponChoice;

public final event function AS_HideMessageBox(bool bSkipFade)
{
    ActionScriptVoid("HideMessageBox");
}
public final event function AS_SetChoiceDialogOptions(const string sMessage, const string sCancelText, const string srOption1, int nOption1ID, bool bOption1Enabled, const string sOption2, int nOption2ID, bool bOption2Enabled, const string sOption3, int nOption3ID, bool bOption3Enabled)
{
    ActionScriptVoid("MessageChoice.SetOptions");
}
public final event function AS_ShowChoiceDialog(bool bSkipTransition)
{
    ActionScriptVoid("MessageChoice.show");
}
public final event function AS_ShowHintMessage(string sMessage, int nPosition)
{
    ActionScriptVoid("ShowHintMessage");
}
public final event function AS_ShowMessageBox(string sMessage, string sAText, string sBText, bool bNoFade, int nIconSet, int nIconIndex, int nSkinType, int nTextAlign)
{
    ActionScriptVoid("ShowMessageBox");
}
public delegate function ChoiceDialogCallback(BioSFHandler_MessageBox oMsgBox, int nChoiceID, bool bCancelled);

public final native function DisplayMessageBox(stringref srMessage, const out BioMessageBoxOptionalParams stParams);

public final native function DisplayMessageBoxEx(string sMessage, const out BioMessageBoxOptionalParams stParams);

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            if (Abs(fValue) > 0.25)
            {
                m_fRScrollValue = -fValue;
            }
            else
            {
                m_fRScrollValue = 0.0;
            }
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public final native function HideMessageBox(optional bool bRemove = TRUE, optional bool bSkipFade = FALSE);

public delegate function InputCallback(bool bAPressed, int nContext);

public final native function InvokeNativeCallback(bool bAPressed);

public function OnPanelAdded()
{
    Super.OnPanelAdded();
    oPanel.SetInputDisabled(TRUE);
    oPanel.UpdateAspectRatio(TRUE);
}
public final native function SetInputDelegate(delegate<InputCallback> pDelegate, optional int nContext = 0);

public final native function SetUpdateDelegate(delegate<UpdateCallback> pDelegate);

public final event function ShowChoiceDialog(stringref srMessage, stringref srCancelText, stringref srOption1, int nOption1ID, bool bOption1Enabled, stringref srOption2, int nOption2ID, bool bOption2Enabled, optional stringref srOption3 = $0, optional int nOption3ID = -1, optional bool bOption3Enabled = TRUE)
{
    ShowChoiceDialogEx(UIStrRef(srMessage), UIStrRef(srCancelText), UIStrRef(srOption1), nOption1ID, bOption1Enabled, UIStrRef(srOption2), nOption2ID, bOption2Enabled, UIStrRef(srOption3), nOption3ID, bOption3Enabled);
}
public final event function ShowChoiceDialogEx(const string sMessage, const string sCancelText, const string sOption1, int nOption1ID, bool bOption1Enabled, const string sOption2, int nOption2ID, bool bOption2Enabled, optional const string sOption3 = "", optional int nOption3ID = -1, optional bool bOption3Enabled = TRUE)
{
    SetGameMode(TRUE);
    bHandleInput = TRUE;
    bShowMouse = TRUE;
    SetInputDisabled(FALSE);
    SetFocus(TRUE);
    StartHandlingKeyPresses();
    AS_SetChoiceDialogOptions(sMessage, sCancelText, sOption1, nOption1ID, bOption1Enabled, sOption2, nOption2ID, bOption2Enabled, sOption3, nOption3ID, bOption3Enabled);
    AS_ShowChoiceDialog(FALSE);
}
public final event function ShowWeaponChoiceDialog(stringref srTitle, stringref srDesc, const string sIconResource, int nIconIndex, stringref srOption1, int nOption1ID, stringref srOption2, int nOption2ID, stringref srOption3, int nOption3ID)
{
    ShowWeaponChoiceDialogEx(UIStrRef(srTitle), UIStrRef(srDesc), sIconResource, nIconIndex, UIStrRef(srOption1), nOption1ID, UIStrRef(srOption2), nOption2ID, UIStrRef(srOption3), nOption3ID);
}
public final event function ShowWeaponChoiceDialogEx(const string sTitle, const string sDesc, const string sIconResource, int nIconIndex, const string sOption1, int nOption1ID, const string sOption2, int nOption2ID, const string sOption3, int nOption3ID)
{
    SetGameMode(TRUE);
    bHandleInput = TRUE;
    bShowMouse = TRUE;
    SetInputDisabled(FALSE);
    SetFocus(TRUE);
    StartHandlingKeyPresses();
    m_bCurrentlyActive = TRUE;
    m_bPausedPriorToWeaponChoice = oWorldInfo.bPlayersOnly;
    oWorldInfo.PauseGame(TRUE);
    AS_SetWeaponChoiceDisplay(sTitle, sDesc, sIconResource, nIconIndex);
    AS_SetWeaponChoiceDialogOptions(sOption1, nOption1ID, sOption2, nOption2ID, sOption3, nOption3ID);
    AS_ShowWeaponChoiceDialog(FALSE);
}
public final event function ShowWeaponChoiceDialogForClass(Class<SFXWeapon> oWeapClass)
{
    ShowWeaponChoiceDialogEx(UIStrRef(default.WeaponPickupUITitle), oWeapClass.static.GetPrettyName(), PathName(oWeapClass.default.IconResource), oWeapClass.default.IconRef, UIStrRef(default.WeaponPickupOpenInventoryText), 1, UIStrRef(default.WeaponPickupAddToInventoryText), 0, UIStrRef(default.WeaponPickupEquipText), 2);
}
public delegate function UpdateCallback(float fDeltaT, BioSFHandler_MessageBox oMsgBox);

public delegate function UpdateCallbackEx(float fDeltaT, Object oMsgBox);

public delegate function WeaponChoiceCallback(BioSFHandler_MessageBox oMsgBox, int nChoiceID);

public final function AS_SetWeaponChoiceDialogOptions(const string sOption1, int nOption1ID, const string sOption2, int nOption2ID, const string sOption3, int nOption3ID)
{
    ActionScriptVoid("WeaponChoice.SetOptions");
}
public final function AS_SetWeaponChoiceDisplay(const string sTitle, const string sDesc, const string sIconResource, int nIconIndex)
{
    ActionScriptVoid("WeaponChoice.SetBoxMessage");
}
public final function AS_ShowWeaponChoiceDialog(bool bSkipTransition)
{
    ActionScriptVoid("WeaponChoice.show");
}
public final function CancelChoice()
{
    if (__ChoiceDialogCallback__Delegate != None)
    {
        __ChoiceDialogCallback__Delegate(Self, -1, TRUE);
        __ChoiceDialogCallback__Delegate = None;
    }
}
public final function ChoiceSelected(int nChoiceID)
{
    if (__ChoiceDialogCallback__Delegate != None)
    {
        __ChoiceDialogCallback__Delegate(Self, nChoiceID, FALSE);
        __ChoiceDialogCallback__Delegate = None;
    }
    else
    {
        CloseChoice();
    }
}
public final function CloseChoice()
{
    StopHandlingKeyPresses();
    bShowMouse = FALSE;
    SetGameMode(FALSE);
    bHandleInput = FALSE;
    Close();
}
public final function CloseWeaponChoice()
{
    StopHandlingKeyPresses();
    bShowMouse = FALSE;
    SetGameMode(FALSE);
    bHandleInput = FALSE;
    m_bCurrentlyActive = FALSE;
    GetSFXUIController().RemoveNamedMessageBox('WeaponPickupUI');
    Close();
}
public function DisplayHintMessage(stringref srMessage, int nIcon, SFXHintPosition ePosition)
{
    m_bDisplayingHint = TRUE;
    AS_ShowHintMessage(GetUIString(srMessage), int(ePosition));
    bShowMouse = FALSE;
}
public final function InvokeCallback(bool bAPressed)
{
    if (__InputCallback__Delegate != None)
    {
        __InputCallback__Delegate(bAPressed, nInputCallbackContext);
    }
    else
    {
        InvokeNativeCallback(bAPressed);
    }
}
public final function MessageBoxAPressed()
{
    InvokeCallback(TRUE);
    HideMessageBox(TRUE, TRUE);
}
public final function MessageBoxBPressed()
{
    InvokeCallback(FALSE);
    HideMessageBox(TRUE, TRUE);
}
public final function MessageBoxRemoved()
{
    HideMessageBox(TRUE, TRUE);
}
public final function SetChoiceResultCallback(delegate<ChoiceDialogCallback> oCallback)
{
    __ChoiceDialogCallback__Delegate = oCallback;
}
public final function SetWeaponChoiceResultCallback(delegate<WeaponChoiceCallback> oCallback)
{
    __WeaponChoiceCallback__Delegate = oCallback;
}
public static final function ShowWeaponPickupUIForWeapon(Class<SFXWeapon> oWeapClass, delegate<WeaponChoiceCallback> oCallback)
{
    local BioSFHandler_MessageBox MsgBox;
    local BioPlayerController PC;
    
    if (oWeapClass == None)
    {
        return;
    }
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    MsgBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(PC);
    MsgBox.SetWeaponChoiceResultCallback(oCallback);
    MsgBox.ShowWeaponChoiceDialogForClass(oWeapClass);
}
public final function WeaponChoiceSelected(int nChoice)
{
    oWorldInfo.PauseGame(m_bPausedPriorToWeaponChoice);
    if (__WeaponChoiceCallback__Delegate != None)
    {
        __WeaponChoiceCallback__Delegate(Self, nChoice);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WeaponPickupUITitle = $655052
    WeaponPickupAddToInventoryText = $163589
    WeaponPickupOpenInventoryText = $655053
    WeaponPickupEquipText = $504101
    bShowMouse = TRUE
    bSetGameMode = FALSE
}