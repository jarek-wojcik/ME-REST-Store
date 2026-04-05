Class NxGenericForceFieldCapsule extends NxGenericForceField
    native
    placeable;

var editinline export DrawCapsuleComponent RenderComponent;
var(NxGenericForceFieldCapsule) float CapsuleHeight;
var(NxGenericForceFieldCapsule) float CapsuleRadius;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawCapsuleComponent Name=DrawCapsule0
        CapsuleColor = {B = 255, G = 70, R = 64, A = 255}
        ReplacementPrimitive = None
    End Object
    RenderComponent = DrawCapsule0
    CapsuleHeight = 200.0
    CapsuleRadius = 200.0
    Components = (DrawCapsule0, None)
}