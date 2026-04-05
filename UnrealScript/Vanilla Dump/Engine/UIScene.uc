Class UIScene extends UIScreenObject
    native
    placeable
    config(UI);

var const transient native Map_Mirror InputSubscriptions[4];
var const transient PostProcessSettings CurrentBackgroundSettings;
var const transient PostProcessSettings CurrentForegroundSettings;
var const transient native array<UIDockingNode> DockingStack;
var const transient array<UIObject> RenderStack;
var const transient array<UITickableObject> TickableObjects;
var transient array<UIScreenObject> AnimatingObjects;
var delegate<GetSceneInputModeOverride> __GetSceneInputModeOverride__Delegate;
var delegate<OnInterceptRawInputKey> __OnInterceptRawInputKey__Delegate;
var delegate<OnSceneActivated> __OnSceneActivated__Delegate;
var delegate<OnSceneDeactivated> __OnSceneDeactivated__Delegate;
var delegate<OnQueryCloseSceneAllowed> __OnQueryCloseSceneAllowed__Delegate;
var delegate<OnTopSceneChanged> __OnTopSceneChanged__Delegate;
var delegate<ShouldModulateBackgroundAlpha> __ShouldModulateBackgroundAlpha__Delegate;
var delegate<OnQueryBeginAnimation_DisableInput> __OnQueryBeginAnimation_DisableInput__Delegate;
var delegate<OnQueryEndAnimation_EnableInput> __OnQueryEndAnimation_EnableInput__Delegate;
var(Controls) const Class<UIContextMenu> DefaultContextMenuClass;
var(UIScene) editconst Name SceneTag;
var Vector2D CurrentViewportSize;
var(Animation) Name SceneAnimation_Open;
var(Animation) Name SceneAnimation_Close;
var(Animation) Name SceneAnimation_LoseFocus;
var(Animation) Name SceneAnimation_RegainingFocus;
var(Animation) Name SceneAnimation_RegainedFocus;
var(Sound) Name SceneOpenedCue;
var(Sound) Name SceneClosedCue;
var const transient UISceneClient SceneClient;
var const transient LocalPlayer PlayerOwner;
var const transient UIContextMenu ActiveContextMenu;
var const transient UIContextMenu StandardContextMenu;
var(Style) const editinlineuse UISkin SceneSkin;
var const transient UISafeRegionPanel PrimarySafeRegionPanel;
var transient int LastPlayerIndex;
var transient int UpdateSceneFeedbackLoopCount;
var(UIScene) int SceneStackPriority;
var(PostProcess) PostProcessChain UIPostProcessForeground;
var(PostProcess) PostProcessChain UIPostProcessBackground;
var const export SceneDataStore SceneData;
var const transient bool bUpdateDockingStack;
var const transient bool bUpdateScenePositions;
var const transient bool bUpdateNavigationLinks;
var const transient bool bUpdatePrimitiveUsage;
var const transient bool bRefreshWidgetStyles;
var const transient bool bRefreshStringFormatting;
var const transient bool bRecalculateInputMask;
var const transient bool bPerformedInitialUpdate;
var const transient bool bResolvingScenePositions;
var const transient bool bUsesPrimitives;
var const transient bool bSupportsNavigation;
var const transient bool bReevaluateRotationSupport;
var const transient bool bSupportsRotation;
var(Flags) bool bDisplayCursor;
var(Flags) bool bRenderParentScenes;
var(Flags) bool bAlwaysRenderScene;
var(Flags) bool bPauseGameWhileActive;
var(Flags) bool bExemptFromAutoClose;
var(Flags) bool bCloseOnLevelChange;
var(Flags) bool bSaveSceneValuesOnClose;
var(PostProcess) bool bEnableScenePostProcessing;
var(Flags) bool bEnableSceneDepthTesting;
var(Flags) bool bRequiresNetwork;
var(Flags) bool bRequiresOnlineService;
var(Flags) bool bMenuLevelRestoresScene;
var(Flags) bool bFlushPlayerInput;
var(Flags) bool bCaptureMatchedInput;
var(Flags) bool bDisableWorldRendering;
var transient bool bAnimationBlockingInput;
var transient byte PlayerInputMask;
var(Interaction) EScreenInputMode SceneInputMode;
var(Interaction) ESplitscreenRenderMode SceneRenderMode;
var(PostProcess) EUIPostProcessGroup ScenePostProcessGroup;

