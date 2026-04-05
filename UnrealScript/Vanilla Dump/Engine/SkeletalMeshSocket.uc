Class SkeletalMeshSocket
    native;

var(SkeletalMeshSocket) Vector RelativeLocation;
var(SkeletalMeshSocket) Rotator RelativeRotation;
var(SkeletalMeshSocket) Vector RelativeScale;
var(SkeletalMeshSocket) const editconst Name SocketName;
var(SkeletalMeshSocket) const editconst Name BoneName;
var(SkeletalMeshSocket) Name SupermodelName;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RelativeScale = {X = 1.0, Y = 1.0, Z = 1.0}
}