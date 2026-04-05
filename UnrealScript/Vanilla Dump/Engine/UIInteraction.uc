Class UIInteraction extends Interaction within GameViewportClient
    native
    transient
    config(UI);

struct native transient UIAxisEmulationData extends UIKeyRepeatData 
{
    var init bool bEnabled;
};
struct native transient UIKeyRepeatData 
{
    var init Double NextRepeatTime;
    var init Name CurrentRepeatKey;
};
const DEFAULT_UISKIN = "DefaultUISkin.DefaultSkin";

var const native noexport Pointer VfTable_FExec;
var const native noexport Pointer VfTable_FGlobalDataStoreClientManager;
var const native noexport Pointer VfTable_FCallbackEventDevice;
var transient UIAxisEmulationData AxisInputEmulation[4];
var const transient UIKeyRepeatData MouseButtonRepeatInfo;
var config string UISkinName;
var config array<Name> UISoundCueNames;
var transient array<Name> SupportedDoubleClickKeys;
var Class<GameUISceneClient> SceneClientClass;
var const transient native Pointer CanvasScene;
var const transient native Object WidgetInputAliasLookupTable;
var const transient native Object AxisEmulationDefinitions;
var const transient GameUISceneClient SceneClient;
var const transient DataStoreClient DataStoreManager;
var const transient UIInputConfiguration UIInputConfig;
var const config float UIJoystickDeadZone;
var const config float UIAxisMultiplier;
var const config float AxisRepeatDelay;
var const config float MouseButtonRepeatDelay;
var const config float DoubleClickTriggerSeconds;
var const config int DoubleClickPixelTolerance;
var const config float ToolTipInitialDelaySeconds;
var const config float ToolTipExpirationSeconds;
var const transient bool bProcessInput;
var const config bool bDisableToolTips;
var const config bool bFocusOnActive;
var const config bool bFocusedStateRules;
var const transient bool bIsUIPrimitiveSceneInitialized;

public static final event function bool CanPlayOnline(int ControllerId)
{
    local EFeaturePrivilegeLevel Result;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Result = EFeaturePrivilegeLevel.FPL_Disabled;
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        if (PlayerInterface != None)
        {
            Result = PlayerInterface.CanPlayOnline(byte(ControllerId));
        }
    }
    return Result != EFeaturePrivilegeLevel.FPL_Disabled;
}
public final native function coerce UIScene CreateScene(Class<UIScene> SceneClass, optional Name SceneTag, optional UIScene SceneTemplate);

public final native function coerce UIObject CreateTransientWidget(Class<UIObject> WidgetClass, Name WidgetTag, optional UIObject Owner);

public static final native function DataStoreClient GetDataStoreClient();

public static final event function ELoginStatus GetLoginStatus(int ControllerId)
{
    local ELoginStatus Result;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    
    Result = ELoginStatus.LS_NotLoggedIn;
    if (ControllerId != -1)
    {
        OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
        if (OnlineSub != None)
        {
            PlayerInterface = OnlineSub.PlayerInterface;
            if (PlayerInterface != None)
            {
                Result = PlayerInterface.GetLoginStatus(byte(ControllerId));
            }
        }
    }
    return Result;
}
public static final event function ENATType GetNATType()
{
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInterface;
    local ENATType Result;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        SystemInterface = OnlineSub.SystemInterface;
        if (SystemInterface != None)
        {
            Result = SystemInterface.GetNATType();
        }
    }
    return Result;
}
public static final native function int GetPlayerControllerId(int PlayerIndex);

public static final native function int GetPlayerCount();

public static final native function int GetPlayerIndex(int ControllerId);

public static final event function bool HasLinkConnection()
{
    local bool bResult;
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInterface;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        SystemInterface = OnlineSub.SystemInterface;
        if (SystemInterface != None)
        {
            bResult = SystemInterface.HasLinkConnection();
        }
    }
    return bResult;
}
public static final function bool IsGamepadConnected(int ControllerId)
{
    local bool bResult;
    local OnlineSubsystem OnlineSub;
    local OnlineSystemInterface SystemInterface;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        SystemInterface = OnlineSub.SystemInterface;
        if (SystemInterface != None)
        {
            bResult = SystemInterface.IsControllerConnected(ControllerId);
        }
    }
    return bResult;
}
public static final event function bool IsLoggedIn(int ControllerId, optional bool bRequireOnlineLogin)
{
    local bool bResult;
    local ELoginStatus LoginStatus;
    
    LoginStatus = GetLoginStatus(ControllerId);
    bResult = LoginStatus == ELoginStatus.LS_LoggedIn || LoginStatus == ELoginStatus.LS_UsingLocalProfile && !bRequireOnlineLogin;
    return bResult;
}
public function NotifyGameSessionEnded()
{
    if (SceneClient != None)
    {
        SceneClient.NotifyGameSessionEnded();
    }
    if (DataStoreManager != None)
    {
        DataStoreManager.NotifyGameSessionEnded();
    }
    if (UIInputConfig != None)
    {
        UIInputConfig.NotifyGameSessionEnded();
    }
}
public final native function bool PlayUISound(Name SoundCueName, optional int PlayerIndex = 0);

