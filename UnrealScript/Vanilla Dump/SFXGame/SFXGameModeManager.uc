Class SFXGameModeManager within BioPlayerController
    native
    config(Game);

struct native LocalizedKeyName 
{
    var Name Key;
    var stringref Name;
};
enum ESpeechContext
{
    SpeechContext_Combat,
    SpeechContext_Explore,
    SpeechContext_Global,
    SpeechContext_Conversation,
};
enum EGameModes
{
    GameMode_Default,
    GameMode_Vehicle,
    GameMode_Atlas,
    GameMode_PowerWheel,
    GameMode_WeaponWheel,
    GameMode_Command,
    GameMode_InjuredShepard,
    GameMode_Conversation,
    GameMode_Cinematic,
    GameMode_GUI,
    GameMode_Movie,
    GameMode_Galaxy,
    GameMode_Orbital,
    GameMode_MultiLand,
    GameMode_CheatMenu,
    GameMode_AIDebug,
    GameMode_Prototyping,
    GameMode_DreamSequence,
    GameMode_IllusiveManConflict,
    GameMode_Spectator,
    GameMode_Dying,
    GameMode_FlyCam,
    GameMode_ReplicationDebug,
    GameMode_Lobby,
};

var array<Class<SFXGameModeBase>> SupportedModes;
var transient array<SFXGameModeBase> GameModes;
var config array<LocalizedKeyName> KeyNames;
var string sAudioGameModeRTPCName;
var bool bDisableInput;
var transient EGameModes CurrentMode;

public final native function bool AllowPowerWeaponUI();

public final native function bool AllowRotationUpdates();

public final native function bool AllowsCameraMods();

public final native function bool AllowsHints();

public final native function bool AllowsMovement();

public final native function bool AllowsSaving();

public event function DisableMode(EGameModes mode, optional Name ModeSpecifier)
{
    local SFXGameModeBase GameMode;
    
    GameMode = GameModes[int(mode)];
    if (GameMode != None)
    {
        GameMode.DeactivateSpecifier(ModeSpecifier);
        if (GameMode.bIsActive)
        {
            ResetKeyPresses();
            GameMode.Deactivated();
        }
        if (int(mode) == int(CurrentMode))
        {
            UpdateCurrentMode();
            return;
        }
    }
}
public event function EnableMode(EGameModes mode, optional Name ModeSpecifier)
{
    local SFXGameModeBase GameMode;
    
    GameMode = GameModes[int(mode)];
    if (GameMode != None)
    {
        GameMode.ActivateSpecifier(ModeSpecifier);
        if (GameMode.bIsActive == FALSE)
        {
            GameMode.Activated();
        }
        if (int(mode) != int(CurrentMode))
        {
            if (IsPlayMode(CurrentMode))
            {
                ResetKeyPresses();
            }
            UpdateCurrentMode();
            return;
        }
    }
}
public event function EGameModes GetDefaultMode()
{
    return EGameModes.GameMode_Default;
}
public final native function string GetLocalizedNameForKey(Name Key, bool Control, bool Shift, bool Alt);

public final native function bool GetMouseVisible();

public final event function HACK_BeginExitGalaxyMap(bool resize)
{
    SFXGameModeGalaxy(GameModes[int(CurrentMode)]).BeginExitGalaxyMap(resize);
}
public final event function bool HACK_CanExitGalaxyMode()
{
    return SFXGameModeGalaxy(GameModes[int(CurrentMode)]).CanExit();
}
public final native function SFXCameraMode HACK_GetCameraMode(EGameModes GalaxyOrConversationMode);

public final event function SFXGameModeBase HACK_GetMultiLandMode()
{
    return GameModes[13];
}
public final native function bool HasMouseAuthority();

public final native function Initialize();

public final native function bool IsActive(EGameModes mode);

public event function bool IsPlayMode(EGameModes mode)
{
    return mode == EGameModes.GameMode_Default || mode == EGameModes.GameMode_Vehicle || mode == EGameModes.GameMode_Atlas;
}
public final native function ResetBindings();

public final native function ResetKeyPresses();

public final native function bool ShouldAllowMessageUI();

public final native function bool ShouldEnforce16x9Subtitles();

public final native function bool ShouldMergeNotifications();

public final native function bool ShouldPlayVocalizations();

public final native function bool ShouldQueueAndSuppressNotifications();

public final native function bool ShouldRestrictToPrimaryViewport();

