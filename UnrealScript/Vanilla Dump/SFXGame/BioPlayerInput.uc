Class BioPlayerInput extends PlayerInput within BioPlayerController
    native
    transient
    config(Input);

struct native InputOverride 
{
    var string Alias;
    var delegate<InputDelegate> InputDelegate;
    var bool bPress;
    var bool bExclusive;
};
struct native DebugMenuEntry 
{
    var string Name;
    var string Command;
};
struct native StaticKeyBind 
{
    var string Command;
    var Name Name;
    var bool Control;
    var bool Shift;
    var bool Alt;
    var bool bDebug;
};
enum EAxisBuffer
{
    AxisBuffer_LX,
    AxisBuffer_LY,
    AxisBuffer_RX,
    AxisBuffer_RY,
    AxisBuffer_MouseX,
    AxisBuffer_MouseY,
};

var transient native Map_Mirror InputTimers;
var InterpCurveFloat LookStickResponseCurve;
var transient InterpCurveFloat MouseDampeningCurve;
var(BioPlayerInput) array<StaticKeyBind> StaticConsoleBinds;
var(BioPlayerInput) array<StaticKeyBind> StaticPCBinds;
var array<StaticKeyBind> m_aFlyCamConsoleBinds;
var config array<DebugMenuEntry> DebugMenu;
var array<DebugMenuEntry> DebugSubMenu;
var transient array<InputOverride> InputOverrides;
var delegate<InputDelegate> __InputDelegate__Delegate;
var float AxisBuffer[6];
var float LastAxisBuffer[6];
var transient Vector LookStick;
var transient Vector MoveStick;
var Vector AccumulatedAimVector;
var transient Name m_nmMappedPower;
var transient Name m_nmMappedPower2;
var transient Name m_nmMappedPower3;
var transient Name m_nmMappedPower4;
var transient Name m_nmMappedPower5;
var transient Name m_nmMappedPower6;
var transient Name m_nmMappedPower7;
var input float aGuiStrafe;
var input float aGuiBaseY;
var input float aGuiTurn;
var input float aGuiLookUp;
var input float aGuiMouseX;
var input float aGuiMouseY;
var transient float MoveStickMag;
var transient float LookStickMag;
var config float GuiDeadzone;
var transient int m_KeyInputDisabled;
var transient float TimeSinceLastActivity;
var transient int m_nCurConvSelection;
var transient float m_fConversationReplyLeftRight;
var transient float m_fConversationReplyUpDown;
var config transient float m_fQuickOrderTime;
var float AccumulatedRotationSpeed;
var const float AccumulatedRotationDecayRate;
var transient int CoverRemapThresholdPC;
var transient int CoverRemapThreshold;
var(BioPlayerInput) float GlobalStickFactor;
var config bool bUseMouseDampening;
var input byte bWantsToZoom;

public event function CancelReload()
{
    if (SFXWeapon(Outer.Pawn.Weapon) != None)
    {
        SFXWeapon(Outer.Pawn.Weapon).CancelReload();
    }
}
public final native function DebugExecInputCommands(string Cmd, bool bButtonPressed);

public native function string GetBind(const out Name Key, bool Control, bool Shift, bool Alt);

public event function bool GetInputDisabled()
{
    return Outer.IsLookInputIgnored() && Outer.IsMoveInputIgnored() && IsKeyInputIgnored();
}
public native function IgnoreKeyInput(bool bValue);

public delegate function InputDelegate(string Alias, bool bPress);

public final native function bool IsCombatEnabled();

public static final simulated native function bool IsEnterMenuButtonAssignmentSwapped();

public native function bool IsKeyInputIgnored();