public event function AddedChild(UIScreenObject WidgetOwner, UIObject NewChild)
{
    Super.AddedChild(WidgetOwner, NewChild);
    NewChild.SetInputMask(PlayerInputMask, TRUE);
    if (int(GetSceneInputMode()) == 2 && int(NewChild.GetInputMask(FALSE, TRUE)) != 0)
    {
        RequestSceneInputMaskUpdate();
    }
}
public final event function CalculateInputMask()
{
    local int ActivePlayers;
    local int ChildIndex;
    local GameUISceneClient GameSceneClient;
    local byte PlayerIndex;
    local byte NewMask;
    local byte TestMask;
    local byte SceneMask;
    local EScreenInputMode InputMode;
    local array<UIObject> SceneChildren;
    
    NewMask = GetInputMask();
    GameSceneClient = GameUISceneClient(SceneClient);
    if (GameSceneClient != None)
    {
        InputMode = GetSceneInputMode();
        switch (InputMode)
        {
            case EScreenInputMode.INPUTMODE_Locked:
            case EScreenInputMode.INPUTMODE_MatchingOnly:
            case EScreenInputMode.INPUTMODE_Selective:
                if (PlayerOwner == None)
                {
                    NewMask = 0;
                    ActivePlayers = GetActivePlayerCount();
                    for (PlayerIndex = 0; int(PlayerIndex) < ActivePlayers; PlayerIndex++)
                    {
                        NewMask = byte(int(NewMask) | 1 << int(PlayerIndex));
                    }
                }
                else
                {
                    PlayerIndex = byte(GameSceneClient.Outer.Outer.Outer.GamePlayers.Find(PlayerOwner));
                    if (int(PlayerIndex) == -1)
                    {
                        NewMask = 15;
                    }
                    else
                    {
                        NewMask = byte(1 << int(PlayerIndex));
                        if (InputMode == EScreenInputMode.INPUTMODE_Selective)
                        {
                            SceneMask = NewMask;
                            SceneChildren = GetChildren(TRUE);
                            for (ChildIndex = 0; ChildIndex < SceneChildren.Length; ChildIndex++)
                            {
                                TestMask = SceneChildren[ChildIndex].GetInputMask(FALSE, TRUE);
                                SceneMask = byte(int(SceneMask) | int(TestMask));
                            }
                        }
                    }
                }
                break;
            case EScreenInputMode.INPUTMODE_Free:
            case EScreenInputMode.INPUTMODE_ActiveOnly:
                NewMask = 15;
                break;
            case EScreenInputMode.INPUTMODE_Simultaneous:
                NewMask = 0;
                ActivePlayers = GetActivePlayerCount();
                for (PlayerIndex = 0; int(PlayerIndex) < ActivePlayers; PlayerIndex++)
                {
                    NewMask = byte(int(NewMask) | 1 << int(PlayerIndex));
                }
                break;
            case EScreenInputMode.INPUTMODE_None:
                NewMask = 0;
                break;
            default:
                break;
        }
    }
    SetInputMask(NewMask, TRUE);
    SetInputMask(byte(int(NewMask) | int(SceneMask)), FALSE, TRUE);
}
public event function bool CloseScene(optional UIScene SceneToClose = Self, optional bool bCloseChildScenes = TRUE, optional bool bForceCloseImmediately)
{
    local GameUISceneClient GameSceneClient;
    local int SceneIndex;
    local UIScene NextSceneInStack;
    local bool bResult;
    
    if (SceneClient != None && SceneToClose != None)
    {
        if (bForceCloseImmediately || !SceneToClose.BeginSceneCloseAnimation(bCloseChildScenes))
        {
            bResult = SceneClient.CloseScene(SceneToClose, bCloseChildScenes, bForceCloseImmediately);
        }
        else
        {
            GameSceneClient = GetSceneClient();
            if (GameSceneClient != None && bCloseChildScenes)
            {
                SceneIndex = GameSceneClient.FindSceneIndex(SceneToClose);
                if (SceneIndex != -1)
                {
                    NextSceneInStack = GameSceneClient.GetNextSceneFromIndex(SceneIndex, SceneToClose.PlayerOwner, TRUE);
                    while (NextSceneInStack != None && NextSceneInStack.SceneStackPriority <= SceneToClose.SceneStackPriority)
                    {
                        if (!NextSceneInStack.bExemptFromAutoClose)
                        {
                            CloseScene(NextSceneInStack, FALSE, TRUE);
                        }
                        NextSceneInStack = GameSceneClient.GetNextSceneFromIndex(SceneIndex, SceneToClose.PlayerOwner, TRUE);
                    }
                }
            }
            bResult = TRUE;
        }
    }
    return bResult;
}
public final native function int FindTickableObjectIndex(UITickableObject ObjectToFind);

public final native function ForceImmediateSceneUpdate();

public final native function UIContextMenu GetActiveContextMenu();

public final native function UIContextMenu GetDefaultContextMenu();

public event function UIObject GetFocusHint(optional bool bQueryOnly);

public final native function UIScene GetNextScene(optional bool bRequireMatchingPlayerOwner = TRUE, optional bool bIgnoreUnfocusedScenes);

public final native function UIScene GetPreviousScene(optional bool bRequireMatchingPlayerOwner = TRUE, optional bool bIgnoreUnfocusedScenes);

public final native function SceneDataStore GetSceneDataStore();

