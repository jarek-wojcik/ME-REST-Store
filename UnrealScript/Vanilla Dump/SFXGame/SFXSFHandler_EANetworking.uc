Class SFXSFHandler_EANetworking extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

enum EAGUI_CerberusIntroResult
{
    EAG_CI_REDEEM_CODE,
    EAG_CI_BUY_CODE,
    EAG_CI_CANCEL,
};
enum EAGUI_EmailPswdMismatchResult
{
    EAG_EPM_SUBMIT,
    EAG_EPM_EMAIL_PSWD,
    EAG_EPM_CANCEL,
};
enum EAGUI_NucleusLoginResult
{
    EAG_NL_LOGIN,
    EAG_NL_CREATE,
    EAG_NL_CANCEL,
};
enum EAGUI_MsgBoxResult
{
    EAG_MSGBOX_BTN_1,
    EAG_MSGBOX_BTN_2,
    EAG_MSGBOX_BTN_3,
    EAG_MSGBOX_BTN_4,
};

var delegate<GuiCallback_SubmitIntroPage> __GuiCallback_SubmitIntroPage__Delegate;
var delegate<GuiCallback_SubmitNucleusLogin> __GuiCallback_SubmitNucleusLogin__Delegate;
var delegate<GuiCallback_SubmitMessageBox> __GuiCallback_SubmitMessageBox__Delegate;
var delegate<GuiCallback_SubmitRedeemCodeConfirmation> __GuiCallback_SubmitRedeemCodeConfirmation__Delegate;
var delegate<GuiCallback_SubmitCreateNucleusAccount> __GuiCallback_SubmitCreateNucleusAccount__Delegate;
var delegate<GuiCallback_SubmitTermsOfService> __GuiCallback_SubmitTermsOfService__Delegate;
var delegate<GuiCallback_SubmitNucleusWelcomeMessage> __GuiCallback_SubmitNucleusWelcomeMessage__Delegate;
var delegate<GuiCallback_SubmitCerberusIntro> __GuiCallback_SubmitCerberusIntro__Delegate;
var delegate<GuiCallback_SubmitRedeemCode> __GuiCallback_SubmitRedeemCode__Delegate;
var delegate<GuiCallback_SubmitCerberusWelcomeMessage> __GuiCallback_SubmitCerberusWelcomeMessage__Delegate;
var delegate<GuiCallback_SubmitCreateNucleusAccountEx> __GuiCallback_SubmitCreateNucleusAccountEx__Delegate;
var delegate<GuiCallback_SubmitEmailPasswordMismatch> __GuiCallback_SubmitEmailPasswordMismatch__Delegate;
var delegate<GuiCallback_SubmitAccountDemographics> __GuiCallback_SubmitAccountDemographics__Delegate;
var delegate<GuiCallback_SubmitParentEmail> __GuiCallback_SubmitParentEmail__Delegate;
var delegate<OnGFxScreenVisibilityChange> __OnGFxScreenVisibilityChange__Delegate;
var transient SFXGUIHelper_ConsoleKeyboard m_oKeyboard;
var config stringref m_srKeyboardEmailTitle;
var config stringref m_srKeyboardPasswordTitle;
var config stringref m_srCerberusCodeTitle;
var config int m_nMaxEmailLength;
var config int m_nMaxPasswordLength;
var config int m_nMaxCerberusCodeLength;
var const config stringref m_srOk;
var const config stringref m_srCancel;
var const config stringref m_srConfirmCodeRedemptionTitle;
var const config stringref m_srConfirmCodeRedemptionText;

public delegate function GuiCallback_SubmitAccountDemographics(bool bContinue, string i_sCountryCode, int BirthDay, int BirthMonth, int BirthYear, string i_sLanguageCode);

public delegate function GuiCallback_SubmitCerberusIntro(EAGUI_CerberusIntroResult eReturnCode);

public delegate function GuiCallback_SubmitCerberusWelcomeMessage();

public delegate function GuiCallback_SubmitCreateNucleusAccount(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bRegisterProduct, bool bBioWareProducts, bool bSubmit);

public delegate function GuiCallback_SubmitCreateNucleusAccountEx(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bBioWareProducts, string i_sCountryCode, int BirthDay, int BirthMonth, int BirthYear, string i_sLanguageCode, bool bSubmit);

public delegate function GuiCallback_SubmitEmailPasswordMismatch(string email, string Password, EAGUI_EmailPswdMismatchResult eReturnCode);

public delegate function GuiCallback_SubmitIntroPage(bool bContinue);

public delegate function GuiCallback_SubmitMessageBox(EAGUI_MsgBoxResult eReturnEnum);

