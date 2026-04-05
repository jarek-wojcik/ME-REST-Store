Class SFXSavedMove extends SavedMove
    native;

enum ESFXSavedMoveType
{
    SavedMoveType_Walk,
    SavedMoveType_Storm,
    SavedMoveType_InCover,
    SavedMoveType_AimBack,
    SavedMoveType_RootMotion,
    SavedMoveType_Standard,
};
const MAX_REPLICATED_MOVES = 5;

var Name ControllerState;
var int TimeStampMS;
var int PawnDesiredYaw;
var float MoveMag;
var int AimDeltaRotYaw;
var int AimDeltaRotPitch;
var bool bIsInStationaryCover;
var bool bWantsToStorm;
var bool bStorming;
var bool bCancelStorm;
var bool bWantsToCrouch;
var bool bWantsToPortArm;
var bool bAimAssistActive;
var bool bIsSniping;
var ESFXSavedMoveType SavedMoveType;
var ECoverType CoverType;
var ECoverAction CoverAction;
var ECoverDirection CoverDirection;
var ECoverDirection CurrentSlotDirection;

public final native function BioSetFlags(BioPlayerController BioPC);

public native function Clear();

public final native function CopyFrom(SFXSavedMove PreviousMove);

public final native function bool HasChanges(SFXSavedMove PreviousMove);

public function byte CompressedFlags()
{
    local byte Result;
    
    if (bWantsToStorm)
    {
        Result += 1;
    }
    if (bWantsToCrouch)
    {
        Result += 2;
    }
    if (bWantsToPortArm)
    {
        Result += 4;
    }
    if (bAimAssistActive)
    {
        Result += 8;
    }
    if (bCancelStorm)
    {
        Result += 16;
    }
    if (bStorming)
    {
        Result += 32;
    }
    if (bIsSniping)
    {
        Result += 64;
    }
    return Result;
}
public static function EDoubleClickDir SetFlags(byte Flags, PlayerController PC)
{
    local BioPlayerController BioPC;
    local BioPawn PawnAsBioPawn;
    
    BioPC = BioPlayerController(PC);
    PawnAsBioPawn = BioPawn(BioPC.Pawn);
    if (BioPC != None)
    {
        if ((int(Flags) & 1) != 0)
        {
            BioPC.bWantsToStorm = 1;
        }
        else
        {
            BioPC.bWantsToStorm = 0;
        }
        if (PawnAsBioPawn != None)
        {
            PawnAsBioPawn.bWantsToCrouch = (int(Flags) & 2) != 0;
            PawnAsBioPawn.bInPortArms = (int(Flags) & 4) != 0;
            PawnAsBioPawn.bIsSniping = (int(Flags) & 64) != 0;
        }
        BioPC.RemoteAimAssistActive = (int(Flags) & 8) != 0;
        BioPC.bCancelStorm = (int(Flags) & 16) != 0;
        BioPC.bClientStorming = (int(Flags) & 32) != 0;
    }
    return 0;
}
public function SetMoveFor(PlayerController P, float DeltaTime, Vector newAccel, EDoubleClickDir InDoubleClick)
{
    local BioPawn PawnAsBioPawn;
    local SFXModule_AimAssist AimAssist;
    
    Super.SetMoveFor(P, DeltaTime, newAccel, InDoubleClick);
    TimeStampMS = Round(TimeStamp * float(1000));
    TimeStamp = float(TimeStampMS) * 0.00100000005;
    Delta = float(Round(DeltaTime * float(1000))) * 0.00100000005;
    PawnAsBioPawn = BioPawn(P.Pawn);
    if (PawnAsBioPawn != None)
    {
        CoverType = PawnAsBioPawn.CoverType;
        CoverAction = PawnAsBioPawn.CoverAction;
        CoverDirection = PawnAsBioPawn.CoverDirection;
        CurrentSlotDirection = PawnAsBioPawn.CurrentSlotDirection;
        bIsInStationaryCover = PawnAsBioPawn.bIsInStationaryCover;
        bWantsToStorm = int(BioPlayerController(P).bWantsToStorm) > 0;
        bStorming = BioPawn(P.Pawn) == None ? FALSE : BioPawn(P.Pawn).bStorming;
        bCancelStorm = BioPlayerController(P).bCancelStorm;
        bWantsToCrouch = PawnAsBioPawn.bWantsToCrouch;
        bWantsToPortArm = PawnAsBioPawn.bInPortArms;
        AimAssist = BioPlayerController(P).GetModule(Class'SFXModule_AimAssist');
        bAimAssistActive = AimAssist != None && AimAssist.CurrentAimAssistTarget == PawnAsBioPawn && AimAssist.CurrentAimAssistSoftMargin >= float(1);
        PawnDesiredYaw = PawnAsBioPawn.DesiredRotation.Yaw;
        MoveMag = FMin(PawnAsBioPawn.fMoveMag, 1.0);
        AimDeltaRotYaw = int(PawnAsBioPawn.AimOffsetPct.X * float(16384));
        AimDeltaRotPitch = int(PawnAsBioPawn.AimOffsetPct.Y * float(16384));
        bIsSniping = PawnAsBioPawn.bIsSniping;
    }
    ControllerState = BioPlayerController(P).GetStateName();
    if (ControllerState == 'PlayerInCover')
    {
        SavedMoveType = ESFXSavedMoveType.SavedMoveType_InCover;
    }
    else if (ControllerState == 'PlayerInAimBack')
    {
        SavedMoveType = ESFXSavedMoveType.SavedMoveType_AimBack;
    }
    else if (bForceRMVelocity)
    {
        SavedMoveType = ESFXSavedMoveType.SavedMoveType_RootMotion;
    }
    else if (ControllerState == 'PlayerWalking')
    {
        SavedMoveType = bStorming ? ESFXSavedMoveType.SavedMoveType_Storm : ESFXSavedMoveType.SavedMoveType_Walk;
    }
    else
    {
        SavedMoveType = ESFXSavedMoveType.SavedMoveType_Standard;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}