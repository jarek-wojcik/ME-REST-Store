Class UIScreenObject extends UIRoot
    native
    placeable
    abstract
    config(UI);

var noimport array<UIObject> Children;
var const array<Class<UIState>> DefaultStates;
var(Appearance) const editconst export array<UIState> InactiveStates;
var const transient array<UIState> StateStack;
var const transient array<PlayerInteractionData> FocusControls;
var(Interaction) transient array<UIFocusPropagationData> FocusPropagation;
var transient array<UIAnimSequence> AnimStack;
var(Animation) editconst transient array<delegate<OnUIAnim_KeyFrameCompleted>> KeyFrameCompletedDelegates;
var(Animation) editconst transient array<delegate<OnUIAnim_TrackCompleted>> TrackCompletedDelegates;
var delegate<NotifyActiveSkinChanged> __NotifyActiveSkinChanged__Delegate;
var delegate<OnRawInputKey> __OnRawInputKey__Delegate;
var delegate<OnRawInputAxis> __OnRawInputAxis__Delegate;
var delegate<OnProcessInputKey> __OnProcessInputKey__Delegate;
var delegate<OnProcessInputAxis> __OnProcessInputAxis__Delegate;
var delegate<NotifyPositionChanged> __NotifyPositionChanged__Delegate;
var delegate<NotifyResolutionChanged> __NotifyResolutionChanged__Delegate;
var transient delegate<NotifyActiveStateChanged> __NotifyActiveStateChanged__Delegate;
var delegate<NotifyVisibilityChanged> __NotifyVisibilityChanged__Delegate;
var transient delegate<OnInitialSceneUpdate> __OnInitialSceneUpdate__Delegate;
var delegate<OnUIAnim_KeyFrameCompleted> __OnUIAnim_KeyFrameCompleted__Delegate;
var delegate<OnUIAnim_TrackCompleted> __OnUIAnim_TrackCompleted__Delegate;
var Class<UIState> InitialState;
var(Appearance) UIScreenValue_Bounds Position;
var(Sound) Name FocusedCue;
var(Sound) Name MouseEnterCue;
var(Sound) Name NavigateUpCue;
var(Sound) Name NavigateDownCue;
var(Sound) Name NavigateLeftCue;
var(Sound) Name NavigateRightCue;
var(Appearance) float ZDepth;
var transient int AnimationCount;
var(ZDebug) globalconfig float AnimationDebugMultiplier;
var(Appearance) float Opacity;
var editinline export UIComp_Event EventProvider;
var(Appearance) bool bHidden;
var transient bool bInitialized;
var(Interaction) const bool bNeverFocus;
var(Interaction) bool bSupportsFocusHint;
var const bool bOverrideInputOrder;
var transient bool bAnimating;
var transient bool bAnimationPaused;
var const bool bSupports3DPrimitives;

public final native function bool AcceptsPlayerInput(int PlayerIndex);

public final native function ActivateEventByClass(int PlayerIndex, Class<UIEvent> EventClassToActivate, optional Object InEventActivator, optional bool bActivateImmediately, optional array<int> IndicesToActivate, optional out array<UIEvent> out_ActivatedEvents);

public event function bool ActivateFocusHint(UIObject FocusHintObject)
{
    return FALSE;
}
public event function ActivateKeyFrameCompletedDelegates(UIScreenObject Sender, Name AnimName, EUIAnimType TrackType)
{
    local int FuncIndex;
    local array<delegate<OnUIAnim_KeyFrameCompleted>> TempDelegates;
    local delegate<OnUIAnim_KeyFrameCompleted> HandlerFunction;
    
    TempDelegates = KeyFrameCompletedDelegates;
    for (FuncIndex = 0; FuncIndex < TempDelegates.Length; FuncIndex++)
    {
        HandlerFunction = TempDelegates[FuncIndex];
        HandlerFunction(Sender, AnimName, TrackType);
    }
}
public final native function bool ActivateState(UIState StateToActivate, int PlayerIndex);

