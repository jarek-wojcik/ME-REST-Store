Class SFXOnlineComponentUI extends SFXOnlineComponent
    implements(ISFXOnlineComponentUserInterface)
    native;

var const native noexport Pointer VfTable_IISFXOnlineComponentUserInterface;
var delegate<ExternalCallback_OnDisplayNotification> __ExternalCallback_OnDisplayNotification__Delegate;
var delegate<ExternalCallback_ClearNotifications> __ExternalCallback_ClearNotifications__Delegate;
var delegate<ExternalCallback_SetState> __ExternalCallback_SetState__Delegate;
var delegate<ExternalCallback_CloseEANetworking> __ExternalCallback_CloseEANetworking__Delegate;
var delegate<ExternalCallback_HasCerberusDLC> __ExternalCallback_HasCerberusDLC__Delegate;
var delegate<ExternalCallback_ShowStore> __ExternalCallback_ShowStore__Delegate;
var Name HandlerId;
var transient SFXSFHandler_EANetworking m_oGUI;

public native function AcceptTOS(bool bAccept);

public event function ClearNotifications(optional array<SFXOnlineConnection_MessageType> MessageTypesToClear)
{
    if (__ExternalCallback_ClearNotifications__Delegate != None)
    {
        __ExternalCallback_ClearNotifications__Delegate(MessageTypesToClear);
    }
}
public event function CloseEANetworking()
{
    if (__ExternalCallback_CloseEANetworking__Delegate != None)
    {
        __ExternalCallback_CloseEANetworking__Delegate();
    }
}
public native function Connect(SFXOnlineConnectMode connectMode);

public native function Disconnect();

public native function DownloadContent(bool bCerberusContent);

public delegate function ExternalCallback_ClearNotifications(optional array<SFXOnlineConnection_MessageType> MessageTypesToClear);

public delegate function ExternalCallback_CloseEANetworking();

public delegate function ExternalCallback_HasCerberusDLC(bool bVal);

public delegate function ExternalCallback_OnDisplayNotification(SFXOnlineConnection_MessageType Type, string MessageData, string Title, string Image, int DLC_ID, int TrackingID);

public delegate function ExternalCallback_SetState(SFXOnlineUIState eState);

public delegate function ExternalCallback_ShowStore(array<SFXOfferDescriptor> aOffers);

public native function Name GetAPIName();

public event function HasCerberusDLC(bool bVal)
{
    if (__ExternalCallback_HasCerberusDLC__Delegate != None)
    {
        __ExternalCallback_HasCerberusDLC__Delegate(bVal);
    }
}
public event function bool IsInMainMenu()
{
    local WorldInfo WI;
    local SFXPlayerController PC;
    local SFXGUIInteraction oGUI;
    
    WI = Class'Engine'.static.GetCurrentWorldInfo();
    PC = WI == None ? None : SFXPlayerController(BioWorldInfo(WI).GetLocalPlayerController());
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    return PC == None ? FALSE : oGUI.GetMovie(PC, 'MainMenu_RTT') != None;
}
public event function MessageBoxCallback(bool bAPressed, int Context)
{
    SubmitMessageBox(bAPressed ? 0 : 1);
}
private final native function OnDisconnected(SFXOnlineEvent oEvent);

public event function OnDisplayNotification(SFXOnlineMOTDInfo Info)
{
    if (__ExternalCallback_OnDisplayNotification__Delegate != None)
    {
        __ExternalCallback_OnDisplayNotification__Delegate(Info.Type, Info.Message, Info.Title, Info.Image, Info.offerId, Info.TrackingID);
    }
}
public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

private final native function OnTick(SFXOnlineEvent oEvent);

