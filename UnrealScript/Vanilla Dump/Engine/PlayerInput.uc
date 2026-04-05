Class PlayerInput extends Input within PlayerController
    native
    transient
    config(Input);

var const Name LastAxisKeyName;
var float ZeroTime[2];
var float SmoothedMouse[2];
var float DoubleClickTimer;
var globalconfig float DoubleClickTime;
var globalconfig float MouseSensitivity;
var input float aBaseX;
var input float aBaseY;
var input float aBaseZ;
var input float aMouseX;
var input float aMouseY;
var input float aForward;
var input float aTurn;
var input float aStrafe;
var input float aUp;
var input float aLookUp;
var input float aRightAnalogTrigger;
var input float aLeftAnalogTrigger;
var input float aPS3AccelX;
var input float aPS3AccelY;
var input float aPS3AccelZ;
var input float aPS3Gyro;
var transient float RawJoyUp;
var transient float RawJoyRight;
var transient float RawJoyLookRight;
var transient float RawJoyLookUp;
var(PlayerInput) config float MoveForwardSpeed;
var(PlayerInput) config float MoveStrafeSpeed;
var(PlayerInput) config float LookRightScale;
var(PlayerInput) config float LookUpScale;
var int MouseSamples;
var float MouseSamplingTotal;
var transient float AutoUnlockTurnTime;
var const bool bUsingGamepad;
var globalconfig bool bInvertMouse;
var globalconfig bool bInvertTurn;
var bool bWasForward;
var bool bWasBack;
var bool bWasLeft;
var bool bWasRight;
var bool bEdgeForward;
var bool bEdgeBack;
var bool bEdgeLeft;
var bool bEdgeRight;
var globalconfig bool bEnableMouseSmoothing;
var bool bEnableFOVScaling;
var transient bool bLockTurnUntilRelease;
var input byte bStrafe;
var input byte bXAxis;
var input byte bYAxis;

