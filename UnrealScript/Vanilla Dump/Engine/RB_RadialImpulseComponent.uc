Class RB_RadialImpulseComponent extends PrimitiveComponent
    native;

var(RB_RadialImpulseComponent) float ImpulseStrength;
var(RB_RadialImpulseComponent) float ImpulseRadius;
var editinline export DrawSphereComponent PreviewSphere;
var(RB_RadialImpulseComponent) bool bVelChange;
var(RB_RadialImpulseComponent) bool bCauseFracture;
var(RB_RadialImpulseComponent) ERadialImpulseFalloff ImpulseFalloff;

public native function FireImpulse(Vector Origin);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ImpulseStrength = 900.0
    ImpulseRadius = 200.0
    ReplacementPrimitive = None
    TickGroup = ETickingGroup.TG_PreAsyncWork
}