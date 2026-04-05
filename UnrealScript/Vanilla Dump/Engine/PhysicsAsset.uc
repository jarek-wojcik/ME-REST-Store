Class PhysicsAsset
    native;

var const native Map_Mirror BodySetupIndexMap;
var const export array<RB_BodySetup> BodySetup;
var const array<int> BoundsBodies;
var const export array<RB_ConstraintSetup> ConstraintSetup;
var const export PhysicsAssetInstance DefaultInstance;

public final native function int FindBodyIndex(Name BodyName);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}