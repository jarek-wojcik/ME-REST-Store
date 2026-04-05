Class PrimitiveComponentFactory
    native
    abstract;

var(Collision) const bool CollideActors;
var(Collision) const bool BlockActors;
var(Collision) const bool BlockZeroExtent;
var(Collision) const bool BlockNonZeroExtent;
var(Collision) const bool BlockRigidBody;
var(Rendering) bool HiddenGame;
var(Rendering) bool HiddenEditor;
var(Rendering) bool CastShadow;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}