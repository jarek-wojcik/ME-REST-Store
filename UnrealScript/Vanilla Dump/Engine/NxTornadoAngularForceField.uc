Class NxTornadoAngularForceField extends NxForceField
    native
    abstract;

var const transient native Pointer Kernel;
var(NxTornadoAngularForceField) interp float RadialStrength;
var(NxTornadoAngularForceField) interp float RotationalStrength;
var(NxTornadoAngularForceField) interp float LiftStrength;
var(NxTornadoAngularForceField) interp float ForceRadius;
var(NxTornadoAngularForceField) interp float ForceTopRadius;
var(NxTornadoAngularForceField) interp float LiftFalloffHeight;
var(NxTornadoAngularForceField) interp float EscapeVelocity;
var(NxTornadoAngularForceField) interp float ForceHeight;
var(NxTornadoAngularForceField) interp float HeightOffset;
var(NxTornadoAngularForceField) interp float SelfRotationStrength;
var(NxTornadoAngularForceField) bool BSpecialRadialForceMode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ForceRadius = 200.0
}