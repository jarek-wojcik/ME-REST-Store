Class SFXOnlineGameEntryFlow extends SFXOnlineComponent
    implements(ISFXOnlineComponentGameEntryFlow)
    native
    config(Game);

enum MPFlowType
{
    MPF_Inactive,
    MPF_Connect,
    MPF_ResolvingInvite,
    MPF_LobbyAccess,
};

var const native noexport Pointer VfTable_IISFXOnlineComponentGameEntryFlow;
var const UniqueNetId ZeroId;
var const Name PopupName;
var SFXOnlineGameSettings DeferredGameSettings;
var const stringref srJoiningGame;
var const stringref srConnecting;
var const stringref srInvalidControllerJoin;
var const stringref srMultiplayerUpdate;
var const stringref srDownloadRequiredDataError;
var const stringref srOK;
var config stringref srCancel;
var config stringref srAlreadyConnected;
var const stringref srOnlinePassRequired;
var config int KismetEventTicksDelay;
var transient int CurrentKismetEventTicksDelay;
var byte InvitePlatformData[80];
var MPFlowType m_FlowType;
var SFXOnlineUIState m_LoginUIState;

private final native function CancelSearchInput(bool bAPressed, int nContext);

private final native function ClearInviteData();

public event simulated function Destroyed()
{
    OnlineSubsystem.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
}
public native function Name GetAPIName();

private final native function SFXGUIMovie GetCurrentFocusMovie();

private final function SFXPlayerController GetLocalPlayerController()
{
    local BioWorldInfo World;
    
    World = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    return SFXPlayerController(World.GetALocalPlayerController());
}
private final function SFXGUIMovie GetMovie(Name nmMovie)
{
    local SFXPlayerController PC;
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    PC = GetLocalPlayerController();
    return PC == None || oGUI == None ? None : oGUI.GetMovie(PC, nmMovie);
}
private final function bool IsInMainMenu()
{
    return IsMovieLoaded('MainMenu_RTT');
}
public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

private final native function ReconstructInviteDataNative(out OnlineGameSearch Invite, int ResultNum);

public event function SetLoginState(SFXOnlineUIState loginState)
{
    m_LoginUIState = loginState;
}
private final function ShowPopup(stringref bodyStr, optional bool showOkButton = TRUE)
{
    local SFXGUIInteraction oGuiMgr;
    local BioMessageBoxOptionalParams stParams;
    
    oGuiMgr = Class'SFXGUIInteraction'.static.GetInstance();
    stParams.bModal = TRUE;
    stParams.bNoFade = TRUE;
    if (showOkButton)
    {
        stParams.srAText = srOK;
    }
    oGuiMgr.QueueNamedMessageBox(PopupName, 2, bodyStr, stParams, None);
}
public native function UpdateMPDLCInfo();

