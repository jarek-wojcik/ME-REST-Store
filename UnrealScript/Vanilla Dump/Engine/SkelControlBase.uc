Class SkelControlBase extends AnimObject
    native
    abstract;

enum EBoneControlSpace
{
    BCS_WorldSpace,
    BCS_ActorSpace,
    BCS_ComponentSpace,
    BCS_ParentBoneSpace,
    BCS_BoneSpace,
    BCS_OtherBoneSpace,
    BCS_BaseMeshSpace,
};

var(Controller) array<Name> StrengthAnimNodeNameList;
var transient array<AnimNode> CachedNodeList;
var transient array<AnimNodeSequence> AnimMetadataCachedAnimNodeSeqList;
var(Controller) Name ControlName;
var(Controller) float ControlStrength;
var(Controller) float BlendInTime;
var(Controller) float BlendOutTime;
var float StrengthTarget;
var transient float BlendTimeToGo;
var transient float AnimMetadataWeight;
var(Controller) float BoneScale;
var transient int ControlTickTag;
var(Performance) int IgnoreAtOrAboveLOD;
var SkelControlBase NextControl;
var(Controller) bool bPostPhysicsController;
var(Controller) bool bSetStrengthFromAnimNode;
var transient bool bInitializedCachedNodeList;
var(Controller) bool bControlledByAnimMetada;
var(Controller) bool bPropagateSetActive;
var(Performance) bool bIgnoreWhenNotRendered;
var bool bShouldTickInScript;
var(Controller) AlphaBlendType BlendType;

public final native function SetSkelControlActive(bool bInActive);

public final native function SetSkelControlStrength(float NewStrength, float InBlendTime);

public event function TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ControlStrength = 1.0
    BlendInTime = 0.200000003
    BlendOutTime = 0.200000003
    StrengthTarget = 1.0
    BoneScale = 1.0
    IgnoreAtOrAboveLOD = 1000
}