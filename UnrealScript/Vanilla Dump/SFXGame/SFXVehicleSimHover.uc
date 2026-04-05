Class SFXVehicleSimHover extends SVehicleSimBase
    native;

var Vector RandForce;
var Vector RandTorque;
var Vector OldVelocity;
var(SFXVehicleSimHover) float MaxThrustForce;
var(SFXVehicleSimHover) float MaxReverseForce;
var(SFXVehicleSimHover) float LongDamping;
var(SFXVehicleSimHover) float MaxStrafeForce;
var(SFXVehicleSimHover) float LatDamping;
var(SFXVehicleSimHover) float DirectionChangeForce;
var(SFXVehicleSimHover) float MaxRiseForce;
var(SFXVehicleSimHover) float UpDamping;
var(SFXVehicleSimHover) float TurnTorqueFactor;
var(SFXVehicleSimHover) float TurnTorqueMax;
var(SFXVehicleSimHover) float TurnDamping;
var(SFXVehicleSimHover) float MaxYawRate;
var(SFXVehicleSimHover) float PitchTorqueFactor;
var(SFXVehicleSimHover) float PitchTorqueMax;
var(SFXVehicleSimHover) float PitchDamping;
var(SFXVehicleSimHover) float RollTorqueTurnFactor;
var(SFXVehicleSimHover) float RollTorqueStrafeFactor;
var(SFXVehicleSimHover) float RollTorqueMax;
var(SFXVehicleSimHover) float RollDamping;
var(SFXVehicleSimHover) float StopThreshold;
var(SFXVehicleSimHover) float MaxRandForce;
var(SFXVehicleSimHover) float RandForceInterval;
var float StrafeTurnDamping;
var float TargetHeading;
var float TargetPitch;
var float PitchViewCorrelation;
var float AccumulatedTime;
var(SFXVehicleSimHover) float StabilizationForceMultiplier;
var float CurrentStabilizationMultiplier;
var float StoppedBrakeTorque;
var float HardLimitAirSpeedScale;
var(SFXVehicleSimHover) bool bAllowZThrust;
var(SFXVehicleSimHover) bool bFullThrustOnDirectionChange;
var(SFXVehicleSimHover) bool bShouldCutThrustMaxOnImpact;
var bool bRecentlyHit;
var bool bStrafeAffectsTurnDamping;
var bool bHeadingInitialized;
var(SFXVehicleSimHover) bool bStabilizeStops;
var bool bDisableWheelsWhenOff;
var bool bRepulsorCollisionEnabled;
var bool bCanClimbSlopes;
var bool bUnPoweredDriving;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StabilizationForceMultiplier = 1.0
    CurrentStabilizationMultiplier = 1.0
    StoppedBrakeTorque = 5.0
    bRepulsorCollisionEnabled = TRUE
}