public delegate function GuiCallback_SubmitNucleusLogin(string email, string Password, EAGUI_NucleusLoginResult eReturnCode);

public delegate function GuiCallback_SubmitNucleusWelcomeMessage();

public delegate function GuiCallback_SubmitParentEmail(bool bContinue, string ParentEmail);

public delegate function GuiCallback_SubmitRedeemCode(bool bContinue, string i_sCode);

public delegate function GuiCallback_SubmitRedeemCodeConfirmation(EAGUI_MsgBoxResult eReturnEnum);

public delegate function GuiCallback_SubmitTermsOfService(bool bAccept);

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_RSTICK_Y:
            stParam.Type = ASParamTypes.ASParam_Float;
            stParam.fVar = fValue;
            lstParams.AddItem(stParam);
            oPanel.InvokeMethodArgs("ScrollControl", lstParams);
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_X:
            if (fValue >= 0.25)
            {
                oPanel.InvokeMethod("OnInputRight");
            }
            else if (fValue <= -0.25)
            {
                oPanel.InvokeMethod("OnInputLeft");
            }
            break;
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_A_RELEASE:
            oPanel.InvokeMethod("ExecuteControl");
            break;
        case BioGuiEvents.BIOGUI_EVENT_CONTROL_DOWN_RELEASE:
            oPanel.InvokeMethod("NextControl");
            break;
        case BioGuiEvents.BIOGUI_EVENT_CONTROL_LEFT_RELEASE:
            oPanel.InvokeMethod("OnInputLeft");
            break;
        case BioGuiEvents.BIOGUI_EVENT_CONTROL_RIGHT_RELEASE:
            oPanel.InvokeMethod("OnInputRight");
            break;
        case BioGuiEvents.BIOGUI_EVENT_CONTROL_UP_RELEASE:
            oPanel.InvokeMethod("PreviousControl");
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public final function KeyboardEntryComplete(bool bOK, string sText)
{
    if (bOK)
    {
        AS_SetActiveInputField(sText);
    }
    m_oKeyboard = None;
}
public delegate function OnGFxScreenVisibilityChange(bool bNewValue);

public event function OnPanelAdded()
{
    Super.OnPanelAdded();
    oPanel.SetExternalInterface(Self);
    oPanel.InvokeMethod("Initialize");
    SetFocus(FALSE);
}
public event function OnPanelRemoved()
{
    ClearDelegates();
}
public native function ShowAccountDemographics(array<string> m_CountryCodeList, array<string> m_CountryDisplayList);

public native function ShowCerberusIntro();

public native function ShowCerberusWelcomeMessage();

public native function ShowCreateNucleusAccount(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bRegisterProduct, bool bBioWareProducts, bool bUnderage);

public native function ShowCreateNucleusAccountEx(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bBioWareProducts, string i_sCountryCode, int BirthDay, int BirthMonth, int BirthYear, string i_sLanguageCode, array<string> m_CountryCodeList, array<string> m_CountryDisplayList);

public native function ShowEmailPasswordMismatch(string email, string Password);

public native function ShowIntroPage();

public native function ShowMessageBox(string sTitle, string sMessage, optional string sButton1Text, optional string sButton2Text, optional string sButton3Text);

public native function ShowNucleusLogin(string email, string Password, int eScreenState);

public native function ShowNucleusWelcomeMessage();

public native function ShowParentEmail();

public native function ShowRedeemCode();

public event function ShowRedeemCodeConfirmation()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    stParam.Type = ASParamTypes.ASParam_String;
    stParam.sVar = GetUIString(m_srConfirmCodeRedemptionTitle);
    lstParams.AddItem(stParam);
    stParam.Type = ASParamTypes.ASParam_String;
    stParam.sVar = GetUIString(m_srConfirmCodeRedemptionText);
    lstParams.AddItem(stParam);
    stParam.Type = ASParamTypes.ASParam_String;
    stParam.sVar = GetUIString(m_srOk);
    lstParams.AddItem(stParam);
    stParam.Type = ASParamTypes.ASParam_String;
    stParam.sVar = GetUIString(m_srCancel);
    lstParams.AddItem(stParam);
    if (oPanel != None)
    {
        __GuiCallback_SubmitRedeemCodeConfirmation__Delegate = OnRedeemCodeConfirmationResult;
        SetFocus(TRUE);
        oPanel.InvokeMethodArgs("ShowSubscreen_MessageBox", lstParams);
    }
    else
    {
        Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().OnCodeRedeemed(3);
    }
}
public native function ShowTermsOfService(string i_sTermsOfService, string i_sPrivacyPolicy, optional bool bTOSChanged = FALSE);

