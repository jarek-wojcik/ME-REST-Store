Class AnimNodeBlendMultiBone extends AnimNodeBlendBase
    native;

struct native ChildBoneBlendInfo 
{
    var array<float> TargetPerBoneWeight;
    var transient array<byte> TargetRequiredBones;
    var(ChildBoneBlendInfo) Name InitTargetStartBone;
    var const Name OldStartBone;
    var(ChildBoneBlendInfo) float InitPerBoneIncrease;
    var const float OldBoneIncrease;
    
    structdefaultproperties
    {
        TargetRequiredBones = ""
        InitPerBoneIncrease = 1.0
    }
};

var(AnimNodeBlendMultiBone) array<ChildBoneBlendInfo> BlendTargetList;
var transient array<byte> SourceRequiredBones;

public final native function SetTargetStartBone(int TargetIdx, Name StartBoneName, optional float PerBoneIncrease);


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
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Target', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
}