public final native function bool ShouldShowDamageIndicators();

public final native function bool ShouldShowExplorationSelection();

public final native function bool ShouldShowHealth();

public final native function bool ShouldShowHUD();

public final native function bool ShouldShowRadar();

public final native function bool ShouldShowReticles();

public final native function bool ShouldShowSelection();

public final native function bool ShouldShowSubtitles();

public final native function bool ShouldShowWeapon();

public final native function bool StopsMovement();

public final native function UpdateAllBindMappingCollections();

public native function UpdateCurrentAudioMode();

public native function UpdateCurrentMode();

public final function bool AllowCameraUpdates()
{
    return GameModes[int(CurrentMode)].bAllowCamera;
}
public final function Console_RestoreBindingsToDefaults()
{
    ResetBindings();
}
public final function Console_UpdatePS3ButtonSwapping(bool bSwapCrossCircle)
{
    local SFXGameModeBase mode;
    local int ModeType;
    
    Helper_SetStaticConsoleBinding('XboxTypeS_B', bSwapCrossCircle ? "GuiKey BIOGUI_EVENT_BUTTON_A | OnRelease GuiKey BIOGUI_EVENT_BUTTON_A_RELEASE" : "GuiKey BIOGUI_EVENT_BUTTON_B | OnRelease GuiKey BIOGUI_EVENT_BUTTON_B_RELEASE");
    Helper_SetStaticConsoleBinding('XboxTypeS_A', bSwapCrossCircle ? "GuiKey BIOGUI_EVENT_BUTTON_B | OnRelease GuiKey BIOGUI_EVENT_BUTTON_B_RELEASE" : "GuiKey BIOGUI_EVENT_BUTTON_A | OnRelease GuiKey BIOGUI_EVENT_BUTTON_A_RELEASE");
    foreach GameModes(mode, ModeType)
    {
        switch (ModeType)
        {
            case 7:
                Helper_SetBinding(mode, 'XboxTypeS_A', bSwapCrossCircle ? "" : "Shared_ConvSelect");
                Helper_SetBinding(mode, 'XboxTypeS_B', bSwapCrossCircle ? "Shared_ConvSelect" : "");
                break;
            case 11:
                Helper_SetBinding(mode, 'XboxTypeS_A', bSwapCrossCircle ? "" : "Console_BuyFuel");
                Helper_SetBinding(mode, 'XboxTypeS_B', bSwapCrossCircle ? "Console_BuyFuel" : "");
                break;
            case 9:
                Helper_SetBinding(mode, 'XboxTypeS_A', bSwapCrossCircle ? "Shared_ExitSlideshow" : "");
                Helper_SetBinding(mode, 'XboxTypeS_B', bSwapCrossCircle ? "" : "Shared_ExitSlideshow");
                break;
            default:
        }
    }
}
public final function Console_UpdateStickBindings(EStickConfigOptions ConfigOption)
{
    local SFXGameModeBase mode;
    local int ModeType;
    
    foreach GameModes(mode, ModeType)
    {
        switch (ModeType)
        {
            case 0:
            case 3:
            case 4:
            case 1:
            case 2:
            case 11:
            case 12:
            case 6:
            case 17:
                if (ConfigOption == EStickConfigOptions.SCO_SouthPaw)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftX', "Console_LookX");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftY', "Console_LookY_Invert");
                    Helper_SetBinding(mode, 'XboxTypeS_RightX', "Console_Strafe");
                    Helper_SetBinding(mode, 'XboxTypeS_RightY', "Console_Movement_Invert");
                }
                break;
            default:
        }
    }
}
public final function Console_UpdateTriggerAndShoulderBindings(ETriggerConfigOptions ConfigOption)
{
    local SFXGameModeBase mode;
    local ETriggerConfigOptions eSouthpawConfig;
    local bool bSwapTriggersShoulders;
    local int ModeType;
    
    eSouthpawConfig = ConfigOption == ETriggerConfigOptions.TCO_Default || ConfigOption == ETriggerConfigOptions.TCO_DefaultSwapped ? ETriggerConfigOptions.TCO_Default : ETriggerConfigOptions.TCO_SouthPaw;
    bSwapTriggersShoulders = ConfigOption == ETriggerConfigOptions.TCO_DefaultSwapped || ConfigOption == ETriggerConfigOptions.TCO_SouthPawSwapped ? TRUE : FALSE;
    foreach GameModes(mode, ModeType)
    {
        switch (ModeType)
        {
            case 0:
                if (eSouthpawConfig == ETriggerConfigOptions.TCO_Default)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "Shared_Aim" : "Console_WeaponWheelAndQuickPower1");
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "Shared_Shoot" : "Console_PowerWheelAndQuickPower2");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "Console_WeaponWheelAndQuickPower1" : "Shared_Aim");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "Console_PowerWheelAndQuickPower2" : "Shared_Shoot");
                }
                else if (eSouthpawConfig == ETriggerConfigOptions.TCO_SouthPaw)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "Shared_Shoot" : "Console_PowerWheelAndQuickPower2");
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "Shared_Aim" : "Console_WeaponWheelAndQuickPower1");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "Console_PowerWheelAndQuickPower2" : "Shared_Shoot");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "Console_WeaponWheelAndQuickPower1" : "Shared_Aim");
                }
                break;
            case 1:
            case 2:
                if (eSouthpawConfig == ETriggerConfigOptions.TCO_Default)
                {
                    if (bSwapTriggersShoulders)
                    {
                        Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', "Console_WeaponWheelAndQuickPower1");
                        Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', "Console_PowerWheelAndQuickPower2");
                        Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', "Shared_Aim");
                        Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', "Shared_Shoot");
                    }
                    else
                    {
                        Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', "Shared_Aim");
                        Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', "Shared_Shoot");
                        Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', "Console_WeaponWheelAndQuickPower1");
                        Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', "Console_PowerWheelAndQuickPower2");
                    }
                }
                else if (eSouthpawConfig == ETriggerConfigOptions.TCO_SouthPaw)
                {
                    if (bSwapTriggersShoulders)
                    {
                        Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', "Console_PowerWheelAndQuickPower2");
                        Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', "Console_WeaponWheelAndQuickPower1");
                        Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', "Shared_Shoot");
                        Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', "Shared_Aim");
                    }
                    else
                    {
                        Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', "Shared_Shoot");
                        Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', "Shared_Aim");
                        Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', "Console_PowerWheelAndQuickPower2");
                        Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', "Console_WeaponWheelAndQuickPower1");
                    }
                }
                break;
            case 3:
                if (eSouthpawConfig == ETriggerConfigOptions.TCO_Default)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "" : "Console_ExitPowerWheel");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "Console_ExitPowerWheel" : "");
                }
                else if (eSouthpawConfig == ETriggerConfigOptions.TCO_SouthPaw)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "" : "Console_ExitPowerWheel");
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "Console_ExitPowerWheel" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "" : "");
                }
                break;
            case 4:
                if (eSouthpawConfig == ETriggerConfigOptions.TCO_Default)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "" : "Console_ExitWeaponWheel");
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "Console_ExitWeaponWheel" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "" : "");
                }
                else if (eSouthpawConfig == ETriggerConfigOptions.TCO_SouthPaw)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "" : "Console_ExitWeaponWheel");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "Console_ExitWeaponWheel" : "");
                }
                break;
            case 12:
                break;
            case 9:
            case 23:
                if (eSouthpawConfig == ETriggerConfigOptions.TCO_Default)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "Shared_MPToggleReady" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "" : "Shared_MPToggleReady");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "" : "");
                }
                else if (eSouthpawConfig == ETriggerConfigOptions.TCO_SouthPaw)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "Shared_MPToggleReady" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "" : "Shared_MPToggleReady");
                }
                break;
            case 19:
                Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "" : "ViewPrevPlayer true");
                Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "" : "ViewNextPlayer true");
                Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "ViewPrevPlayer true" : "");
                Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "ViewNextPlayer true" : "");
                break;
            case 6:
                if (eSouthpawConfig == ETriggerConfigOptions.TCO_Default)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "Shared_Aim" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "Shared_Shoot" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "" : "Shared_Aim");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "" : "Shared_Shoot");
                }
                else if (eSouthpawConfig == ETriggerConfigOptions.TCO_SouthPaw)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "Shared_Shoot" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "Shared_Aim" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "" : "Shared_Shoot");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "" : "Shared_Aim");
                }
                break;
            case 7:
                if (eSouthpawConfig == ETriggerConfigOptions.TCO_Default)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "Shared_ConvIntParagon" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "Shared_ConvIntRenegade" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "" : "Shared_ConvIntParagon");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "" : "Shared_ConvIntRenegade");
                }
                else if (eSouthpawConfig == ETriggerConfigOptions.TCO_SouthPaw)
                {
                    Helper_SetBinding(mode, 'XboxTypeS_LeftShoulder', bSwapTriggersShoulders ? "Shared_ConvIntRenegade" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_RightShoulder', bSwapTriggersShoulders ? "Shared_ConvIntParagon" : "");
                    Helper_SetBinding(mode, 'XboxTypeS_LeftTrigger', bSwapTriggersShoulders ? "" : "Shared_ConvIntRenegade");
                    Helper_SetBinding(mode, 'XboxTypeS_RightTrigger', bSwapTriggersShoulders ? "" : "Shared_ConvIntParagon");
                }
                break;
            default:
        }
    }
}
public final function DisableInput()
{
    bDisableInput = TRUE;
}
public final function EnableInput()
{
    bDisableInput = FALSE;
}
public final function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    local int i;
    local EGameModes DefaultMode;
    local SFXCameraMode mode;
    
    DefaultMode = GetDefaultMode();
    for (i = GameModes.Length - 1; i >= 0; i--)
    {
        if (i != int(DefaultMode) && !GameModes[i].bIsActive)
        {
            continue;
        }
        mode = GameModes[i].GetCameraMode(OldCameraMode, PreserveTarget, TransitionTime, Transition);
        if (mode != None)
        {
            return mode;
        }
    }
    return GameModes[int(DefaultMode)].GetCameraMode(OldCameraMode, PreserveTarget, TransitionTime, Transition);
}
public final function SFXGameModeBase HACK_GetOrbitalMode()
{
    return GameModes[12];
}
public final function Helper_ResetStaticConsoleBindings()
{
    local BioPlayerInput Input;
    
    Input = BioPlayerInput(Outer.PlayerInput);
    if (Input != None)
    {
        Input.StaticConsoleBinds = Class'BioPlayerInput'.default.StaticConsoleBinds;
    }
}
private final function Helper_SetBinding(SFXGameModeBase mode, Name Key, string Command)
{
    local int idx;
    local KeyBind NewBind;
    
    if (mode != None)
    {
        idx = mode.Bindings.Find('Name', Key);
        if (idx != -1)
        {
            mode.Bindings[idx].Command = Command;
        }
        else
        {
            NewBind.Name = Key;
            NewBind.Command = Command;
            mode.Bindings.AddItem(NewBind);
        }
    }
}
public final function Helper_SetStaticConsoleBinding(Name Key, string Command)
{
    local int idx;
    local StaticKeyBind NewBind;
    local BioPlayerInput Input;
    
    Input = BioPlayerInput(Outer.PlayerInput);
    if (Input != None)
    {
        idx = Input.StaticConsoleBinds.Find('Name', Key);
        if (idx != -1)
        {
            Input.StaticConsoleBinds[idx].Command = Command;
        }
        else
        {
            NewBind.Name = Key;
            NewBind.Command = Command;
            Input.StaticConsoleBinds.AddItem(NewBind);
        }
    }
}
private final function Helper_SwapBinding(SFXGameModeBase mode, Name KeyA, Name KeyB)
{
    local int IdxA;
    local int IdxB;
    local string CommandA;
    local string CommandB;
    
    IdxA = mode.Bindings.Find('Name', KeyA);
    IdxB = mode.Bindings.Find('Name', KeyB);
    if (IdxA != -1 || IdxB != -1)
    {
        if (IdxA != -1)
        {
            CommandA = mode.Bindings[IdxA].Command;
        }
        if (IdxB != -1)
        {
            CommandB = mode.Bindings[IdxB].Command;
        }
        Helper_SetBinding(mode, KeyA, CommandB);
        Helper_SetBinding(mode, KeyB, CommandA);
    }
}
public final function HideReticle()
{
    GameModes[int(CurrentMode)].bShowReticles = FALSE;
}
public final function bool IsInAnInteractiveGalaxyMode()
{
    if (CurrentMode == EGameModes.GameMode_Galaxy || CurrentMode == EGameModes.GameMode_Orbital || CurrentMode == EGameModes.GameMode_MultiLand)
    {
        if (GameModes[8].bIsActive)
        {
            return FALSE;
        }
        return TRUE;
    }
    return FALSE;
}
public final function LogKeyBindings()
{
    local int Index;
    local SFXGameModeBase GameMode;
    
    GameMode = GameModes[int(CurrentMode)];
    if (GameMode != None)
    {
        for (Index = 0; Index < GameMode.Bindings.Length; Index++)
        {
        }
    }
}
public final function ResetReticles()
{
    local int i;
    
    for (i = 0; i < GameModes.Length; i++)
    {
        GameModes[i].bShowReticles = GameModes[i].default.bShowReticles;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SupportedModes = (Class'SFXGameModeDefault', 
                      Class'SFXGameModeVehicle', 
                      Class'SFXGameModeAtlas', 
                      Class'SFXGameModePowerWheel', 
                      Class'SFXGameModeWeaponWheel', 
                      Class'SFXGameModeCommand', 
                      Class'SFXGameModeInjuredShepard', 
                      Class'SFXGameModeConversation', 
                      Class'SFXGameModeCinematic', 
                      Class'SFXGameModeGUI', 
                      Class'SFXGameModeMovie', 
                      Class'SFXGameModeGalaxy', 
                      Class'SFXGameModeOrbital', 
                      Class'SFXGameModeMultiLand', 
                      Class'SFXGameModeCheatMenu', 
                      Class'SFXGameModeAIDebug', 
                      Class'SFXGameModeProto', 
                      Class'SFXGameModeDreamSequence', 
                      Class'SFXGameModeIllusiveManConflict', 
                      Class'SFXGameModeSpectator', 
                      Class'SFXGameModeDying', 
                      Class'SFXGameModeFlyCam', 
                      Class'SFXGameModeReplicationDebug', 
                      Class'SFXGameModeLobby'
                     )
    KeyNames = ({Key = 'LeftMouseButton', Name = $174716}, 
                {Key = 'RightMouseButton', Name = $174800}, 
                {Key = 'MiddleMouseButton', Name = $174728}, 
                {Key = 'ThumbMouseButton', Name = $351135}, 
                {Key = 'ThumbMouseButton2', Name = $351136}, 
                {Key = 'BackSpace', Name = $174629}, 
                {Key = 'Tab', Name = $174834}, 
                {Key = 'Enter', Name = $174663}, 
                {Key = 'Pause', Name = $174771}, 
                {Key = 'CapsLock', Name = $174635}, 
                {Key = 'Escape', Name = $174665}, 
                {Key = 'SpaceBar', Name = $174820}, 
                {Key = 'PageUp', Name = $174769}, 
                {Key = 'PageDown', Name = $174768}, 
                {Key = 'End', Name = $174661}, 
                {Key = 'Home', Name = $174697}, 
                {Key = 'Left', Name = $174713}, 
                {Key = 'Up', Name = $174846}, 
                {Key = 'Right', Name = $174797}, 
                {Key = 'Down', Name = $174652}, 
                {Key = 'Insert', Name = $174706}, 
                {Key = 'Delete', Name = $174647}, 
                {Key = 'Zero', Name = $174565}, 
                {Key = 'One', Name = $174566}, 
                {Key = 'Two', Name = $174567}, 
                {Key = 'Three', Name = $174568}, 
                {Key = 'Four', Name = $174569}, 
                {Key = 'Five', Name = $174570}, 
                {Key = 'Six', Name = $174571}, 
                {Key = 'Seven', Name = $174572}, 
                {Key = 'Eight', Name = $174573}, 
                {Key = 'Nine', Name = $174574}, 
                {Key = 'A', Name = $174595}, 
                {Key = 'B', Name = $174625}, 
                {Key = 'C', Name = $174632}, 
                {Key = 'D', Name = $174644}, 
                {Key = 'E', Name = $174657}, 
                {Key = 'F', Name = $174666}, 
                {Key = 'G', Name = $174685}, 
                {Key = 'H', Name = $174693}, 
                {Key = 'i', Name = $174698}, 
                {Key = 'J', Name = $174709}, 
                {Key = 'K', Name = $174711}, 
                {Key = 'L', Name = $174712}, 
                {Key = 'M', Name = $174724}, 
                {Key = 'N', Name = $174740}, 
                {Key = 'o', Name = $174764}, 
                {Key = 'P', Name = $174767}, 
                {Key = 'Q', Name = $174778}, 
                {Key = 'R', Name = $174791}, 
                {Key = 'S', Name = $174807}, 
                {Key = 'T', Name = $174833}, 
                {Key = 'U', Name = $174844}, 
                {Key = 'V', Name = $174847}, 
                {Key = 'W', Name = $174850}, 
                {Key = 'X', Name = $174856}, 
                {Key = 'Y', Name = $174858}, 
                {Key = 'Z', Name = $174860}, 
                {Key = 'NumPadZero', Name = $174754}, 
                {Key = 'NumPadOne', Name = $174755}, 
                {Key = 'NumPadTwo', Name = $174756}, 
                {Key = 'NumPadThree', Name = $174757}, 
                {Key = 'NumPadFour', Name = $174758}, 
                {Key = 'NumPadFive', Name = $174759}, 
                {Key = 'NumPadSix', Name = $174760}, 
                {Key = 'NumPadSeven', Name = $174761}, 
                {Key = 'NumPadEight', Name = $174762}, 
                {Key = 'NumPadNine', Name = $174763}, 
                {Key = 'Multiply', Name = $174750}, 
                {Key = 'Add', Name = $174753}, 
                {Key = 'Subtract', Name = $174749}, 
                {Key = 'Decimal', Name = $174751}, 
                {Key = 'Divide', Name = $174752}, 
                {Key = 'F1', Name = $174667}, 
                {Key = 'F2', Name = $174671}, 
                {Key = 'F3', Name = $174672}, 
                {Key = 'F4', Name = $174673}, 
                {Key = 'F5', Name = $174674}, 
                {Key = 'F6', Name = $174675}, 
                {Key = 'F7', Name = $174676}, 
                {Key = 'F8', Name = $174677}, 
                {Key = 'F9', Name = $174678}, 
                {Key = 'F10', Name = $174668}, 
                {Key = 'F11', Name = $174669}, 
                {Key = 'F12', Name = $174670}, 
                {Key = 'NumLock', Name = $174748}, 
                {Key = 'ScrollLock', Name = $174808}, 
                {Key = 'LeftShift', Name = $174717}, 
                {Key = 'RightShift', Name = $174801}, 
                {Key = 'LeftControl', Name = $174715}, 
                {Key = 'RightControl', Name = $174799}, 
                {Key = 'LeftAlt', Name = $174714}, 
                {Key = 'RightAlt', Name = $174798}, 
                {Key = 'Semicolon', Name = $174580}, 
                {Key = 'Equals', Name = $174575}, 
                {Key = 'Comma', Name = $174577}, 
                {Key = 'Underscore', Name = $176064}, 
                {Key = 'Period', Name = $174578}, 
                {Key = 'Slash', Name = $174579}, 
                {Key = 'Tilde', Name = $174585}, 
                {Key = 'LeftBracket', Name = $174581}, 
                {Key = 'Backslash', Name = $174582}, 
                {Key = 'RightBracket', Name = $174583}, 
                {Key = 'Quote', Name = $174576}, 
                {Key = 'XboxTypeS_A', Name = $176045}, 
                {Key = 'XboxTypeS_B', Name = $176046}, 
                {Key = 'XboxTypeS_X', Name = $176047}, 
                {Key = 'XboxTypeS_Y', Name = $176048}, 
                {Key = 'XboxTypeS_LeftShoulder', Name = $174718}, 
                {Key = 'XboxTypeS_RightShoulder', Name = $174806}, 
                {Key = 'XboxTypeS_LeftTrigger', Name = $174720}, 
                {Key = 'XboxTypeS_RightTrigger', Name = $174802}, 
                {Key = 'XboxTypeS_Back', Name = $174628}, 
                {Key = 'XboxTypeS_Start', Name = $174829}, 
                {Key = 'XboxTypeS_LeftThumbstick', Name = $174637}, 
                {Key = 'XboxTypeS_RightThumbstick', Name = $174638}, 
                {Key = 'XboxTypeS_DPad_Up', Name = $174656}, 
                {Key = 'XboxTypeS_DPad_Down', Name = $174653}, 
                {Key = 'XboxTypeS_DPad_Right', Name = $174655}, 
                {Key = 'XboxTypeS_DPad_Left', Name = $174654}, 
                {Key = 'XboxTypeS_LeftX', Name = $174719}, 
                {Key = 'XboxTypeS_LeftY', Name = $174805}, 
                {Key = 'XboxTypeS_RightX', Name = $174803}, 
                {Key = 'XboxTypeS_RightY', Name = $174804}, 
                {Key = 'MouseScrollUp', Name = $283289}, 
                {Key = 'MouseScrollDown', Name = $283290}
               )
    sAudioGameModeRTPCName = "Audio_Game_Mode"
}