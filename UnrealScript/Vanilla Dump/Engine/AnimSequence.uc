Class AnimSequence
    native
    config(Engine);

struct native AnimTag 
{
    var string Tag;
    var array<string> Contains;
};
enum AnimationKeyFormat
{
    AKF_ConstantKeyLerp,
    AKF_VariableKeyLerp,
};
struct native CompressedTrack 
{
    var array<byte> ByteStream;
    var array<float> Times;
    var float Mins[3];
    var float Ranges[3];
    
    structdefaultproperties
    {
        ByteStream = ""
    }
};
enum AnimationCompressionFormat
{
    ACF_None,
    ACF_Float96NoW,
    ACF_Fixed48NoW,
    ACF_IntervalFixed32NoW,
    ACF_Fixed32NoW,
    ACF_Float32NoW,
    ACF_BioFixed48,
};
struct native CurveTrack 
{
    var array<float> CurveWeights;
    var Name CurveName;
};
struct native RotationTrack 
{
    var array<Quat> RotKeys;
    var array<float> Times;
};
struct native TranslationTrack 
{
    var array<Vector> PosKeys;
    var array<float> Times;
};
struct native SkelControlModifier 
{
    var(SkelControlModifier) array<TimeModifier> Modifiers;
    var(SkelControlModifier) Name SkelControlName;
};
struct native TimeModifier 
{
    var(TimeModifier) float Time;
    var(TimeModifier) float TargetStrength;
};
struct RawAnimSequenceTrack 
{
    var array<Vector> PosKeys;
    var array<Quat> RotKeys;
};
struct native AnimNotifyEvent 
{
    var(AnimNotifyEvent) Name Comment;
    var(AnimNotifyEvent) float Time;
    var(AnimNotifyEvent) float Duration;
    var(AnimNotifyEvent) export AnimNotify Notify;
    var(AnimNotifyEvent) bool bIgnoreWeightThreshold;
};

var native biosave array<byte> CompressedByteStream;
var(AnimSequence) array<AnimNotifyEvent> Notifies;
var(AnimSequence) export array<AnimMetaData> MetaData;
var const transient array<TranslationTrack> TranslationData;
var const transient array<RotationTrack> RotationData;
var const array<CurveTrack> CurveData;
var array<int> CompressedTrackOffsets;
var const array<RawAnimSequenceTrack> AdditiveBasePose;
var transient native Pointer TranslationCodec;
var transient native Pointer RotationCodec;
var Name SequenceName;
var float SequenceLength;
var int NumFrames;
var(AnimSequence) float RateScale;
var transient int LargestTrackStreamSize;
var BioAnimSetData m_pBioAnimSetData;
var const int EncodingPkgVersion;
var const transient float UseScore;
var(AnimSequence) bool bNoLoopingInterpolation;
var const transient native bool bRawAnimationBulkDataCached;
var const transient native bool bRawAnimationDirty;
var const bool bIsAdditive;
var const transient bool bHasBeenUsed;
var transient bool bHasWeightIgnoreNotifies;
var const AnimationCompressionFormat TranslationCompressionFormat;
var const AnimationCompressionFormat RotationCompressionFormat;
var const AnimationKeyFormat KeyEncodingFormat;

public native function float GetNotifyTimeByClass(Class<AnimNotify> NotifyClass, optional float PlayRate = 1.0, optional float StartPosition = -1.0);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RateScale = 1.0
}