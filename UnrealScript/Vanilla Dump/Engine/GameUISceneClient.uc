Class GameUISceneClient extends UISceneClient within UIInteraction
    native
    transient
    config(UI);

var const transient Double DoubleClickStartTime;
var const transient native Map_Mirror InitialPressedKeys;
var const transient array<UIScene> ActiveScenes;
var transient array<UIAnimationSeq> AnimSequencePool;
var const transient array<Name> NavAliases;
var const transient array<Name> AxisInputKeys;
var transient Class<UIMessageBoxBase> MessageBoxClass;
var const transient Texture DefaultUITexture[3];
var const transient IntPoint DoubleClickStartPosition;
var const transient UITexture CurrentMouseCursor;
var const transient float LatestDeltaTime;
var config float OverlaySceneAlphaModulation;
var const transient UIScreenObject DebugTarget;
var const transient bool bRenderCursor;
var const transient bool bUpdateInputProcessingStatus;
var const transient bool bUpdateCursorRenderStatus;
var transient bool bUpdateSceneViewportSizes;
var config bool bEnableDebugInput;
var config bool bRenderDebugInfo;
var globalconfig bool bRenderDebugInfoAtTop;
var globalconfig bool bRenderActiveControlInfo;
var globalconfig bool bRenderFocusedControlInfo;
var globalconfig bool bRenderTargetControlInfo;
var globalconfig bool bSelectVisibleTargetsOnly;
var globalconfig bool bInteractiveMode;
var globalconfig bool bDisplayFullPaths;
var globalconfig bool bShowWidgetPath;
var globalconfig bool bShowRenderBounds;
var globalconfig bool bShowCurrentState;
var globalconfig bool bShowMousePos;
var config bool bRestrictActiveControlToFocusedScene;
var const config bool bCaptureUnprocessedInput;
var const config bool bSynchronizePlayers;
var transient bool bKillRestoreMenuProgression;
var(ZDebug) transient bool bDebugResolveScene;
var(ZDebug) transient bool bBlockSceneUpdates;
var(ZDebug) transient bool bBlockUpdatesAfterStackModification;

public final iterator native function AllActiveScenes(Class<UIScene> SceneClass, out UIScene OutScene, optional bool bIterateBackwards, optional int StartingIndex = -1, optional int SceneFilterMask = -1);

public event function bool CanShowToolTips()
{
    if (Outer.bDisableToolTips)
    {
        return FALSE;
    }
    return TRUE;
}
public final native function bool CanUnpauseInternalUI();

public final native function coerce UIScene CreateScene(Class<UIScene> SceneClass, optional Name SceneTag, optional UIScene SceneTemplate);

public final native function coerce UIObject CreateTransientWidget(Class<UIObject> WidgetClass, Name WidgetTag, optional UIObject Owner);

public final native function UIScene FindSceneByTag(Name SceneTag, optional LocalPlayer SceneOwner);

public final native function int FindSceneIndex(const UIScene SceneToFind);

public final native function int FindSceneIndexByTag(Name SceneTag, optional LocalPlayer SceneOwner);

public final native function UIAnimationSeq FindUIAnimation(Name NameOfSequence);

public final native function UIScene GetActiveScene(optional LocalPlayer MatchingPlayerOwner, optional bool bIgnoreUnfocusedScenes);

public final native function int GetActiveSceneCount(optional LocalPlayer MatchingPlayerOwner, optional bool bIgnoreUnfocusedScenes);

public static final native function ENetMode GetCurrentNetMode();

public final native function UIScene GetNextScene(const UIScene SourceScene, optional bool bRequireMatchingPlayerOwner = TRUE, optional bool bIgnoreUnfocusedScenes);

public final native function UIScene GetNextSceneFromIndex(int StartingSceneIndex, optional LocalPlayer MatchingPlayerOwner, optional bool bIgnoreUnfocusedScenes);

