Class SFXModule_Locomotion extends SFXModule
    native
    config(Game);

enum ESFXLocomotionState
{
    eSFXLocomotionState_Inactive,
    eSFXLocomotionState_Moving,
    eSFXLocomotionState_Idle,
    eSFXLocomotionState_MoveStart,
    eSFXLocomotionState_MoveStop,
    eSFXLocomotionState_SkidTurn,
};
enum EWalkingSpeedMode
{
    eWalkingSpeedMode_ExploreRun,
    eWalkingSpeedMode_ExploreWalk,
    eWalkingSpeedMode_ExploreStorming,
    eWalkingSpeedMode_ExploreCrouched,
    eWalkingSpeedMode_CombatRun,
    eWalkingSpeedMode_CombatWalk,
    eWalkingSpeedMode_CombatStorming,
    eWalkingSpeedMode_CombatCrouched,
    eWalkingSpeedMode_CombatSniping,
    eWalkingSpeedMode_CombatZoomed,
    eWalkingSpeedMode_CoverMove,
    eWalkingSpeedMode_CoverCrouched,
};

var transient Rotator PawnDesiredRotation;
var transient Vector PawnAcceleration;
var transient Vector MoveStartInitialPos;
var transient float MovingLeanYaw[2];
var transient BioPawn MyBP;
var transient AnimNode AnimNode;
var transient int StateTag;
var transient int TickTag;
var config float PawnMoveStartFwdAngle;
var config float PawnMoveStartFwdSpeed;
var config float PawnMoveStartFwdAccelerationTimer;
var config float PawnMoveStartSidewayAccelerationTimer;
var config float PawnMoveStartStopTimerThreshold;
var config float PawnMoveStandTurnDistanceThreshold;
var config float PawnMoveStandTurnRotRate;
var config float PawnMoveStopTimerThreshold;
var config float PawnMoveStopRestartTimerThreshold;
var transient float StateTimer;
var transient float StateSpeed;
var transient float MovingLean;
var transient float MovingIncline;
var transient float MoveStartInitialYaw;
var transient float MoveStartRelYaw;
var transient float MoveStartLastYaw;
var transient float MoveStartIdleTimer;
var transient bool MoveStartStopping;
var transient ESFXLocomotionState CurrentState;

public event simulated function HandlePostBeginPlay()
{
    MyBP = BioPawn(Outer);
    Super.HandlePostBeginPlay();
}
public final native function SetAcceleration(Vector Acceleration);

public final native function SetDesiredRotation(Rotator DesiredRotation);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PawnMoveStartFwdAngle = 120.0
    PawnMoveStartFwdAccelerationTimer = 0.400000006
    PawnMoveStartSidewayAccelerationTimer = 0.449999988
    PawnMoveStartStopTimerThreshold = 0.100000001
    PawnMoveStandTurnDistanceThreshold = 10.0
    PawnMoveStandTurnRotRate = 180.0
    PawnMoveStopTimerThreshold = 0.100000001
    PawnMoveStopRestartTimerThreshold = 0.100000001
}