public final function SetMousePosition(int NewMouseX, int NewMouseY)
{
    SceneClient.SetMousePosition(NewMouseX, NewMouseY);
}
public function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
    local UIAxisEmulationData Empty;
    
    if (PlayerIndex >= 0 && PlayerIndex < 4)
    {
        Empty.CurrentRepeatKey = 'None';
        AxisInputEmulation[PlayerIndex] = Empty;
    }
    if (SceneClient != None)
    {
        SceneClient.NotifyPlayerAdded(PlayerIndex, AddedPlayer);
    }
}
public function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
    local int PlayerCount;
    local int NextPlayerIndex;
    local int i;
    local UIAxisEmulationData Empty;
    
    if (PlayerIndex >= 0 && PlayerIndex < 4)
    {
        PlayerCount = GetPlayerCount();
        assert(PlayerCount < 4);
        for (i = PlayerIndex; i < PlayerCount; i++)
        {
            NextPlayerIndex = i + 1;
            AxisInputEmulation[i].NextRepeatTime = AxisInputEmulation[NextPlayerIndex].NextRepeatTime;
            AxisInputEmulation[i].CurrentRepeatKey = AxisInputEmulation[NextPlayerIndex].CurrentRepeatKey;
            AxisInputEmulation[i].bEnabled = AxisInputEmulation[NextPlayerIndex].bEnabled;
        }
        Empty.CurrentRepeatKey = 'None';
        AxisInputEmulation[PlayerCount] = Empty;
    }
    if (SceneClient != None)
    {
        SceneClient.NotifyPlayerRemoved(PlayerIndex, RemovedPlayer);
    }
}
public final function bool CanAllPlayOnline()
{
    local int PlayerIndex;
    
    for (PlayerIndex = 0; PlayerIndex < Outer.Outer.GamePlayers.Length; PlayerIndex++)
    {
        if (!CanPlayOnline(Outer.Outer.GamePlayers[PlayerIndex].ControllerId))
        {
            return FALSE;
        }
    }
    return TRUE;
}
public static final function int GetConnectedGamepadCount(optional array<bool> ControllerConnectionStatusOverrides)
{
    local int i;
    local int Result;
    
    for (i = 0; i < 4; i++)
    {
        if (i < ControllerConnectionStatusOverrides.Length)
        {
            if (ControllerConnectionStatusOverrides[i])
            {
                Result++;
            }
            continue;
        }
        if (IsGamepadConnected(i))
        {
            Result++;
        }
    }
    return Result;
}
public static final function LocalPlayer GetLocalPlayer(int PlayerIndex)
{
    local UIInteraction UIController;
    local LocalPlayer Result;
    
    UIController = Class'UIRoot'.static.GetCurrentUIController();
    if (UIController != None && PlayerIndex >= 0 && PlayerIndex < UIController.Outer.Outer.GamePlayers.Length)
    {
        Result = UIController.Outer.Outer.GamePlayers[PlayerIndex];
    }
    return Result;
}
public static final function int GetLoggedInPlayerCount(optional bool bRequireOnlineLogin)
{
    local int ControllerId;
    local int Result;
    
    for (ControllerId = 0; ControllerId < 4; ControllerId++)
    {
        if (IsLoggedIn(ControllerId, bRequireOnlineLogin))
        {
            Result++;
        }
    }
    return Result;
}
public final function ELoginStatus GetLowestLoginStatusOfControllers()
{
    local ELoginStatus Result;
    local ELoginStatus LoginStatus;
    local int PlayerIndex;
    
    Result = ELoginStatus.LS_LoggedIn;
    for (PlayerIndex = 0; PlayerIndex < Outer.Outer.GamePlayers.Length; PlayerIndex++)
    {
        LoginStatus = GetLoginStatus(Outer.Outer.GamePlayers[PlayerIndex].ControllerId);
        if (int(LoginStatus) < int(Result))
        {
            Result = LoginStatus;
        }
    }
    return Result;
}
public static final function int GetNumGuestsLoggedIn()
{
    local OnlineSubsystem OnlineSub;
    local int ControllerId;
    local int GuestCount;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None && OnlineSub.PlayerInterface != None)
    {
        for (ControllerId = 0; ControllerId < 4; ControllerId++)
        {
            if (OnlineSub.PlayerInterface.IsGuestLogin(byte(ControllerId)))
            {
                GuestCount++;
            }
        }
    }
    return GuestCount;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AxisInputEmulation[0] = {
                             bEnabled = TRUE, 
                             NextRepeatTime = {}, 
                             CurrentRepeatKey = 'None'
                            }
    AxisInputEmulation[1] = {
                             bEnabled = TRUE, 
                             NextRepeatTime = {}, 
                             CurrentRepeatKey = 'None'
                            }
    AxisInputEmulation[2] = {
                             bEnabled = TRUE, 
                             NextRepeatTime = {}, 
                             CurrentRepeatKey = 'None'
                            }
    AxisInputEmulation[3] = {
                             bEnabled = TRUE, 
                             NextRepeatTime = {}, 
                             CurrentRepeatKey = 'None'
                            }
    UISkinName = "DefaultUISkin.DefaultSkin"
    UISoundCueNames = ('GenericError', 
                       'MouseEnter', 
                       'MouseExit', 
                       'Clicked', 
                       'Focused', 
                       'SceneOpened', 
                       'SceneClosed', 
                       'ListSubmit', 
                       'ListUp', 
                       'ListDown', 
                       'SliderIncrement', 
                       'SliderDecrement', 
                       'NavigateUp', 
                       'NavigateDown', 
                       'NavigateLeft', 
                       'NavigateRight', 
                       'CheckboxChecked', 
                       'CheckboxUnchecked'
                      )
    SceneClientClass = Class'GameUISceneClient'
    UIJoystickDeadZone = 0.899999976
    UIAxisMultiplier = 1.0
    AxisRepeatDelay = 0.200000003
    MouseButtonRepeatDelay = 0.150000006
    DoubleClickTriggerSeconds = 0.5
    DoubleClickPixelTolerance = 1
    ToolTipInitialDelaySeconds = 0.25
    ToolTipExpirationSeconds = 5.0
}