Class Object
    native
    noexport
    abstract;

enum EDebugBreakType
{
    DEBUGGER_NativeOnly,
    DEBUGGER_ScriptOnly,
    DEBUGGER_Both,
};
enum EAutomatedRunResult
{
    ARR_Unknown,
    ARR_OOM,
    ARR_Passed,
};
enum ENetRole
{
    ROLE_None,
    ROLE_SimulatedProxy,
    ROLE_AutonomousProxy,
    ROLE_Authority,
};
enum ETickingGroup
{
    TG_PreAsyncWork,
    TG_DuringAsyncWork,
    TG_PostAsyncWork,
    TG_PostUpdateWork,
    TG_PostDirtyComponentsWork,
};
const InvAspectRatio16x9 = 0.56249;
const InvAspectRatio5x4 = 0.8;
const InvAspectRatio4x3 = 0.75;
const AspectRatio16x9 = 1.77778;
const AspectRatio5x4 = 1.25;
const AspectRatio4x3 = 1.33333;
const DegToUU = 182.044444444444;
const UUToDeg = 0.005493164063;
const INDEX_NONE = -1;
const RadToUnrRot = 10430.3783504704527;
const UnrRotToRad = 0.00009587379924285;
const DegToRad = 0.017453292519943296;
const RadToDeg = 57.295779513082321600;
const Pi = 3.1415926535897932;
const MaxInt = 0x7fffffff;
struct BoneAtom 
{
    var Quat Rotation;
    var Vector Translation;
    var float Scale;
};
struct OctreeElementId 
{
    var const native Pointer Node;
    var const native int ElementIndex;
};
struct RenderCommandFence 
{
    var const native int NumPendingFences;
};
struct BioRawDistributionRwVector3Base 
{
    var byte Type;
    var byte Op;
    var byte LookupTableNumElements;
    var byte LookupTableChunkSize;
    var float LookupTableMinOut;
    var float LookupTableMaxOut;
    var array<RwVector3> LookupTable;
    var float LookupTableTimeScale;
    var float LookupTableStartTime;
};
struct RawDistribution 
{
    var byte Type;
    var byte Op;
    var byte LookupTableNumElements;
    var byte LookupTableChunkSize;
    var array<float> LookupTable;
    var float LookupTableTimeScale;
    var float LookupTableStartTime;
};
struct InterpCurveLinearColor 
{
    var(InterpCurveLinearColor) array<InterpCurvePointLinearColor> Points;
    var EInterpMethodType InterpMethod;
};
struct InterpCurvePointLinearColor 
{
    var(InterpCurvePointLinearColor) float InVal;
    var(InterpCurvePointLinearColor) LinearColor OutVal;
    var(InterpCurvePointLinearColor) LinearColor ArriveTangent;
    var(InterpCurvePointLinearColor) LinearColor LeaveTangent;
    var(InterpCurvePointLinearColor) EInterpCurveMode InterpMode;
};
struct InterpCurveQuat 
{
    var(InterpCurveQuat) array<InterpCurvePointQuat> Points;
    var EInterpMethodType InterpMethod;
};
struct InterpCurvePointQuat 
{
    var(InterpCurvePointQuat) float InVal;
    var(InterpCurvePointQuat) Quat OutVal;
    var(InterpCurvePointQuat) Quat ArriveTangent;
    var(InterpCurvePointQuat) Quat LeaveTangent;
    var(InterpCurvePointQuat) EInterpCurveMode InterpMode;
};
struct InterpCurveTwoVectors 
{
    var(InterpCurveTwoVectors) array<InterpCurvePointTwoVectors> Points;
    var EInterpMethodType InterpMethod;
};
struct InterpCurvePointTwoVectors 
{
    var(InterpCurvePointTwoVectors) float InVal;
    var(InterpCurvePointTwoVectors) TwoVectors OutVal;
    var(InterpCurvePointTwoVectors) TwoVectors ArriveTangent;
    var(InterpCurvePointTwoVectors) TwoVectors LeaveTangent;
    var(InterpCurvePointTwoVectors) EInterpCurveMode InterpMode;
};
struct InterpCurveVector 
{
    var(InterpCurveVector) array<InterpCurvePointVector> Points;
    var EInterpMethodType InterpMethod;
};
struct InterpCurvePointVector 
{
    var(InterpCurvePointVector) float InVal;
    var(InterpCurvePointVector) Vector OutVal;
    var(InterpCurvePointVector) Vector ArriveTangent;
    var(InterpCurvePointVector) Vector LeaveTangent;
    var(InterpCurvePointVector) EInterpCurveMode InterpMode;
};
struct InterpCurveVector2D 
{
    var(InterpCurveVector2D) array<InterpCurvePointVector2D> Points;
    var EInterpMethodType InterpMethod;
};
struct InterpCurvePointVector2D 
{
    var(InterpCurvePointVector2D) float InVal;
    var(InterpCurvePointVector2D) Vector2D OutVal;
    var(InterpCurvePointVector2D) Vector2D ArriveTangent;
    var(InterpCurvePointVector2D) Vector2D LeaveTangent;
    var(InterpCurvePointVector2D) EInterpCurveMode InterpMode;
};
struct InterpCurveFloat 
{
    var(InterpCurveFloat) array<InterpCurvePointFloat> Points;
    var EInterpMethodType InterpMethod;
};
struct InterpCurvePointFloat 
{
    var(InterpCurvePointFloat) float InVal;
    var(InterpCurvePointFloat) float OutVal;
    var(InterpCurvePointFloat) float ArriveTangent;
    var(InterpCurvePointFloat) float LeaveTangent;
    var(InterpCurvePointFloat) EInterpCurveMode InterpMode;
};
enum EInterpMethodType
{
    IMT_UseFixedTangentEvalAndNewAutoTangents,
    IMT_UseFixedTangentEval,
    IMT_UseBrokenTangentEval,
};
enum EInterpCurveMode
{
    CIM_Linear,
    CIM_CurveAuto,
    CIM_Constant,
    CIM_CurveUser,
    CIM_CurveBreak,
    CIM_CurveAutoClamped,
};
struct Cylinder 
{
    var float Radius;
    var float Height;
};
struct immutable Matrix 
{
    var(Matrix) Plane XPlane;
    var(Matrix) Plane YPlane;
    var(Matrix) Plane ZPlane;
    var(Matrix) Plane WPlane;
};
struct BoxSphereBounds 
{
    var(BoxSphereBounds) Vector Origin;
    var(BoxSphereBounds) Vector BoxExtent;
    var(BoxSphereBounds) float SphereRadius;
};
struct immutable Box 
{
    var(Box) Vector Min;
    var(Box) Vector Max;
    var byte IsValid;
};
struct immutable LinearColor 
{
    var(LinearColor) float R;
    var(LinearColor) float G;
    var(LinearColor) float B;
    var(LinearColor) float A;
    