public final native function UIScene GetPreviousInputProcessingScene(const UIScene SourceScene, optional bool bIgnoreUnfocusedScenes = TRUE);

public final native function UIScene GetPreviousScene(const UIScene SourceScene, optional bool bRequireMatchingPlayerOwner = TRUE, optional bool bIgnoreUnfocusedScenes);

public final native function UIScene GetPreviousSceneFromIndex(int StartingSceneIndex, optional LocalPlayer MatchingPlayerOwner, optional bool bIgnoreUnfocusedScenes);

public final native function UIScene GetSceneAtIndex(int SceneIndex);

public final native function UIScene GetTransientScene();

public event function InitializeSceneClient()
{
    local OnlineSubsystem OnlineSub;
    
    Super.InitializeSceneClient();
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        if (OnlineSub.SystemInterface != None)
        {
            OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(NotifyOnlineServiceStatusChanged);
            OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(NotifyLinkStatusChanged);
            OnlineSub.SystemInterface.AddControllerChangeDelegate(NotifyControllerChanged);
            OnlineSub.SystemInterface.AddStorageDeviceChangeDelegate(NotifyStorageDeviceChanged);
        }
        if (OnlineSub.PlayerInterface != None)
        {
            OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        }
    }
}
public function NotifyGameSessionEnded()
{
    local int i;
    local array<UIScene> CurrentlyActiveScenes;
    
    SaveMenuProgression();
    CurrentlyActiveScenes = ActiveScenes;
    for (i = CurrentlyActiveScenes.Length - 1; i >= 0; i--)
    {
        if (CurrentlyActiveScenes[i] != None)
        {
            CurrentlyActiveScenes[i].NotifyGameSessionEnded();
            continue;
        }
        CurrentlyActiveScenes.Remove(i, 1);
    }
    for (i = CurrentlyActiveScenes.Length - 1; i >= 0; i--)
    {
        if (CurrentlyActiveScenes[i].bCloseOnLevelChange)
        {
            CurrentlyActiveScenes[i].CloseScene(CurrentlyActiveScenes[i], TRUE, TRUE);
        }
    }
}
public function OnLoginChange(byte ControllerId)
{
    local UIScene Scene;
    local ELoginStatus Status;
    
    Status = Outer.GetLoginStatus(int(ControllerId));
    Scene = GetActiveScene();
    if (Scene != None)
    {
        Scene.NotifyLoginStatusChanged(int(ControllerId), Status);
    }
}
public event function PauseGame(bool bDesiredPauseState, optional int PlayerIndex = 0)
{
    local PlayerController PlayerOwner;
    
    if (Outer.Outer.Outer.GamePlayers.Length > 0)
    {
        PlayerIndex = Clamp(PlayerIndex, 0, Outer.Outer.Outer.GamePlayers.Length - 1);
        PlayerOwner = Outer.Outer.Outer.GamePlayers[PlayerIndex].Actor;
        if (PlayerOwner != None)
        {
            PlayerOwner.SetPause(bDesiredPauseState, CanUnpauseInternalUI);
        }
    }
}
public final native function RequestCursorRenderUpdate();

public final native function RequestInputProcessingUpdate();

public native function bool SetActiveControl(UIObject NewActiveControl);

