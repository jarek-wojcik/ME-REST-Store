Class PhysXDestructibleAsset
    native;

struct native PhysXDestructibleAssetChunk 
{
    var Name BoneName;
    var int Index;
    var int FragmentIndex;
    var float Volume;
    var float Size;
    var int Depth;
    var int ParentIndex;
    var int FirstChildIndex;
    var int NumChildren;
    var int MeshIndex;
    var int BoneIndex;
    var int BodyIndex;
};

var array<PhysXDestructibleAssetChunk> ChunkTree;
var(PhysXDestructibleAsset) const array<SkeletalMesh> Meshes;
var(PhysXDestructibleAsset) const array<PhysicsAsset> Assets;
var(PhysXDestructibleAsset) const int MaxDepth;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}