    structdefaultproperties
    {
        A = 1.0
    }
};
struct immutable Color 
{
    var(Color) byte B;
    var(Color) byte G;
    var(Color) byte R;
    var(Color) byte A;
};
enum EInputEvent
{
    IE_Pressed,
    IE_Released,
    IE_Repeat,
    IE_DoubleClick,
    IE_Axis,
};
enum EAxis
{
    AXIS_NONE,
    AXIS_X,
    AXIS_Y,
    AXIS_BLANK,
    AXIS_Z,
};
struct TAlphaBlend 
{
    var const float AlphaIn;
    var const float AlphaOut;
    var(TAlphaBlend) float AlphaTarget;
    var(TAlphaBlend) float BlendTime;
    var const float BlendTimeToGo;
    var(TAlphaBlend) AlphaBlendType BlendType;
    
    structdefaultproperties
    {
        BlendTime = 0.670000017
    }
};
enum AlphaBlendType
{
    ABT_Linear,
    ABT_Cubic,
    ABT_Sinusoidal,
    ABT_EaseInOutExponent2,
    ABT_EaseInOutExponent3,
    ABT_EaseInOutExponent4,
    ABT_EaseInOutExponent5,
    ABT_EaseIn,
    ABT_EaseOut,
};
struct TPOV 
{
    var(TPOV) Vector location;
    var(TPOV) Rotator Rotation;
    var(TPOV) float FOV;
    
    structdefaultproperties
    {
        FOV = 90.0
    }
};
struct SHVectorRGB 
{
    var(SHVectorRGB) SHVector R;
    var(SHVectorRGB) SHVector G;
    var(SHVectorRGB) SHVector B;
};
struct SHVector 
{
    var(SHVector) float V[9];
    var float Padding[3];
};
struct immutable IntPoint 
{
    var(IntPoint) int X;
    var(IntPoint) int Y;
};
struct immutable Quat 
{
    var(Quat) float X;
    var(Quat) float Y;
    var(Quat) float Z;
    var(Quat) float W;
};
struct immutable Rotator 
{
    var(Rotator) int Pitch;
    var(Rotator) int Yaw;
    var(Rotator) int Roll;
};
struct immutable Plane extends Vector 
{
    var(Plane) float W;
};
struct immutable TwoVectors 
{
    var(TwoVectors) Vector v1;
    var(TwoVectors) Vector v2;
};
struct immutable Vector2D 
{
    var(Vector2D) float X;
    var(Vector2D) float Y;
};
struct immutable Vector4 
{
    var(Vector4) float X;
    var(Vector4) float Y;
    var(Vector4) float Z;
    var(Vector4) float W;
};
struct immutable Vector 
{
    var(Vector) float X;
    var(Vector) float Y;
    var(Vector) float Z;
};
struct immutable Guid 
{
    var int A;
    var int B;
    var int C;
    var int D;
};
struct Array_Mirror 
{
    var const native Pointer Data;
    var const native int ArrayNum;
    var const native int ArrayMax;
};
struct IndirectArray_Mirror 
{
    var const native Pointer Data;
    var const native int ArrayNum;
    var const native int ArrayMax;
};
struct FColorVertexBuffer_Mirror 
{
    var const native Pointer VfTable;
    var const native Pointer VertexData;
    var const int Data;
    var const int Stride;
    var const int NumVertices;
};
struct RenderCommandFence_Mirror 
{
    var const transient native int NumPendingFences;
};
struct UntypedBulkData_Mirror 
{
    var const native Pointer VfTable;
    var const native int BulkDataFlags;
    var const native int ElementCount;
    var const native int BulkDataOffsetInFile;
    var const native int BulkDataSizeOnDisk;
    var const native int SavedBulkDataFlags;
    var const native int SavedElementCount;
    var const native int SavedBulkDataOffsetInFile;
    var const native int SavedBulkDataSizeOnDisk;
    var const native Pointer BulkData;
    var const native int LockStatus;
    var const native Pointer AttachedAr;
    var const native int bShouldFreeOnEmpty;
};
struct immutable BioRwBox 
{
    var(BioRwBox) RwVector3 Min;
    var(BioRwBox) RwVector3 Max;
    var biomask4 IsValid;
    