public final native function EScreenInputMode GetSceneInputMode(optional bool bMemberValueOnly);

public delegate function EScreenInputMode GetSceneInputModeOverride();

public final native function EUIPostProcessGroup GetScenePostProcessGroup();

public final native function ESplitscreenRenderMode GetSceneRenderMode();

public static native function WorldInfo GetWorldInfo();

public final native function bool IsSceneActive(optional bool bTopmostScene);

public final native function LoadSceneDataValues();

public final native function LogDockingStack();

public function NotifyGameSessionEnded()
{
    if (bCloseOnLevelChange && SceneClient != None)
    {
        CloseScene(Self, TRUE, TRUE);
    }
}
public delegate function bool OnInterceptRawInputKey(const out InputEventParameters EventParms);

public delegate function bool OnQueryBeginAnimation_DisableInput(Name AnimationSequenceName, int TrackTypeMask)
{
    local bool bResult;
    
    if (TrackTypeMask == 0)
    {
        bResult = bAnimating && AnimationSequenceName != 'None';
    }
    return bResult;
}
public delegate function bool OnQueryCloseSceneAllowed(UIScene SceneToDeactivate, bool bCloseChildScenes, bool bForcedClose);

public delegate function bool OnQueryEndAnimation_EnableInput(Name AnimationSequenceName, int TrackTypeMask)
{
    local bool bResult;
    
    if (TrackTypeMask == 0)
    {
        bResult = !bAnimating && AnimationSequenceName != 'None';
    }
    return bResult;
}
public delegate function OnSceneActivated(UIScene ActivatedScene, bool bInitialActivation);

public delegate function OnSceneDeactivated(UIScene DeactivatedScene);

public delegate function OnTopSceneChanged(UIScene NewTopScene);

public event function UIScene OpenScene(UIScene SceneToOpen, optional LocalPlayer ScenePlayerOwner = GetPlayerOwner(), optional byte ForcedPriority, optional bool bSkipAnimation = FALSE, optional delegate<OnSceneActivated> SceneDelegate = None)
{
    local UIScene ActiveScene;
    local UIScene SceneInstance;
    local GameUISceneClient GameSceneClient;
    
    if (SceneToOpen != None)
    {
        GameSceneClient = GetSceneClient();
        if (GameSceneClient != None)
        {
            GameSceneClient.InitializeScene(SceneToOpen, ScenePlayerOwner, SceneInstance);
            if (SceneInstance != None)
            {
                if (SceneDelegate != None)
                {
                    SceneInstance.__OnSceneActivated__Delegate = SceneDelegate;
                }
                ActiveScene = GameSceneClient.GetActiveScene(ScenePlayerOwner, TRUE);
                if (ActiveScene != None)
                {
                    ActiveScene.StopSceneAnimation(ActiveScene.SceneAnimation_Close);
                }
                if (GameSceneClient.OpenScene(SceneInstance, ScenePlayerOwner, SceneInstance, ForcedPriority))
                {
                    if (ScenePlayerOwner != SceneInstance.PlayerOwner)
                    {
                        ActiveScene = GameSceneClient.GetActiveScene(SceneInstance.PlayerOwner);
                        if (ActiveScene != None && ActiveScene == SceneInstance)
                        {
                            ActiveScene = ActiveScene.GetPreviousScene(TRUE, TRUE);
                        }
                        ScenePlayerOwner = SceneInstance.PlayerOwner;
                    }
                    if (bSkipAnimation)
                    {
                        if (ActiveScene != None)
                        {
                            ActiveScene.StopSceneAnimation(ActiveScene.SceneAnimation_LoseFocus);
                        }
                        if (SceneInstance != None)
                        {
                            SceneInstance.StopSceneAnimation(SceneInstance.SceneAnimation_Open);
                        }
                    }
                    else if (ActiveScene != None)
                    {
                        if (ActiveScene != GameSceneClient.GetActiveScene(ScenePlayerOwner, TRUE))
                        {
                            ActiveScene.StopSceneAnimation(ActiveScene.SceneAnimation_Open, FALSE);
                            ActiveScene.BeginSceneLostFocusAnimation();
                        }
                        else
                        {
                            SceneInstance.StopSceneAnimation(ActiveScene.SceneAnimation_Open);
                            SceneInstance.BeginSceneLostFocusAnimation();
                        }
                    }
                }
            }
        }
    }
    return SceneInstance;
}
public final native function RebuildDockingStack();

public final native function bool RegisterTickableObject(UITickableObject ObjectToRegister, optional int InsertIndex = -1);