public final native function bool ActivateStateByClass(Class<UIState> StateToActivate, int PlayerIndex, optional out UIState StateThatWasAdded);

public event function ActivateTrackCompletedDelegates(UIScreenObject Sender, Name AnimName, int TrackTypeMask)
{
    local int FuncIndex;
    local array<delegate<OnUIAnim_TrackCompleted>> TempDelegates;
    local delegate<OnUIAnim_TrackCompleted> HandlerFunction;
    
    TempDelegates = TrackCompletedDelegates;
    for (FuncIndex = 0; FuncIndex < TempDelegates.Length; FuncIndex++)
    {
        HandlerFunction = TempDelegates[FuncIndex];
        HandlerFunction(Sender, AnimName, TrackTypeMask);
    }
}
public event function AddedChild(UIScreenObject WidgetOwner, UIObject NewChild);

public final native function bool Anim_GetValue(EUIAnimType AnimationType, out UIAnimationRawData out_CurrentValue);

public final native function bool Anim_SetValue(EUIAnimType AnimationType, const out UIAnimationRawData NewValue);

public final native function bool AnimGetCurrentPPSettings(out PostProcessSettings CurrentSettings);

public native function bool CanAcceptFocus(optional int PlayerIndex = GetBestPlayerIndex(), optional bool bIncludeParentVisibility = TRUE);

public final function bool CanPlayOnline(optional int ControllerId = GetBestControllerId())
{
    return Class'UIInteraction'.static.CanPlayOnline(ControllerId);
}
public final native function bool CanPropagateFocusFor(UIObject TestChild);

public final native function Vector4 CanvasToScreen(const out Vector CanvasPosition);

public event native function ClearUIAnimationLoop(int SequenceIndex, optional int TrackTypeMask);

public final native function bool ConditionalPropagateEnabledState(int PlayerIndex, optional bool bForce);

public final native function bool ContainsChild(UIObject Child, optional bool bRecurse = TRUE);

public final native function bool ContainsChildOfClass(Class<UIObject> SearchClass, optional bool bRecurse = TRUE);

public final native function CreatePlayerData(int PlayerIndex, LocalPlayer AddedPlayer);

public final native function UIObject CreateWidget(UIScreenObject Owner, Class<UIObject> WidgetClass, optional Object WidgetArchetype, optional Name WidgetName);

public final native function bool DeactivateState(UIState StateToRemove, int PlayerIndex);

public final native function bool DeactivateStateByClass(Class<UIState> StateToRemove, int PlayerIndex, optional out UIState StateThatWasRemoved);

public final native function Vector DeProject(const out Vector PixelPosition);

public final event function DisablePlayerInput(byte PlayerIndex, optional bool bRecurse = TRUE)
{
    local byte NewPlayerInputMask;
    
    if (int(PlayerIndex) >= 0 && int(PlayerIndex) < 4)
    {
        NewPlayerInputMask = byte(int(GetInputMask(FALSE, TRUE)) & ~(1 << int(PlayerIndex)));
        SetInputMask(NewPlayerInputMask, bRecurse, TRUE);
    }
}
public final event function EnablePlayerInput(byte PlayerIndex, optional bool bRecurse = TRUE)
{
    local byte CurrentPlayerInputMask;
    local byte NewPlayerInputMask;
    
    if (int(PlayerIndex) >= 0 && int(PlayerIndex) < 4)
    {
        CurrentPlayerInputMask = GetInputMask(FALSE, TRUE);
        NewPlayerInputMask = byte(int(CurrentPlayerInputMask) | 1 << int(PlayerIndex));
        SetInputMask(NewPlayerInputMask, bRecurse, TRUE);
    }
}
public final native function int FindAnimationSequenceIndex(Name SequenceName);

public final native function UIObject FindChild(Name WidgetName, optional bool bRecurse);

public final native function int FindChildIndex(Name WidgetName);

public final native function UIObject FindChildUsingID(WIDGET_ID WidgetID, optional bool bRecurse);