    structdefaultproperties
    {
        IsValid = 0
    }
};
struct immutable RwQuat 
{
    var(RwQuat) float X;
    var(RwQuat) float Y;
    var(RwQuat) float Z;
    var(RwQuat) float W;
};
struct immutable RwMatrix44 
{
    var(RwMatrix44) RwPlane XPlane;
    var(RwMatrix44) RwPlane YPlane;
    var(RwMatrix44) RwPlane ZPlane;
    var(RwMatrix44) RwPlane WPlane;
};
struct immutable RwPlane 
{
    var(RwPlane) float X;
    var(RwPlane) float Y;
    var(RwPlane) float Z;
    var(RwPlane) float W;
};
struct immutable RwVector4 
{
    var(RwVector4) float X;
    var(RwVector4) float Y;
    var(RwVector4) float Z;
    var(RwVector4) float W;
};
struct immutable RwVector3 
{
    var(RwVector3) float X;
    var(RwVector3) float Y;
    var(RwVector3) float Z;
};
struct immutable RwVector2 
{
    var(RwVector2) float X;
    var(RwVector2) float Y;
};
struct MultiMap_Mirror 
{
    var const native Set_Mirror Pairs;
};
struct Map_Mirror 
{
    var const native Set_Mirror Pairs;
};
struct Set_Mirror 
{
    var const native SparseArray_Mirror Elements;
    var const native Pointer Hash;
    var const native int InlineHash;
    var const native int HashSize;
};
struct SparseArray_Mirror 
{
    var const native array<int> Elements;
    var const native BitArray_Mirror AllocationFlags;
    var const native int FirstFreeIndex;
    var const native int NumFreeIndices;
};
struct BitArray_Mirror 
{
    var const native Pointer IndirectData;
    var const native int InlineData[4];
    var const native int NumBits;
    var const native int MaxBits;
};
struct ThreadSafeCounter 
{
    var const native int Value;
};
struct Double 
{
    var const native int A;
    var const native int B;
};
enum ESFXLanguageSetting
{
    ESFXLanguageSetting_Current,
    ESFXLanguageSetting_SystemPreferred,
    ESFXLanguageSetting_SKUDefault,
};
enum ESFXLanguageContentType
{
    ESFXLanguageContentType_Package,
    ESFXLanguageContentType_Text,
    ESFXLanguageContentType_Speech,
};
struct native SFXTokenMapping 
{
    var(SFXTokenMapping) int TokenId;
    var(SFXTokenMapping) string Data;
};
struct QWord 
{
    var const native int A;
    var const native int B;
};
struct Pointer 
{
    var const native int Dummy;
};
const INVALID_STRINGREF = 0;

var const editconst native noexport Pointer VfTableObject;
var const editconst native noexport int ObjectInternalInteger;
var const editconst native QWord ObjectFlags;
var const editconst native Pointer HashNext;
var const editconst native Pointer HashOuterNext;
var const editconst native Pointer StateFrame;
var const editconst native noexport Object Linker;
var const editconst native noexport Pointer LinkerIndex;
var const editconst native noexport int NetIndex;
var const editconst native Object Outer;
var(Object) const editconst native Name Name;
var const editconst native Class<Object> Class;
var(Object) const editconst native Object ObjectArchetype;

public static final native(186) function float Abs(float A);

public static final native function float Acos(float A);

public static final native function appScreenDebugMessageStatic(string sMsg);

public static final native(237) function int Asc(string S);

public static final native function float Asin(float A);

public static final native(190) function float Atan(float A);

public static final native function float Atan2(float A, float B);

public event function BeginState(Name PreviousStateName);

public static final native(235) function string Caps(coerce string S);

public static final native(236) function string Chr(int i);

public static final native(251) function int Clamp(int V, int A, int B);

public static final native function Vector ClampLength(Vector V, float MaxLength);

public static final native(258) function bool ClassIsChildOf(Class<Object> TestClass, Class<Object> ParentClass);

public static final native function ClearCustomTokens();

public event function ContinuedState();

public static final native(188) function float Cos(float A);

public static final native function DebugBreak(optional int UserFlags, optional EDebugBreakType DebuggerType = 0);

public final native function DumpStateStack();

public static final native function Object DynamicLoadObject(string ObjectName, Class<Object> ObjectClass, optional bool MayFail);

public event function EndState(Name NextStateName);

public final native function float EvalInterpCurveFloat(InterpCurveFloat FloatCurve, float InVal);

public final native function Vector EvalInterpCurveVector(InterpCurveVector VectorCurve, float InVal);

public final native function Vector2D EvalInterpCurveVector2D(InterpCurveVector2D Vector2DCurve, float InVal);

public static final native(191) function float Exp(float A);

public static final native function int FCeil(float A);

public static final native(246) function float FClamp(float V, float A, float B);

public static final native function float FCubicInterp(float P0, float T0, float P1, float T1, float A);

public static final native function int FFloor(float A);

public static final native function Object FindObject(string ObjectName, Class<Object> ObjectClass);

public static final native function float FInterpConstantTo(float Current, float Target, float DeltaTime, float InterpSpeed);

public static final native function float FInterpEaseInOut(float A, float B, float Alpha, float Exp);

public static final native function float FInterpTo(float Current, float Target, float DeltaTime, float InterpSpeed);

public static final native(245) function float FMax(float A, float B);

public static final native(244) function float FMin(float A, float B);

public static final native(195) function float FRand();

public static final native function float GetAngleBetween(Vector A, Vector B);

public static final native function bool GetAngularDistance(out Vector2D OutAngularDist, Vector Direction, Vector AxisX, Vector AxisY, Vector AxisZ);

public static final native function GetAngularFromDotDist(out Vector2D OutAngDist, Vector2D DotDist);

public static final native(229) function GetAxes(Rotator A, out Vector X, out Vector Y, out Vector Z);

public static final native function bool GetDotDistance(out Vector2D OutDotDist, Vector Direction, Vector AxisX, Vector AxisY, Vector AxisZ);

public static final native function Name GetEnum(Object E, coerce int i);

public static final native function int GetEnumIndex(Object E, Name valueName);

public static final native function Name GetFuncName();

public static final simulated native function float GetMappedRangeValue(Vector2D InputRange, Vector2D OutputRange, float Value);

public final native function int GetNetIndex();

public static final native function array<Object> GetObjectArrayFromConfigSection(Class<Object> SearchClass, out array<Object> out_ObjectResults, optional bool SearchChildren = FALSE, optional Object ResultOuter = None);

public static final native function bool GetPerObjectConfigSections(Class<Object> SearchClass, out array<string> out_SectionNames, optional Object ObjectOuter, optional int MaxResults = 1024);

public final native(284) function Name GetStateName();