public event function PlayerInput(float DeltaTime)
{
    local float FOVScale;
    local float TimeScale;
    
    RawJoyUp = aBaseY;
    RawJoyRight = aStrafe;
    RawJoyLookRight = aTurn;
    RawJoyLookUp = aLookUp;
    DeltaTime /= Outer.WorldInfo.TimeDilation * Outer.CustomTimeDilation;
    if (Outer.bDemoOwner && Outer.WorldInfo.NetMode == ENetMode.NM_Client)
    {
        DeltaTime /= Outer.WorldInfo.DemoPlayTimeDilation;
    }
    PreProcessInput(DeltaTime);
    TimeScale = 100.0 * DeltaTime;
    aBaseY *= TimeScale * MoveForwardSpeed;
    aStrafe *= TimeScale * MoveStrafeSpeed;
    aUp *= TimeScale * MoveStrafeSpeed;
    aTurn *= TimeScale * LookRightScale;
    aLookUp *= TimeScale * LookUpScale;
    PostProcessInput(DeltaTime);
    ProcessInputMatching(DeltaTime);
    CatchDoubleClickInput();
    if (bEnableFOVScaling)
    {
        FOVScale = Outer.GetFOVAngle() * 0.0111100003;
    }
    else
    {
        FOVScale = 1.0;
    }
    AdjustMouseSensitivity(FOVScale);
    if (bEnableMouseSmoothing)
    {
        aMouseX = SmoothMouse(aMouseX, DeltaTime, bXAxis, 0);
        aMouseY = SmoothMouse(aMouseY, DeltaTime, bYAxis, 1);
    }
    aLookUp *= FOVScale;
    aTurn *= FOVScale;
    if (int(bStrafe) > 0)
    {
        aStrafe += aBaseX + aMouseX;
    }
    else
    {
        aTurn += aBaseX + aMouseX;
    }
    aLookUp += aMouseY;
    if (bInvertMouse)
    {
        aLookUp *= -1.0;
    }
    if (bInvertTurn)
    {
        aTurn *= -1.0;
    }
    aForward += aBaseY;
    Outer.HandleWalking();
    if (bLockTurnUntilRelease)
    {
        if (RawJoyLookRight != float(0))
        {
            aTurn = 0.0;
            if (AutoUnlockTurnTime > 0.0)
            {
                AutoUnlockTurnTime -= DeltaTime;
                if (AutoUnlockTurnTime < 0.0)
                {
                    bLockTurnUntilRelease = FALSE;
                }
            }
        }
        else
        {
            bLockTurnUntilRelease = FALSE;
        }
    }
    if (Outer.IsMoveInputIgnored())
    {
        aForward = 0.0;
        aStrafe = 0.0;
        aUp = 0.0;
    }
    if (Outer.IsLookInputIgnored())
    {
        aTurn = 0.0;
        aLookUp = 0.0;
    }
}
public function AdjustMouseSensitivity(float FOVScale)
{
    aMouseX *= MouseSensitivity * FOVScale;
    aMouseY *= MouseSensitivity * FOVScale;
}
public function CatchDoubleClickInput()
{
    if (!Outer.IsMoveInputIgnored())
    {
        bEdgeForward = bWasForward ^^ aBaseY > float(0);
        bEdgeBack = bWasBack ^^ aBaseY < float(0);
        bEdgeLeft = bWasLeft ^^ aStrafe < float(0);
        bEdgeRight = bWasRight ^^ aStrafe > float(0);
        bWasForward = aBaseY > float(0);
        bWasBack = aBaseY < float(0);
        bWasLeft = aStrafe < float(0);
        bWasRight = aStrafe > float(0);
    }
}
public function EDoubleClickDir CheckForDoubleClickMove(float DeltaTime)
{
    local EDoubleClickDir DoubleClickMove;
    local EDoubleClickDir OldDoubleClick;
    
    if (Outer.DoubleClickDir == EDoubleClickDir.DCLICK_Active)
    {
        DoubleClickMove = EDoubleClickDir.DCLICK_Active;
    }
    else
    {
        DoubleClickMove = EDoubleClickDir.DCLICK_None;
    }
    if (DoubleClickTime > 0.0)
    {
        if (Outer.DoubleClickDir == EDoubleClickDir.DCLICK_Active)
        {
            if (Outer.Pawn != None && Outer.Pawn.Physics == EPhysics.PHYS_Walking)
            {
                DoubleClickTimer = 0.0;
                Outer.DoubleClickDir = EDoubleClickDir.DCLICK_Done;
            }
        }
        else if (Outer.DoubleClickDir != EDoubleClickDir.DCLICK_Done)
        {
            OldDoubleClick = Outer.DoubleClickDir;
            Outer.DoubleClickDir = EDoubleClickDir.DCLICK_None;
            if (bEdgeForward && bWasForward)
            {
                Outer.DoubleClickDir = EDoubleClickDir.DCLICK_Forward;
            }
            else if (bEdgeBack && bWasBack)
            {
                Outer.DoubleClickDir = EDoubleClickDir.DCLICK_Back;
            }
            else if (bEdgeLeft && bWasLeft)
            {
                Outer.DoubleClickDir = EDoubleClickDir.DCLICK_Left;
            }
            else if (bEdgeRight && bWasRight)
            {
                Outer.DoubleClickDir = EDoubleClickDir.DCLICK_Right;
            }
            if (Outer.DoubleClickDir == EDoubleClickDir.DCLICK_None)
            {
                Outer.DoubleClickDir = OldDoubleClick;
            }
            else if (int(Outer.DoubleClickDir) != int(OldDoubleClick))
            {
                DoubleClickTimer = DoubleClickTime + 0.5 * DeltaTime;
            }
            else
            {
                DoubleClickMove = Outer.DoubleClickDir;
            }
        }
        if (Outer.DoubleClickDir == EDoubleClickDir.DCLICK_Done)
        {
            DoubleClickTimer = FMin(DoubleClickTimer - DeltaTime, 0.0);
            if (DoubleClickTimer < -0.349999994)
            {
                Outer.DoubleClickDir = EDoubleClickDir.DCLICK_None;
                DoubleClickTimer = DoubleClickTime;
            }
        }
        else if (Outer.DoubleClickDir != EDoubleClickDir.DCLICK_None && Outer.DoubleClickDir != EDoubleClickDir.DCLICK_Active)
        {
            DoubleClickTimer -= DeltaTime;
            if (DoubleClickTimer < float(0))
            {
                Outer.DoubleClickDir = EDoubleClickDir.DCLICK_None;
                DoubleClickTimer = DoubleClickTime;
            }
        }
    }
    return DoubleClickMove;
}
public exec function ClearSmoothing()
{
    local int i;
    
    for (i = 0; i < 2; i++)
    {
        ZeroTime[i] = 0.0;
        SmoothedMouse[i] = 0.0;
    }
    MouseSamplingTotal = default.MouseSamplingTotal;
    MouseSamples = default.MouseSamples;
}
public function DrawHUD(HUD H);

public exec function bool InvertMouse()
{
    bInvertMouse = !bInvertMouse;
    SaveConfig();
    return bInvertMouse;
}
public exec function bool InvertTurn()
{
    bInvertTurn = !bInvertTurn;
    SaveConfig();
    return bInvertTurn;
}
public exec function Jump()
{
    if (Outer.WorldInfo.Pauser == Outer.PlayerReplicationInfo)
    {
        Outer.SetPause(FALSE);
    }
    else
    {
        Outer.bPressedJump = TRUE;
    }
}
public function PostProcessInput(float DeltaTime);

public function PreProcessInput(float DeltaTime);

