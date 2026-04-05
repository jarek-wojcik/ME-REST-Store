Class SFXGUIMovie extends GFxMovie
    native
    config(UI);

struct native ScreenRect 
{
    var float Top;
    var float Left;
    var float Width;
    var float Height;
};
struct native SFXGUISceneView 
{
    var Matrix ViewProjectionMatrix;
    var Vector WorldspaceViewLocation;
};
enum GUILayout
{
    GUILayout_PC,
    GUILayout_XBox,
    GUILayout_PS3,
};
const PROFILE_FRAME_AVERAGE_COUNT = 10;

var(SFXGUIMovie) array<delegate<OnMovieClosedDelegate>> m_OnCloseCallbacks;
var transient array<int> m_aPressedKeys;
var array<SFXGUIMovieExtension> m_aMovieExtensions;
var delegate<OnMovieClosedDelegate> __OnMovieClosedDelegate__Delegate;
var transient float m_UpdateTimes[10];
var transient float m_RenderTimes[10];
var transient float m_AdvanceTimes[10];
var(SFXGUIMovie) ScreenRect MouseCaptureRect;
var config Rotator m_UIWorldMPPawnInitialRotation;
var config Vector m_UIWorldMPPawnInitialLocation;
var(SFXGUIMovie) Name nmTag;
var Name OpenSound;
var Name CloseSound;
var(SFXGUIMovie) BioWorldInfo oWorldInfo;
var transient int m_nUpdateFrame;
var(SFXGUIMovie) int m_nFSCommandHandlerID;
var transient float m_fSavedAspectRatio;
var config stringref m_srNuiSpeechCommandFormatting;
var config float MovieAlpha;
var(SFXGUIMovie) bool bCache;
var(SFXGUIMovie) bool m_bInCache;
var(SFXGUIMovie) bool m_bInAdvanceCall;
var(SFXGUIMovie) bool m_bPendingClose;
var(SFXGUIMovie) bool m_bUnloadInPendingClose;
var(SFXGUIMovie) bool m_bFocusOnStart;
var(SFXGUIMovie) bool m_bDesiresFocus;
var(SFXGUIMovie) bool m_bHandleKeyPresses;
var(SFXGUIMovie) bool m_bUseThumbstickAsDPad;
var(SFXGUIMovie) bool m_bRequiresUIWorld;
var(SFXGUIMovie) bool m_bMouseVisibleWhenFocused;
var(SFXGUIMovie) bool m_bApplyLeftThumbstickDeadzone;
var(SFXGUIMovie) bool m_bApplyRightThumbstickDeadzone;
var(SFXGUIMovie) bool m_bAcceptingFSCommands;
var bool m_bBeingUnitTested;
var(SFXGUIMovie) bool ProcessMouseMovementWithRTT;
var(SFXGUIMovie) bool AllowRTTMouseInputWithLowerZOrder;
var bool m_InputEnabled;
var(SFXGUIMovie) GUILayout ScreenLayout;

public final native function coerce SFXGUIMovieExtension AddExtension(Class<SFXGUIMovieExtension> classObj);

public native function AddOnMovieClosedDelegate(delegate<OnMovieClosedDelegate> i_OnMovieClosedDelegate);

public final native function AttachToASFunction(const string sASObjectPath, const string sASFuncName, Name nmFuncToCall, bool bCallOriginalAS, optional bool bInsertBeforeAS = TRUE, optional Object oCallbackObj);

public native function ClearOnMovieClosedDelegate(delegate<OnMovieClosedDelegate> i_OnMovieClosedDelegate);

public native function Close(optional bool Unload = TRUE);

public final native function string GetBoundKeyString(const string sAlias, optional bool bWrapNonTokenInParentheses = FALSE, optional EGameModes eGameMode = 0);

public final native function bool GetEnabled();

public final native function coerce SFXGUIMovieExtension GetExtension(Class<SFXGUIMovieExtension> classObj);

public final native function SFXGUISceneView GetGUISceneView();

public final native function bool GetInputEnabled();

public final native function float GetMovieAspectRatio();

public final native function GetProfileTimes(out float fUpdate, out float fRender, out float fAdvance);

public final native function GetRequiresUIWorld();

public final native function SFXGUIInteraction GetSFXUIController();

public static final native function string GetTokenizedUIString(stringref sr, const out array<SFXTokenMapping> aTokens);

public static final native function string GetUIString(stringref sr, optional bool bParse = FALSE);

public final native function bool GetUpdate();

public final native function float GetViewportAspectRatio();

public final native function bool GetVisible();

public event function bool HandleInputEvent(BioGuiEvents nEventID, optional float fValue = 1.0)
{
    return FALSE;
}
public final native function bool HasFocus();

public final native function ASValue Invoke0(string sFuncPath);

public final event function InvokeOnCloseDelegates()
{
    local int nIndex;
    local delegate<OnMovieClosedDelegate> oCallback;
    
    for (nIndex = 0; nIndex < m_OnCloseCallbacks.Length; nIndex++)
    {
        oCallback = m_OnCloseCallbacks[nIndex];
        if (oCallback != None)
        {
            oCallback(Self);
        }
    }
    ClearAllDelegates();
}
public final native function bool IsEnterMenuButtonAssignmentSwapped();

public static final native function bool IsNuiSpeechEnabled();

public final native function bool IsOpen();

public final native function bool IsStickSouthpaw();

public final native function bool IsTriggerShoulderSwapped();

public final native function bool IsTriggerSouthpaw();

public event function OnAspectRatioChanged(float fNewAspectRatio);

public event function OnControllerProfileSettingChange();

public event function OnLanguageChanged();

