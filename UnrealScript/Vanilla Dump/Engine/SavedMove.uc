Class SavedMove
    native;

var Vector StartLocation;
var Vector StartRelativeLocation;
var Vector StartVelocity;
var Vector StartFloor;
var Vector SavedLocation;
var Vector SavedVelocity;
var Vector SavedRelativeLocation;
var Vector RMVelocity;
var Vector Acceleration;
var Rotator Rotation;
var Vector RootMotionInterpCurveLastValue;
var SavedMove NextMove;
var float TimeStamp;
var float Delta;
var Actor StartBase;
var Actor EndBase;
var float CustomTimeDilation;
var float AccelDotThreshold;
var float RootMotionInterpCurrentTime;
var bool bRun;
var bool bDuck;
var bool bPressedJump;
var bool bDoubleJump;
var bool bPreciseDestination;
var bool bForceRMVelocity;
var bool bForceMaxAccel;
var bool bRootMotionFromInterpCurve;
var EDoubleClickDir DoubleClickMove;
var EPhysics SavedPhysics;
var ERootMotionMode RootMotionMode;

public native function Clear();

public function string GetDebugString()
{
    local string Str;
    
    Str = Self @ "Delta:'" $ Delta $ "'" @ "SavedPhysics:'" $ SavedPhysics $ "'" @ "StartLocation:'" $ StartLocation $ "'" @ "StartVelocity:'" $ StartVelocity $ "'" @ "SavedLocation:'" $ SavedLocation $ "'" @ "SavedVelocity:'" $ SavedVelocity $ "'" @ "RMVelocity:'" $ RMVelocity $ "'" @ "Acceleration:'" $ Acceleration $ "'" @ "bRootMotionFromInterpCurve:'" $ bRootMotionFromInterpCurve $ "'" @ "RootMotionInterpCurrentTime:'" $ RootMotionInterpCurrentTime $ "'";
    return Str;
}
public function bool CanCombineWith(SavedMove NewMove, Pawn inPawn, float MaxDelta)
{
    if (inPawn == None)
    {
        return FALSE;
    }
    if (NewMove.Acceleration == vect(0.0, 0.0, 0.0))
    {
        return Acceleration == vect(0.0, 0.0, 0.0) && StartVelocity == vect(0.0, 0.0, 0.0) && NewMove.StartVelocity == vect(0.0, 0.0, 0.0) && int(SavedPhysics) == int(inPawn.Physics) && !bPressedJump && !NewMove.bPressedJump && bRun == NewMove.bRun && bDuck == NewMove.bDuck && bPreciseDestination == NewMove.bPreciseDestination && bDoubleJump == NewMove.bDoubleJump && (DoubleClickMove == EDoubleClickDir.DCLICK_None || DoubleClickMove == EDoubleClickDir.DCLICK_Active) && int(NewMove.DoubleClickMove) == int(DoubleClickMove) && !bForceRMVelocity && !NewMove.bForceRMVelocity && CustomTimeDilation == NewMove.CustomTimeDilation;
    }
    else
    {
        return inPawn != None && NewMove.Delta + Delta < MaxDelta && int(SavedPhysics) == int(inPawn.Physics) && !bPressedJump && !NewMove.bPressedJump && bRun == NewMove.bRun && bDuck == NewMove.bDuck && bDoubleJump == NewMove.bDoubleJump && bPreciseDestination == NewMove.bPreciseDestination && (DoubleClickMove == EDoubleClickDir.DCLICK_None || DoubleClickMove == EDoubleClickDir.DCLICK_Active) && int(NewMove.DoubleClickMove) == int(DoubleClickMove) && Normal(Acceleration) Dot Normal(NewMove.Acceleration) > 0.99000001 && !bForceRMVelocity && !NewMove.bForceRMVelocity && CustomTimeDilation == NewMove.CustomTimeDilation;
    }
}
public function byte CompressedFlags()
{
    local byte Result;
    
    Result = DoubleClickMove;
    if (bRun)
    {
        Result += 8;
    }
    if (bDuck)
    {
        Result += 16;
    }
    if (bPressedJump)
    {
        Result += 32;
    }
    if (bDoubleJump)
    {
        Result += 64;
    }
    if (bPreciseDestination)
    {
        Result += 128;
    }
    return Result;
}
public function Vector GetStartLocation()
{
    if (StartBase != None && !StartBase.bWorldGeometry)
    {
        return StartBase.location + StartRelativeLocation;
    }
    return StartLocation;
}
public function bool IsImportantMove(Vector CompareAccel)
{
    local Vector AccelNorm;
    
    if (bPressedJump || bDoubleJump || DoubleClickMove != EDoubleClickDir.DCLICK_None && DoubleClickMove != EDoubleClickDir.DCLICK_Active && DoubleClickMove != EDoubleClickDir.DCLICK_Done)
    {
        return TRUE;
    }
    AccelNorm = Normal(Acceleration);
    return CompareAccel != AccelNorm && CompareAccel Dot AccelNorm < AccelDotThreshold;
}
public function PostUpdate(PlayerController P)
{
    bDoubleJump = P.bDoubleJump || bDoubleJump;
    if (P.Pawn != None)
    {
        RMVelocity = P.Pawn.RMVelocity;
        SavedLocation = P.Pawn.location;
        SavedVelocity = P.Pawn.Velocity;
        EndBase = P.Pawn.Base;
        if (EndBase != None && !EndBase.bWorldGeometry)
        {
            SavedRelativeLocation = P.Pawn.location - EndBase.location;
        }
    }
    Rotation = P.Rotation;
}
public function PrepMoveFor(Pawn P)
{
    if (P != None)
    {
        P.bForceRMVelocity = bForceRMVelocity;
        P.bForceMaxAccel = bForceMaxAccel;
    }
}
public function ResetMoveFor(Pawn P)
{
    if (P != None)
    {
        SavedLocation = P.location;
        SavedVelocity = P.Velocity;
        EndBase = P.Base;
        if (EndBase != None && !EndBase.bWorldGeometry)
        {
            SavedRelativeLocation = P.location - EndBase.location;
        }
        P.bForceRMVelocity = FALSE;
    }
}
public static function EDoubleClickDir SetFlags(byte Flags, PlayerController PC)
{
    if ((int(Flags) & 8) != 0)
    {
        PC.bRun = 1;
    }
    else
    {
        PC.bRun = 0;
    }
    if ((int(Flags) & 16) != 0)
    {
        PC.bDuck = 1;
    }
    else
    {
        PC.bDuck = 0;
    }
    PC.bPreciseDestination = (int(Flags) & 128) != 0;
    PC.bDoubleJump = (int(Flags) & 64) != 0;
    PC.bPressedJump = (int(Flags) & 32) != 0;
    switch (int(Flags) & 7)
    {
        case 0:
            return EDoubleClickDir.DCLICK_None;
            break;
        case 1:
            return EDoubleClickDir.DCLICK_Left;
            break;
        case 2:
            return EDoubleClickDir.DCLICK_Right;
            break;
        case 3:
            return EDoubleClickDir.DCLICK_Forward;
            break;
        case 4:
            return EDoubleClickDir.DCLICK_Back;
            break;
        default:
    }
    return EDoubleClickDir.DCLICK_None;
}
public function SetInitialPosition(Pawn P)
{
    SavedPhysics = P.Physics;
    StartLocation = P.location;
    StartVelocity = P.Velocity;
    StartBase = P.Base;
    StartFloor = P.Floor;
    CustomTimeDilation = P.CustomTimeDilation;
    if (StartBase != None && !StartBase.bWorldGeometry)
    {
        StartRelativeLocation = P.location - StartBase.location;
    }
}
public function SetMoveFor(PlayerController P, float DeltaTime, Vector newAccel, EDoubleClickDir InDoubleClick)
{
    Delta = DeltaTime;
    if (VSize(newAccel) > float(26214))
    {
        newAccel = float(26214) * Normal(newAccel);
    }
    if (P.Pawn != None)
    {
        SetInitialPosition(P.Pawn);
    }
    Acceleration = newAccel;
    DoubleClickMove = InDoubleClick;
    bRun = int(P.bRun) > 0;
    bDuck = int(P.bDuck) > 0;
    bPressedJump = P.bPressedJump;
    bDoubleJump = P.bDoubleJump;
    bPreciseDestination = P.bPreciseDestination;
    bForceRMVelocity = P.bPreciseDestination || P.Pawn != None && P.Pawn.Mesh != None && (P.Pawn.Mesh.RootMotionMode == ERootMotionMode.RMM_Accel || P.Pawn.Mesh.RootMotionMode == ERootMotionMode.RMM_Velocity);
    bForceMaxAccel = P.Pawn != None && P.Pawn.bForceMaxAccel;
    TimeStamp = P.WorldInfo.TimeSeconds;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AccelDotThreshold = 0.899999976
}