public final native function GetSystemTime(out int Year, out int Month, out int DayOfWeek, out int Day, out int Hour, out int Min, out int Sec, out int MSec);

public static final native function string GetTokenisedString(stringref srStringID, optional array<SFXTokenMapping> TokenList);

public static final native(230) function GetUnAxes(Rotator A, out Vector X, out Vector Y, out Vector Z);

public static final native function int GetVectorSide(Vector A, Vector B);

public final native(620) function GotoState(optional Name NewState, optional Name Label, optional bool bForceEvents, optional bool bKeepStack);

public static final native(651) function int InStr(coerce string S, coerce string T, optional bool bSearchFromRight, optional bool bIgnoreCase, optional int StartPos);

public static final native function Vector InverseTransformNormal(Matrix TM, Vector A);

public static final native function Vector InverseTransformVector(Matrix TM, Vector A);

public final native(197) function bool IsA(Name className);

public final native function bool IsChildState(Name TestState, Name TestParentState);

public final native(281) function bool IsInState(Name TestState, optional bool bTestStateStack);

public final native function bool IsPendingKill();

public static final native function bool IsUTracing();

public static final native(1501) function bool IsZero(Vector A);

public static final native(653) function string Left(coerce string S, int i);

public static final native(650) function int Len(coerce string S);

public static final native(247) function float Lerp(float A, float B, float Alpha);

public static native function string Localize(string SectionName, string KeyName, string PackageName);

public static final native(238) function string Locs(coerce string S);

public static final native(192) function float Loge(float A);

private static final native(231) function LogInternal(coerce string S, optional Name Tag);

public static final native function Matrix MakeRotationMatrix(Rotator Rotation);

public static final native function Matrix MakeRotationTranslationMatrix(Vector Translation, Rotator Rotation);

public static final native function Vector MatrixGetAxis(Matrix TM, EAxis Axis);

public static final native function Vector MatrixGetOrigin(Matrix TM);

public static final native function Rotator MatrixGetRotator(Matrix TM);

public static final native(250) function int Max(int A, int B);

public static final native(652) function string Mid(coerce string S, int i, optional int J);

public static final native(249) function int Min(int A, int B);

public static final native(300) function Vector MirrorVectorByNormal(Vector InVect, Vector InNormal);

public static final native(226) function Vector Normal(Vector A);

public static final native function Rotator Normalize(Rotator Rot);

public static final native function int NormalizeRotAxis(int Angle);

public static final native function Rotator OrthoRotation(Vector X, Vector Y, Vector Z);

public static final native function ParseStringIntoArray(string BaseString, out array<string> Pieces, string delim, bool bCullEmpty);

public static final native function string PathName(Object CheckObject);

public event function PausedState();

public final native function float PointDistToLine(Vector Point, Vector Line, Vector Origin, optional out Vector OutClosestPoint);

public final native function float PointDistToSegment(Vector Point, Vector StartPoint, Vector EndPoint, optional out Vector OutClosestPoint);

public static final native function Vector PointProjectToPlane(Vector Point, Vector A, Vector B, Vector C);

public event function PoppedState();

public final native function PopState(optional bool bPopAll);

public static final native(1500) function Vector ProjectOnTo(Vector X, Vector Y);

public event function PushedState();

public final native function PushState(Name NewState, optional Name NewLabel);

public static final native function float QuatDot(Quat A, Quat B);

public static final native function Quat QuatFindBetween(Vector A, Vector B);

public static final native function Quat QuatFromAxisAndAngle(Vector Axis, float Angle);

public static final native function Quat QuatFromRotator(Rotator A);

public static final native function Quat QuatInvert(Quat A);

public static final native function Quat QuatProduct(Quat A, Quat B);

public static final native function Vector QuatRotateVector(Quat A, Vector B);

public static final native function Quat QuatSlerp(Quat A, Quat B, float Alpha, optional bool bShortestPath);

public static final native function Rotator QuatToRotator(Quat A);

public static final native(167) function int Rand(int Max);

public static final native function float RDiff(Rotator A, Rotator B);

public static final native(201) function string Repl(coerce string Src, coerce string Match, coerce string With, optional bool bCaseSensitive);

public static final native(234) function string Right(coerce string S, int i);

public static final native function Rotator RInterpTo(Rotator Current, Rotator Target, float DeltaTime, float InterpSpeed, optional bool bConstantInterpSpeed);

public static final native function Rotator RLerp(Rotator A, Rotator B, float Alpha, optional bool bShortestPath);

public static final native(320) function Rotator RotRand(optional bool bRoll);

public static final native(199) function int Round(float A);

public static final native function Rotator RSmerp(Rotator A, Rotator B, float Alpha, optional bool bShortestPath);

public static final native function Rotator RTransform(Rotator R, Rotator RBasis);

public final native(536) function SaveConfig();

public static final native function ScriptTrace();

public static final native function SetBioRwBox(BioRwBox Target, Vector Min, Vector Max);

public static final native function SetCustomToken(int nTokenNum, string sToken);

public static final native function SetUTracing(bool bShouldUTrace);

public static final native(187) function float Sin(float A);

public static final native(193) function float Sqrt(float A);

public static final native(194) function float Square(float A);

public static final native function StaticSaveConfig();

public static final native(189) function float Tan(float A);

public final native function string TimeStamp();

public static final native function string ToHex(int A);

public static final native function Vector TransformNormal(Matrix TM, Vector A);

public static final native function Vector TransformVector(Matrix TM, Vector A);

public final native function Vector TransformVectorByRotation(Rotator SourceRotation, Vector SourceVector, optional bool bInverse);

public static final native function Vector VInterpTo(Vector Current, Vector Target, float DeltaTime, float InterpSpeed);

public static final native function Vector VLerp(Vector A, Vector B, float Alpha);

public static final native(252) function Vector VRand();

public static final native function Vector VRandCone(Vector Dir, float ConeHalfAngleRadians);

