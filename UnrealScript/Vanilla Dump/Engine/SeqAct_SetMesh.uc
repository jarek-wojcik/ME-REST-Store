Class SeqAct_SetMesh extends SequenceAction
    native;

enum EMeshType
{
    MeshType_StaticMesh,
    MeshType_SkeletalMesh,
};

var(SeqAct_SetMesh) SkeletalMesh NewSkeletalMesh;
var(SeqAct_SetMesh) StaticMesh NewStaticMesh;
var(SeqAct_SetMesh) bool bIsAllowedToMove;
var(SeqAct_SetMesh) bool bAllowDecalsToReattach;
var(SeqAct_SetMesh) EMeshType MeshType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}