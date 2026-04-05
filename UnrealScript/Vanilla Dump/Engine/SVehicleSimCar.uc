Class SVehicleSimCar extends SVehicleSimBase
    native;

var(SVehicleSimCar) InterpCurveFloat MaxSteerAngleCurve;
var(SVehicleSimCar) float ChassisTorqueScale;
var(SVehicleSimCar) float SteerSpeed;
var(SVehicleSimCar) float ReverseThrottle;
var(SVehicleSimCar) float EngineBrakeFactor;
var(SVehicleSimCar) float MaxBrakeTorque;
var(SVehicleSimCar) float StopThreshold;
var float ActualSteering;
var float TimeSinceThrottle;
var bool bIsDriving;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReverseThrottle = -1.0
}