public static final native function Vector VRandCone2(Vector Dir, float HorizontalConeHalfAngleRadians, float VerticalConeHalfAngleRadians);

public static final native(225) function float VSize(Vector A);

public static final native function float VSize2D(Vector A);

public static final native function float VSizeSq(Vector A);

public static final native function float VSizeSq2D(Vector A);

public static final native function Vector VSmerp(Vector A, Vector B, float Alpha);

private static final native(232) function WarnInternal(coerce string S);

public static final operator function Color Add_ColorColor(Color A, Color B)
{
    A.R += B.R;
    A.G += B.G;
    A.B += B.B;
    return A;
}
public static final operator native(174) function float Add_FloatFloat(float A, float B);

public static final operator native(146) function int Add_IntInt(int A, int B);

public static final operator native(270) function Quat Add_QuatQuat(Quat A, Quat B);

public static final operator native(316) function Rotator Add_RotatorRotator(Rotator A, Rotator B);

public static final operator native function Vector2D Add_Vector2DVector2D(Vector2D A, Vector2D B);

public static final operator native(215) function Vector Add_VectorVector(Vector A, Vector B);

public static final operator native(139) function byte AddAdd_Byte(out byte A);

public static final operator native(165) function int AddAdd_Int(out int A);

public static final preoperator native(137) function byte AddAdd_PreByte(out byte A);

public static final preoperator native(163) function int AddAdd_PreInt(out int A);

public static final operator native(135) function byte AddEqual_ByteByte(out byte A, byte B);

public static final operator native(184) function float AddEqual_FloatFloat(out float A, float B);

public static final operator native(161) function int AddEqual_IntInt(out int A, int B);

public static final operator native(318) function Rotator AddEqual_RotatorRotator(out Rotator A, Rotator B);

public static final operator native(223) function Vector AddEqual_VectorVector(out Vector A, Vector B);

public static final operator native(156) function int And_IntInt(int A, int B);

public static final operator native(130) function bool AndAnd_BoolBool(bool A, skip bool B);

public final function appScreenDebugMessage(string sMsg)
{
    Class'Object'.static.appScreenDebugMessageStatic(sMsg);
}
public static final operator native(168) function string At_StrStr(coerce string A, coerce string B);

public static final operator native(323) function string AtEqual_StrStr(out string A, coerce string B);

public final simulated function float ByteToFloat(byte inputByte, optional bool bSigned)
{
    if (bSigned)
    {
        return float(inputByte) / 128.0 - 1.0;
    }
    else
    {
        return float(inputByte) / 255.0;
    }
}
public static final simulated function ClampRotAxis(int ViewAxis, out int out_DeltaViewAxis, int MaxLimit, int MinLimit)
{
    local int DesiredViewAxis;
    
    ViewAxis = NormalizeRotAxis(ViewAxis);
    DesiredViewAxis = ViewAxis + out_DeltaViewAxis;
    if (DesiredViewAxis > MaxLimit)
    {
        DesiredViewAxis = MaxLimit;
    }
    if (DesiredViewAxis < MinLimit)
    {
        DesiredViewAxis = MinLimit;
    }
    out_DeltaViewAxis = DesiredViewAxis - ViewAxis;
}
public static final simulated function int ClampRotAxisFromBase(int Current, int Center, int MaxDelta)
{
    local int DeltaFromCenter;
    
    DeltaFromCenter = NormalizeRotAxis(Current - Center);
    if (DeltaFromCenter > MaxDelta)
    {
        Current = Center + MaxDelta;
    }
    else if (DeltaFromCenter < -MaxDelta)
    {
        Current = Center - MaxDelta;
    }
    return Current;
}
public static final simulated function int ClampRotAxisFromRange(int Current, int Min, int Max)
{
    local int Delta;
    local int Center;
    
    Delta = NormalizeRotAxis(Max - Min) / 2;
    Center = NormalizeRotAxis(Max + Min) / 2;
    return ClampRotAxisFromBase(Current, Center, Delta);
}
public static final operator native function bool ClockwiseFrom_IntInt(int A, int B);

public static final function LinearColor ColorToLinearColor(Color OldColor)
{
    return MakeLinearColor(float(OldColor.R) / 255.0, float(OldColor.G) / 255.0, float(OldColor.B) / 255.0, float(OldColor.A) / 255.0);
}
public static final preoperator native(141) function int Complement_PreInt(int A);

public static final operator native(210) function bool ComplementEqual_FloatFloat(float A, float B);

public static final operator native(607) function bool ComplementEqual_StrStr(string A, string B);

public static final operator native(600) function string Concat_StrStr(coerce string A, coerce string B);

public static final operator native(322) function string ConcatEqual_StrStr(out string A, coerce string B);

public static final operator native(220) function Vector Cross_VectorVector(Vector A, Vector B);

public static final operator native(172) function float Divide_FloatFloat(float A, float B);

public static final operator native(145) function int Divide_IntInt(int A, int B);

public static final operator native(289) function Rotator Divide_RotatorFloat(Rotator A, float B);

public static final operator native(214) function Vector Divide_VectorFloat(Vector A, float B);

public static final operator native(134) function byte DivideEqual_ByteByte(out byte A, byte B);

public static final operator native(183) function float DivideEqual_FloatFloat(out float A, float B);

public static final operator native(160) function int DivideEqual_IntFloat(out int A, float B);

public static final operator native(291) function Rotator DivideEqual_RotatorFloat(out Rotator A, float B);

public static final operator native(222) function Vector DivideEqual_VectorFloat(out Vector A, float B);

public static final operator native(219) function float Dot_VectorVector(Vector A, Vector B);

public static final operator native(242) function bool EqualEqual_BoolBool(bool A, bool B);

public static final operator native(180) function bool EqualEqual_FloatFloat(float A, float B);

public static final operator native function bool EqualEqual_InterfaceInterface(Interface A, Interface B);

public static final operator native(154) function bool EqualEqual_IntInt(int A, int B);