public function SubmitAccountDemographics(bool bContinue, string i_sCountryCode, int BirthDay, int BirthMonth, int BirthYear, string i_sLanguageCode)
{
    if (__GuiCallback_SubmitAccountDemographics__Delegate != None)
    {
        __GuiCallback_SubmitAccountDemographics__Delegate(bContinue, i_sCountryCode, BirthDay, BirthMonth, BirthYear, i_sLanguageCode);
    }
}
public function SubmitCerberusIntro(EAGUI_CerberusIntroResult eReturnCode)
{
    if (__GuiCallback_SubmitCerberusIntro__Delegate != None)
    {
        __GuiCallback_SubmitCerberusIntro__Delegate(eReturnCode);
    }
}
public function SubmitCerberusWelcomeMessage()
{
    if (__GuiCallback_SubmitCerberusWelcomeMessage__Delegate != None)
    {
        __GuiCallback_SubmitCerberusWelcomeMessage__Delegate();
    }
}
public function SubmitCreateNucleusAccount(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bRegisterProduct, bool bBioWareProducts, bool bSubmit)
{
    if (__GuiCallback_SubmitCreateNucleusAccount__Delegate != None)
    {
        __GuiCallback_SubmitCreateNucleusAccount__Delegate(sEmail, sPassword, bEAProducts, bThirdParty, bRegisterProduct, bBioWareProducts, bSubmit);
    }
}
public function SubmitCreateNucleusAccountEx(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bBioWareProducts, string i_sCountryCode, int BirthDay, int BirthMonth, int BirthYear, string i_sLanguageCode, bool bSubmit)
{
    if (__GuiCallback_SubmitCreateNucleusAccountEx__Delegate != None)
    {
        __GuiCallback_SubmitCreateNucleusAccountEx__Delegate(sEmail, sPassword, bEAProducts, bThirdParty, bBioWareProducts, i_sCountryCode, BirthDay, BirthMonth, BirthYear, i_sLanguageCode, bSubmit);
    }
}
public function SubmitEmailPasswordMismatch(string email, string Password, EAGUI_EmailPswdMismatchResult eReturnCode)
{
    if (__GuiCallback_SubmitEmailPasswordMismatch__Delegate != None)
    {
        __GuiCallback_SubmitEmailPasswordMismatch__Delegate(email, Password, eReturnCode);
    }
}
public function SubmitIntroPage(bool bContinue)
{
    if (__GuiCallback_SubmitIntroPage__Delegate != None)
    {
        __GuiCallback_SubmitIntroPage__Delegate(bContinue);
    }
}
public function SubmitMessageBox(EAGUI_MsgBoxResult eReturnEnum)
{
    if (__GuiCallback_SubmitRedeemCodeConfirmation__Delegate != None)
    {
        __GuiCallback_SubmitRedeemCodeConfirmation__Delegate(eReturnEnum);
        __GuiCallback_SubmitRedeemCodeConfirmation__Delegate = None;
    }
    else if (__GuiCallback_SubmitMessageBox__Delegate != None)
    {
        __GuiCallback_SubmitMessageBox__Delegate(eReturnEnum);
    }
}
public function SubmitNucleusLogin(string email, string Password, EAGUI_NucleusLoginResult eReturnCode)
{
    if (__GuiCallback_SubmitNucleusLogin__Delegate != None)
    {
        __GuiCallback_SubmitNucleusLogin__Delegate(email, Password, eReturnCode);
    }
}
public function SubmitNucleusWelcomeMessage()
{
    if (__GuiCallback_SubmitNucleusWelcomeMessage__Delegate != None)
    {
        __GuiCallback_SubmitNucleusWelcomeMessage__Delegate();
    }
}
public function SubmitParentEmail(bool bContinue, string ParentEmail)
{
    if (__GuiCallback_SubmitParentEmail__Delegate != None)
    {
        __GuiCallback_SubmitParentEmail__Delegate(bContinue, ParentEmail);
    }
}
public function SubmitRedeemCode(bool bContinue, string i_sCode)
{
    if (__GuiCallback_SubmitRedeemCode__Delegate != None)
    {
        __GuiCallback_SubmitRedeemCode__Delegate(bContinue, i_sCode);
    }
}
public function SubmitTermsOfService(bool bAccept)
{
    if (__GuiCallback_SubmitTermsOfService__Delegate != None)
    {
        __GuiCallback_SubmitTermsOfService__Delegate(bAccept);
    }
}
public function ClearDelegates()
{
    __GuiCallback_SubmitIntroPage__Delegate = None;
    __GuiCallback_SubmitNucleusLogin__Delegate = None;
    __GuiCallback_SubmitMessageBox__Delegate = None;
    __GuiCallback_SubmitRedeemCodeConfirmation__Delegate = None;
    __GuiCallback_SubmitEmailPasswordMismatch__Delegate = None;
    __GuiCallback_SubmitCreateNucleusAccount__Delegate = None;
    __GuiCallback_SubmitTermsOfService__Delegate = None;
    __GuiCallback_SubmitNucleusWelcomeMessage__Delegate = None;
    __GuiCallback_SubmitCerberusIntro__Delegate = None;
    __GuiCallback_SubmitRedeemCode__Delegate = None;
    __GuiCallback_SubmitAccountDemographics__Delegate = None;
    __GuiCallback_SubmitParentEmail__Delegate = None;
    __GuiCallback_SubmitCerberusWelcomeMessage__Delegate = None;
    __GuiCallback_SubmitCreateNucleusAccountEx__Delegate = None;
    __OnGFxScreenVisibilityChange__Delegate = None;
}
public final function AS_SetActiveInputField(string sText)
{
    ActionScriptVoid("SetActiveInputField");
}
public function EnterCode(string sDefault)
{
    if (m_oKeyboard == None)
    {
        m_oKeyboard = new (Self) Class'SFXGUIHelper_ConsoleKeyboard';
    }
    m_oKeyboard.__OnKeyboardEntryComplete__Delegate = KeyboardEntryComplete;
    m_oKeyboard.DisplayKeyboard(m_srCerberusCodeTitle, $0, 3, m_nMaxCerberusCodeLength, sDefault);
}
public function EnterEmail(string sDefault)
{
    if (m_oKeyboard == None)
    {
        m_oKeyboard = new (Self) Class'SFXGUIHelper_ConsoleKeyboard';
    }
    m_oKeyboard.__OnKeyboardEntryComplete__Delegate = KeyboardEntryComplete;
    m_oKeyboard.DisplayKeyboard(m_srKeyboardEmailTitle, $0, 1, m_nMaxEmailLength, sDefault);
}
public function EnterPassword(string sDefault)
{
    if (m_oKeyboard == None)
    {
        m_oKeyboard = new (Self) Class'SFXGUIHelper_ConsoleKeyboard';
    }
    m_oKeyboard.__OnKeyboardEntryComplete__Delegate = KeyboardEntryComplete;
    m_oKeyboard.DisplayKeyboard(m_srKeyboardPasswordTitle, $0, 2, m_nMaxPasswordLength, sDefault);
}
public function GFxScreenVisibilityChange(bool bNewValue)
{
    if (__OnGFxScreenVisibilityChange__Delegate != None)
    {
        __OnGFxScreenVisibilityChange__Delegate(bNewValue);
    }
}
public function onExternalInitialize()
{
    local ASParams stParam;
    local array<ASParams> lstParams;
    
    stParam.Type = ASParamTypes.ASParam_Float;
    stParam.fVar = float(ScreenLayout);
    lstParams.AddItem(stParam);
    stParam.Type = ASParamTypes.ASParam_Float;
    stParam.fVar = float(m_nMaxPasswordLength);
    lstParams.AddItem(stParam);
    stParam.Type = ASParamTypes.ASParam_Float;
    stParam.fVar = float(m_nMaxEmailLength);
    lstParams.AddItem(stParam);
    oPanel.InvokeMethodArgs("onGameSideInit", lstParams);
}
public final function OnRedeemCodeConfirmationResult(EAGUI_MsgBoxResult eReturnEnum)
{
    local CodeRedemptionResult nReturnValue;
    
    switch (eReturnEnum)
    {
        case EAGUI_MsgBoxResult.EAG_MSGBOX_BTN_1:
            nReturnValue = CodeRedemptionResult.REDEMPTION_SUCCESS;
            break;
        case EAGUI_MsgBoxResult.EAG_MSGBOX_BTN_2:
            nReturnValue = CodeRedemptionResult.REDEMPTION_CANCELED;
            break;
        default:
            nReturnValue = CodeRedemptionResult.REDEMPTION_ERROR;
    }
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().OnCodeRedeemed(nReturnValue);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_srKeyboardEmailTitle = $339054
    m_srKeyboardPasswordTitle = $339055
    m_srCerberusCodeTitle = $315185
    m_nMaxEmailLength = 100
    m_nMaxPasswordLength = 16
    m_nMaxCerberusCodeLength = 16
    m_srOk = $152938
    m_srCancel = $168246
    m_srConfirmCodeRedemptionTitle = $715664
    m_srConfirmCodeRedemptionText = $715665
}