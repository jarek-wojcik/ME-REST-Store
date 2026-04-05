Class NxForceFieldTornado extends NxForceField
    native
    placeable;

var const transient native Pointer Kernel;
var(NxForceFieldTornado) ForceFieldShape Shape;
var editinline native export ActorComponent DrawComponent;
var(NxForceFieldTornado) interp float RadialStrength;
var(NxForceFieldTornado) interp float RotationalStrength;
var(NxForceFieldTornado) interp float LiftStrength;
var(NxForceFieldTornado) interp float ForceRadius;
var(NxForceFieldTornado) interp float ForceTopRadius;
var(NxForceFieldTornado) interp float LiftFalloffHeight;
var(NxForceFieldTornado) interp float EscapeVelocity;
var(NxForceFieldTornado) interp float ForceHeight;
var(NxForceFieldTornado) interp float HeightOffset;
var(NxForceFieldTornado) interp float SelfRotationStrength;
var(NxForceFieldTornado) bool BSpecialRadialForceMode;

public native function DoInitRBPhys();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ForceRadius = 200.0
    ForceTopRadius = 200.0
    ForceHeight = 200.0
    Components = (None)
}