Class NxForceFieldRadial extends NxForceField
    native
    placeable;

var const transient native Pointer Kernel;
var(NxForceFieldRadial) ForceFieldShape Shape;
var editinline native export ActorComponent DrawComponent;
var(NxForceFieldRadial) interp float ForceStrength;
var(NxForceFieldRadial) interp float ForceRadius;
var(NxForceFieldRadial) interp float SelfRotationStrength;
var(NxForceFieldRadial) editinline export ERadialImpulseFalloff ForceFalloff;

public native function DoInitRBPhys();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ForceRadius = 200.0
    Components = (None)
}