Class NxGenericForceField extends NxForceField
    native
    abstract;

var const transient native Pointer LinearKernel;
var(NxGenericForceField) Vector Constant;
var(NxGenericForceField) Vector PositionMultiplierX;
var(NxGenericForceField) Vector PositionMultiplierY;
var(NxGenericForceField) Vector PositionMultiplierZ;
var(NxGenericForceField) Vector PositionTarget;
var(NxGenericForceField) Vector VelocityMultiplierX;
var(NxGenericForceField) Vector VelocityMultiplierY;
var(NxGenericForceField) Vector VelocityMultiplierZ;
var(NxGenericForceField) Vector VelocityTarget;
var(NxGenericForceField) Vector Noise;
var(NxGenericForceField) Vector FalloffLinear;
var(NxGenericForceField) Vector FalloffQuadratic;
var(NxGenericForceField) float TorusRadius;
var(NxGenericForceField) FFG_ForceFieldCoordinates Coordinates;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TorusRadius = 1.0
}