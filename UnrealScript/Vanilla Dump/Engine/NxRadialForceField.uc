Class NxRadialForceField extends NxForceField
    native
    placeable;

var const transient native Pointer LinearKernel;
var editinline export DrawSphereComponent RenderComponent;
var(NxRadialForceField) interp float ForceStrength;
var(NxRadialForceField) interp float ForceRadius;
var(NxRadialForceField) editinline export ERadialImpulseFalloff ForceFalloff;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawSphereComponent Name=DrawSphere0
        SphereColor = {B = 255, G = 70, R = 64, A = 255}
        SphereRadius = 200.0
        ReplacementPrimitive = None
    End Object
    RenderComponent = DrawSphere0
    ForceStrength = 10.0
    ForceRadius = 200.0
    Components = (DrawSphere0, None)
}