public event function RemovedChild(UIScreenObject WidgetOwner, UIObject OldChild, optional array<UIObject> ExclusionSet)
{
    local UITickableObject TickableObject;
    
    Super.RemovedChild(WidgetOwner, OldChild, ExclusionSet);
    if (int(GetSceneInputMode()) == 2 && int(OldChild.GetInputMask(FALSE, TRUE)) != 0)
    {
        RequestSceneInputMaskUpdate();
    }
    TickableObject = UITickableObject(OldChild);
    if (TickableObject != None)
    {
        UnregisterTickableObject(TickableObject);
    }
}
public final native function UIDataStore ResolveDataStore(Name DataStoreTag, optional LocalPlayer InPlayerOwner);

public final native function ResolveScenePositions();

public final native function SaveSceneDataValues(optional bool bUnbindSubscribers);

public event function SceneActivated(bool bInitialActivation);

public event function SceneDeactivated();

public final native function bool SetActiveContextMenu(UIContextMenu NewContextMenu, int PlayerIndex);

public final native function SetSceneInputMode(EScreenInputMode NewInputMode);

public final native function SetSceneRenderMode(ESplitscreenRenderMode NewRenderMode);

public event function SetVisibility(bool bIsVisible)
{
    local GameUISceneClient GameSceneClient;
    
    Super.SetVisibility(bIsVisible);
    GameSceneClient = GameUISceneClient(SceneClient);
    if (GameSceneClient != None)
    {
        GameSceneClient.RequestCursorRenderUpdate();
    }
}
public delegate function bool ShouldModulateBackgroundAlpha(out float AlphaModulationPercent);

public final native function bool ShouldRenderParentScenes();

public event function UIAnimationEnded(UIScreenObject Sender, Name AnimName, int TrackTypeMask)
{
    if (Sender != None && !Sender.IsAnimating())
    {
        AnimatingObjects.RemoveItem(Sender);
    }
    Super.UIAnimationEnded(Sender, AnimName, TrackTypeMask);
    if (!IsAnimating())
    {
        AnimatingObjects.RemoveItem(Self);
    }
    if (__OnQueryEndAnimation_EnableInput__Delegate(AnimName, TrackTypeMask))
    {
        bAnimationBlockingInput = FALSE;
    }
}
public event function UIAnimationStarted(UIScreenObject Sender, Name AnimName, int TrackTypeMask, optional bool bSetAnimatingFlag = TRUE)
{
    local int AnimatorIndex;
    local int SequenceIndex;
    local int TrackIndex;
    local int FrameIndex;
    local int PPTrackMask;
    local EUIAnimType TrackType;
    local PostProcessSettings CurrentSettings;
    
    AnimatorIndex = FindAnimatorIndex(Sender);
    if (AnimatorIndex == -1 && Sender != None)
    {
        AnimatingObjects[AnimatingObjects.Length] = Sender;
    }
    Super.UIAnimationStarted(Sender, AnimName, TrackTypeMask, bSetAnimatingFlag);
    PPTrackMask = 14 | 15 | 16;
    if ((TrackTypeMask & PPTrackMask) != 0 && AnimGetCurrentPPSettings(CurrentSettings))
    {
        SequenceIndex = FindAnimationSequenceIndex(AnimName);
        for (TrackIndex = 0; TrackIndex < AnimStack[SequenceIndex].AnimationTracks.Length; TrackIndex++)
        {
            TrackType = AnimStack[SequenceIndex].AnimationTracks[TrackIndex].TrackType;
            if (TrackType == EUIAnimType.EAT_PPBloom || TrackType == EUIAnimType.EAT_PPBlurSampleSize || TrackType == EUIAnimType.EAT_PPBlurAmount)
            {
                for (FrameIndex = 0; FrameIndex < AnimStack[SequenceIndex].AnimationTracks[TrackIndex].KeyFrames.Length; FrameIndex++)
                {
                    if (AnimStack[SequenceIndex].AnimationTracks[TrackIndex].KeyFrames[FrameIndex].RemainingTime == -1.0)
                    {
                        if (TrackType == EUIAnimType.EAT_PPBloom)
                        {
                            AnimStack[SequenceIndex].AnimationTracks[TrackIndex].KeyFrames[FrameIndex].RemainingTime = CurrentSettings.Bloom_InterpolationDuration;
                        }
                        else
                        {
                            AnimStack[SequenceIndex].AnimationTracks[TrackIndex].KeyFrames[FrameIndex].RemainingTime = CurrentSettings.DOF_InterpolationDuration;
                        }
                        break;
                    }
                }
            }
        }
    }
    if (__OnQueryBeginAnimation_DisableInput__Delegate(AnimName, TrackTypeMask))
    {
        bAnimationBlockingInput = TRUE;
    }
}
public final native function UnbindSubscribers();

public final native function bool UnregisterTickableObject(UITickableObject ObjectToRemove);