public event function SynchronizePlayers(optional int MaxPlayersAllowed = 4, optional bool bAllowJoins = TRUE, optional bool bAllowRemoval = TRUE)
{
    local int PlayerIndex;
    local int ControllerId;
    local string ErrorString;
    local LocalPlayer PlayerRef;
    
    if (IsAllowedToModifyPlayerCount())
    {
        for (ControllerId = 0; ControllerId < 4; ControllerId++)
        {
            PlayerIndex = Outer.GetPlayerIndex(ControllerId);
            if (Outer.IsGamepadConnected(ControllerId))
            {
                if (PlayerIndex == -1 && bAllowJoins)
                {
                    if (Outer.Outer.Outer.GamePlayers.Length < MaxPlayersAllowed)
                    {
                        PlayerRef = Outer.Outer.CreatePlayer(ControllerId, ErrorString, TRUE);
                    }
                }
                continue;
            }
            if (PlayerIndex != -1 && bAllowRemoval && !Outer.IsLoggedIn(ControllerId))
            {
                PlayerRef = Outer.Outer.Outer.GamePlayers[PlayerIndex];
                if (Outer.Outer.Outer.GamePlayers.Length > 1)
                {
                    if (!Outer.Outer.RemovePlayer(PlayerRef))
                    {
                    }
                    continue;
                }
            }
        }
        while (Outer.Outer.Outer.GamePlayers.Length > Max(1, MaxPlayersAllowed))
        {
            PlayerRef = Outer.Outer.Outer.GamePlayers[PlayerIndex];
            if (!Outer.Outer.RemovePlayer(PlayerRef))
            {
            }
        }
    }
}
public function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
    local int SceneIndex;
    local array<UIScene> CurrentScenes;
    
    CurrentScenes = ActiveScenes;
    for (SceneIndex = 0; SceneIndex < CurrentScenes.Length; SceneIndex++)
    {
        CurrentScenes[SceneIndex].NotifyPlayerAdded(PlayerIndex, AddedPlayer);
    }
    if (IsUIActive(2))
    {
        RequestInputProcessingUpdate();
    }
}
public function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
    local int SceneIndex;
    local array<UIScene> CurrentScenes;
    
    CurrentScenes = ActiveScenes;
    for (SceneIndex = 0; SceneIndex < CurrentScenes.Length; SceneIndex++)
    {
        CurrentScenes[SceneIndex].NotifyPlayerRemoved(PlayerIndex, RemovedPlayer);
    }
    if (IsUIActive(2))
    {
        RequestInputProcessingUpdate();
    }
}
public exec function ShowDockingStacks()
{
    local int i;
    
    for (i = 0; i < ActiveScenes.Length; i++)
    {
        ActiveScenes[i].LogDockingStack();
    }
}
public function ClearMenuProgression()
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry RegistryDS;
    local UIDynamicFieldProvider RegistryProvider;
    
    DSClient = Class'UIInteraction'.static.GetDataStoreClient();
    if (DSClient != None)
    {
        RegistryDS = UIDataStore_Registry(DSClient.FindDataStore('Registry'));
        if (RegistryDS != None)
        {
            RegistryProvider = RegistryDS.GetDataProvider();
            if (RegistryProvider != None)
            {
                RegistryProvider.ClearCollectionValueArray('MenuProgression');
            }
        }
    }
}
public static final function bool ClearUIMessageScene(Name SceneTag, optional LocalPlayer ScenePlayerOwner, optional bool bCloseChildScenes = FALSE)
{
    local GameUISceneClient GameSceneClient;
    local UIScene ExistingScene;
    local bool bResult;
    
    GameSceneClient = Class'UIRoot'.static.GetSceneClient();
    if (GameSceneClient != None)
    {
        ExistingScene = GameSceneClient.FindSceneByTag(SceneTag, ScenePlayerOwner);
        if (ExistingScene != None)
        {
            bResult = ExistingScene.CloseScene(ExistingScene, bCloseChildScenes, TRUE);
        }
    }
    return bResult;
}
public exec function CloseMenu(optional Name SceneName);

public exec function CreateMenu(Class<UIScene> SceneClass, optional int PlayerIndex = -1);

public static function UIMessageBoxBase CreateUIMessageBox(Name SceneTag, optional Class<UIMessageBoxBase> CustomMessageBoxClass = default.MessageBoxClass, optional UIMessageBoxBase SceneTemplate)
{
    local UIMessageBoxBase Result;
    local GameUISceneClient GameSceneClient;
    
    if (SceneTag != 'None')
    {
        GameSceneClient = Class'UIRoot'.static.GetSceneClient();
        if (GameSceneClient != None)
        {
            Result = GameSceneClient.CreateScene(CustomMessageBoxClass, SceneTag, SceneTemplate);
        }
    }
    return Result;
}
public function bool DebugMessageOptionSelected(UIMessageBoxBase Sender, Name SelectedInputAlias, int PlayerIndex);

