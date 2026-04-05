Class SFXGUI_SplashScreen extends BioSFHandler_Splash
    native
    config(UI);

var float fAttractModeTimeout;
var float fLegalTimeout;
var config float fAttractModeDelay;
var config float fShowLegalTime;
var config stringref srNotificationAdvanceOrigin;
var config stringref srNotifificationOriginDRMFail;
var config stringref srNotificationOptionQuitGame;
var config stringref srConnectingToOrigin;
var config stringref srNoLoginStart;
var config stringref srConfirmNoLoginStart;
var config stringref srCancelNoLoginStart;
var config stringref srStartText;
var config stringref srLegalText;
var config stringref srDemo;
var BioSFHandler_MessageBox connectingMessageBox;
var config bool bSuppressAttractMode;
var bool bPressedStart;
var bool bWaitingForOrigin;

public event function AdvanceScreen()
{
    local BioPlayerController PC;
    local OnlineSubsystem OnlineSub;
    local SFXOnlineComponentUnrealPlayer PlayerInt;
    local SFXEngine Engine;
    local SFXOnlineComponentOrigin oOrigin;
    local BioSFHandler_MessageBox messageBox;
    local BioMessageBoxOptionalParams messageParams;
    local bool bAllowAdvance;
    local bool bIsConsole;
    
    bIsConsole = Class'WorldInfo'.static.IsConsoleBuild();
    bAllowAdvance = TRUE;
    if (!bIsConsole)
    {
        oOrigin = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentOrigin();
        if (oOrigin != None)
        {
            if (bWaitingForOrigin)
            {
                return;
            }
            if (!oOrigin.mIsOriginDisabled)
            {
                if (oOrigin.CheckSignedIn() && oOrigin.CheckEntitlementCache() && !oOrigin.mIsPendingConnection)
                {
                    oOrigin.SetPresenceState(2);
                }
                else
                {
                    bAllowAdvance = FALSE;
                }
            }
        }
    }
    if (bAllowAdvance)
    {
        PC = BioPlayerController(GetPC());
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (PC != None && PC.Player != None && OnlineSub != None)
        {
            PlayerInt = SFXOnlineComponentUnrealPlayer(OnlineSub.PlayerInterface);
            Engine = SFXEngine(PC.Player.Outer);
            if (PlayerInt != None)
            {
                if (!bIsConsole)
                {
                    PlayerInt.ClearProfileCaches();
                    PC.RegisterPlayerDataStores();
                }
                if (Engine != None)
                {
                    PlayerInt.GetOfflinePlayerId(byte(LocalPlayer(PC.Player).ControllerId), Engine.m_oInitialPlayerID);
                }
            }
        }
        bPressedStart = TRUE;
        SetMovieFocus(FALSE);
        fAttractModeTimeout = 0.0;
        GetPC().CauseEvent('startpressed');
        TransitionOut();
        PlayGuiSound('SplashStart');
    }
    else
    {
        messageBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(GetPC());
        messageParams.srAText = Class'SFXGUI_MainMenu_RTT'.default.srOK;
        messageParams.srBText = srNotificationOptionQuitGame;
        messageBox.SetInputDelegate(OnHandleOriginErrorUserResponse);
        messageBox.DisplayMessageBox(srNotificationAdvanceOrigin, messageParams);
    }
}
public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_BUTTON_START:
            CheckLogin();
            break;
        default:
    }
    return TRUE;
}
public function Initialize()
{
    local BioPlayerController PC;
    
    PC = BioPlayerController(GetPC());
    if (PC != None)
    {
        PC.GameModeManager2.DisableMode(10);
    }
}
public event function OnStart()
{
    local BioMessageBoxOptionalParams messageParams;
    local BioPlayerController PC;
    local SFXOnlineComponentOrigin oOrigin;
    local SFXEngine Engine;
    
    Super(SFXGUIMovie).OnStart();
    SetGameMode(TRUE, 9);
    oWorldInfo.WaitForStartKey = 'XboxTypeS_Start';
    PlayGuiMusic('MainMenu');
    SetMovieFocus(FALSE);
    fAttractModeTimeout = 0.0;
    PC = BioPlayerController(GetPC());
    PC.SetRichPresence();
    Engine = SFXEngine(PC.Player.Outer);
    Engine.bMPTransitionToEntryMenu = FALSE;
    InitSplashScreen(int(srStartText), int(srLegalText));
    if (Class'WorldInfo'.static.IsConsoleBuild() == FALSE)
    {
        oOrigin = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentOrigin();
        if (oOrigin != None)
        {
            if (!oOrigin.mIsOriginDisabled && !oOrigin.mServiceStarted)
            {
                oOrigin.OnOriginClosed();
            }
            else if (!oOrigin.mIsOriginDisabled)
            {
                connectingMessageBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(GetPC());
                connectingMessageBox.DisplayMessageBox(srConnectingToOrigin, messageParams);
                bWaitingForOrigin = TRUE;
            }
        }
    }
}
public function Update(float fDeltaT)
{
    local SFXOnlineComponentOrigin oOrigin;
    
    if (bWaitingForOrigin)
    {
        if (Class'WorldInfo'.static.IsConsoleBuild() == FALSE)
        {
            oOrigin = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentOrigin();
            if (oOrigin != None)
            {
                if (oOrigin.mServiceStarted && !oOrigin.mIsPendingConnection)
                {
                    bWaitingForOrigin = FALSE;
                    connectingMessageBox.Close();
                }
            }
        }
    }
    if (fAttractModeTimeout > 0.0)
    {
        fAttractModeTimeout -= fDeltaT;
        if (fAttractModeTimeout <= 0.0 && !bSuppressAttractMode)
        {
            oWorldInfo.WaitForStartKey = 'XboxTypeS_Start';
            StopGuiMusic();
            oWorldInfo.GetLocalPlayerController().CauseEvent('startattractmode');
            GetSFXUIController().RemoveNamedMessageBox('ConfirmNoProfile', GetPC());
            FadeToBlack(TRUE);
        }
        else if (fLegalTimeout > 0.0)
        {
            fLegalTimeout -= fDeltaT;
            if (fLegalTimeout <= 0.0)
            {
                FadeLegal();
            }
        }
    }
}
public event function OnClose()
{
    SetGameMode(FALSE, 9);
    Super(SFXGUIMovie).OnClose();
}
public function Callback_LoginComplete(bool bIsOpening)
{
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInt;
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;
    
    if (!bIsOpening)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            SystemInt = OnlineSub.SystemInterface;
            PlayerInt = OnlineSub.PlayerInterface;
            if (SystemInt != None)
            {
                SystemInt.ClearExternalUIChangeDelegate(Callback_LoginComplete);
            }
            if (PlayerInt != None)
            {
                ControllerId = GetLP().ControllerId;
                if (int(PlayerInt.GetLoginStatus(byte(ControllerId))) != 0)
                {
                    AdvanceScreen();
                }
                else
                {
                    DisplayNoProfileConfirmation();
                }
            }
        }
    }
}
public function Callback_NoLoginStart(bool bAPressed, int Context)
{
    if (bAPressed)
    {
        AdvanceScreen();
    }
    else
    {
        oWorldInfo.WaitForStartKey = 'XboxTypeS_Start';
    }
}
public function CheckLogin()
{
    local int ControllerId;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;
    local OnlineSystemInterface SystemInt;
    local LocalPlayer LP;
    
    if (Class'WorldInfo'.static.IsConsoleBuild() == FALSE)
    {
        AdvanceScreen();
        return;
    }
    LP = GetLP();
    ControllerId = LP.ControllerId;
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        SystemInt = OnlineSub.SystemInterface;
        if (PlayerInt != None && SystemInt != None)
        {
            if (int(PlayerInt.GetLoginStatus(byte(ControllerId))) == 0)
            {
                SystemInt.AddExternalUIChangeDelegate(Callback_LoginComplete);
                if (!PlayerInt.ShowLoginUI())
                {
                    SystemInt.ClearExternalUIChangeDelegate(Callback_LoginComplete);
                    AdvanceScreen();
                }
                return;
            }
        }
    }
    AdvanceScreen();
}
public function DisplayNoProfileConfirmation()
{
    local BioMessageBoxOptionalParams Params;
    local BioPlayerController PlayerOwner;
    
    PlayerOwner = BioPlayerController(GetPC());
    if (PlayerOwner != None)
    {
        Params.srAText = srConfirmNoLoginStart;
        Params.srBText = srCancelNoLoginStart;
        Params.bModal = TRUE;
        Params.bNoFade = TRUE;
        GetSFXUIController().QueueNamedMessageBox('ConfirmNoProfile', 2, srNoLoginStart, Params, Callback_NoLoginStart, 0, PlayerOwner);
    }
    else
    {
        AdvanceScreen();
    }
}
public function FadeLegal()
{
    ActionScriptVoid("FadeLegal");
}
public function FadeToBlack(bool bSkipTransition)
{
    ActionScriptVoid("FadeToBlack");
}
public function InitSplashScreen(int nStartText, int nLegalText)
{
    ActionScriptVoid("InitSplashScreen");
}
public function OnHandleOriginErrorUserResponse(bool bAPressed, int nContext)
{
    if (!bAPressed)
    {
        GetPC().ConsoleCommand("quit");
    }
}
public function OnTransitionInComplete()
{
    SetMovieFocus(TRUE);
}
public function OnTransitionOutComplete()
{
    oWorldInfo.GetLocalPlayerController().CauseEvent('transitionoutcomplete');
    Close(TRUE);
}
public function SetBackgroundMovie(TextureMovie movie);

public function StartTimeout(bool bShowLegal)
{
    fAttractModeTimeout = fAttractModeDelay;
    fLegalTimeout = bShowLegal ? fShowLegalTime : -1.0;
    TransitionIn(bShowLegal);
}
public function TransitionIn(bool bShowLegal)
{
    ActionScriptVoid("TransitionIn");
}
public function TransitionOut()
{
    ActionScriptVoid("TransitionOut");
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fAttractModeDelay = 60.0
    fShowLegalTime = 15.0
    srNotificationAdvanceOrigin = $683529
    srNotifificationOriginDRMFail = $683640
    srNotificationOptionQuitGame = $349603
    srConnectingToOrigin = $718414
    srNoLoginStart = $337346
    srConfirmNoLoginStart = $163219
    srCancelNoLoginStart = $163220
    srStartText = $238232
    srLegalText = $168194
    srDemo = $724407
    bSuppressAttractMode = TRUE
}