public function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
    CreatePlayerData(PlayerIndex, AddedPlayer);
}
public function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
    local bool bRemovingPlayerOwner;
    
    bRemovingPlayerOwner = PlayerOwner == RemovedPlayer;
    RemovePlayerData(PlayerIndex, RemovedPlayer);
    if (bRemovingPlayerOwner)
    {
    }
}
public function bool BeginSceneAnimation(Name AnimationSequenceName, optional delegate<OnUIAnim_TrackCompleted> TrackCompletedDelegate)
{
    local bool bResult;
    
    if (AnimationSequenceName != 'None' && !IsEditor())
    {
        if (TrackCompletedDelegate != None)
        {
            Add_UIAnimTrackCompletedHandler(TrackCompletedDelegate);
        }
        PlayUIAnimation(AnimationSequenceName);
        bResult = TRUE;
    }
    return bResult;
}
public function bool BeginSceneCloseAnimation(bool bCloseChildScenes)
{
    local UIScene ParentScene;
    local bool bResult;
    
    if (BeginSceneAnimation(SceneAnimation_Close, bCloseChildScenes ? OnCloseAnimationComplete : OnCloseAnimationComplete_IgnoreChildScenes))
    {
        ParentScene = GetPreviousScene();
        if (ParentScene != None)
        {
            ParentScene.BeginSceneRegainingFocusAnimation();
        }
        bResult = TRUE;
    }
    return bResult;
}
public function BeginSceneLostFocusAnimation()
{
    BeginSceneAnimation(SceneAnimation_LoseFocus, OnLostFocusAnimationComplete);
}
public function BeginSceneOpenAnimation()
{
    local bool bIsPerformingLoseFocusAnimation;
    local bool bIsPerformingCloseAnimation;
    
    bIsPerformingLoseFocusAnimation = SceneAnimation_LoseFocus != 'None' && IsAnimating(SceneAnimation_LoseFocus);
    bIsPerformingCloseAnimation = SceneAnimation_Close != 'None' && IsAnimating(SceneAnimation_Close);
    if (!bIsPerformingLoseFocusAnimation && !bIsPerformingCloseAnimation)
    {
        BeginSceneAnimation(SceneAnimation_Open, OnOpenAnimationComplete);
    }
}
public function BeginSceneRegainedFocusAnimation()
{
    BeginSceneAnimation(SceneAnimation_RegainedFocus, OnRegainedFocusAnimationComplete);
}
public function BeginSceneRegainingFocusAnimation()
{
    BeginSceneAnimation(SceneAnimation_RegainingFocus, OnRegainingFocusAnimationComplete);
}
public function DebugShowAnimators();

public function int FindAnimatorIndex(UIScreenObject SearchObj)
{
    local int Index;
    local int Result;
    
    Result = -1;
    if (SearchObj != None)
    {
        for (Index = 0; Index < AnimatingObjects.Length; Index++)
        {
            if (AnimatingObjects[Index] == SearchObj)
            {
                Result = Index;
                break;
            }
        }
    }
    return Result;
}
public function LogCurrentState(int Indent);

public function LogRenderBounds(int Indent)
{
    local int i;
    
    for (i = 0; i < Children.Length; i++)
    {
        Children[i].LogRenderBounds(3);
    }
}
public function NotifyControllerStatusChanged(int ControllerId, bool bConnected)
{
    local UIScene ParentScene;
    
    ParentScene = GetPreviousScene(FALSE);
    if (ParentScene != None)
    {
        ParentScene.NotifyControllerStatusChanged(ControllerId, bConnected);
    }
}
public function NotifyLinkStatusChanged(bool bConnected)
{
    local UIScene ParentScene;
    
    ParentScene = GetPreviousScene(FALSE);
    if (!bConnected && bRequiresNetwork)
    {
        CloseScene(Self, TRUE, TRUE);
    }
    if (ParentScene != None)
    {
        ParentScene.NotifyLinkStatusChanged(bConnected);
    }
}
public function bool NotifyLoginStatusChanged(int ControllerId, ELoginStatus NewStatus)
{
    local UIScene ParentScene;
    local bool bResult;
    
    ParentScene = GetPreviousScene(FALSE, TRUE);
    if (ParentScene != None)
    {
        bResult = ParentScene.NotifyLoginStatusChanged(ControllerId, NewStatus);
    }
    return bResult;
}
public function NotifyOnlineServiceStatusChanged(EOnlineServerConnectionStatus NewConnectionStatus)
{
    local UIScene ParentScene;
    
    ParentScene = GetPreviousScene(FALSE);
    if (NewConnectionStatus != EOnlineServerConnectionStatus.OSCS_Connected && bRequiresOnlineService)
    {
        CloseScene(Self, TRUE, TRUE);
    }
    if (ParentScene != None)
    {
        ParentScene.NotifyOnlineServiceStatusChanged(NewConnectionStatus);
    }
}
public function NotifyPreClientTravel(string TravelURL, ETravelType TravelType, bool bIsSeamless);