public function OnInviteJoinComplete(Name SessionName, bool bWasSuccessful)
{
    OnlineSubsystem.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
    if (!bWasSuccessful)
    {
        HidePopup();
    }
}
private final function AccessLobbyFlowComplete()
{
    if (OnlineSubsystem.GetComponentGame().IsOnLatestMultiplayerVersion())
    {
        GetLocalPlayerController().ClientTravel(Class'GameEngine'.static.GetDefaultLobbyMap() $ "?origin=MainMenu", 0);
    }
    else
    {
        ShowPopup(srMultiplayerUpdate);
    }
}
public function bool ActivateConnectFlow()
{
    m_FlowType = MPFlowType.MPF_Connect;
    if (OnlineSubsystem.GetComponentLogin().IsSignedIn() && OnlineSubsystem.GetComponentLogin().IsCerberusMember())
    {
        ShowPopup(srAlreadyConnected);
        return FALSE;
    }
    GotoState('TravelToMainMenu', , , );
    return TRUE;
}
public function ActivateConnectToMapFlow(string mapPackageName, optional bool fromGalaxyMap = FALSE, optional SFXOnlineGameDifficulty Difficulty = 0, optional int EnemyType = 0)
{
    DeferredGameSettings = new Class'SFXOnlineGameSettings';
    if (DeferredGameSettings.ValidateMapName(mapPackageName))
    {
        DeferredGameSettings.mFromGalaxyMap = fromGalaxyMap;
    }
    DeferredGameSettings.mME3MapName = mapPackageName;
    DeferredGameSettings.Difficulty = Difficulty;
    DeferredGameSettings.EnemyType = EnemyType;
    ActivateMPLobbyAccessFlow();
}
public function ActivateInviteFlow(const out OnlineGameSearchResult InviteResult)
{
    if (m_FlowType == MPFlowType.MPF_ResolvingInvite)
    {
    }
    else
    {
        m_FlowType = MPFlowType.MPF_ResolvingInvite;
        ArchiveInviteData(InviteResult);
        if (OnlineSubsystem.GetComponentGameFlow().GM_IsInMultiplayerGame())
        {
            GotoState('InviteLeavingPreviousGame', , , );
        }
        else
        {
            ProcessInvite();
        }
    }
}
public function ActivateMPLobbyAccessFlow()
{
    m_FlowType = MPFlowType.MPF_LobbyAccess;
    GotoState('TravelToMainMenu', , , );
}
private final function ArchiveInviteData(const out OnlineGameSearchResult Invite)
{
    ClearInviteData();
    DeferredGameSettings = SFXOnlineGameSettings(Invite.GameSettings).Copy();
    OnlineSubsystem.GameInterface.ReadPlatformSpecificSessionInfo(Invite, InvitePlatformData);
}
private final function CancelConnecting(bool bAPressed, int nContext)
{
    ClearMainMenuFlow(FALSE);
}
protected function ClearMainMenuFlow(bool Success)
{
    local SFXEngine oEngine;
    
    oEngine = SFXEngine(Class'SFXEngine'.static.GetEngine());
    if (!oEngine.HasCantContinueError() && m_FlowType != MPFlowType.MPF_Connect)
    {
        if (Success)
        {
            OnlineSubsystem.GetComponentGameFlow().GM_OnEnterMPFlow();
            UpdateMPDLCInfo();
            if (m_FlowType == MPFlowType.MPF_ResolvingInvite)
            {
                GotoState('InviteSelectKit', , , );
                return;
            }
            else if (m_FlowType == MPFlowType.MPF_LobbyAccess)
            {
                AccessLobbyFlowComplete();
            }
        }
        else if (m_FlowType == MPFlowType.MPF_ResolvingInvite)
        {
            OnlineSubsystem.GetComponentGameFlow().GM_OnInviteAborted();
        }
        ClearInviteData();
    }
    GotoState('Inactive', , , );
}
public function SFXOnlineGameSettings GetDeferredGameSettings()
{
    return DeferredGameSettings;
}
private final function SFXGUIMovie GetMainMenuMovie()
{
    return GetMovie('MainMenu_RTT');
}
private final function bool HasValidDeployedCharacter()
{
    local SFXSaveManagerMP MPSaveManager;
    
    MPSaveManager = SFXEngine(Class'SFXEngine'.static.GetEngine()).MPSaveManager;
    return MPSaveManager != None && MPSaveManager.IsCurrentSelectedCharacterRecordValid();
}
private final function HidePopup()
{
    local SFXGUIInteraction oGuiMgr;
    
    oGuiMgr = Class'SFXGUIInteraction'.static.GetInstance();
    if (oGuiMgr != None)
    {
        oGuiMgr.RemoveNamedMessageBox(PopupName);
    }
}
private final function InviteFlowComplete(const out OnlineGameSearchResult InviteResult)
{
    GetLocalPlayerController().ContinueGameInviteAccepted(InviteResult);
}
public function InviteStartConnecting()
{
    local OnlineGameSearch GameSearch;
    local OnlineGameSearchResult ReconstructedInvite;
    
    ShowPopup(srJoiningGame, FALSE);
    OnlineSubsystem.GameInterface.AddJoinOnlineGameCompleteDelegate(OnInviteJoinComplete);
    GameSearch = new Class'OnlineGameSearch';
    ReconstructInviteData(GameSearch);
    ReconstructedInvite = GameSearch.Results[0];
    InviteFlowComplete(ReconstructedInvite);
}
public function bool IsInConnectToMapFlow()
{
    return DeferredGameSettings != None && DeferredGameSettings.mME3MapName != "";
}
public function bool IsInGalaxyMapFlow()
{
    return DeferredGameSettings != None && DeferredGameSettings.mFromGalaxyMap == TRUE;
}
private final function bool IsInSplash()
{
    return Class'SFXGUIInteraction'.static.GetInstance().IsInSplashScreen();
}
public function bool IsInvitedUserActive(const out UniqueNetId invitedId)
{
    local SFXEngine oEngine;
    
    oEngine = SFXEngine(Class'SFXEngine'.static.GetEngine());
    return invitedId.Uid.B == 0 || invitedId.Uid == oEngine.m_oProfilePlayerID.Uid;
}
private final function bool IsMovieLoaded(Name MovieName)
{
    local SFXPlayerController PC;
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    PC = GetLocalPlayerController();
    return PC == None ? FALSE : oGUI.GetMovie(PC, MovieName) != None;
}
public function bool IsWaitingForKitSelect()
{
    return FALSE;
}
public function OnConnectToMapFlowCompleted(optional bool Success = TRUE)
{
    DeferredGameSettings = None;
}
public function OnKitDeployed(bool Success);

