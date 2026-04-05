Class NxTornadoForceField extends NxForceField
    native
    abstract;

var const transient native Pointer Kernel;
var(NxTornadoForceField) interp float RadialStrength;
var(NxTornadoForceField) interp float RotationalStrength;
var(NxTornadoForceField) interp float LiftStrength;
var(NxTornadoForceField) interp float ForceRadius;
var(NxTornadoForceField) interp float ForceTopRadius;
var(NxTornadoForceField) interp float LiftFalloffHeight;
var(NxTornadoForceField) interp float EscapeVelocity;
var(NxTornadoForceField) interp float ForceHeight;
var(NxTornadoForceField) interp float HeightOffset;
var(NxTornadoForceField) bool BSpecialRadialForceMode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ForceRadius = 200.0
}