public static final operator native(1002) function bool EqualEqual_IntStringRef(int A, stringref B);

public static final operator native(254) function bool EqualEqual_NameName(Name A, Name B);

public static final operator native(640) function bool EqualEqual_ObjectObject(Object A, Object B);

public static final operator native(142) function bool EqualEqual_RotatorRotator(Rotator A, Rotator B);

public static final operator native(1001) function bool EqualEqual_StringRefInt(stringref A, int B);

public static final operator native(1000) function bool EqualEqual_StringRefStringRef(stringref A, stringref B);

public static final operator native(605) function bool EqualEqual_StrStr(string A, string B);

public static final operator native(217) function bool EqualEqual_VectorVector(Vector A, Vector B);

public static final simulated function float FindDeltaAngle(float A1, float A2)
{
    local float Delta;
    
    Delta = A2 - A1;
    if (Delta > 3.14159274)
    {
        Delta = Delta - 3.14159274 * 2.0;
    }
    else if (Delta < -3.14159274)
    {
        Delta = Delta + 3.14159274 * 2.0;
    }
    return Delta;
}
public static final function float FInterpEaseIn(float A, float B, float Alpha, float Exp)
{
    return Lerp(A, B, Alpha ** Exp);
}
public static final function float FInterpEaseOut(float A, float B, float Alpha, float Exp)
{
    return Lerp(A, B, Alpha ** (float(1) / Exp));
}
public final simulated function byte FloatToByte(float inputFloat, optional bool bSigned)
{
    if (bSigned)
    {
        if (inputFloat > 0.980000019)
        {
            return 255;
        }
        else if (inputFloat < -0.980000019)
        {
            return 0;
        }
        else
        {
            return byte((inputFloat + 1.0) * 128.0);
        }
    }
    else if (inputFloat > 0.996100008)
    {
        return 255;
    }
    else if (inputFloat < 0.00400000019)
    {
        return 0;
    }
    else
    {
        return byte(inputFloat * 255.0);
    }
}
public static final simulated function float FPctByRange(float Value, float InMin, float InMax)
{
    return (Value - InMin) / (InMax - InMin);
}
public static final simulated function GetAngularDegreesFromRadians(out Vector2D OutFOV)
{
    OutFOV.X = OutFOV.X * 57.2957802;
    OutFOV.Y = OutFOV.Y * 57.2957802;
}
public static final simulated function float GetHeadingAngle(Vector Dir)
{
    local float Angle;
    
    Angle = Acos(FClamp(Dir.X, -1.0, 1.0));
    if (Dir.Y < 0.0)
    {
        Angle *= -1.0;
    }
    return Angle;
}
public final function Name GetPackageName()
{
    local Object o;
    
    o = Self;
    while (o.Outer != None)
    {
        o = o.Outer;
    }
    return o.Name;
}
public static final simulated function float GetRangePctByValue(Vector2D Range, float Value)
{
    return Range.Y == Range.X ? Range.X : (Value - Range.X) / (Range.Y - Range.X);
}
public static final simulated function float GetRangeValueByPct(Vector2D Range, float Pct)
{
    return Range.X + (Range.Y - Range.X) * Pct;
}
public static final function string GetRightMost(coerce string Text)
{
    local int idx;
    
    idx = InStr(Text, "_", , , );
    while (idx != -1)
    {
        Text = Mid(Text, idx + 1, Len(Text));
        idx = InStr(Text, "_", , , );
    }
    return Text;
}
public static final operator native(177) function bool Greater_FloatFloat(float A, float B);

public static final operator native(151) function bool Greater_IntInt(int A, int B);

public static final operator native(602) function bool Greater_StrStr(string A, string B);

public static final operator native(179) function bool GreaterEqual_FloatFloat(float A, float B);

public static final operator native(153) function bool GreaterEqual_IntInt(int A, int B);

public static final operator native(604) function bool GreaterEqual_StrStr(string A, string B);

public static final operator native(149) function int GreaterGreater_IntInt(int A, int B);

public static final operator native(276) function Vector GreaterGreater_VectorRotator(Vector A, Rotator B);

public static final operator native(196) function int GreaterGreaterGreater_IntInt(int A, int B);

public final simulated function bool InCylinder(Vector Origin, Rotator Dir, float Width, Vector A, optional bool bIgnoreZ)
{
    local Vector B;
    local Vector VDir;
    
    if (bIgnoreZ)
    {
        Origin.Z = 0.0;
        Dir.Pitch = 0;
        A.Z = 0.0;
    }
    VDir = Vector(Dir);
    B = (A - Origin) Dot VDir * VDir + Origin;
    if (VSizeSq(B - A) <= Width * Width)
    {
        return TRUE;
    }
    return FALSE;
}
public static final function JoinArray(array<string> StringArray, out string out_Result, optional string delim = ",", optional bool bIgnoreBlanks = TRUE)
{
    local int i;
    
    out_Result = "";
    for (i = 0; i < StringArray.Length; i++)
    {
        if (StringArray[i] != "" || !bIgnoreBlanks)
        {
            if (out_Result != "" || !bIgnoreBlanks && i > 0)
            {
                out_Result $= delim;
            }
            out_Result $= StringArray[i];
        }
    }
}
public static final function Color LerpColor(Color A, Color B, float Alpha)
{
    local Vector FloatA;
    local Vector FloatB;
    local Vector FloatResult;
    local float AlphaA;
    local float AlphaB;
    local float FloatResultAlpha;
    local Color Result;
    
    FloatA.X = float(A.R);
    FloatA.Y = float(A.G);
    FloatA.Z = float(A.B);
    AlphaA = float(A.A);
    FloatB.X = float(B.R);
    FloatB.Y = float(B.G);
    FloatB.Z = float(B.B);
    AlphaB = float(B.A);
    FloatResult = FloatA + (FloatB - FloatA) * FClamp(Alpha, 0.0, 1.0);
    FloatResultAlpha = AlphaA + (AlphaB - AlphaA) * FClamp(Alpha, 0.0, 1.0);
    Result.R = byte(FloatResult.X);
    Result.G = byte(FloatResult.Y);
    Result.B = byte(FloatResult.Z);
    Result.A = byte(FloatResultAlpha);
    return Result;
}
public static final operator native(176) function bool Less_FloatFloat(float A, float B);

