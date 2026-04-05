Class AnimNode extends AnimObject
    native
    abstract;

struct CurveKey 
{
    var Name CurveName;
    var float Weight;
};
enum ESliderType
{
    ST_1D,
    ST_2D,
};
struct BoneTransform 
{
};

var transient BoneAtom CachedRootMotionDelta;
var transient array<AnimNodeBlendBase> ParentNodes;
var transient array<BoneAtom> CachedBoneAtoms;
var transient array<CurveKey> CachedCurveKeys;
var(AnimNode) Name NodeName;
var const transient int NodeTickTag;
var const transient int NodeCachedAtomsTag;
var const float NodeTotalWeight;
var const transient int SkelCompIndex;
var transient int bCachedHasRootMotion;
var const transient int SearchTag;
var const transient bool bRelevant;
var const transient bool bJustBecameRelevant;
var(Performance) bool bSkipTickWhenZeroWeight;
var(Performance) bool bTickDuringPausedAnims;
var transient byte CachedNumDesiredBones;

public final native function AnimNode FindAnimNode(Name InNodeName);

public event function OnBecomeRelevant();

public event function OnCeaseRelevant();

public event function OnInit();

public native function PlayAnim(optional bool bLoop = FALSE, optional float Rate = 1.0, optional float StartTime = 0.0);

public native function ReplayAnim();

public native function StopAnim();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}