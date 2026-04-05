Class AnimTree extends AnimNodeBlendBase
    native;

struct native PreviewAnimSetsStruct 
{
    var(PreviewAnimSetsStruct) array<AnimSet> PreviewAnimSets;
    var(PreviewAnimSetsStruct) Name DisplayName;
};
struct native PreviewSocketStruct 
{
    var(PreviewSocketStruct) Name DisplayName;
    var(PreviewSocketStruct) Name SocketName;
    var(PreviewSocketStruct) SkeletalMesh PreviewSkelMesh;
    var(PreviewSocketStruct) StaticMesh PreviewStaticMesh;
};
struct native PreviewSkelMeshStruct 
{
    var(PreviewSkelMeshStruct) array<MorphTargetSet> PreviewMorphSets;
    var(PreviewSkelMeshStruct) Name DisplayName;
    var(PreviewSkelMeshStruct) SkeletalMesh PreviewSkelMesh;
};
struct native SkelControlListHead 
{
    var Name BoneName;
    var export SkelControlBase ControlHead;
};
struct native AnimGroup 
{
    var const transient array<AnimNodeSequence> SeqNodes;
    var(AnimGroup) const Name GroupName;
    var const transient AnimNodeSequence SynchMaster;
    var const transient AnimNodeSequence NotifyMaster;
    var(AnimGroup) const float RateScale;
    var const float SynchPctPosition;
    
    structdefaultproperties
    {
        RateScale = 1.0
    }
};

var(AnimTree) array<AnimGroup> AnimGroups;
var(AnimTree) array<Name> ComposePrePassBoneNames;
var(AnimTree) array<Name> ComposePostPassBoneNames;
var export array<MorphNodeBase> RootMorphNodes;
var export array<SkelControlListHead> SkelControlLists;
var array<BoneAtom> SavedPose;
var bool bUseSavedPose;

public final native function MorphNodeBase FindMorphNode(Name InNodeName);

public final native function SkelControlBase FindSkelControl(Name InControlName);

public final native function ForceGroupRelativePosition(Name GroupName, float RelativePosition);

public final native function int GetGroupIndex(Name GroupName);

public final native function AnimNodeSequence GetGroupNotifyMaster(Name GroupName);

public final native function float GetGroupRateScale(Name GroupName);

public final native function float GetGroupRelativePosition(Name GroupName);

public final native function AnimNodeSequence GetGroupSynchMaster(Name GroupName);

public final native function bool SetAnimGroupForNode(AnimNodeSequence SeqNode, Name GroupName, optional bool bCreateIfNotFound);

public final native function SetGroupRateScale(Name GroupName, float NewRateScale);

public final native function SetUseSavedPose(bool bUseSaved);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Child', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
}