public static final operator native(150) function bool Less_IntInt(int A, int B);

public static final operator native(601) function bool Less_StrStr(string A, string B);

public static final operator native(178) function bool LessEqual_FloatFloat(float A, float B);

public static final operator native(152) function bool LessEqual_IntInt(int A, int B);

public static final operator native(603) function bool LessEqual_StrStr(string A, string B);

public static final operator native(148) function int LessLess_IntInt(int A, int B);

public static final operator native(275) function Vector LessLess_VectorRotator(Vector A, Rotator B);

public static final function Color MakeColor(byte R, byte G, byte B, optional byte A)
{
    local Color C;
    
    C.R = R;
    C.G = G;
    C.B = B;
    C.A = A;
    return C;
}
public static final function LinearColor MakeLinearColor(float R, float G, float B, float A)
{
    local LinearColor LC;
    
    LC.R = R;
    LC.G = G;
    LC.B = B;
    LC.A = A;
    return LC;
}
public static final function Rotator MakeRotator(int Pitch, int Yaw, int Roll)
{
    local Rotator R;
    
    R.Pitch = Pitch;
    R.Yaw = Yaw;
    R.Roll = Roll;
    return R;
}
public static final operator function Color Multiply_ColorFloat(Color A, float B)
{
    A.R *= B;
    A.G *= B;
    A.B *= B;
    return A;
}
public static final operator function Color Multiply_FloatColor(float A, Color B)
{
    B.R *= A;
    B.G *= A;
    B.B *= A;
    return B;
}
public static final operator native(171) function float Multiply_FloatFloat(float A, float B);

public static final operator native(288) function Rotator Multiply_FloatRotator(float A, Rotator B);

public static final operator native(213) function Vector Multiply_FloatVector(float A, Vector B);

public static final operator native(144) function int Multiply_IntInt(int A, int B);

public static final operator function LinearColor Multiply_LinearColorFloat(LinearColor LC, float Mult)
{
    LC.R *= Mult;
    LC.G *= Mult;
    LC.B *= Mult;
    return LC;
}
public static final operator native function Matrix Multiply_MatrixMatrix(Matrix A, Matrix B);

public static final operator native(287) function Rotator Multiply_RotatorFloat(Rotator A, float B);

public static final operator native(212) function Vector Multiply_VectorFloat(Vector A, float B);

public static final operator native(296) function Vector Multiply_VectorVector(Vector A, Vector B);

public static final operator native(133) function byte MultiplyEqual_ByteByte(out byte A, byte B);

public static final operator native(198) function byte MultiplyEqual_ByteFloat(out byte A, float B);

public static final operator native(182) function float MultiplyEqual_FloatFloat(out float A, float B);

public static final operator native(159) function int MultiplyEqual_IntFloat(out int A, float B);

public static final operator native(290) function Rotator MultiplyEqual_RotatorFloat(out Rotator A, float B);

public static final operator native(221) function Vector MultiplyEqual_VectorFloat(out Vector A, float B);

public static final operator native(297) function Vector MultiplyEqual_VectorVector(out Vector A, Vector B);

public static final operator native(170) function float MultiplyMultiply_FloatFloat(float Base, float Exp);

public static final preoperator native(129) function bool Not_PreBool(bool A);

public static final operator native(243) function bool NotEqual_BoolBool(bool A, bool B);

public static final operator native(181) function bool NotEqual_FloatFloat(float A, float B);

public static final operator native function bool NotEqual_InterfaceInterface(Interface A, Interface B);

public static final operator native(155) function bool NotEqual_IntInt(int A, int B);

public static final operator native(1005) function bool NotEqual_IntStringRef(int A, stringref B);

public static final operator native(255) function bool NotEqual_NameName(Name A, Name B);

public static final operator native(641) function bool NotEqual_ObjectObject(Object A, Object B);

public static final operator native(203) function bool NotEqual_RotatorRotator(Rotator A, Rotator B);

public static final operator native(1004) function bool NotEqual_StringRefInt(stringref A, int B);

public static final operator native(1003) function bool NotEqual_StringRefStringRef(stringref A, stringref B);

public static final operator native(606) function bool NotEqual_StrStr(string A, string B);

public static final operator native(218) function bool NotEqual_VectorVector(Vector A, Vector B);

public final simulated function float NoZDot(Vector A, Vector B)
{
    A.Z = B.Z;
    A = Normal(A);
    B = Normal(B);
    return A Dot B;
}
public static final operator native(158) function int Or_IntInt(int A, int B);

public static final operator native(132) function bool OrOr_BoolBool(bool A, skip bool B);

public static final function string ParseLocalizedPropertyPath(string PathName)
{
    local array<string> Pieces;
    
    ParseStringIntoArray(PathName, Pieces, ".", FALSE);
    if (Pieces.Length >= 3)
    {
        return Localize(Pieces[1], Pieces[2], Pieces[0]);
    }
    else
    {
        return "";
    }
}
public static final operator native(173) function float Percent_FloatFloat(float A, float B);

public static final operator native(253) function int Percent_IntInt(int A, int B);

