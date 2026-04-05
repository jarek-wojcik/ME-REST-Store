Class BioAnimNodeBlendByDeath extends BioAnimNodeBlendBase
    native;

enum EBioAnimDeath
{
    eBioAnimDeath_Head,
    eBioAnimDeath_Stomach,
    eBioAnimDeath_ArmLeft,
    eBioAnimDeath_ArmRight,
    eBioAnimDeath_LegLeft,
    eBioAnimDeath_LegRight,
};

var(SkelRoots) Name Head;
var(SkelRoots) Name LeftArm;
var(SkelRoots) Name RightArm;
var(SkelRoots) Name LeftLeg;
var(SkelRoots) Name RightLeg;
var(BioAnimNodeBlendByDeath) Name DeathEventName;
var const int m_nHeadRoot;
var const int m_nLeftArmRoot;
var const int m_nRightArmRoot;
var const int m_nLeftLegRoot;
var const int m_nRightLegRoot;
var float m_fTimeToRagdoll;
var float m_fCurrentTime;
var bool m_bEventTriggered;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Head = 'Neck'
    LeftArm = 'LeftCollar'
    RightArm = 'RightCollar'
    LeftLeg = 'LeftHip'
    RightLeg = 'RightHip'
    DeathEventName = 'FinishDeath'
    m_nHeadRoot = -1
    m_nLeftArmRoot = -1
    m_nRightArmRoot = -1
    m_nLeftLegRoot = -1
    m_nRightLegRoot = -1
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Head', 
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
                 Name = 'Stomach', 
                 Weight = 0.0, 
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
                 Name = 'ArmLeft', 
                 Weight = 0.0, 
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
                 Name = 'ArmRight', 
                 Weight = 0.0, 
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
                 Name = 'LegLeft', 
                 Weight = 0.0, 
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
                 Name = 'LegRight', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
}