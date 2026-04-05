Class BioAnimNodeBlendPerBone extends AnimNodeBlendPerBone
    native;

enum EBoneBlendTestType
{
    BLENDTESTTYPE_NONE,
    BLENDTESTTYPE_ANIM,
    BLENDTESTTYPE_BONE,
};
enum EBoneBlendType
{
    BLENDTYPE_ALWAYS,
    BLENDTYPE_ALWAYS_BONE_SWITCH,
    BLENDTYPE_CROSSFADE_BONE_SWITCH,
    BLENDTYPE_SWITCH,
    BLENDTYPE_TOGGLE,
    BLENDTYPE_WEIGHT,
};

var(BioAnimNodeBlendPerBone) array<Name> BioBranchStartBoneName;
var(BioAnimNodeBlendPerBone) Name BlendName;
var(BioAnimNodeBlendPerBone) float OverblendFactor;
var(BioAnimNodeBlendPerBone) float FadeInTime;
var(BioAnimNodeBlendPerBone) float FadeOutTime;
var bool m_bNotifiedBlendComplete;
var bool m_bBoneSwitchOn;
var(BioAnimNodeBlendPerBone) EBoneBlendType BoneBlendType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FadeInTime = 0.100000001
    FadeOutTime = 0.330000013
    BoneBlendType = EBoneBlendType.BLENDTYPE_TOGGLE
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Default', 
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
                 Name = 'BoneAnim', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
}