public exec function DebugShowMessage(string Message, optional string Aliases = "GenericCancel,GenericAccept", optional string Title, optional string Question);

public function bool IsAllowedToModifyPlayerCount()
{
    return bSynchronizePlayers;
}
public function NotifyClientTravel(PlayerController TravellingPlayer, string TravelURL, ETravelType TravelType, bool bIsSeamlessTravel)
{
    local int SceneIndex;
    local array<UIScene> CurrentlyActiveScenes;
    local UIScene NextScene;
    local LocalPlayer TravellingLP;
    
    if (TravellingPlayer != None)
    {
        TravellingLP = LocalPlayer(TravellingPlayer.Player);
    }
    CurrentlyActiveScenes = ActiveScenes;
    for (SceneIndex = CurrentlyActiveScenes.Length - 1; SceneIndex >= 0; SceneIndex--)
    {
        NextScene = CurrentlyActiveScenes[SceneIndex];
        if (NextScene != None && (NextScene.PlayerOwner == TravellingLP || NextScene.PlayerOwner == None))
        {
            NextScene.NotifyPreClientTravel(TravelURL, TravelType, bIsSeamlessTravel);
        }
    }
}
public function NotifyControllerChanged(int ControllerId, bool bConnected)
{
    local UIScene Scene;
    
    Scene = GetActiveScene();
    if (Scene != None)
    {
        Scene.NotifyControllerStatusChanged(ControllerId, bConnected);
    }
}
public function NotifyLinkStatusChanged(bool bConnected)
{
    local UIScene Scene;
    
    Scene = GetActiveScene();
    if (Scene != None)
    {
        Scene.NotifyLinkStatusChanged(bConnected);
    }
}
public function NotifyOnlineServiceStatusChanged(EOnlineServerConnectionStatus NewConnectionStatus)
{
    local UIScene Scene;
    
    Scene = GetActiveScene();
    if (Scene != None)
    {
        Scene.NotifyOnlineServiceStatusChanged(NewConnectionStatus);
    }
}
public function NotifyStorageDeviceChanged()
{
    local UIScene Scene;
    
    Scene = GetActiveScene();
    if (Scene != None)
    {
        Scene.NotifyStorageDeviceChanged();
    }
}
public exec function OpenMenu(string MenuPath, optional int PlayerIndex = -1);

public exec function RefreshFormatting();