public function NotifyStorageDeviceChanged()
{
    local UIScene ParentScene;
    
    ParentScene = GetPreviousScene(FALSE);
    if (ParentScene != None)
    {
        ParentScene.NotifyStorageDeviceChanged();
    }
}
public function OnCloseAnimationComplete(UIScreenObject Sender, Name AnimName, int TrackTypeMask)
{
    local GameUISceneClient GameSceneClient;
    
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_Close)
    {
        Remove_UIAnimTrackCompletedHandler(OnCloseAnimationComplete);
        GameSceneClient = GetSceneClient();
        if (GameSceneClient != None)
        {
            GameSceneClient.CloseScene(Self);
        }
    }
}
public function OnCloseAnimationComplete_IgnoreChildScenes(UIScreenObject Sender, Name AnimName, int TrackTypeMask)
{
    local GameUISceneClient GameSceneClient;
    
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_Close)
    {
        Remove_UIAnimTrackCompletedHandler(OnCloseAnimationComplete_IgnoreChildScenes);
        GameSceneClient = GetSceneClient();
        if (GameSceneClient != None)
        {
            GameSceneClient.CloseScene(Self, FALSE);
        }
    }
}
public function OnLostFocusAnimationComplete(UIScreenObject Sender, Name AnimName, int TrackTypeMask)
{
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_LoseFocus)
    {
        Remove_UIAnimTrackCompletedHandler(OnLostFocusAnimationComplete);
    }
}
public function OnOpenAnimationComplete(UIScreenObject Sender, Name AnimName, int TrackTypeMask)
{
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_Open)
    {
        Remove_UIAnimTrackCompletedHandler(OnOpenAnimationComplete);
    }
}
public function OnRegainedFocusAnimationComplete(UIScreenObject Sender, Name AnimName, int TrackTypeMask)
{
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_RegainedFocus)
    {
        Remove_UIAnimTrackCompletedHandler(OnRegainedFocusAnimationComplete);
    }
}
public function OnRegainingFocusAnimationComplete(UIScreenObject Sender, Name AnimName, int TrackTypeMask)
{
    if (TrackTypeMask == 0 && AnimName == SceneAnimation_RegainingFocus)
    {
        Remove_UIAnimTrackCompletedHandler(OnRegainingFocusAnimationComplete);
    }
}
public function SceneCreated(UIScene CreatedScene);

