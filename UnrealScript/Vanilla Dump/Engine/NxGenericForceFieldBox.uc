Class NxGenericForceFieldBox extends NxGenericForceField
    native
    placeable;

var(NxGenericForceFieldBox) interp Vector BoxExtent;
var editinline export DrawBoxComponent RenderComponent;

public native function DoInitRBPhys();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawBoxComponent Name=DrawBox0
        BoxColor = {B = 255, G = 70, R = 64, A = 255}
        ReplacementPrimitive = None
    End Object
    BoxExtent = {X = 200.0, Y = 200.0, Z = 200.0}
    RenderComponent = DrawBox0
    Components = (DrawBox0, None)
}