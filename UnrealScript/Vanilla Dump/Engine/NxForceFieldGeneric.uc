Class NxForceFieldGeneric extends NxForceField
    native
    placeable;

enum FFG_ForceFieldCoordinates
{
    FFG_CARTESIAN,
    FFG_SPHERICAL,
    FFG_CYLINDRICAL,
    FFG_TOROIDAL,
};

var const transient native Pointer LinearKernel;
var(NxForceFieldGeneric) Vector Constant;
var(NxForceFieldGeneric) Vector PositionMultiplierX;
var(NxForceFieldGeneric) Vector PositionMultiplierY;
var(NxForceFieldGeneric) Vector PositionMultiplierZ;
var(NxForceFieldGeneric) Vector PositionTarget;
var(NxForceFieldGeneric) Vector VelocityMultiplierX;
var(NxForceFieldGeneric) Vector VelocityMultiplierY;
var(NxForceFieldGeneric) Vector VelocityMultiplierZ;
var(NxForceFieldGeneric) Vector VelocityTarget;
var(NxForceFieldGeneric) Vector Noise;
var(NxForceFieldGeneric) Vector FalloffLinear;
var(NxForceFieldGeneric) Vector FalloffQuadratic;
var(NxForceFieldGeneric) ForceFieldShape Shape;
var editinline native export ActorComponent DrawComponent;
var(NxForceFieldGeneric) float RoughExtentX;
var(NxForceFieldGeneric) float RoughExtentY;
var(NxForceFieldGeneric) float RoughExtentZ;
var(NxForceFieldGeneric) float TorusRadius;
var(NxForceFieldGeneric) FFG_ForceFieldCoordinates Coordinates;

public native function DoInitRBPhys();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RoughExtentX = 200.0
    RoughExtentY = 200.0
    RoughExtentZ = 200.0
    TorusRadius = 1.0
    Components = (None)
}