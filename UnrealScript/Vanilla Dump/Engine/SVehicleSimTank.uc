Class SVehicleSimTank extends SVehicleSimCar
    native;

var float LeftTrackVel;
var float RightTrackVel;
var float LeftTrackTorque;
var float RightTrackTorque;
var(SVehicleSimTank) float MaxEngineTorque;
var(SVehicleSimTank) float EngineDamping;
var(SVehicleSimTank) float InsideTrackTorqueFactor;
var(SVehicleSimTank) float SteeringLatStiffnessFactor;
var(SVehicleSimTank) float TurnInPlaceThrottle;
var(SVehicleSimTank) float TurnMaxGripReduction;
var(SVehicleSimTank) float TurnGripScaleRate;
var(SVehicleSimTank) bool bTurnInPlaceOnSteer;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TurnMaxGripReduction = 0.970000029
    TurnGripScaleRate = 1.0
    bTurnInPlaceOnSteer = TRUE
    bWheelSpeedOverride = TRUE
}