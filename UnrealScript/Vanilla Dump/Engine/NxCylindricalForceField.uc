Class NxCylindricalForceField extends NxForceField
    native
    abstract;

var const transient native Pointer Kernel;
var(NxCylindricalForceField) interp float RadialStrength;
var(NxCylindricalForceField) interp float RotationalStrength;
var(NxCylindricalForceField) interp float LiftStrength;
var(NxCylindricalForceField) interp float ForceRadius;
var(NxCylindricalForceField) interp float ForceTopRadius;
var(NxCylindricalForceField) interp float LiftFalloffHeight;
var(NxCylindricalForceField) interp float EscapeVelocity;
var(NxCylindricalForceField) interp float ForceHeight;
var(NxCylindricalForceField) interp float HeightOffset;
var(NxCylindricalForceField) bool UseSpecialRadialForce;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ForceRadius = 200.0
}