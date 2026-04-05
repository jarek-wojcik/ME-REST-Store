Class SFXCompositeSkeletalMesh extends SkeletalMesh
    native;

var array<string> SourceMeshNames;
var array<BoneOverrideInfo> OverrideInfo;

public native function bool MatchesMerge(SkeletalMesh BaseMesh, array<SkeletalMesh> AdditionalMeshes, SkeletalMeshComponent HeadMeshComponent);

public static final native function SFXCompositeSkeletalMesh MergeMeshes(SkeletalMesh BaseMesh, array<SkeletalMesh> AdditionalMeshes, SkeletalMeshComponent HeadMeshComponent);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}