public final native function FindEventsOfClass(Class<UIEvent> EventClassToFind, out array<UIEvent> out_EventInstances, optional UIState LimitScope, optional bool bExactClass);

public native function bool FocusFirstControl(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex());

public native function bool FocusLastControl(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex());

public static final native function int GetActivePlayerCount();

public final native function float GetAspectRatio();

public final native function float GetAspectRatioAutoScaleFactor(optional Font BaseFont);

public final native function int GetBestControllerId();

public final native function int GetBestPlayerIndex();

public final native function float GetBounds(EUIOrientation Dimension, optional EPositionEvalType OutputType = 0, optional bool bIgnoreDockPadding);

public final native function Matrix GetCanvasToScreen();

public final native function array<UIObject> GetChildren(optional bool bRecurse, optional array<UIObject> ExclusionSet);

public final native function UIState GetCurrentState(optional int PlayerIndex = -1);

public final native function int GetDockClients(optional out array<UIObject> DockClients, optional bool bDirectDockClientsOnly = TRUE, optional EUIWidgetFace TargetFace = 4, optional EUIWidgetFace SourceFace = 4);

public final native function GetDockedWidgets(out array<UIObject> out_DockedWidgets, optional EUIWidgetFace SourceFace = 4, optional EUIWidgetFace TargetFace = 4);

public final native function UIObject GetFocusedControl(optional bool bRecurse, optional int PlayerIndex = GetBestPlayerIndex());

public final native function byte GetInputMask(optional bool bInheritedMaskOnly, optional bool bOverrideMaskOnly);

public final native function Matrix GetInverseCanvasToScreen();

public final native function UIObject GetLastFocusedControl(optional bool bRecurse, optional int PlayerIndex = GetBestPlayerIndex());

public final function ELoginStatus GetLoginStatus(optional int ControllerId = GetBestControllerId())
{
    return Class'UIInteraction'.static.GetLoginStatus(ControllerId);
}
public function ENATType GetNATType()
{
    return Class'UIInteraction'.static.GetNATType();
}
public final native function int GetObjectCount();

public final native function LocalPlayer GetPlayerOwner(optional int PlayerIndex = -1);

public final native function int GetPlayerOwnerIndex(optional bool bRequireValidIndex = TRUE);

public final native function float GetPosition(EUIWidgetFace Face, optional EPositionEvalType OutputType = 0, optional bool bIncludeOrigin, optional bool bIgnoreDockPadding);

public final native function Vector GetPositionVector(optional bool bIncludeParentPosition = TRUE);

public final native function int GetSupportedPlayerCount();

public event function GetSupportedUIActionKeyNames(out array<Name> out_KeyNames);

public final native function float GetViewportHeight();

public final native function bool GetViewportOffset(out Vector2D out_ViewportOffset);

public final native function bool GetViewportOrigin(out Vector2D out_ViewportOrigin);

public final native function float GetViewportScale();

public final native function bool GetViewportSize(out Vector2D out_ViewportSize);

public final native function float GetViewportWidth();

public final native function string GetWidgetPathName();

public final native function float GetZDepth();

public final native function bool HasActiveStateOfClass(Class<UIState> StateClass, int PlayerIndex, optional out int StateIndex);

public static final function bool HasLinkConnection()
{
    return Class'UIInteraction'.static.HasLinkConnection();
}
public final native function Initialize(UIScene inOwnerScene, optional UIObject InOwner);

public event function Initialized();

public final native function InitializePlayerTracking();

public native function int InsertChild(UIObject NewChild, optional int InsertIndex = -1, optional bool bRenameExisting = TRUE);

public final native function UIPrefabInstance InstanceUIPrefab(UIPrefab SourcePrefab, optional Name PrefabInstanceName, optional const out Vector2D PlacementLocation, optional int InsertIndex = -1, optional bool bRenameExisting = TRUE);

public final native function InvalidateAllPositions(optional bool bIgnoreDockedFaces = TRUE);

public final native function InvalidatePosition(EUIWidgetFace Face);

public final native function bool IsActive(optional int PlayerIndex = GetBestPlayerIndex());

