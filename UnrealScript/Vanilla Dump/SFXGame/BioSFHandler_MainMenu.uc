Class BioSFHandler_MainMenu extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

var Name ConnectionMessageBoxId;
var transient SFXOnlineComponentUI m_BlazeUI;
var config stringref srDemo;
var config stringref srCerb_ActivateCerb;
var config stringref srCerb_ConnectTo;
var config stringref srCerb_ConnectingToCerb;
var config stringref srCerb_ConnectedToCerb;
var config stringref srNotificationOriginSignin;
var config stringref srFriendBeatMe;
var config stringref srFriendBeatByMe;
var transient float fTimeSinceLastPendingLoadMessageCheck;
var config float fPendingLoadMessageCheckThreshold;
var transient export SFXGUI_MainMenu_RightComputer MessagingComputer;
var transient export SFXGUI_MainMenu_RTT MenuComputer;
var transient bool bEARegistrationScreenVisible;
var transient bool bConnectButtonVisible;
var transient SFXOnlineUIState m_CerbConnectState;

public event function CerberusConnect(SFXOnlineConnectMode connectMode)
{
    local SFXSFHandler_EANetworking oHandler;
    local SFXGUIInteraction oManager;
    local SFXOnlineComponentOrigin oOrigin;
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams messageParams;
    local bool bAllowLogin;
    
    oOrigin = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentOrigin();
    bAllowLogin = TRUE;
    if (oOrigin != None)
    {
        if (!oOrigin.mIsOriginDisabled)
        {
            if (oOrigin.CheckSignedIn() == FALSE)
            {
                bAllowLogin = FALSE;
            }
        }
    }
    if (bAllowLogin)
    {
        if (m_BlazeUI != None)
        {
            if (m_BlazeUI.m_oGUI == None)
            {
                if (oPanel != None)
                {
                    oManager = oPanel.oParentManager;
                    if (oManager != None)
                    {
                        oHandler = oManager.CreateNetworkGUI(m_BlazeUI.HandlerId, GetPC());
                        m_BlazeUI.SetGui(oHandler);
                        m_BlazeUI.__ExternalCallback_OnDisplayNotification__Delegate = OnDisplayNotification;
                        m_BlazeUI.__ExternalCallback_SetState__Delegate = SetOnlineState;
                        m_BlazeUI.__ExternalCallback_CloseEANetworking__Delegate = CloseEANetworking;
                        oHandler.__OnGFxScreenVisibilityChange__Delegate = OnEANetworkingVisibilityChange;
                    }
                }
            }
            if (m_BlazeUI.m_oGUI != None)
            {
                SetInputEnabled(FALSE);
                m_BlazeUI.Connect(connectMode);
            }
        }
    }
    else if (connectMode == SFXOnlineConnectMode.SFXONLINE_CM_EXPLICIT)
    {
        messageBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(GetPC());
        messageParams.srAText = Class'SFXGUI_MainMenu_RTT'.default.srOK;
        messageBox.DisplayMessageBox(srNotificationOriginSignin, messageParams);
    }
}
public function ClearNotifications(optional array<SFXOnlineConnection_MessageType> MessageTypesToClear)
{
    if (MessagingComputer != None)
    {
        MessagingComputer.ClearNotifications(MessageTypesToClear);
    }
}
public function CloseEANetworking()
{
    local SFXGUIInteraction oManager;
    
    if (oPanel != None)
    {
        oManager = oPanel.oParentManager;
        if (oManager != None && m_BlazeUI != None)
        {
            m_BlazeUI.ClearGui();
            oManager.DestroyNetworkGUI(m_BlazeUI.HandlerId, GetPC());
        }
    }
    bEARegistrationScreenVisible = FALSE;
    RemoveConnectingMessageBox();
    SetInputEnabled(TRUE);
    OpenMenuComputer();
}
public event function bool HandleInputEvent(BioGuiEvents nEventID, optional float fValue = 1.0)
{
    local bool bHandled;
    
    bHandled = FALSE;
    if (MenuComputer != None && MenuComputer.GetInputEnabled())
    {
        bHandled = MenuComputer.HandleInputEvent(nEventID, fValue);
    }
    if (!bHandled)
    {
        switch (nEventID)
        {
            case BioGuiEvents.BIOGUI_EVENT_BUTTON_Y:
                OnMessagingComputerConnectButton();
                bHandled = TRUE;
                break;
            case BioGuiEvents.BIOGUI_EVENT_BUTTON_LB:
                PrevCerberusItem();
                bHandled = TRUE;
                break;
            case BioGuiEvents.BIOGUI_EVENT_BUTTON_RB:
                NextCerberusItem();
                bHandled = TRUE;
                break;
            default:
        }
    }
    return bHandled;
}
public native function InitCerberus();