public function RestoreMenuProgression(optional UIScene BaseScene)
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry RegistryDS;
    local UIDynamicFieldProvider RegistryProvider;
    local UIScene CurrentScene;
    local UIScene NextSceneTemplate;
    local UIScene SceneInstance;
    local string ScenePathName;
    local bool bHasValidNetworkConnection;
    local LocalPlayer PlayerOwner;
    
    bKillRestoreMenuProgression = FALSE;
    if (Class'WorldInfo'.static.IsMenuLevel())
    {
        if (BaseScene == None && IsUIActive())
        {
            BaseScene = ActiveScenes[ActiveScenes.Length - 1];
        }
        if (BaseScene != None)
        {
            DSClient = Class'UIInteraction'.static.GetDataStoreClient();
            if (DSClient != None)
            {
                RegistryDS = UIDataStore_Registry(DSClient.FindDataStore('Registry'));
                if (RegistryDS != None)
                {
                    RegistryProvider = RegistryDS.GetDataProvider();
                    if (RegistryProvider != None)
                    {
                        bHasValidNetworkConnection = Class'UIInteraction'.static.HasLinkConnection();
                        PlayerOwner = Outer.Outer.Outer.GamePlayers[0];
                        CurrentScene = BaseScene;
                        while (CurrentScene != None && !bKillRestoreMenuProgression)
                        {
                            ScenePathName = "";
                            if (RegistryProvider.GetCollectionValue('MenuProgression', 0, ScenePathName, FALSE, CurrentScene.SceneTag))
                            {
                                if (ScenePathName != "")
                                {
                                    NextSceneTemplate = UIScene(DynamicLoadObject(ScenePathName, Class'UIScene'));
                                    if (NextSceneTemplate != None)
                                    {
                                        if (NextSceneTemplate.bRequiresNetwork && !bHasValidNetworkConnection)
                                        {
                                            break;
                                        }
                                        SceneInstance = CurrentScene.OpenScene(NextSceneTemplate, PlayerOwner, , TRUE);
                                        if (SceneInstance != None)
                                        {
                                            CurrentScene = SceneInstance;
                                        }
                                        else
                                        {
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        break;
                                    }
                                }
                                else
                                {
                                    break;
                                }
                                continue;
                            }
                            break;
                        }
                        RegistryProvider.ClearCollectionValueArray('MenuProgression');
                    }
                }
            }
        }
    }
}
public function SaveMenuProgression()
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry RegistryDS;
    local UIDynamicFieldProvider RegistryProvider;
    local int i;
    local UIScene SceneResource;
    local UIScene CurrentScene;
    local UIScene NextScene;
    local string ScenePathName;
    
    if (Class'WorldInfo'.static.IsMenuLevel())
    {
        DSClient = Class'UIInteraction'.static.GetDataStoreClient();
        if (DSClient != None)
        {
            RegistryDS = UIDataStore_Registry(DSClient.FindDataStore('Registry'));
            if (RegistryDS != None)
            {
                RegistryProvider = RegistryDS.GetDataProvider();
                if (RegistryProvider != None)
                {
                    RegistryProvider.ClearCollectionValueArray('MenuProgression');
                    for (i = 0; i < ActiveScenes.Length - 1; i++)
                    {
                        CurrentScene = ActiveScenes[i];
                        NextScene = ActiveScenes[i + 1];
                        if (CurrentScene != None && NextScene != None && CurrentScene != NextScene)
                        {
                            if (NextScene.bMenuLevelRestoresScene)
                            {
                                SceneResource = UIScene(NextScene.ObjectArchetype);
                                if (SceneResource != None)
                                {
                                    ScenePathName = PathName(SceneResource);
                                    if (RegistryProvider.InsertCollectionValue('MenuProgression', ScenePathName, -1, FALSE, FALSE, CurrentScene.SceneTag))
                                    {
                                        continue;
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
public exec function ShowDataStoreField(string DataStoreMarkup);

public exec function ShowDataStores(optional bool bVerbose);

public exec function ShowMenuProgression()
{
    local DataStoreClient DSClient;
    local UIDataStore_Registry RegistryDS;
    local UIDynamicFieldProvider RegistryProvider;
    local array<string> Values;
    local array<Name> SceneTags;
    local int SceneIndex;
    local int MenuIndex;
    
    DSClient = Class'UIInteraction'.static.GetDataStoreClient();
    if (DSClient != None)
    {
        RegistryDS = UIDataStore_Registry(DSClient.FindDataStore('Registry'));
        if (RegistryDS != None)
        {
            RegistryProvider = RegistryDS.GetDataProvider();
            if (RegistryProvider != None)
            {
                if (RegistryProvider.GetCollectionValueSchema('MenuProgression', SceneTags))
                {
                    for (SceneIndex = 0; SceneIndex < SceneTags.Length; SceneIndex++)
                    {
                        if (RegistryProvider.GetCollectionValueArray('MenuProgression', Values, FALSE, SceneTags[SceneIndex]))
                        {
                            for (MenuIndex = 0; MenuIndex < Values.Length; MenuIndex++)
                            {
                            }
                            continue;
                        }
                    }
                }
            }
        }
    }
}
public exec function ShowMenuStates()
{
    local int i;
    
    for (i = 0; i < ActiveScenes.Length; i++)
    {
        ActiveScenes[i].LogCurrentState(0);
    }
}
public exec function ShowRenderBounds()
{
    local int i;
    
    for (i = 0; i < ActiveScenes.Length; i++)
    {
        ActiveScenes[i].LogRenderBounds(0);
    }
}
public static function bool ShowUIMessage(Name SceneTag, string Title, string Message, string Question, array<Name> ButtonAliases, delegate<UIMessageBoxBase.OnOptionSelected> SelectionCallback, optional LocalPlayer ScenePlayerOwner, optional out UIMessageBoxBase out_CreatedScene, optional byte ForcedPriority)
{
    local UIScene ExistingScene;
    local UIMessageBoxBase messageBox;
    local GameUISceneClient GameSceneClient;
    local bool bResult;
    
    out_CreatedScene = None;
    GameSceneClient = Class'UIRoot'.static.GetSceneClient();
    if (GameSceneClient != None)
    {
        ExistingScene = GameSceneClient.FindSceneByTag(SceneTag, ScenePlayerOwner);
        if (ExistingScene == None)
        {
            messageBox = CreateUIMessageBox(SceneTag);
            if (messageBox != None)
            {
                ExistingScene = messageBox.OpenScene(messageBox, ScenePlayerOwner, ForcedPriority);
                if (ExistingScene != None)
                {
                    messageBox = UIMessageBoxBase(ExistingScene);
                    messageBox.SetupMessageBox(Title, Message, Question, ButtonAliases, SelectionCallback);
                    out_CreatedScene = messageBox;
                    bResult = TRUE;
                }
            }
        }
    }
    return bResult;
}
public exec function ToggleDebugInput(optional bool bEnable = !bEnableDebugInput)
{
    bEnableDebugInput = bEnable;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NavAliases = ('UIKEY_NavFocusUp', 'UIKEY_NavFocusDown', 'UIKEY_NavFocusLeft', 'UIKEY_NavFocusRight')
    AxisInputKeys = ('KEY_Gamepad_LeftStick_Up', 
                     'KEY_Gamepad_LeftStick_Down', 
                     'KEY_Gamepad_LeftStick_Right', 
                     'KEY_Gamepad_LeftStick_Left', 
                     'KEY_Gamepad_RightStick_Up', 
                     'KEY_Gamepad_RightStick_Down', 
                     'KEY_Gamepad_RightStick_Right', 
                     'KEY_Gamepad_RightStick_Left', 
                     'KEY_SIXAXIS_AccelX', 
                     'KEY_SIXAXIS_AccelY', 
                     'KEY_SIXAXIS_AccelZ', 
                     'KEY_SIXAXIS_Gyro', 
                     'KEY_XboxTypeS_LeftX', 
                     'KEY_XboxTypeS_LeftY', 
                     'KEY_XboxTypeS_RightX', 
                     'KEY_XboxTypeS_RightY'
                    )
    MessageBoxClass = Class'UIMessageBox'
    DefaultUITexture[0] = Texture2D'EngineResources.WhiteSquareTexture'
    DefaultUITexture[1] = Texture2D'EngineResources.Black'
    DefaultUITexture[2] = Texture2D'EngineResources.Gray'
    OverlaySceneAlphaModulation = 0.449999988
    bEnableDebugInput = TRUE
    bRenderDebugInfoAtTop = TRUE
    bRenderActiveControlInfo = TRUE
    bRenderFocusedControlInfo = TRUE
    bRenderTargetControlInfo = TRUE
    bSelectVisibleTargetsOnly = TRUE
    bDisplayFullPaths = TRUE
    bShowWidgetPath = TRUE
    bShowRenderBounds = TRUE
    bShowCurrentState = TRUE
    bShowMousePos = TRUE
    bRestrictActiveControlToFocusedScene = TRUE
    bCaptureUnprocessedInput = TRUE
}