public event function SetState(SFXOnlineUIState eState)
{
    local ISFXOnlineComponentGameEntryFlow gameEntryFlow;
    
    if (__ExternalCallback_SetState__Delegate != None)
    {
        __ExternalCallback_SetState__Delegate(eState);
    }
    gameEntryFlow = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGameEntryFlow();
    if (gameEntryFlow != None)
    {
        gameEntryFlow.SetLoginState(eState);
    }
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

public native function bool ShowQueuedMessageBox(string sMessage, stringref srButton1Text);

public native function ShowRedeemCode();

public event function ShowRedeemCodeConfirmation()
{
    if (m_oGUI != None)
    {
        m_oGUI.ShowRedeemCodeConfirmation();
    }
    else
    {
        Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().OnCodeRedeemed(3);
    }
}
public event function ShowStore(array<SFXOfferDescriptor> aOffers)
{
    if (__ExternalCallback_ShowStore__Delegate != None)
    {
        __ExternalCallback_ShowStore__Delegate(aOffers);
    }
}
public native function ShowTermsOfService(string i_sTermsOfService, string i_sPrivacyPolicy, optional bool bTOSChanged = FALSE);

public native function SubmitAccountDemographics(bool bContinue, string i_sCountryCode, int BirthDay, int BirthMonth, int BirthYear, string i_sLanguageCode);

public native function SubmitCerberusIntro(EAGUI_CerberusIntroResult eReturnCode);

public native function SubmitCerberusWelcomeMessage();

public native function SubmitCreateNucleusAccount(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bRegisterProduct, bool bBioWareProducts, bool bSubmit);

public native function SubmitCreateNucleusAccountEx(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bBioWareProducts, string i_sCountryCode, int BirthDay, int BirthMonth, int BirthYear, string i_sLanguageCode, bool bSubmit);

public native function SubmitEmailPasswordMismatch(string email, string Password, EAGUI_EmailPswdMismatchResult eReturnCode);

public native function SubmitIntroPage(bool bContinue);

public native function SubmitMessageBox(EAGUI_MsgBoxResult eReturnEnum);

public native function SubmitNucleusLogin(string email, string Password, EAGUI_NucleusLoginResult eReturnCode);

public native function SubmitNucleusWelcomeMessage();

public native function SubmitParentEmail(bool bContinue, string ParentEmail);

public native function SubmitRedeemCode(bool bContinue, string i_sCode);

public native function SubmitStore(array<int> aiChosen);

public native function SubmitTermsOfService(bool bAccept);

public event function UpdateGalaxyAtWarLevel(float newLevel)
{
    local WorldInfo WI;
    local SFXPlayerController oController;
    local SFXProfileSettings oSettings;
    local float savedGaWLevel;
    local int formatedNewLevel;
    local int formatedSavedLevel;
    local string gawLevelStr;
    local SFXOnlineMOTDInfo Info;
    
    WI = Class'Engine'.static.GetCurrentWorldInfo();
    oController = WI == None ? None : SFXPlayerController(BioWorldInfo(WI).GetLocalPlayerController());
    oSettings = oController == None ? None : oController.ProfileSettings;
    if (oSettings != None)
    {
        if (oSettings.GetProfileSettingValueFloat(92, savedGaWLevel) == TRUE)
        {
            if (savedGaWLevel != newLevel)
            {
                formatedNewLevel = int(newLevel);
                formatedSavedLevel = int(savedGaWLevel);
                if (formatedNewLevel != formatedSavedLevel)
                {
                    ClearCustomTokens();
                    SetCustomToken(0, string(formatedSavedLevel));
                    SetCustomToken(1, string(formatedNewLevel));
                    gawLevelStr = GetTokenisedString(Class'SFXOnlineComponentGalaxyAtWar'.default.LevelChangeStrRef);
                    Info.Type = SFXOnlineConnection_MessageType.SFXONLINE_MT_GAW_STATUS_UPDATE;
                    Info.Message = gawLevelStr;
                    OnDisplayNotification(Info);
                }
                if (oSettings.SetProfileSettingValueFloat(92, newLevel) == FALSE)
                {
                }
            }
        }
    }
}
public function ClearDelegates()
{
    __ExternalCallback_OnDisplayNotification__Delegate = None;
    __ExternalCallback_ClearNotifications__Delegate = None;
    __ExternalCallback_SetState__Delegate = None;
    __ExternalCallback_CloseEANetworking__Delegate = None;
    __ExternalCallback_HasCerberusDLC__Delegate = None;
    __ExternalCallback_ShowStore__Delegate = None;
}
public function ClearGui()
{
    if (m_oGUI != None)
    {
        m_oGUI.ClearDelegates();
        m_oGUI = None;
    }
}
private final function OnNetworkWaitFinished(SFXOnlineEvent oEvent)
{
    ShowNetworkWaitUI(FALSE);
}
private final function OnNetworkWaitStart(SFXOnlineEvent oEvent)
{
    ShowNetworkWaitUI(TRUE);
}
public function SetGui(SFXSFHandler_EANetworking i_NetworkingGUI)
{
    m_oGUI = i_NetworkingGUI;
    m_oGUI.__GuiCallback_SubmitIntroPage__Delegate = SubmitIntroPage;
    m_oGUI.__GuiCallback_SubmitNucleusLogin__Delegate = SubmitNucleusLogin;
    m_oGUI.__GuiCallback_SubmitMessageBox__Delegate = SubmitMessageBox;
    m_oGUI.__GuiCallback_SubmitRedeemCodeConfirmation__Delegate = None;
    m_oGUI.__GuiCallback_SubmitEmailPasswordMismatch__Delegate = SubmitEmailPasswordMismatch;
    m_oGUI.__GuiCallback_SubmitCreateNucleusAccount__Delegate = SubmitCreateNucleusAccount;
    m_oGUI.__GuiCallback_SubmitTermsOfService__Delegate = SubmitTermsOfService;
    m_oGUI.__GuiCallback_SubmitNucleusWelcomeMessage__Delegate = SubmitNucleusWelcomeMessage;
    m_oGUI.__GuiCallback_SubmitCerberusIntro__Delegate = SubmitCerberusIntro;
    m_oGUI.__GuiCallback_SubmitRedeemCode__Delegate = SubmitRedeemCode;
    m_oGUI.__GuiCallback_SubmitAccountDemographics__Delegate = SubmitAccountDemographics;
    m_oGUI.__GuiCallback_SubmitParentEmail__Delegate = SubmitParentEmail;
    m_oGUI.__GuiCallback_SubmitCerberusWelcomeMessage__Delegate = SubmitCerberusWelcomeMessage;
    m_oGUI.__GuiCallback_SubmitCreateNucleusAccountEx__Delegate = SubmitCreateNucleusAccountEx;
}
private final function ShowNetworkWaitUI(bool Show)
{
    local SFXGUIInteraction oGuiMgr;
    
    oGuiMgr = Class'SFXGUIInteraction'.static.GetInstance();
    if (Show)
    {
        oGuiMgr.GetSaveLoadWidget().ShowNetworkMessage(FALSE);
    }
    else
    {
        oGuiMgr.GetSaveLoadWidget().HideNetworkMessage(FALSE);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HandlerId = 'NetworkRegistration'
    EventSubscriberTable = ({EventCallback = 'OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}, 
                            {EventCallback = 'OnDisconnected', EventType = SFXOnlineEventType.SFXONLINE_EVENT_PLATFORM_DISCONNECT}, 
                            {EventCallback = 'OnNetworkWaitStart', EventType = SFXOnlineEventType.SFXONLINE_EVENT_NETWORK_WAIT_START}, 
                            {EventCallback = 'OnNetworkWaitFinished', EventType = SFXOnlineEventType.SFXONLINE_EVENT_NETWORK_WAIT_FINISHED}
                           )
}