public event native function bool IsAnimating(optional Name AnimationSequenceName);

public final native function bool IsAnimationPaused();

public final native function bool IsDisabled(optional int PlayerIndex = GetBestPlayerIndex(), optional bool bCheckOwnerChain = TRUE);

public final native function bool IsEnabled(optional int PlayerIndex = GetBestPlayerIndex(), optional bool bCheckOwnerChain = TRUE);

public final native function bool IsFocused(optional int PlayerIndex = GetBestPlayerIndex());

public final event function bool IsGamepadConnected(optional int ControllerId = 255)
{
    if (ControllerId == 255)
    {
        ControllerId = GetBestControllerId();
    }
    return Class'UIInteraction'.static.IsGamepadConnected(ControllerId);
}
public final native function bool IsHidden(optional bool bIncludeParents);

public final native function bool IsHoldingAlt(int ControllerId);

public final native function bool IsHoldingCtrl(int ControllerId);

public final native function bool IsHoldingShift(int ControllerId);

public final native function bool IsInitialized();

public event function bool IsLoggedIn(optional int ControllerId = 255, optional bool bRequireOnlineLogin)
{
    if (ControllerId == 255)
    {
        ControllerId = GetBestControllerId();
    }
    return Class'UIInteraction'.static.IsLoggedIn(ControllerId, bRequireOnlineLogin);
}
public final native function bool IsNeverFocused();

public final native function bool IsPressed(optional int PlayerIndex = GetBestPlayerIndex());

public final native function bool IsRuntimeInstance();

public final native function bool IsVisible(optional bool bIncludeParents);

public native function bool KillFocus(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex());

public native function bool NavigateFocus(UIScreenObject Sender, EUIWidgetFace Direction, optional int PlayerIndex = GetBestPlayerIndex(), optional out byte bFocusChanged);

public native function bool NextControl(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex());

public delegate function NotifyActiveSkinChanged();

public delegate function NotifyActiveStateChanged(UIScreenObject Sender, int PlayerIndex, UIState NewlyActiveState, optional UIState PreviouslyActiveState);

public delegate function NotifyPositionChanged(UIScreenObject Sender);

public delegate function NotifyResolutionChanged(const out Vector2D OldViewportsize, const out Vector2D NewViewportSize);

public delegate function NotifyVisibilityChanged(UIScreenObject SourceWidget, bool bIsVisible);

public delegate function OnInitialSceneUpdate();

public delegate function bool OnProcessInputAxis(const out SubscribedInputEventParameters EventParms);

public delegate function bool OnProcessInputKey(const out SubscribedInputEventParameters EventParms);

public delegate function bool OnRawInputAxis(const out InputEventParameters EventParms);

public delegate function bool OnRawInputKey(const out InputEventParameters EventParms);

public delegate function OnUIAnim_KeyFrameCompleted(UIScreenObject Sender, Name AnimName, EUIAnimType TrackType);

public delegate function OnUIAnim_TrackCompleted(UIScreenObject Sender, Name AnimName, int TrackTypeMask);

public final native function OverrideLastFocusedControl(int PlayerIndex, UIObject ChildToFocus);

public final native function PauseAnimations(bool bPauseAnimation);

public final native function Vector PixelToCanvas(const out Vector2D PixelPosition);

public final native function Vector4 PixelToScreen(const out Vector2D PixelPosition);

public event native function PlayUIAnimation(Name AnimName, optional UIAnimationSeq AnimSeqTemplate, optional EUIAnimationLoopMode OverrideLoopMode = 3, optional float PlaybackRate = 1.0, optional float InitialPosition = 0.0, optional bool bSetAnimatingFlag = TRUE);

public static final native function bool PlayUISound(Name SoundCueName, optional int PlayerIndex = 0);

public event function PostInitialize();

public native function bool PrevControl(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex());

public final native function Vector Project(const out Vector CanvasPosition);

public final native function bool RebuildNavigationLinks();

public final native function bool RemoveChild(UIObject ExistingChild, optional array<UIObject> ExclusionSet);