private final function OpenMainMenu()
{
    GetLocalPlayerController().ClientTravel("EntryMenu?nosplash?fromgameentryflow", 0);
}
public function OS_OnTick(SFXOnlineEvent oEvent);

public function ProcessInvite()
{
    local bool invitedInactiveUser;
    
    invitedInactiveUser = !IsInvitedUserActive(DeferredGameSettings.invitedUserId);
    if (!OnlineSubsystem.GetComponentGameFlow().GM_OnInviteAccepted(invitedInactiveUser))
    {
        return;
    }
    if (invitedInactiveUser)
    {
        GotoState('ChangingUser', , , );
    }
    else
    {
        GotoState('TravelToMainMenu', , , );
    }
}
private final function ReconstructInviteData(out OnlineGameSearch Invite)
{
    local OnlineGameSearchResult InviteResult;
    
    Invite.Results.InsertItem(0, InviteResult);
    OnlineSubsystem.GameInterface.BindPlatformSpecificSessionToSearch(0, Invite, InvitePlatformData);
    ReconstructInviteDataNative(Invite, 0);
}

state InviteLeavingPreviousGame extends GameEntryState 
{
    public function OS_OnTick(SFXOnlineEvent oEvent)
    {
        if (!OnlineSubsystem.GetComponentGame().IsPlaying())
        {
            ProcessInvite();
        }
    }
    public function BeginState(Name PreviousState)
    {
        Super.BeginState(PreviousState);
        OnlineSubsystem.GetComponentGame().LeaveGame();
    }
    
    stop;
};
state InviteSelectKit extends GameEntryState 
{
    public function OnKitDeployed(bool Success)
    {
        if (Success)
        {
            InviteStartConnecting();
            ClearInviteData();
            GotoState('Inactive', , , );
        }
        else
        {
            OnlineSubsystem.GetComponentGameFlow().GM_OnInviteAborted();
            ClearInviteData();
            GotoState('Inactive', , , );
        }
    }
    public function BeginState(Name PreviousState)
    {
        Super.BeginState(PreviousState);
        GetLocalPlayerController().ClientTravel(Class'GameEngine'.static.GetDefaultLobbyMap() $ "?origin=MainMenu", 0);
    }
    public function bool IsWaitingForKitSelect()
    {
        return TRUE;
    }
    
    stop;
};
state WaitingForProfileId extends GameEntryState 
{
    public function OS_OnTick(SFXOnlineEvent oEvent)
    {
        local SFXEngine oEngine;
        local int PlayerIndex;
        
        oEngine = SFXEngine(Class'SFXEngine'.static.GetEngine());
        if (oEngine.HasCantContinueProfileError())
        {
            GetLocalPlayerController().CheckThatGameCanContinue();
        }
        if (IsInMainMenu())
        {
            oEngine.MPSaveManager.bInitialized = FALSE;
            oEngine.MPSaveManager.OnlineSave = None;
            for (PlayerIndex = 0; PlayerIndex < 4; PlayerIndex++)
            {
                OnlineSubsystem.GetComponentUnrealPlayer().PlayerStorageCache[PlayerIndex] = None;
            }
            OnlineSubsystem.GetComponentGameFlow().GM_OnProfileSelected();
            if (IsInvitedUserActive(DeferredGameSettings.invitedUserId))
            {
                GotoState('TravelToMainMenu', , , );
            }
            else
            {
                ShowPopup(srInvalidControllerJoin);
                ClearMainMenuFlow(FALSE);
            }
        }
    }
    
    stop;
};
state ChangingUser extends GameEntryState 
{
    public function OS_OnTick(SFXOnlineEvent oEvent)
    {
        if (IsInSplash())
        {
            GotoState('WaitingForProfileId', , , );
        }
    }
    public function BeginState(Name PreviousState)
    {
        local SFXEngine oEngine;
        
        Super.BeginState(PreviousState);
        oEngine = SFXEngine(Class'SFXEngine'.static.GetEngine());
        if (!IsInSplash() || oEngine.m_oProfilePlayerID != ZeroId)
        {
            oEngine.m_oInitialPlayerID = ZeroId;
            oEngine.m_oProfilePlayerID = ZeroId;
            if (OnlineSubsystem.GetComponentLogin().IsSignedIn())
            {
                OnlineSubsystem.GetComponentLogin().Cancel();
            }
            oEngine.bMPTransitionToEntryMenu = TRUE;
            GetLocalPlayerController().ClientTravel("EntryMenu", 0);
        }
    }
    
    stop;
};
state TravelToMainMenu extends GameEntryState 
{
    public function OS_OnTick(SFXOnlineEvent oEvent)
    {
        if (IsInMainMenu())
        {
            GotoState('BlazeLoginFlow', , , );
        }
    }
    public function BeginState(Name PreviousState)
    {
        local SFXGUIMovie oMovie;
        
        Super.BeginState(PreviousState);
        if (IsInMainMenu())
        {
            if (m_LoginUIState != SFXOnlineUIState.SFXONLINE_UISTATE_NUCLEUS_CONNECTING && m_LoginUIState != SFXOnlineUIState.SFXONLINE_UISTATE_CERBERUS_CONNECTING)
            {
                oMovie = GetMainMenuMovie();
                if (oMovie != None)
                {
                    SFXGUI_MainMenu_RTT(oMovie).InternalConnect();
                }
            }
            GotoState('BlazeLoginFlow', , , );
        }
        else if (IsInSplash())
        {
            oMovie = GetMovie('Splash');
            if (oMovie != None)
            {
                SFXGUI_SplashScreen(oMovie).AdvanceScreen();
            }
        }
        else
        {
            OpenMainMenu();
        }
    }
    
    stop;
};
state StartLobbyKismetEvent extends GameEntryState 
{
    public function OS_OnTick(SFXOnlineEvent oEvent)
    {
        if (CurrentKismetEventTicksDelay-- <= 0)
        {
            ClearMainMenuFlow(TRUE);
        }
    }
    public function BeginState(Name PreviousState)
    {
        local SeqEvent_RemoteEvent reStartLobby;
        local BioWorldInfo World;
        
        Super.BeginState(PreviousState);
        reStartLobby = Class'SeqEvent_RemoteEvent'.static.FindRemoteEvent(Name("re_StartLobby "));
        if (reStartLobby != None)
        {
            World = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
            reStartLobby.CheckActivate(World, World);
            CurrentKismetEventTicksDelay = KismetEventTicksDelay;
        }
        else
        {
            ClearMainMenuFlow(TRUE);
        }
    }
    
    stop;
};
state WaitForDLCMounting extends GameEntryState 
{
    private final function CheckDLCMountingState()
    {
        local SFXGUI_MainMenu_RTT mainMenuMovie;
        
        mainMenuMovie = SFXGUI_MainMenu_RTT(GetMainMenuMovie());
        if (mainMenuMovie != None && !mainMenuMovie.IsEnumeratingDownloadableContent())
        {
            if (mainMenuMovie.bDisplayingDLCErrorMessage)
            {
                ClearMainMenuFlow(FALSE);
            }
            else
            {
                GotoState('StartLobbyKismetEvent', , , );
            }
        }
    }
    public event function OS_OnTick(SFXOnlineEvent oEvent)
    {
        CheckDLCMountingState();
    }
    public function BeginState(Name PreviousState)
    {
        Super.BeginState(PreviousState);
        CheckDLCMountingState();
    }
    
    stop;
};
state BlazeLoginFlow extends GameEntryState 
{
    public event function SetLoginState(SFXOnlineUIState loginState)
    {
        Super.SetLoginState(loginState);
        if (m_LoginUIState != SFXOnlineUIState.SFXONLINE_UISTATE_NUCLEUS_CONNECTING && m_LoginUIState != SFXOnlineUIState.SFXONLINE_UISTATE_CERBERUS_CONNECTING)
        {
            if (loginState == SFXOnlineUIState.SFXONLINE_UISTATE_CERBERUS_CONNECTED)
            {
                GotoState('WaitForDLCMounting', , , );
            }
            else
            {
                ClearMainMenuFlow(FALSE);
            }
        }
    }
    public function BeginState(Name PreviousState)
    {
        local SFXGUIMovie mainMenuMovie;
        
        Super.BeginState(PreviousState);
        if (m_LoginUIState == SFXOnlineUIState.SFXONLINE_UISTATE_CERBERUS_CONNECTED)
        {
            GotoState('WaitForDLCMounting', , , );
        }
        else if (m_LoginUIState != SFXOnlineUIState.SFXONLINE_UISTATE_NUCLEUS_CONNECTING && m_LoginUIState != SFXOnlineUIState.SFXONLINE_UISTATE_CERBERUS_CONNECTING)
        {
            mainMenuMovie = GetMainMenuMovie();
            if (mainMenuMovie == None)
            {
                GotoState('Inactive', , , );
            }
        }
    }
    
    stop;
};
auto state Inactive extends GameEntryState 
{
    public function BeginState(Name PreviousState)
    {
        Super.BeginState(PreviousState);
        m_FlowType = MPFlowType.MPF_Inactive;
    }
    
    stop;
};
state GameEntryState 
{
    public function OS_OnTick(SFXOnlineEvent oEvent);
    
    public function BeginState(Name PreviousState)
    {
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PopupName = 'GameEntryFlowPopup'
    srJoiningGame = $633386
    srConnecting = $344567
    srInvalidControllerJoin = $633387
    srMultiplayerUpdate = $641919
    srDownloadRequiredDataError = $700029
    srOK = $152938
    srCancel = $168246
    srAlreadyConnected = $706058
    srOnlinePassRequired = $719988
    KismetEventTicksDelay = 2
    EventSubscriberTable = ({EventCallback = 'OS_OnTick', EventType = SFXOnlineEventType.SFXONLINE_EVENT_TICK}
                           )
}