public event function PlayerInput(float DeltaTime)
{
    local Vector CamLoc;
    local Rotator CamRot;
    local float Temp;
    
    if (SFXPlayerCamera(Outer.PlayerCamera).CurrentCameraMode != None && SFXPlayerCamera(Outer.PlayerCamera).CurrentCameraMode.Input.bSwitchSticks)
    {
        Temp = RawJoyRight;
        RawJoyRight = RawJoyLookRight;
        RawJoyLookRight = Temp;
        Temp = aTurn;
        aTurn = aStrafe;
        aStrafe = Temp;
    }
    Super.PlayerInput(DeltaTime);
    UpdateViewRotation(DeltaTime);
    Outer.RemappedJoyRight = RawJoyRight;
    Outer.RemappedJoyUp = RawJoyUp;
    LookStick.X = RawJoyLookUp;
    LookStick.Y = RawJoyLookRight;
    LookStickMag = VSize2D(LookStick);
    MoveStick.X = RawJoyUp;
    MoveStick.Y = RawJoyRight;
    MoveStickMag = VSize2D(MoveStick);
    if (Outer.IsInCoverState() && BioPawn(Outer.Pawn) != None)
    {
        Outer.GetPlayerViewPoint(CamLoc, CamRot);
        RemapControlsByRotation(Normalize(Outer.Pawn.Rotation - CamRot), Outer.RemappedJoyRight, Outer.RemappedJoyUp);
    }
}
public event function SetInputDisabled(bool bValue)
{
    Outer.IgnoreLookInput(bValue);
    Outer.IgnoreMoveInput(bValue);
    IgnoreKeyInput(bValue);
}
public function AdjustMouseSensitivity(float FOVScale)
{
    local SFXCameraInput Input;
    
    Super.AdjustMouseSensitivity(FOVScale);
    if (SFXPlayerCamera(Outer.PlayerCamera).CurrentCameraMode != None)
    {
        Input = SFXPlayerCamera(Outer.PlayerCamera).CurrentCameraMode.Input;
        if (Input != None)
        {
            aMouseX *= Input.CameraSensitivity.X;
            aMouseY *= Input.CameraSensitivity.Y;
            if (Input.bClampMouse)
            {
                aMouseX = FClamp(aMouseX, -Input.MouseClampMax, Input.MouseClampMax);
                aMouseY = FClamp(aMouseY, -Input.MouseClampMax, Input.MouseClampMax);
            }
        }
    }
}
public function PostProcessInput(float DeltaTime)
{
    local BioPawn BP;
    local SFXVehicle_MountedGun MG;
    local bool bForceNoZoom;
    local bool bForceZoom;
    local BioCustomAction CA;
    
    if (Outer.Pawn == None)
    {
        return;
    }
    if (Outer.Pawn.Controller != None && Outer.Pawn.Controller.IsInState('PlayerDriving', ) == FALSE && Outer.Pawn.Physics == EPhysics.PHYS_RigidBody)
    {
        bWantsToZoom = 0;
        Outer.bFire = 0;
    }
    if (Outer.Pawn.Weapon != None)
    {
        BP = BioPawn(Outer.Pawn);
        if (BP != None)
        {
            BP.GetCurrentCustomAction(CA);
            if (Outer.IsReloading() || int(Outer.bWantsToStorm) == 1 || BP.Weapon.IsInState('WeaponEquipping', ) || BP.Weapon.IsInState('WeaponPuttingDown', ) || BP.m_bPowerInvokedLeanOut == TRUE)
            {
                bForceNoZoom = TRUE;
            }
            else if (BP.IsPerformingCustomAction(TRUE))
            {
                bForceNoZoom = TRUE;
            }
            else if (CA != None && CA.bTurnOffZoom)
            {
                bForceNoZoom = TRUE;
            }
            else if (BP.IsInCover())
            {
                if (BP.CoverAction == ECoverAction.CA_Default || !BP.CanDoCoverAction(5, TRUE, TRUE) && !BP.CanDoCoverAction(3, TRUE, TRUE) && !BP.CanDoCoverAction(4, TRUE, TRUE))
                {
                    bForceNoZoom = TRUE;
                }
            }
        }
        MG = SFXVehicle_MountedGun(Outer.Pawn);
        if (MG != None && MG.bForceTightAim)
        {
            bForceZoom = TRUE;
        }
        if ((int(bWantsToZoom) == 0 || bForceNoZoom) && !bForceZoom)
        {
            if (BP.IsInCover() && SFXWeapon(BP.Weapon) != None && !SFXWeapon(BP.Weapon).CanPartialLean() && !BP.IsInAnimatedTransition() && (BP.CoverAction == ECoverAction.CA_PopUp || BP.CoverAction == ECoverAction.CA_LeanLeft || BP.CoverAction == ECoverAction.CA_LeanRight))
            {
                if (Outer.IsZoomed() == FALSE)
                {
                    Outer.SetZoomed(TRUE);
                }
            }
            else if (Outer.IsZoomed())
            {
                Outer.SetZoomed(FALSE);
            }
        }
        else if (bForceZoom)
        {
            if (Outer.IsZoomed() == FALSE)
            {
                Outer.SetZoomed(TRUE);
            }
        }
        else if (!bForceNoZoom && int(bWantsToZoom) != 0)
        {
            if (!BP.IsInCover() || !BP.IsBlindFiring() && BP.CoverAction == ECoverAction.CA_PopUp || !BP.IsInAnimatedTransition() && (BP.CoverAction == ECoverAction.CA_PeekLeft || BP.CoverAction == ECoverAction.CA_PeekRight))
            {
                if (Outer.IsZoomed() == FALSE)
                {
                    Outer.SetZoomed(TRUE);
                }
            }
        }
    }
}
public function PreProcessInput(float DeltaTime)
{
    local SFXEngine Engine;
    local SFXCameraInput Input;
    local float RawStickFactor;
    local float StickFactor;
    local float fRemappedX;
    local float fRemappedY;
    local float StickMag;
    local float X;
    local float Y;
    local int idx;
    local SFXGUIInteraction oSFXGUIInteraction;
    local int ControllerId;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    oSFXGUIInteraction = Class'SFXGUIInteraction'.static.GetInstance();
    ControllerId = Outer.GetPlayerControllerId();
    if (bUseMouseDampening)
    {
        Class'BioInterpolator'.static.InterpolateFloatCurve(fRemappedX, MouseDampeningCurve, 0.0, 1.0, Abs(aMouseX));
        Class'BioInterpolator'.static.InterpolateFloatCurve(fRemappedY, MouseDampeningCurve, 0.0, 1.0, Abs(aMouseY));
        aMouseX = (aMouseX > float(0) ? 1.0 : -1.0) * fRemappedX;
        aMouseY = (aMouseY > float(0) ? 1.0 : -1.0) * fRemappedY;
    }
    RawStickFactor = Sqrt(aTurn * aTurn + aLookUp * aLookUp);
    if (SFXPlayerCamera(Outer.PlayerCamera).CurrentCameraMode != None)
    {
        Input = SFXPlayerCamera(Outer.PlayerCamera).CurrentCameraMode.Input;
        if (Input != None && RawStickFactor > Input.StickDeadZone)
        {
            StickFactor = ComputeStickResponse(RawStickFactor, Input, DeltaTime) / RawStickFactor;
            aTurn = aTurn * Input.CameraSensitivity.X * GlobalStickFactor * StickFactor * Outer.GetSensitivityScaling();
            aLookUp = aLookUp * Input.CameraSensitivity.Y * GlobalStickFactor * StickFactor * Outer.GetSensitivityScaling();
        }
    }
    if (AxisBuffer[0] != float(0) || AxisBuffer[1] != float(0) || AxisBuffer[0] != LastAxisBuffer[0] || AxisBuffer[1] != LastAxisBuffer[1])
    {
        X = AxisBuffer[0];
        Y = AxisBuffer[1];
        StickMag = Sqrt(X * X + Y * Y);
        if (StickMag <= GuiDeadzone)
        {
            X = 0.0;
            Y = 0.0;
        }
        else if (Engine != None)
        {
            TimeSinceLastActivity = Engine.GetCurrentTime();
        }
        oSFXGUIInteraction.HandleInputEvent(ControllerId, 2, 0.0, X, X);
        oSFXGUIInteraction.HandleInputEvent(ControllerId, 3, 0.0, Y, Y);
    }
    if (AxisBuffer[2] != float(0) || AxisBuffer[3] != float(0) || AxisBuffer[2] != LastAxisBuffer[2] || AxisBuffer[3] != LastAxisBuffer[3])
    {
        X = AxisBuffer[2];
        Y = AxisBuffer[3];
        StickMag = Sqrt(X * X + Y * Y);
        if (StickMag <= GuiDeadzone)
        {
            X = 0.0;
            Y = 0.0;
        }
        else if (Engine != None)
        {
            TimeSinceLastActivity = Engine.GetCurrentTime();
        }
        oSFXGUIInteraction.HandleInputEvent(ControllerId, 4, 0.0, X, X);
        oSFXGUIInteraction.HandleInputEvent(ControllerId, 5, 0.0, Y, Y);
    }
    if (AxisBuffer[4] != LastAxisBuffer[4] || AxisBuffer[5] != LastAxisBuffer[5])
    {
        X = AxisBuffer[4];
        Y = AxisBuffer[5];
        oSFXGUIInteraction.HandleInputEvent(ControllerId, 6, 0.0, X, X);
        oSFXGUIInteraction.HandleInputEvent(ControllerId, 7, 0.0, Y, Y);
        if (Engine != None)
        {
            TimeSinceLastActivity = Engine.GetCurrentTime();
        }
    }
    for (idx = 0; idx < 6; idx++)
    {
        LastAxisBuffer[idx] = AxisBuffer[idx];
        AxisBuffer[idx] = 0.0;
    }
}
public function bool ActivatePower(Name nmPower, optional Actor oTarget, optional Vector vTargetLocation, optional Vector vOriginalCameraLocation, optional Rotator rOriginalCameraRotation)
{
    local BioPawn MyPawn;
    local SFXPowerCustomActionBase Power;
    local int Index;
    
    if (IsCombatEnabled() == FALSE)
    {
        return FALSE;
    }
    MyPawn = BioPawn(Outer.Pawn);
    if (MyPawn == None || MyPawn.PowerManager == None)
    {
        return FALSE;
    }
    Power = MyPawn.PowerManager.GetPower(nmPower);
    if (Power == None || Power.IsEnabled() == FALSE || Power.CurrentCooldownTime > 0.0)
    {
        return FALSE;
    }
    CancelReload();
    for (Index = 0; Index < MyPawn.PowerCustomActions.Length; Index++)
    {
        if (MyPawn.PowerCustomActions[Index] == Power)
        {
            Power.m_oTargetToAimAt = oTarget;
            Power.m_vLocationToAimAt = vTargetLocation;
            Outer.StartPowerCustomAction(Power);
            Outer.HintSystem.HintEvent('PowerCast', Power.Class.Name);
            return TRUE;
        }
    }
    return FALSE;
}
public function float ComputeStickResponse(float RawStickValue, SFXCameraInput Input, float DeltaTime)
{
    local float AngleDelta;
    local Vector NewAimVector;
    local float Accel;
    local float Decel;
    
    NewAimVector.X = RawJoyLookRight;
    NewAimVector.Y = RawJoyLookUp;
    NewAimVector.Z = 0.0;
    AngleDelta = NewAimVector Dot AccumulatedAimVector;
    AccumulatedRotationSpeed *= FClamp(AngleDelta, 0.0, 1.0);
    AccumulatedAimVector = NewAimVector;
    if (RawStickValue > 0.670000017)
    {
        Accel = AccumulatedRotationSpeed + DeltaTime * Input.MaxCameraRotationSpeed / FMax(0.100000001, Input.TimeToReachFullSpeed);
        Decel = AccumulatedRotationSpeed * AccumulatedRotationDecayRate ** DeltaTime;
        AccumulatedRotationSpeed = Lerp(Decel, Accel, (RawStickValue - 0.670000017) * 3.0);
    }
    else
    {
        AccumulatedRotationSpeed *= AccumulatedRotationDecayRate ** DeltaTime;
    }
    AccumulatedRotationSpeed = FClamp(AccumulatedRotationSpeed, 0.0, Input.MaxCameraRotationSpeed);
    Class'BioInterpolator'.static.InterpolateFloatCurve(RawStickValue, LookStickResponseCurve, 0.0, 1.0, RawStickValue);
    return AccumulatedRotationSpeed + RawStickValue;
}
public exec function GhostMoveDown(bool bState)
{
    if (Outer.Pawn.Controller.IsInState('PlayerFlying', ))
    {
        Outer.m_bDEBUGFlyDownPressed = bState;
    }
}
public exec function GhostMoveUp(bool bState)
{
    if (Outer.Pawn.Controller.IsInState('PlayerFlying', ))
    {
        Outer.m_bDEBUGFlyUpPressed = bState;
    }
}
public function RegisterInputOverride(string Alias, delegate<InputDelegate> InputDelegate, bool bExclusive, optional bool bPress = TRUE)
{
    local bool bFoundAlias;
    local int i;
    local InputOverride NewOverride;
    
    bFoundAlias = FALSE;
    for (i = 0; i < InputOverrides.Length && !bFoundAlias; i++)
    {
        if (InputOverrides[i].Alias == Alias && InputOverrides[i].bPress == bPress)
        {
            bFoundAlias = TRUE;
        }
    }
    if (!bFoundAlias)
    {
        NewOverride.Alias = Alias;
        NewOverride.bPress = bPress;
        NewOverride.bExclusive = bExclusive;
        NewOverride.InputDelegate = InputDelegate;
        InputOverrides.AddItem(NewOverride);
    }
}
public function RemapControlsByRotation(Rotator DeltaRot, out float NewRight, out float NewUp)
{
    local Vector Controls;
    local Vector NewControls;
    
    Controls.X = RawJoyRight;
    Controls.Y = RawJoyUp;
    if (IsZero(Controls))
    {
        NewRight = 0.0;
        NewUp = 0.0;
        return;
    }
    if (Abs(float(DeltaRot.Yaw)) > float((Class'WorldInfo'.static.IsConsoleBuild() ? CoverRemapThreshold : CoverRemapThresholdPC)))
    {
        DeltaRot.Pitch = 0;
        NewControls = Normal(Controls >> DeltaRot);
        NewRight = NewControls.X;
        NewUp = NewControls.Y;
    }
}
public function SetFlyCam(bool bOn)
{
    if (bOn)
    {
        Outer.SetCameraMode('FreeCam');
        Outer.PushState('PlayerFlyCam');
    }
    else
    {
        Outer.ResetCameraMode();
        Outer.PopState();
    }
}
public exec function ToggleFlyCam()
{
    SetFlyCam(!Outer.Pawn.InFreeCam());
}
public function UnregisterInputOverride(string Alias, optional bool bPress = TRUE)
{
    local int i;
    
    for (i = 0; i < InputOverrides.Length; i++)
    {
        if (InputOverrides[i].Alias == Alias && InputOverrides[i].bPress == bPress)
        {
            InputOverrides.RemoveItem(InputOverrides[i]);
            break;
        }
    }
}
public function UpdateViewRotation(float DeltaTime)
{
    local Rotator Kickback;
    local Rotator KickbackFade;
    local SFXPlayerCamera CamManager;
    
    CamManager = SFXPlayerCamera(Outer.PlayerCamera);
    if (CamManager != None)
    {
        if (Outer.IsLookInputIgnored() == FALSE)
        {
            CamManager.CameraStick = vect2d(RawJoyLookRight, -RawJoyLookUp);
            CamManager.MovementStick = vect2d(RawJoyRight, RawJoyUp);
        }
        else
        {
            CamManager.CameraStick = vect2d(0.0, 0.0);
            CamManager.MovementStick = vect2d(0.0, 0.0);
        }
    }
    if (Outer.GameModeManager2.AllowsCameraMods())
    {
        if (Outer.Pawn != None && SFXInventoryManager(Outer.Pawn.InvManager) != None)
        {
            SFXInventoryManager(Outer.Pawn.InvManager).UpdateKickback(DeltaTime, Kickback);
            SFXInventoryManager(Outer.Pawn.InvManager).UpdateKickbackFade(DeltaTime, KickbackFade);
            Kickback -= KickbackFade;
            Outer.SetRotation(Outer.Rotation + Kickback);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LookStickResponseCurve = {
                              Points = ({InVal = 0.0, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveAuto}, 
                                        {InVal = 0.330000013, OutVal = 0.166999996, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveAuto}, 
                                        {InVal = 0.670000017, OutVal = 0.5, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveAuto}, 
                                        {InVal = 1.0, OutVal = 1.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveAuto}
                                       ), 
                              InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                             }
    MouseDampeningCurve = {
                           Points = ({InVal = 0.0, OutVal = 0.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                                     {InVal = 50.0, OutVal = 20.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
                                     {InVal = 100.0, OutVal = 60.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}
                                    ), 
                           InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                          }
    StaticConsoleBinds = ({
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_A | OnRelease GuiKey BIOGUI_EVENT_BUTTON_A_RELEASE", 
                           Name = 'XboxTypeS_A', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_B | OnRelease GuiKey BIOGUI_EVENT_BUTTON_B_RELEASE", 
                           Name = 'XboxTypeS_B', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_X | OnRelease GuiKey BIOGUI_EVENT_BUTTON_X_RELEASE", 
                           Name = 'XboxTypeS_X', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_Y | OnRelease GuiKey BIOGUI_EVENT_BUTTON_Y_RELEASE", 
                           Name = 'XboxTypeS_Y', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_LB | OnRelease GuiKey BIOGUI_EVENT_BUTTON_LB_RELEASE", 
                           Name = 'XboxTypeS_LeftShoulder', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_RB | OnRelease GuiKey BIOGUI_EVENT_BUTTON_RB_RELEASE", 
                           Name = 'XboxTypeS_RightShoulder', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_LT | OnRelease GuiKey BIOGUI_EVENT_BUTTON_LT_RELEASE", 
                           Name = 'XboxTypeS_LeftTrigger', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_RT | OnRelease GuiKey BIOGUI_EVENT_BUTTON_RT_RELEASE", 
                           Name = 'XboxTypeS_RightTrigger', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_LTHUMB | OnRelease GuiKey BIOGUI_EVENT_BUTTON_LTHUMB_RELEASE", 
                           Name = 'XboxTypeS_LeftThumbstick', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_RTHUMB | OnRelease GuiKey BIOGUI_EVENT_BUTTON_RTHUMB_RELEASE", 
                           Name = 'XboxTypeS_RightThumbstick', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "Repeat GuiKey BIOGUI_EVENT_CONTROL_UP | OnRelease GuiKey BIOGUI_EVENT_CONTROL_UP_RELEASE", 
                           Name = 'XboxTypeS_DPad_Up', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "Repeat GuiKey BIOGUI_EVENT_CONTROL_DOWN | OnRelease GuiKey BIOGUI_EVENT_CONTROL_DOWN_RELEASE", 
                           Name = 'XboxTypeS_DPad_Down', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "Repeat GuiKey BIOGUI_EVENT_CONTROL_LEFT | OnRelease GuiKey BIOGUI_EVENT_CONTROL_LEFT_RELEASE", 
                           Name = 'XboxTypeS_DPad_Left', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "Repeat GuiKey BIOGUI_EVENT_CONTROL_RIGHT | OnRelease GuiKey BIOGUI_EVENT_CONTROL_RIGHT_RELEASE", 
                           Name = 'XboxTypeS_DPad_Right', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_BACK | GuiKey BIOGUI_EVENT_BUTTON_BACK_RELEASE", 
                           Name = 'XboxTypeS_Back', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "GuiKey BIOGUI_EVENT_BUTTON_START | OnRelease GuiKey BIOGUI_EVENT_BUTTON_START_RELEASE", 
                           Name = 'XboxTypeS_Start', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "Axis aGuiStrafe Speed=1.0 EventID=2", 
                           Name = 'XboxTypeS_LeftX', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "Axis aGuiBaseY Speed=1.0 EventID=3", 
                           Name = 'XboxTypeS_LeftY', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "Axis aGuiTurn Speed=1.0 EventID=4", 
                           Name = 'XboxTypeS_RightX', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }, 
                          {
                           Command = "Axis aGuiLookUp Speed=1.0 EventID=5", 
                           Name = 'XboxTypeS_RightY', 
                           Control = FALSE, 
                           Shift = FALSE, 
                           Alt = FALSE, 
                           bDebug = FALSE
                          }
                         )
    StaticPCBinds = ({
                      Command = "Axis aGuiMouseX EventID=6", 
                      Name = 'MouseX', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }, 
                     {
                      Command = "Axis aGuiMouseY EventID=7", 
                      Name = 'MouseY', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }, 
                     {
                      Command = "GuiKey BIOGUI_EVENT_MOUSE_BUTTON_LEFT | OnRelease GuiKey BIOGUI_EVENT_MOUSE_BUTTON_LEFT_RELEASE", 
                      Name = 'LeftMouseButton', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }, 
                     {
                      Command = "GuiKey BIOGUI_EVENT_MOUSE_BUTTON_RIGHT | OnRelease GuiKey BIOGUI_EVENT_MOUSE_BUTTON_RIGHT_RELEASE", 
                      Name = 'RightMouseButton', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }, 
                     {
                      Command = "GuiKey BIOGUI_EVENT_BUTTON_B | OnRelease GuiKey BIOGUI_EVENT_BUTTON_B_RELEASE", 
                      Name = 'Escape', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }, 
                     {
                      Command = "Repeat GuiKey BIOGUI_EVENT_CONTROL_UP | OnRelease GuiKey BIOGUI_EVENT_CONTROL_UP_RELEASE", 
                      Name = 'Up', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }, 
                     {
                      Command = "Repeat GuiKey BIOGUI_EVENT_CONTROL_DOWN | OnRelease GuiKey BIOGUI_EVENT_CONTROL_DOWN_RELEASE", 
                      Name = 'Down', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }, 
                     {
                      Command = "Repeat GuiKey BIOGUI_EVENT_CONTROL_LEFT | OnRelease GuiKey BIOGUI_EVENT_CONTROL_LEFT_RELEASE", 
                      Name = 'Left', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }, 
                     {
                      Command = "Repeat GuiKey BIOGUI_EVENT_CONTROL_RIGHT | OnRelease GuiKey BIOGUI_EVENT_CONTROL_RIGHT_RELEASE", 
                      Name = 'Right', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }, 
                     {
                      Command = "exec FKEY_F1.txt", 
                      Name = 'F1', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F2.txt", 
                      Name = 'F2', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F3.txt", 
                      Name = 'F3', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F4.txt", 
                      Name = 'F4', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F5.txt", 
                      Name = 'F5', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F6.txt", 
                      Name = 'F6', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F7.txt", 
                      Name = 'F7', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F8.txt", 
                      Name = 'F8', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F9.txt", 
                      Name = 'F9', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F10.txt", 
                      Name = 'F10', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F11.txt", 
                      Name = 'F11', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec FKEY_F12.txt", 
                      Name = 'F12', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F1.txt", 
                      Name = 'F1', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F2.txt", 
                      Name = 'F2', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F3.txt", 
                      Name = 'F3', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F4.txt", 
                      Name = 'F4', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F5.txt", 
                      Name = 'F5', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F6.txt", 
                      Name = 'F6', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F7.txt", 
                      Name = 'F7', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F8.txt", 
                      Name = 'F8', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F9.txt", 
                      Name = 'F9', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F10.txt", 
                      Name = 'F10', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F11.txt", 
                      Name = 'F11', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "exec AFKEY_F12.txt", 
                      Name = 'F12', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = TRUE, 
                      bDebug = TRUE
                     }, 
                     {
                      Command = "GuiKey BIOGUI_EVENT_KEY_WHEEL_UP", 
                      Name = 'MouseScrollUp', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }, 
                     {
                      Command = "GuiKey BIOGUI_EVENT_KEY_WHEEL_DOWN", 
                      Name = 'MouseScrollDown', 
                      Control = FALSE, 
                      Shift = FALSE, 
                      Alt = FALSE, 
                      bDebug = FALSE
                     }
                    )
    m_aFlyCamConsoleBinds = ({
                              Command = "Console_Strafe | Axis aGuiStrafe Speed=1.0 EventID=2", 
                              Name = 'XboxTypeS_LeftX', 
                              Control = FALSE, 
                              Shift = FALSE, 
                              Alt = FALSE, 
                              bDebug = TRUE
                             }, 
                             {
                              Command = "Console_Movement | Axis aGuiBaseY Speed=1.0 EventID=3", 
                              Name = 'XboxTypeS_LeftY', 
                              Control = FALSE, 
                              Shift = FALSE, 
                              Alt = FALSE, 
                              bDebug = TRUE
                             }, 
                             {
                              Command = "Console_LookX | Axis aGuiTurn Speed=1.0 EventID=4", 
                              Name = 'XboxTypeS_RightX', 
                              Control = FALSE, 
                              Shift = FALSE, 
                              Alt = FALSE, 
                              bDebug = TRUE
                             }, 
                             {
                              Command = "Console_LookY | Axis aGuiLookUp Speed=1.0 EventID=5", 
                              Name = 'XboxTypeS_RightY', 
                              Control = FALSE, 
                              Shift = FALSE, 
                              Alt = FALSE, 
                              bDebug = TRUE
                             }, 
                             {
                              Command = "Axis aUp Speed=1.0", 
                              Name = 'XboxTypeS_RightThumbstick', 
                              Control = FALSE, 
                              Shift = FALSE, 
                              Alt = FALSE, 
                              bDebug = TRUE
                             }, 
                             {
                              Command = "Axis aUp Speed=-1.0", 
                              Name = 'XboxTypeS_LeftThumbstick', 
                              Control = FALSE, 
                              Shift = FALSE, 
                              Alt = FALSE, 
                              bDebug = TRUE
                             }, 
                             {
                              Command = "FastFlyCamOn | OnRelease FastFlyCamOff", 
                              Name = 'XboxTypeS_A', 
                              Control = FALSE, 
                              Shift = FALSE, 
                              Alt = FALSE, 
                              bDebug = TRUE
                             }
                            )
    DebugMenu = ({Name = "Level Skip Commands >", Command = "showsubmenu LEVELSKIP"}
                )
    GuiDeadzone = 0.400000006
    m_fQuickOrderTime = 0.200000003
    AccumulatedRotationDecayRate = 0.999998987
    CoverRemapThresholdPC = 20000
    GlobalStickFactor = 0.0120000001
    bUseMouseDampening = TRUE
    MouseSamples = 20
    MouseSamplingTotal = 0.400000006
}