public delegate function bool OnMovieClosedDelegate(SFXGUIMovie i_ScreenToClose);

public event function OnStart()
{
    if (OpenSound != 'None')
    {
        PlayGuiSound(OpenSound);
    }
    UpdateInputConfigurations();
}
public final native function PlayGuiError();

public final native function PlayGuiMusic(Name nmMusic, optional bool bRestart = FALSE);

public final native function bool PlayGuiSound(Name nmSound);

public final native function PlayGuiVoice(Name nmVoice);

public event function PostAdvance(float tDelta);

public final native function PostProjectionToScreen(const out Vector4 vPostProjectPos, out Vector2D vScreenLocation);

public final native function RemoveExtension(Class<SFXGUIMovieExtension> classObj);

public final native function SendMouseEvent(BioGuiEvents nEventID);

public final native function SetAllowFSCommands(bool bAllowFSCommands);

public final native function SetBackgroundAlpha(float F);

public native function SetEnabled(bool bEnabled);

public native function SetFocus(bool bCapture, optional bool bFocus = TRUE);

public final native function SetGameMode(bool bEnable, optional EGameModes eGameMode = 9);

public final native function SetInputEnabled(bool bEnabled);

public final native function SetMouseVisible(bool bVisible);

public final native function SetMovieFocus(bool Focus);

public final native function SetRequiresUIWorld(bool bUIWorldRequired);

public final native function SetUpdate(bool bUpdate);

public native function SetVisible(bool bVisible);

public event native function bool Start(optional bool StartPaused = FALSE);

public final native function StopGuiMusic();

public final native function bool StopGuiSound(Name nmSound);

public final native function StopGuiVoice();

public event function Update(float fDeltaT);

public final native function float UpdateAspectRatio(optional bool bForce = FALSE, optional bool bHorizontal = FALSE);

public event function UpdateInputConfigurations()
{
    HandleInputConfigurations(IsEnterMenuButtonAssignmentSwapped(), IsStickSouthpaw(), IsTriggerSouthpaw(), IsTriggerShoulderSwapped());
}
public final native function bool WorldToSafePostProjectionFast(const out SFXGUISceneView SceneView, const Vector vWorld, out Vector4 vSafePostProjectPos, out Vector4 vUnsafePostProjectPos, optional bool bEnforceScreenEdge = TRUE, optional const Vector2D vAdditionalScreenEdgeBorderBL, optional const Vector2D vAdditionalScreenEdgeBorderTR);

public final native function bool WorldToScreen(const Vector vWorld, out Vector2D vScreenLocation, out Vector4 vPostProject, optional bool bEnforceScreenEdge = TRUE);

public final native function bool WorldToScreenFast(const out SFXGUISceneView SceneView, const Vector vWorld, out Vector2D vScreenLocation, out Vector4 vPostProject, optional bool bEnforceScreenEdge = TRUE, optional const Vector2D vAdditionalScreenEdgeBorderBL, optional const Vector2D vAdditionalScreenEdgeBorderTR);

public native function Advance(float Time);

public event function OnClose()
{
    if (CloseSound != 'None')
    {
        PlayGuiSound(CloseSound);
    }
    m_aPressedKeys.Length = 0;
    Super.OnClose();
}
public function ClearAllDelegates()
{
    m_OnCloseCallbacks.Length = 0;
}
public final function string GetNuiPawnCommandString(string TargetPawn, string Rule)
{
    local string ToRet;
    
    if (TargetPawn != "")
    {
        ClearCustomTokens();
        SetCustomToken(0, TargetPawn);
        SetCustomToken(1, Rule);
        ToRet = GetTokenisedString(m_srNuiSpeechCommandFormatting);
        ClearCustomTokens();
        return ToRet;
    }
    return Rule;
}
public final function GUILayout GetScreenLayout()
{
    return ScreenLayout;
}
public final function HandleInputConfigurations(bool bMenuAdvanceSwapped, bool bStickSouthpaw, bool bTriggerSouthpaw, bool bTriggersShouldersSwapped)
{
    ActionScriptVoid("_global.com.SFXScreen.HandleInputConfigurations");
}
public final function bool IsMPClient()
{
    return oWorldInfo.NetMode == ENetMode.NM_Client;
}
public final function bool IsMPGame()
{
    return oWorldInfo.NetMode != ENetMode.NM_Standalone;
}
public final function PreloadImages(array<string> Images)
{
    local int idx;
    local EAsyncLoadStatus eAsyncStatus;
    
    for (idx = 0; idx < Images.Length; ++idx)
    {
        Class'SFXEngine'.static.LoadSeekFreeObjectAsync(Images[idx], Class'Texture2D', eAsyncStatus);
    }
}
public final function SetVariableStringRef(string Path, stringref sr)
{
    SetVariableString(Path, UIStrRef(sr));
}
public final function StartHandlingKeyPresses()
{
    m_bHandleKeyPresses = TRUE;
}
public final function StopHandlingKeyPresses()
{
    m_bHandleKeyPresses = FALSE;
}
public static final function string UIStrRef(stringref sr)
{
    if (sr != 0)
    {
        return "$" $ int(sr);
    }
    return "";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_UIWorldMPPawnInitialRotation = {Pitch = 0, Yaw = 33628, Roll = 0}
    m_UIWorldMPPawnInitialLocation = {X = -1195.83911, Y = -1702.15491, Z = 9.99999237}
    m_srNuiSpeechCommandFormatting = $720492
    MovieAlpha = 100.0
    m_bUseThumbstickAsDPad = TRUE
    m_bMouseVisibleWhenFocused = TRUE
    m_InputEnabled = TRUE
    ScreenLayout = GUILayout.GUILayout_XBox
}