public final native function array<UIObject> RemoveChildren(array<UIObject> ChildrenToRemove);

public event function RemovedChild(UIScreenObject WidgetOwner, UIObject OldChild, optional array<UIObject> ExclusionSet);

public event function RemovedFromParent(UIScreenObject WidgetOwner)
{
    local int AnimationIndex;
    
    for (AnimationIndex = AnimStack.Length - 1; AnimationIndex >= 0; AnimationIndex--)
    {
        StopUIAnimation(AnimStack[AnimationIndex].SequenceRef.SeqName, AnimStack[AnimationIndex].SequenceRef, FALSE);
    }
}
public final native function RemovePlayerData(int PlayerIndex, LocalPlayer RemovedPlayer);

public final native function bool ReparentChild(UIObject CurrentChild, UIScreenObject NewParent, optional int InsertIndex = -1);

public final native function bool ReparentChildren(array<UIObject> ChildrenToReparent, UIScreenObject NewParent, optional int InsertIndex = -1);

public final native function bool ReplaceChild(UIObject ExistingChild, UIObject NewChild);

public final native function RequestFormattingUpdate();

public final native function RequestPrimitiveReview(bool bReinitializePrimitives, bool bReviewPrimitiveUsage);

public final native function RequestSceneInputMaskUpdate();

public final native function RequestSceneUpdate(bool bDockingStackChanged, bool bPositionsChanged, optional bool bNavLinksOutdated = FALSE, optional bool bWidgetStylesChanged = FALSE);

public static final native function float ResolveUIExtent(const out UIScreenValue_Extent ExtentToResolve, UIScreenObject OwnerWidget, optional EUIExtentEvalType OutputType = 0);

public final native function Vector ScreenToCanvas(const out Vector4 ScreenPosition);

public final native function Vector2D ScreenToPixel(const out Vector4 ScreenPosition);

public native function bool SetEnabled(bool bEnabled, optional int PlayerIndex = GetBestPlayerIndex());

public native function bool SetFocus(UIScreenObject Sender, optional int PlayerIndex = GetBestPlayerIndex());

public native function bool SetFocusToChild(optional UIObject ChildToFocus, optional int PlayerIndex = GetBestPlayerIndex());

public final native function SetInputMask(byte NewInputMask, optional bool bRecurse = TRUE, optional bool bForcedOverride);

public final native function SetPosition(float NewValue, EUIWidgetFace Face, optional EPositionEvalType InputType = 3, optional bool bIncludesViewportOrigin, optional bool bResolveChange = TRUE);

public event function SetVisibility(bool bIsVisible)
{
    PrivateSetVisibility(bIsVisible);
}
public final native function SetZDepth(float NewZDepth, optional bool bPropagateToChildren);

public event native function StopUIAnimation(Name AnimName, optional UIAnimationSeq AnimSeq, optional bool bFinalize = TRUE, optional int TrackTypeMask);

public native function TickAnimations(float DeltaTime);