public event function bool IsFromGameEntryFlow()
{
    local string URLString;
    local string OptionsString;
    
    URLString = oWorldInfo.GetLocalURL();
    OptionsString = Mid(URLString, InStr(URLString, "?", , , ), );
    return Class'GameInfo'.static.HasOption(OptionsString, "fromgameentryflow");
}
public function OnDisplayNotification(SFXOnlineConnection_MessageType Type, string MessageData, string Title, string Image, int DLC_ID, int ServerID)
{
    switch (Type)
    {
        case SFXOnlineConnection_MessageType.SFXONLINE_MT_MESSAGEOFTHEDAY:
            AddNetworkImageMessageItem(Title, MessageData, Image, Type, DLC_ID, ServerID);
            break;
        case SFXOnlineConnection_MessageType.SFXONLINE_MT_FRIEND_ACHIVEMENT:
        case SFXOnlineConnection_MessageType.SFXONLINE_MT_FRIEND_LEADERBOARD_RANK_CHANGE:
        case SFXOnlineConnection_MessageType.SFXONLINE_MT_MESSAGEOFTHEDAY_TICKERONLY:
        case SFXOnlineConnection_MessageType.SFXONLINE_MT_GAW_STATUS_UPDATE:
            AddTickerMessage(Type, MessageData, DLC_ID, ServerID);
            break;
        case SFXOnlineConnection_MessageType.SFXONLINE_MT_DOWNLOAD_PROMPT:
            AddDownloadPromtMessageItem(Title, MessageData, Image, Type, DLC_ID, ServerID);
            break;
        default:
            break;
    }
}
public function OnPanelAdded()
{
    local SFXOnlineSubsystem OnlineSub;
    
    Super.OnPanelAdded();
    oPanel.SetExternalInterface(Self);
    OnlineSub = SFXOnlineSubsystem(Class'GameEngine'.static.GetOnlineSubsystem());
    if (OnlineSub != None)
    {
        OnlineSub.GetComponentLeaderboard().AddRankNotificationCallback(OnRankMessageRecieved);
    }
    MessagingComputer.__OnComputerDisplayRegistered__Delegate = OnMessagingSystemReady;
    MessagingComputer.__OnConnectButtonExecuted__Delegate = OnMessagingComputerConnectButton;
}
public function OnPanelRemoved()
{
    local OnlineSubsystem OnlineSub;
    
    if (m_BlazeUI != None)
    {
        m_BlazeUI.ClearDelegates();
        m_BlazeUI.ClearGui();
        m_BlazeUI = None;
    }
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        if (SFXOnlineSubsystem(OnlineSub) != None)
        {
            SFXOnlineSubsystem(OnlineSub).GetComponentLeaderboard().RemoveRankNotificationCallback(OnRankMessageRecieved);
            if (Class'SFXEngine'.static.GetSFXEngine().GetProfileSettings() != None)
            {
                SFXOnlineSubsystem(OnlineSub).GetComponentLeaderboard().FlushRankNotifications();
            }
        }
    }
    if (MessagingComputer != None)
    {
        MessagingComputer.OnShutdown();
        MessagingComputer = None;
    }
    if (MenuComputer != None)
    {
        MenuComputer = None;
    }
}
public function SetEnabled(bool bVal)
{
    local SFXGUI_MainMenu_RTT_RC DisplayComputer;
    
    Super(SFXGUIMovie).SetEnabled(bVal);
    MenuComputer.SetEnabled(bVal);
    DisplayComputer = MessagingComputer.GetDisplayComputer();
    DisplayComputer.SetEnabled(bVal);
}
public event function Update(float fDeltaT)
{
    fTimeSinceLastPendingLoadMessageCheck = fTimeSinceLastPendingLoadMessageCheck + fDeltaT;
    if (MessagingComputer != None && m_CerbConnectState == SFXOnlineUIState.SFXONLINE_UISTATE_CERBERUS_CONNECTED && fTimeSinceLastPendingLoadMessageCheck >= fPendingLoadMessageCheckThreshold)
    {
        fTimeSinceLastPendingLoadMessageCheck = 0.0;
        MessagingComputer.LoadPendingMessageData();
    }
}
public final function AddDisconnectedTickerMessages()
{
    if (MessagingComputer != None)
    {
        MessagingComputer.AddDisconnectedTickerMessages();
    }
}
public function AddDownloadPromtMessageItem(string i_sTitle, string i_sInfo, string i_sImage, SFXOnlineConnection_MessageType Type, int nDLC_ID, int ServerID)
{
    if (MessagingComputer != None)
    {
        MessagingComputer.AddDownloadPromtMessageItem(i_sTitle, i_sInfo, i_sImage, Type, nDLC_ID, ServerID);
    }
}
public function AddNetworkImageMessageItem(string i_sTitle, string i_sInfo, string i_sImage, SFXOnlineConnection_MessageType Type, int nDLC_ID, int ServerID)
{
    if (MessagingComputer != None)
    {
        MessagingComputer.AddNetworkImageMessage(i_sTitle, i_sInfo, i_sImage, Type, nDLC_ID, ServerID);
    }
}
public function AddTickerMessage(SFXOnlineConnection_MessageType Type, string MessageData, int nDLC_ID, int ServerID)
{
    if (MessagingComputer != None)
    {
        MessagingComputer.AddTickerMessage(Type, MessageData, nDLC_ID, ServerID);
    }
}
public function ClearAllConnectedNotifications()
{
    local array<SFXOnlineConnection_MessageType> MessageTypesToClear;
    
    MessageTypesToClear.AddItem(0);
    MessageTypesToClear.AddItem(1);
    MessageTypesToClear.AddItem(3);
    MessageTypesToClear.AddItem(0);
    MessageTypesToClear.AddItem(4);
    MessageTypesToClear.AddItem(5);
    MessageTypesToClear.AddItem(6);
    ClearNotifications(MessageTypesToClear);
}
public final function ClearDisconnectedTickerMessages()
{
    if (MessagingComputer != None)
    {
        MessagingComputer.ClearDisconnectedTickerMessages();
    }
}
public final function CloseMessagingComputer()
{
    if (MessagingComputer != None && MessagingComputer.IsComputerOpen())
    {
        MessagingComputer.CloseComputer();
    }
}
public final function MainMenu_FailImageAssets()
{
    if (MessagingComputer != None)
    {
        MessagingComputer.FailImageAssets();
    }
}
public function NextCerberusItem()
{
    MessagingComputer.NextMessage();
}
public final function OnEANetworkingVisibilityChange(bool bNewValue)
{
    if (!bEARegistrationScreenVisible && bNewValue)
    {
        bEARegistrationScreenVisible = TRUE;
        RemoveConnectingMessageBox();
    }
}
public final function OnMessagingComputerConnectButton()
{
    if (bConnectButtonVisible)
    {
        CerberusConnect(2);
    }
}
public function OnMessagingSystemReady()
{
    local SFXEngine Engine;
    local SFXPlayerController PC;
    local string URLString;
    local string OptionsString;
    
    SetOnlineState(0);
    MessagingComputer.AddGalaxyAtWarMessage();
    InitCerberus();
    MessagingComputer.__OnComputerDisplayRegistered__Delegate = None;
    URLString = oWorldInfo.GetLocalURL();
    OptionsString = Mid(URLString, InStr(URLString, "?", , , ), );
    PC = SFXPlayerController(oWorldInfo.GetLocalPlayerController());
    if (PC != None)
    {
        Engine = SFXEngine(Class'Engine'.static.GetEngine());
        if (Class'GameInfo'.static.HasOption(OptionsString, "showdisconnecterror"))
        {
            PC.QueueHostLeftMessage();
        }
        else if (Engine != None && Engine.eNetworkErrorStatus == ESFXNetworkErrorStatus.ErrorStatus_DisplayPromptAfterTravel)
        {
            Engine.eNetworkErrorStatus = ESFXNetworkErrorStatus.ErrorStatus_NoError;
            PC.QueueHostLeftMessage();
        }
    }
}
private final function OnRankMessageRecieved(array<RankBypassNotification> RankBypassNotifications)
{
    local RankBypassNotification aRankNotification;
    local string strRankMessage;
    local array<SFXTokenMapping> TokenList;
    
    TokenList.Add(1);
    TokenList[0].TokenId = 1;
    foreach RankBypassNotifications(aRankNotification, )
    {
        Class'Object'.static.ClearCustomTokens();
        TokenList[0].Data = aRankNotification.sEntityName;
        strRankMessage = Class'Object'.static.GetTokenisedString(aRankNotification.bBeatenByMe ? srFriendBeatByMe : srFriendBeatMe, TokenList);
        OnDisplayNotification(5, strRankMessage, "", "", 0, 0);
    }
}
public final function OpenMenuComputer()
{
    if (MenuComputer != None && !MenuComputer.IsComputerOpen())
    {
        MenuComputer.OpenComputer();
    }
}
public final function OpenMessagingComputer()
{
    if (MessagingComputer != None && !MessagingComputer.IsComputerOpen())
    {
        MessagingComputer.OpenComputer();
    }
}
public function OutputMessages()
{
    MessagingComputer.OutputMessages();
}
public function PrevCerberusItem()
{
    MessagingComputer.PrevMessage();
}
public final function QueueConnectingMessageBox(stringref srMessage)
{
    local BioMessageBoxOptionalParams stParams;
    
    if (!bEARegistrationScreenVisible)
    {
        Class'SFXGUIInteraction'.static.GetInstance().QueueNamedMessageBox(ConnectionMessageBoxId, 10, srMessage, stParams, None, 0);
    }
}
public final function RemoveConnectingMessageBox()
{
    Class'SFXGUIInteraction'.static.GetInstance().RemoveNamedMessageBox(ConnectionMessageBoxId);
}
protected final function RequestAdditionalNetworkMessages()
{
    local SFXOnlineSubsystem OnlineSub;
    local ISFXOnlineComponentLeaderboard Leaderboards;
    
    OnlineSub = SFXOnlineSubsystem(Class'GameEngine'.static.GetOnlineSubsystem());
    if (OnlineSub != None)
    {
        Leaderboards = OnlineSub.GetComponentLeaderboard();
        if (Leaderboards != None)
        {
            if (!Leaderboards.HasNotificationsAvailable())
            {
                Leaderboards.GetRankNotifications();
            }
            else
            {
                OnRankMessageRecieved(Leaderboards.GetCurrentRankNotificationsArray());
            }
        }
    }
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentMessaging().FetchAllMessagesViaJob();
}
public final function SetConnectButtonState(string sMessage, optional bool bVisible = TRUE)
{
    if (MessagingComputer != None)
    {
        bConnectButtonVisible = bVisible;
        MessagingComputer.SetConnectButtonState(sMessage, bVisible);
    }
}
public function SetOnlineState(SFXOnlineUIState eState)
{
    local bool bConnectionButtonVisible;
    local string sMessage;
    
    if (int(m_CerbConnectState) == int(eState))
    {
        return;
    }
    bConnectionButtonVisible = TRUE;
    m_CerbConnectState = eState;
    switch (m_CerbConnectState)
    {
        case SFXOnlineUIState.SFXONLINE_UISTATE_CERBERUS_ENTITLED:
            sMessage = UIStrRef(srCerb_ConnectTo);
            break;
        case SFXOnlineUIState.SFXONLINE_UISTATE_CERBERUS_CONNECTED:
            bConnectionButtonVisible = FALSE;
            sMessage = UIStrRef(srCerb_ConnectedToCerb);
            OpenMessagingComputer();
            ClearDisconnectedTickerMessages();
            RequestAdditionalNetworkMessages();
            break;
        case SFXOnlineUIState.SFXONLINE_UISTATE_NUCLEUS_CONNECTED:
            sMessage = UIStrRef(srCerb_ActivateCerb);
            break;
        case SFXOnlineUIState.SFXONLINE_UISTATE_NUCLEUS_CONNECTING:
            bConnectionButtonVisible = FALSE;
            sMessage = UIStrRef(srCerb_ConnectingToCerb);
            QueueConnectingMessageBox(srCerb_ConnectingToCerb);
            ClearAllConnectedNotifications();
            break;
        case SFXOnlineUIState.SFXONLINE_UISTATE_CERBERUS_CONNECTING:
            bConnectionButtonVisible = FALSE;
            sMessage = UIStrRef(srCerb_ConnectingToCerb);
            UpdateConnectingMessageBox(srCerb_ConnectingToCerb);
            break;
        case SFXOnlineUIState.SFXONLINE_UISTATE_NONE:
        default:
            CloseMessagingComputer();
            sMessage = UIStrRef(srCerb_ConnectTo);
            AddDisconnectedTickerMessages();
            break;
    }
    SetConnectButtonState(sMessage, bConnectionButtonVisible);
}
public final function UpdateConnectingMessageBox(stringref srMessage)
{
    if (!bEARegistrationScreenVisible)
    {
        Class'SFXGUIInteraction'.static.GetInstance().UpdateNamedMessageBox(ConnectionMessageBoxId, srMessage);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXGUI_MainMenu_RightComputer Name=MessagingComputer1
    End Object
    ConnectionMessageBoxId = 'MainMenu_ConnectProcess'
    srDemo = $724407
    srCerb_ActivateCerb = $344565
    srCerb_ConnectTo = $350590
    srCerb_ConnectingToCerb = $387825
    srCerb_ConnectedToCerb = $387826
    srNotificationOriginSignin = $681618
    srFriendBeatMe = $718192
    srFriendBeatByMe = $718193
    fPendingLoadMessageCheckThreshold = 1.0
    MessagingComputer = MessagingComputer1
    bConnectButtonVisible = TRUE
    m_CerbConnectState = None
    nHandlerID = 8
    AllowRTTMouseInputWithLowerZOrder = TRUE
}