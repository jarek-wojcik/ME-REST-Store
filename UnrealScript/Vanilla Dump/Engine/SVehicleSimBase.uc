Class SVehicleSimBase extends ActorComponent
    native;

var(SVehicleSimBase) float WheelSuspensionStiffness;
var(SVehicleSimBase) float WheelSuspensionDamping;
var(SVehicleSimBase) float WheelSuspensionBias;
var(SVehicleSimBase) float WheelLongExtremumSlip;
var(SVehicleSimBase) float WheelLongExtremumValue;
var(SVehicleSimBase) float WheelLongAsymptoteSlip;
var(SVehicleSimBase) float WheelLongAsymptoteValue;
var(SVehicleSimBase) float WheelLatExtremumSlip;
var(SVehicleSimBase) float WheelLatExtremumValue;
var(SVehicleSimBase) float WheelLatAsymptoteSlip;
var(SVehicleSimBase) float WheelLatAsymptoteValue;
var(SVehicleSimBase) float WheelInertia;
var(SVehicleSimBase) float AutoDriveSteer;
var(SVehicleSimBase) bool bWheelSpeedOverride;
var(SVehicleSimBase) bool bClampedFrictionModel;
var(SVehicleSimBase) bool bAutoDrive;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    WheelLongExtremumSlip = 0.100000001
    WheelLongExtremumValue = 1.0
    WheelLongAsymptoteSlip = 2.0
    WheelLongAsymptoteValue = 0.600000024
    WheelLatExtremumSlip = 0.349999994
    WheelLatExtremumValue = 0.850000024
    WheelLatAsymptoteSlip = 1.39999998
    WheelLatAsymptoteValue = 0.699999988
    WheelInertia = 1.0
}