public event function UIAnimationEnded(UIScreenObject Sender, Name AnimName, int TrackTypeMask)
{
    local UIScreenObject Parent;
    
    if (Sender != None)
    {
        AnimationCount--;
        if (AnimationCount <= 0)
        {
            AnimationCount = 0;
            bAnimating = FALSE;
        }
        if (Sender == Self)
        {
            ActivateTrackCompletedDelegates(Sender, AnimName, TrackTypeMask);
        }
        Parent = GetParent();
        if (Parent != None)
        {
            Parent.UIAnimationEnded(Sender, AnimName, TrackTypeMask);
        }
    }
}
public event function UIAnimationStarted(UIScreenObject Sender, Name AnimName, int TrackTypeMask, optional bool bSetAnimatingFlag = TRUE)
{
    local UIScreenObject Parent;
    
    if (Sender != None)
    {
        AnimationCount++;
        if (!bAnimating && bSetAnimatingFlag)
        {
            bAnimating = TRUE;
        }
        Parent = GetParent();
        if (Parent != None)
        {
            Parent.UIAnimationStarted(Sender, AnimName, TrackTypeMask, bSetAnimatingFlag);
        }
    }
}
public final function Add_UIAnimKeyFrameCompletedHandler(delegate<OnUIAnim_KeyFrameCompleted> KeyFrameCompletedDelegate)
{
    if (KeyFrameCompletedDelegate != None)
    {
        if (KeyFrameCompletedDelegates.Find(KeyFrameCompletedDelegate) == -1)
        {
            KeyFrameCompletedDelegates.AddItem(KeyFrameCompletedDelegate);
        }
    }
}
public final function Add_UIAnimTrackCompletedHandler(delegate<OnUIAnim_TrackCompleted> TrackCompletedDelegate)
{
    if (TrackCompletedDelegate != None)
    {
        if (TrackCompletedDelegates.Find(TrackCompletedDelegate) == -1)
        {
            TrackCompletedDelegates.AddItem(TrackCompletedDelegate);
        }
    }
}
public function BecomePrimaryPlayer(int PlayerIndex)
{
    local array<LocalPlayer> OtherPlayers;
    local LocalPlayer PlayerOwner;
    local LocalPlayer NextPlayer;
    local LocalPlayer OriginalPrimaryPlayer;
    local UIInteraction UIController;
    local UIScene OwnerScene;
    local UIObject Widget;
    
    UIController = GetCurrentUIController();
    if (UIController != None && PlayerIndex > 0 && PlayerIndex < UIController.GetPlayerCount())
    {
        OriginalPrimaryPlayer = GetPlayerOwner(0);
        PlayerOwner = GetPlayerOwner(PlayerIndex);
        if (PlayerOwner == None)
        {
            PlayerOwner = GetPlayerOwner();
        }
        if (PlayerOwner != None)
        {
            NextPlayer = OriginalPrimaryPlayer;
            while (NextPlayer != None && NextPlayer != PlayerOwner)
            {
                UIController.NotifyPlayerRemoved(0, NextPlayer);
                UIController.Outer.Outer.GamePlayers.Remove(0, 1);
                OtherPlayers.AddItem(NextPlayer);
                NextPlayer = GetPlayerOwner(0);
            }
            while (OtherPlayers.Length > 0)
            {
                NextPlayer = OtherPlayers[0];
                UIController.Outer.Outer.GamePlayers.InsertItem(1, NextPlayer);
                UIController.NotifyPlayerAdded(1, NextPlayer);
                OtherPlayers.Remove(0, 1);
            }
            Widget = UIObject(Self);
            if (Widget == None)
            {
                OwnerScene = UIScene(Self);
            }
            else
            {
                OwnerScene = Widget.GetScene();
            }
            if (OwnerScene != None)
            {
                OwnerScene.LastPlayerIndex = 0;
            }
            PlayerIndex = 0;
        }
        NextPlayer = GetPlayerOwner(0);
        if (OriginalPrimaryPlayer != NextPlayer)
        {
            NextPlayer.Actor.ReloadProfileSettings();
        }
    }
}
public final function bool DisableWidget(int PlayerIndex)
{
    return SetEnabled(FALSE, PlayerIndex);
}
public final function bool EnableWidget(int PlayerIndex)
{
    return SetEnabled(TRUE, PlayerIndex);
}
public final function int Find_UIAnimKeyFrameCompletedHandler(delegate<OnUIAnim_KeyFrameCompleted> KeyFrameCompletedDelegate)
{
    return KeyFrameCompletedDelegates.Find(KeyFrameCompletedDelegate);
}
public final function int Find_UIAnimTrackCompletedHandler(delegate<OnUIAnim_TrackCompleted> TrackCompletedDelegate)
{
    return TrackCompletedDelegates.Find(TrackCompletedDelegate);
}
public static final function GetLoggedInControllerIds(out array<int> ControllerIds, optional bool bRequireOnlineLogin, optional int MaxPlayersToCheck = 4)
{
    local int ControllerId;
    
    MaxPlayersToCheck = Min(Class'OnlineSubsystem'.static.GetNumSupportedLogins(), MaxPlayersToCheck);
    ControllerIds.Length = 0;
    for (ControllerId = 0; ControllerId < MaxPlayersToCheck; ControllerId++)
    {
        if (Class'UIInteraction'.static.IsLoggedIn(ControllerId, bRequireOnlineLogin))
        {
            ControllerIds.AddItem(ControllerId);
        }
    }
}
public static final function int GetLoggedInPlayerCount(optional bool bRequireOnlineLogin, optional int MaxPlayersToCheck = 4)
{
    local array<int> Ids;
    
    GetLoggedInControllerIds(Ids, bRequireOnlineLogin, MaxPlayersToCheck);
    return Ids.Length;
}
public function UIScreenObject GetParent();