public function bool StopSceneAnimation(Name AnimationSequenceName, optional bool bFinalize = TRUE)
{
    local bool bResult;
    
    if (AnimationSequenceName != 'None' && !IsEditor() && IsAnimating(AnimationSequenceName))
    {
        StopUIAnimation(AnimationSequenceName, , bFinalize);
        bResult = TRUE;
    }
    return bResult;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=UIComp_Event Name=SceneEventComponent
    End Object
    CurrentBackgroundSettings = {
                                 ColorGradingLUT = {
                                                    LUTTextures = (), 
                                                    LUTWeights = ()
                                                   }, 
                                 RimShader_Color = {R = 0.47044, G = 0.585973024, B = 0.827726007, A = 1.0}, 
                                 DOF_FocusPosition = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                 Scene_HighLights = {X = 1.0, Y = 1.0, Z = 1.0}, 
                                 Scene_MidTones = {X = 1.0, Y = 1.0, Z = 1.0}, 
                                 Scene_Shadows = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                 Bloom_Scale = 1.0, 
                                 Bloom_Threshold = 1.0, 
                                 Bloom_Tint = {B = 255, G = 255, R = 255, A = 0}, 
                                 Bloom_ScreenBlendThreshold = 10.0, 
                                 Bloom_InterpolationDuration = 1.0, 
                                 DOF_FalloffExponent = 4.0, 
                                 DOF_BlurKernelSize = 16.0, 
                                 DOF_BlurBloomKernelSize = 16.0, 
                                 DOF_MaxNearBlurAmount = 1.0, 
                                 DOF_MaxFarBlurAmount = 1.0, 
                                 DOF_ModulateBlurColor = {B = 255, G = 255, R = 255, A = 255}, 
                                 DOF_FocusInnerRadius = 2000.0, 
                                 DOF_FocusDistance = 0.0, 
                                 DOF_InterpolationDuration = 1.0, 
                                 MotionBlur_MaxVelocity = 1.0, 
                                 MotionBlur_Amount = 0.5, 
                                 MotionBlur_CameraRotationThreshold = 45.0, 
                                 MotionBlur_CameraTranslationThreshold = 10000.0, 
                                 MotionBlur_InterpolationDuration = 1.0, 
                                 Scene_Desaturation = 0.0, 
                                 Scene_InterpolationDuration = 1.0, 
                                 RimShader_InterpolationDuration = 1.0, 
                                 ColorGrading_LookupTable = None, 
                                 PP_DesaturationMultiplier = 0.0, 
                                 PP_HighlightsMultiplier = 1.0, 
                                 PP_MidTonesMultiplier = 1.0, 
                                 PP_ShadowsMultiplier = 0.0, 
                                 bOverride_EnableBloom = TRUE, 
                                 bOverride_EnableDOF = TRUE, 
                                 bOverride_EnableMotionBlur = TRUE, 
                                 bOverride_EnableSceneEffect = TRUE, 
                                 bOverride_AllowAmbientOcclusion = TRUE, 
                                 bOverride_OverrideRimShaderColor = TRUE, 
                                 bOverride_Bloom_Scale = TRUE, 
                                 bOverride_Bloom_Threshold = TRUE, 
                                 bOverride_Bloom_Tint = TRUE, 
                                 bOverride_Bloom_ScreenBlendThreshold = TRUE, 
                                 bOverride_Bloom_InterpolationDuration = TRUE, 
                                 bOverride_DOF_FalloffExponent = TRUE, 
                                 bOverride_DOF_BlurKernelSize = TRUE, 
                                 bOverride_DOF_BlurBloomKernelSize = TRUE, 
                                 bOverride_DOF_MaxNearBlurAmount = TRUE, 
                                 bOverride_DOF_MaxFarBlurAmount = TRUE, 
                                 bOverride_DOF_ModulateBlurColor = TRUE, 
                                 bOverride_DOF_FocusType = TRUE, 
                                 bOverride_DOF_FocusInnerRadius = TRUE, 
                                 bOverride_DOF_FocusDistance = TRUE, 
                                 bOverride_DOF_FocusPosition = TRUE, 
                                 bOverride_DOF_InterpolationDuration = TRUE, 
                                 bOverride_MotionBlur_MaxVelocity = TRUE, 
                                 bOverride_MotionBlur_Amount = TRUE, 
                                 bOverride_MotionBlur_FullMotionBlur = TRUE, 
                                 bOverride_MotionBlur_CameraRotationThreshold = TRUE, 
                                 bOverride_MotionBlur_CameraTranslationThreshold = TRUE, 
                                 bOverride_MotionBlur_InterpolationDuration = TRUE, 
                                 bOverride_Scene_Desaturation = TRUE, 
                                 bOverride_Scene_HighLights = TRUE, 
                                 bOverride_Scene_MidTones = TRUE, 
                                 bOverride_Scene_Shadows = TRUE, 
                                 bOverride_Scene_InterpolationDuration = TRUE, 
                                 bOverride_RimShader_Color = TRUE, 
                                 bOverride_RimShader_InterpolationDuration = TRUE, 
                                 bEnableBloom = TRUE, 
                                 bEnableDOF = FALSE, 
                                 bEnableMotionBlur = TRUE, 
                                 bEnableSceneEffect = TRUE, 
                                 bAllowAmbientOcclusion = TRUE, 
                                 bOverrideRimShaderColor = FALSE, 
                                 bOverride_EnableFilmic = TRUE, 
                                 bEnableFilmic = TRUE, 
                                 bOverride_EnableVignette = TRUE, 
                                 bEnableVignette = TRUE, 
                                 bOverride_EnableFilmGrain = TRUE, 
                                 bEnableFilmGrain = TRUE, 
                                 MotionBlur_FullMotionBlur = TRUE, 
                                 DOF_FocusType = EFocusType.FOCUS_Distance
                                }
    CurrentForegroundSettings = {
                                 ColorGradingLUT = {
                                                    LUTTextures = (), 
                                                    LUTWeights = ()
                                                   }, 
                                 RimShader_Color = {R = 0.47044, G = 0.585973024, B = 0.827726007, A = 1.0}, 
                                 DOF_FocusPosition = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                 Scene_HighLights = {X = 1.0, Y = 1.0, Z = 1.0}, 
                                 Scene_MidTones = {X = 1.0, Y = 1.0, Z = 1.0}, 
                                 Scene_Shadows = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                 Bloom_Scale = 1.0, 
                                 Bloom_Threshold = 1.0, 
                                 Bloom_Tint = {B = 255, G = 255, R = 255, A = 0}, 
                                 Bloom_ScreenBlendThreshold = 10.0, 
                                 Bloom_InterpolationDuration = 1.0, 
                                 DOF_FalloffExponent = 4.0, 
                                 DOF_BlurKernelSize = 16.0, 
                                 DOF_BlurBloomKernelSize = 16.0, 
                                 DOF_MaxNearBlurAmount = 1.0, 
                                 DOF_MaxFarBlurAmount = 1.0, 
                                 DOF_ModulateBlurColor = {B = 255, G = 255, R = 255, A = 255}, 
                                 DOF_FocusInnerRadius = 2000.0, 
                                 DOF_FocusDistance = 0.0, 
                                 DOF_InterpolationDuration = 1.0, 
                                 MotionBlur_MaxVelocity = 1.0, 
                                 MotionBlur_Amount = 0.5, 
                                 MotionBlur_CameraRotationThreshold = 45.0, 
                                 MotionBlur_CameraTranslationThreshold = 10000.0, 
                                 MotionBlur_InterpolationDuration = 1.0, 
                                 Scene_Desaturation = 0.0, 
                                 Scene_InterpolationDuration = 1.0, 
                                 RimShader_InterpolationDuration = 1.0, 
                                 ColorGrading_LookupTable = None, 
                                 PP_DesaturationMultiplier = 0.0, 
                                 PP_HighlightsMultiplier = 1.0, 
                                 PP_MidTonesMultiplier = 1.0, 
                                 PP_ShadowsMultiplier = 0.0, 
                                 bOverride_EnableBloom = TRUE, 
                                 bOverride_EnableDOF = TRUE, 
                                 bOverride_EnableMotionBlur = TRUE, 
                                 bOverride_EnableSceneEffect = TRUE, 
                                 bOverride_AllowAmbientOcclusion = TRUE, 
                                 bOverride_OverrideRimShaderColor = TRUE, 
                                 bOverride_Bloom_Scale = TRUE, 
                                 bOverride_Bloom_Threshold = TRUE, 
                                 bOverride_Bloom_Tint = TRUE, 
                                 bOverride_Bloom_ScreenBlendThreshold = TRUE, 
                                 bOverride_Bloom_InterpolationDuration = TRUE, 
                                 bOverride_DOF_FalloffExponent = TRUE, 
                                 bOverride_DOF_BlurKernelSize = TRUE, 
                                 bOverride_DOF_BlurBloomKernelSize = TRUE, 
                                 bOverride_DOF_MaxNearBlurAmount = TRUE, 
                                 bOverride_DOF_MaxFarBlurAmount = TRUE, 
                                 bOverride_DOF_ModulateBlurColor = TRUE, 
                                 bOverride_DOF_FocusType = TRUE, 
                                 bOverride_DOF_FocusInnerRadius = TRUE, 
                                 bOverride_DOF_FocusDistance = TRUE, 
                                 bOverride_DOF_FocusPosition = TRUE, 
                                 bOverride_DOF_InterpolationDuration = TRUE, 
                                 bOverride_MotionBlur_MaxVelocity = TRUE, 
                                 bOverride_MotionBlur_Amount = TRUE, 
                                 bOverride_MotionBlur_FullMotionBlur = TRUE, 
                                 bOverride_MotionBlur_CameraRotationThreshold = TRUE, 
                                 bOverride_MotionBlur_CameraTranslationThreshold = TRUE, 
                                 bOverride_MotionBlur_InterpolationDuration = TRUE, 
                                 bOverride_Scene_Desaturation = TRUE, 
                                 bOverride_Scene_HighLights = TRUE, 
                                 bOverride_Scene_MidTones = TRUE, 
                                 bOverride_Scene_Shadows = TRUE, 
                                 bOverride_Scene_InterpolationDuration = TRUE, 
                                 bOverride_RimShader_Color = TRUE, 
                                 bOverride_RimShader_InterpolationDuration = TRUE, 
                                 bEnableBloom = TRUE, 
                                 bEnableDOF = FALSE, 
                                 bEnableMotionBlur = TRUE, 
                                 bEnableSceneEffect = TRUE, 
                                 bAllowAmbientOcclusion = TRUE, 
                                 bOverrideRimShaderColor = FALSE, 
                                 bOverride_EnableFilmic = TRUE, 
                                 bEnableFilmic = TRUE, 
                                 bOverride_EnableVignette = TRUE, 
                                 bEnableVignette = TRUE, 
                                 bOverride_EnableFilmGrain = TRUE, 
                                 bEnableFilmGrain = TRUE, 
                                 MotionBlur_FullMotionBlur = TRUE, 
                                 DOF_FocusType = EFocusType.FOCUS_Distance
                                }
    DefaultContextMenuClass = Class'UIContextMenu'
    CurrentViewportSize = {X = 1024.0, Y = 768.0}
    SceneOpenedCue = 'SceneOpened'
    SceneClosedCue = 'SceneClosed'
    LastPlayerIndex = -1
    SceneStackPriority = 10
    bUpdateDockingStack = TRUE
    bUpdateScenePositions = TRUE
    bUpdateNavigationLinks = TRUE
    bUpdatePrimitiveUsage = TRUE
    bReevaluateRotationSupport = TRUE
    bDisplayCursor = TRUE
    bPauseGameWhileActive = TRUE
    bCloseOnLevelChange = TRUE
    bSaveSceneValuesOnClose = TRUE
    bFlushPlayerInput = TRUE
    bCaptureMatchedInput = TRUE
    PlayerInputMask = 15
    SceneInputMode = EScreenInputMode.INPUTMODE_Locked
    SceneRenderMode = ESplitscreenRenderMode.SPLITRENDER_PlayerOwner
    DefaultStates = (Class'UIState_Enabled', Class'UIState_Disabled', Class'UIState_Focused', Class'UIState_Active')
    EventProvider = SceneEventComponent
}