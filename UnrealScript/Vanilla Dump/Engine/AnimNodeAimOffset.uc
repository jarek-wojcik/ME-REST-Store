Class AnimNodeAimOffset extends AnimNodeBlendBase
    native;

struct native immutablewhencooked AimOffsetProfile 
{
    var array<AimComponent> AimComponents;
    var(AimOffsetProfile) const editconst Name ProfileName;
    var(AimOffsetProfile) Vector2D HorizontalRange;
    var(AimOffsetProfile) Vector2D VerticalRange;
    var(AimOffsetProfile) Name AnimName_LU;
    var(AimOffsetProfile) Name AnimName_LC;
    var(AimOffsetProfile) Name AnimName_LD;
    var(AimOffsetProfile) Name AnimName_CU;
    var(AimOffsetProfile) Name AnimName_CC;
    var(AimOffsetProfile) Name AnimName_CD;
    var(AimOffsetProfile) Name AnimName_RU;
    var(AimOffsetProfile) Name AnimName_RC;
    var(AimOffsetProfile) Name AnimName_RD;
    
    structdefaultproperties
    {
        ProfileName = 'Default'
        HorizontalRange = {X = -1.0, Y = 1.0}
        VerticalRange = {X = -1.0, Y = 1.0}
    }
};
enum EAimID
{
    EAID_LeftUp,
    EAID_LeftDown,
    EAID_RightUp,
    EAID_RightDown,
    EAID_ZeroUp,
    EAID_ZeroDown,
    EAID_ZeroLeft,
    EAID_ZeroRight,
    EAID_CellLU,
    EAID_CellCU,
    EAID_CellRU,
    EAID_CellLC,
    EAID_CellCC,
    EAID_CellRC,
    EAID_CellLD,
    EAID_CellCD,
    EAID_CellRD,
};
enum EAnimAimDir
{
    ANIMAIM_LEFTUP,
    ANIMAIM_CENTERUP,
    ANIMAIM_RIGHTUP,
    ANIMAIM_LEFTCENTER,
    ANIMAIM_CENTERCENTER,
    ANIMAIM_RIGHTCENTER,
    ANIMAIM_LEFTDOWN,
    ANIMAIM_CENTERDOWN,
    ANIMAIM_RIGHTDOWN,
};
struct native immutablewhencooked AimComponent 
{
    var(AimComponent) AimTransform LU;
    var(AimComponent) AimTransform LC;
    var(AimComponent) AimTransform LD;
    var(AimComponent) AimTransform CU;
    var(AimComponent) AimTransform CC;
    var(AimComponent) AimTransform CD;
    var(AimComponent) AimTransform RU;
    var(AimComponent) AimTransform RC;
    var(AimComponent) AimTransform RD;
    var(AimComponent) Name BoneName;
};
struct native immutablewhencooked AimTransform 
{
    var(AimTransform) Quat Quaternion;
    var(AimTransform) Vector Translation;
};

var transient array<byte> RequiredBones;
var transient array<byte> AimCpntBoneIndex;
var transient array<byte> AimCpntIndexLUT;
var(AnimNodeAimOffset) editfixedsize array<AimOffsetProfile> Profiles;
var(AnimNodeAimOffset) Vector2D Aim;
var(AnimNodeAimOffset) Vector2D AngleOffset;
var(Performance) int PassThroughAtOrAboveLOD;
var transient AnimNodeAimOffset TemplateNode;
var(AnimNodeAimOffset) const editconst int CurrentProfileIndex;
var(AnimNodeAimOffset) bool bForceAimDir;
var(AnimNodeAimOffset) bool bBakeFromAnimations;
var(Performance) bool bPassThroughWhenNotRendered;
var(Editor) bool bSynchronizeNodesInEditor;
var(AnimNodeAimOffset) EAnimAimDir ForcedAimDir;

public native function SetActiveProfileByIndex(int ProfileIndex);

public native function SetActiveProfileByName(Name ProfileName);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PassThroughAtOrAboveLOD = 1000
    bSynchronizeNodesInEditor = TRUE
    ForcedAimDir = EAnimAimDir.ANIMAIM_CENTERCENTER
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Input', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    bSkipTickWhenZeroWeight = TRUE
}