public function LogCurrentState(int Indent);

public function OnConsoleCommand(UIAction_ConsoleCommand Action)
{
    local LocalPlayer PlayerOwner;
    
    PlayerOwner = GetPlayerOwner();
    if (PlayerOwner != None && PlayerOwner.Actor != None)
    {
        PlayerOwner.Actor.ConsoleCommand(Action.Command);
    }
}
private final function PrivateSetVisibility(bool bVisible)
{
    local bool bCouldAcceptFocus;
    
    if (bHidden == bVisible)
    {
        bCouldAcceptFocus = CanAcceptFocus(GetBestPlayerIndex());
        bHidden = !bVisible;
        __NotifyVisibilityChanged__Delegate(Self, bVisible);
        if (IsFocused())
        {
            KillFocus(None);
        }
        if (bCouldAcceptFocus != CanAcceptFocus(GetBestPlayerIndex()))
        {
            RequestSceneUpdate(FALSE, FALSE, TRUE);
        }
    }
}
public final function Remove_UIAnimKeyFrameCompletedHandler(delegate<OnUIAnim_KeyFrameCompleted> KeyFrameCompletedDelegate)
{
    local int RemoveIndex;
    
    if (KeyFrameCompletedDelegate != None)
    {
        RemoveIndex = KeyFrameCompletedDelegates.Find(KeyFrameCompletedDelegate);
        if (RemoveIndex != -1)
        {
            KeyFrameCompletedDelegates.Remove(RemoveIndex, 1);
        }
    }
}
public final function Remove_UIAnimTrackCompletedHandler(delegate<OnUIAnim_TrackCompleted> TrackCompletedDelegate)
{
    local int RemoveIndex;
    
    if (TrackCompletedDelegate != None)
    {
        RemoveIndex = TrackCompletedDelegates.Find(TrackCompletedDelegate);
        if (RemoveIndex != -1)
        {
            TrackCompletedDelegates.Remove(RemoveIndex, 1);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultStates = (Class'UIState_Enabled', Class'UIState_Disabled')
    InitialState = Class'UIState_Enabled'
    Position = {
                Value[0] = 0.0, 
                Value[1] = 0.0, 
                Value[2] = 1.0, 
                Value[3] = 1.0, 
                ScaleType[0] = EPositionEvalType.EVALPOS_PercentageOwner, 
                ScaleType[1] = EPositionEvalType.EVALPOS_PercentageOwner, 
                ScaleType[2] = EPositionEvalType.EVALPOS_PercentageOwner, 
                ScaleType[3] = EPositionEvalType.EVALPOS_PercentageOwner, 
                bInvalidated[0] = 1, 
                bInvalidated[1] = 1, 
                bInvalidated[2] = 1, 
                bInvalidated[3] = 1, 
                AspectRatioMode = EUIAspectRatioConstraint.UIASPECTRATIO_AdjustNone
               }
    FocusedCue = 'Focused'
    NavigateUpCue = 'NavigateUp'
    NavigateDownCue = 'NavigateDown'
    NavigateLeftCue = 'NavigateLeft'
    NavigateRightCue = 'NavigateRight'
    AnimationDebugMultiplier = 1.0
    Opacity = 1.0
}