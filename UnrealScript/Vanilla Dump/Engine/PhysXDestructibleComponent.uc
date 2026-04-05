Class PhysXDestructibleComponent extends PrimitiveComponent
    native;

var array<byte> Fragmented;
var array<int> BoxElemStart;
var array<int> ConvexElemStart;
var RB_BodySetup DetailedCollision;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReplacementPrimitive = None
}