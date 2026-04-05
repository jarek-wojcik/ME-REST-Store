Class AnimNode_MultiBlendPerBone extends AnimNodeBlendBase
    native;

enum EBlendType
{
    EBT_ParentBoneSpace,
    EBT_MeshSpace,
};
struct native PerBoneMaskInfo 
{
    var(PerBoneMaskInfo) array<BranchInfo> BranchList;
    var(PerBoneMaskInfo) array<WeightRule> WeightRuleList;
    var transient array<float> PerBoneWeights;
    var transient array<byte> TransformReqBone;
    var(PerBoneMaskInfo) float DesiredWeight;
    var(PerBoneMaskInfo) float BlendTimeToGo;
    var transient int TransformReqBoneIndex;
    var(PerBoneMaskInfo) bool bWeightBasedOnNodeRules;
    var(PerBoneMaskInfo) bool bDisableForNonLocalHumanPlayers;
    var transient bool bPendingBlend;
    
    structdefaultproperties
    {
        TransformReqBone = ""
    }
};
struct native BranchInfo 
{
    var(BranchInfo) Name BoneName;
    var(BranchInfo) float PerBoneWeightIncrease;
    
    structdefaultproperties
    {
        PerBoneWeightIncrease = 1.0
    }
};
struct native WeightRule 
{
    var(WeightRule) WeightNodeRule FirstNode;
    var(WeightRule) WeightNodeRule SecondNode;
};
struct native WeightNodeRule 
{
    var(WeightNodeRule) Name NodeName;
    var AnimNodeBlendBase CachedNode;
    var AnimNodeSlot CachedSlotNode;
    var(WeightNodeRule) int ChildIndex;
    var(WeightNodeRule) EWeightCheck WeightCheck;
};
enum EWeightCheck
{
    EWC_AnimNodeSlotNotPlaying,
    EWC_ChildIndexFullWeight,
    EWC_ChildIndexNotFullWeight,
    EWC_ChildIndexRelevant,
    EWC_ChildIndexNotRelevant,
};

var(AnimNode_MultiBlendPerBone) editfixedsize array<PerBoneMaskInfo> MaskList;
var const transient Pawn PawnOwner;
var(AnimNode_MultiBlendPerBone) EBlendType RotationBlendType;

public final native function SetMaskWeight(int MaskIndex, float DesiredWeight, float BlendTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Source', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bSkipTickWhenZeroWeight = TRUE
}