public final simulated function float PointDistToPlane(Vector Point, Rotator Orientation, Vector Origin, optional out Vector out_ClosestPoint)
{
    local Vector AxisX;
    local Vector AxisY;
    local Vector AxisZ;
    local Vector PointNoZ;
    local Vector OriginNoZ;
    local float fPointZ;
    local float fProjDistToAxis;
    
    GetAxes(Orientation, AxisX, AxisY, AxisZ);
    fPointZ = Point Dot AxisZ;
    PointNoZ = Point - fPointZ * AxisZ;
    OriginNoZ = Origin - Origin Dot AxisZ * AxisZ;
    fProjDistToAxis = (PointNoZ - OriginNoZ) Dot AxisX;
    out_ClosestPoint = OriginNoZ + fProjDistToAxis * AxisX + fPointZ * AxisZ;
    return VSize(out_ClosestPoint - Point);
}
public static final simulated function float RandRange(float InMin, float InMax)
{
    return InMin + (InMax - InMin) * FRand();
}
public static final function float RSize(Rotator R)
{
    local int PitchNorm;
    local int YawNorm;
    local int RollNorm;
    
    PitchNorm = NormalizeRotAxis(R.Pitch);
    YawNorm = NormalizeRotAxis(R.Yaw);
    RollNorm = NormalizeRotAxis(R.Roll);
    return Sqrt(float(PitchNorm * PitchNorm + YawNorm * YawNorm + RollNorm * RollNorm));
}
public static final simulated function bool SClampRotAxis(float DeltaTime, int ViewAxis, out int out_DeltaViewAxis, int MaxLimit, int MinLimit, float InterpolationSpeed)
{
    local bool bClamped;
    
    out_DeltaViewAxis = NormalizeRotAxis(out_DeltaViewAxis);
    ViewAxis = NormalizeRotAxis(ViewAxis);
    if (ViewAxis <= MaxLimit && ViewAxis + out_DeltaViewAxis >= MaxLimit)
    {
        out_DeltaViewAxis = MaxLimit - ViewAxis;
        bClamped = TRUE;
    }
    else if (ViewAxis > MaxLimit)
    {
        if (out_DeltaViewAxis > 0)
        {
            out_DeltaViewAxis = 0;
        }
        if (ViewAxis + out_DeltaViewAxis > MaxLimit)
        {
            out_DeltaViewAxis = int(FInterpTo(float(ViewAxis), float(MaxLimit), DeltaTime, InterpolationSpeed) - float(ViewAxis) - float(1));
        }
    }
    else if (ViewAxis >= MinLimit && ViewAxis + out_DeltaViewAxis <= MinLimit)
    {
        out_DeltaViewAxis = MinLimit - ViewAxis;
        bClamped = TRUE;
    }
    else if (ViewAxis < MinLimit)
    {
        if (out_DeltaViewAxis < 0)
        {
            out_DeltaViewAxis = 0;
        }
        if (ViewAxis + out_DeltaViewAxis < MinLimit)
        {
            out_DeltaViewAxis += int(FInterpTo(float(ViewAxis), float(MinLimit), DeltaTime, InterpolationSpeed) - float(ViewAxis) + float(1));
        }
    }
    return bClamped;
}
public static final function string Split(coerce string Text, coerce string SplitStr, optional bool bOmitSplitStr)
{
    local int pos;
    
    pos = InStr(Text, SplitStr, , , );
    if (pos != -1)
    {
        if (bOmitSplitStr)
        {
            return Mid(Text, pos + Len(SplitStr), );
        }
        return Mid(Text, pos, );
    }
    else
    {
        return Text;
    }
}
public static final function array<string> SplitString(string Source, optional string Delimiter = ",", optional bool bCullEmpty)
{
    local array<string> Result;
    
    ParseStringIntoArray(Source, Result, Delimiter, bCullEmpty);
    return Result;
}
public static final operator function Color Subtract_ColorColor(Color A, Color B)
{
    A.R -= B.R;
    A.G -= B.G;
    A.B -= B.B;
    return A;
}
public static final operator native(175) function float Subtract_FloatFloat(float A, float B);

public static final operator native(147) function int Subtract_IntInt(int A, int B);

public static final operator function LinearColor Subtract_LinearColorLinearColor(LinearColor A, LinearColor B)
{
    A.R -= B.R;
    A.G -= B.G;
    A.B -= B.B;
    return A;
}
public static final preoperator native(169) function float Subtract_PreFloat(float A);

public static final preoperator native(143) function int Subtract_PreInt(int A);

public static final preoperator native(211) function Vector Subtract_PreVector(Vector A);

public static final operator native(271) function Quat Subtract_QuatQuat(Quat A, Quat B);

public static final operator native(317) function Rotator Subtract_RotatorRotator(Rotator A, Rotator B);

public static final operator native function Vector2D Subtract_Vector2DVector2D(Vector2D A, Vector2D B);

public static final operator native(216) function Vector Subtract_VectorVector(Vector A, Vector B);

public static final operator native(136) function byte SubtractEqual_ByteByte(out byte A, byte B);

public static final operator native(185) function float SubtractEqual_FloatFloat(out float A, float B);

public static final operator native(162) function int SubtractEqual_IntInt(out int A, int B);

public static final operator native(319) function Rotator SubtractEqual_RotatorRotator(out Rotator A, Rotator B);

public static final operator native(324) function string SubtractEqual_StrStr(out string A, coerce string B);

public static final operator native(224) function Vector SubtractEqual_VectorVector(out Vector A, Vector B);

public static final operator native(140) function byte SubtractSubtract_Byte(out byte A);

public static final operator native(166) function int SubtractSubtract_Int(out int A);

public static final preoperator native(138) function byte SubtractSubtract_PreByte(out byte A);

public static final preoperator native(164) function int SubtractSubtract_PreInt(out int A);

public static final simulated function float UnwindHeading(float A)
{
    while (A > 3.14159274)
    {
        A -= 3.14159274 * 2.0;
    }
    while (A < -3.14159274)
    {
        A += 3.14159274 * 2.0;
    }
    return A;
}
public static final function Vector2D vect2d(float InX, float InY)
{
    local Vector2D NewVect2d;
    
    NewVect2d.X = InX;
    NewVect2d.Y = InY;
    return NewVect2d;
}
public static final operator native(157) function int Xor_IntInt(int A, int B);

public static final operator native(131) function bool XorXor_BoolBool(bool A, bool B);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}