public final function ProcessInputMatching(float DeltaTime)
{
    local float Value;
    local int i;
    local int MatchIdx;
    local bool bMatch;
    
    for (i = 0; i < Outer.InputRequests.Length; i++)
    {
        if (Outer.InputRequests[i].MatchIdx >= 0 && Outer.InputRequests[i].MatchIdx < Outer.InputRequests[i].Inputs.Length)
        {
            if (Outer.InputRequests[i].MatchActor == None)
            {
                Outer.InputRequests[i].MatchActor = Outer;
            }
            MatchIdx = Outer.InputRequests[i].MatchIdx;
            if (MatchIdx != 0 && Outer.InputRequests[i].Inputs[MatchIdx].TimeDelta > 0.0 && Outer.WorldInfo.TimeSeconds - Outer.InputRequests[i].LastMatchTime >= Outer.InputRequests[i].Inputs[MatchIdx].TimeDelta)
            {
                Outer.InputRequests[i].LastMatchTime = 0.0;
                Outer.InputRequests[i].MatchIdx = 0;
                if (Outer.InputRequests[i].FailedFuncName != 'None')
                {
                    Outer.InputRequests[i].MatchActor.SetTimer(0.00999999978, FALSE, Outer.InputRequests[i].FailedFuncName, );
                }
                continue;
            }
            Value = 0.0;
            switch (Outer.InputRequests[i].Inputs[MatchIdx].Type)
            {
                case EInputTypes.IT_XAxis:
                    Value = aStrafe;
                    break;
                case EInputTypes.IT_YAxis:
                    Value = aBaseY;
                    break;
                default:
            }
            switch (Outer.InputRequests[i].Inputs[MatchIdx].Action)
            {
                case EInputMatchAction.IMA_GreaterThan:
                    bMatch = Value >= Outer.InputRequests[i].Inputs[MatchIdx].Value;
                    break;
                case EInputMatchAction.IMA_LessThan:
                    bMatch = Value <= Outer.InputRequests[i].Inputs[MatchIdx].Value;
                    break;
                default:
            }
            if (bMatch)
            {
                Outer.InputRequests[i].LastMatchTime = Outer.WorldInfo.TimeSeconds;
                Outer.InputRequests[i].MatchIdx++;
                if (Outer.InputRequests[i].MatchIdx >= Outer.InputRequests[i].Inputs.Length)
                {
                    if (Outer.InputRequests[i].MatchDelegate != None)
                    {
                        Outer.__InputMatchDelegate__Delegate = Outer.InputRequests[i].MatchDelegate;
                        Outer.__InputMatchDelegate__Delegate();
                    }
                    if (Outer.InputRequests[i].MatchFuncName != 'None')
                    {
                        Outer.InputRequests[i].MatchActor.SetTimer(0.00999999978, FALSE, Outer.InputRequests[i].MatchFuncName, );
                    }
                    Outer.InputRequests[i].LastMatchTime = 0.0;
                    Outer.InputRequests[i].MatchIdx = 0;
                }
            }
        }
    }
}
public exec function SetSensitivity(float F)
{
    MouseSensitivity = F;
}
public exec function SmartJump()
{
    Jump();
}
public function float SmoothMouse(float aMouse, float DeltaTime, out byte SampleCount, int Index)
{
    local float MouseSamplingTime;
    
    if (DeltaTime < 0.25)
    {
        MouseSamplingTime = MouseSamplingTotal / float(MouseSamples);
        if (aMouse == float(0))
        {
            ZeroTime[Index] += DeltaTime;
            if (ZeroTime[Index] < MouseSamplingTime)
            {
                aMouse = SmoothedMouse[Index] * DeltaTime / MouseSamplingTime;
            }
            else
            {
                SmoothedMouse[Index] = 0.0;
            }
        }
        else
        {
            ZeroTime[Index] = 0.0;
            if (SmoothedMouse[Index] != float(0))
            {
                if (DeltaTime < MouseSamplingTime * float((int(SampleCount) + 1)))
                {
                    SampleCount = int(SampleCount) == 0 ? 1 : SampleCount;
                    aMouse = aMouse * DeltaTime / (MouseSamplingTime * float(SampleCount));
                }
                else
                {
                    SampleCount = byte(DeltaTime / MouseSamplingTime);
                }
            }
            SampleCount = int(SampleCount) == 0 ? 1 : SampleCount;
            SmoothedMouse[Index] = aMouse / float(SampleCount);
        }
    }
    else
    {
        ClearSmoothing();
    }
    SampleCount = 0;
    return aMouse;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DoubleClickTime = 0.25
    MouseSensitivity = 1.0
    MoveForwardSpeed = 1200.0
    MoveStrafeSpeed = 1200.0
    LookRightScale = 250.0
    LookUpScale = -175.0
    MouseSamples = 1
    MouseSamplingTotal = 0.00829999987
    bEnableMouseSmoothing = TRUE
    Bindings = ({
                 Command = "CloseEditorViewport", 
                 Name = 'Escape', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "GhostMoveUp 1 | OnRelease GhostMoveUp 0", 
                 Name = 'XboxTypeS_RightShoulder', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "GhostMoveDown 1 | OnRelease GhostMoveDown 0", 
                 Name = 'XboxTypeS_LeftShoulder', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "GhostMoveUp 1 | OnRelease GhostMoveUp 0", 
                 Name = 'Up', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "GhostMoveDown 1 | OnRelease GhostMoveDown 0", 
                 Name = 'Down', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ReportCustomEvent", 
                 Name = 'XboxTypeS_Back', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "ReportCustomEvent", 
                 Name = 'P', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
}