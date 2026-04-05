Class GameTypes
    native;

struct native TakeHitInfo 
{
    var Class<DamageType> DamageType;
    var Vector HitLocation;
    var Vector Momentum;
    var Vector RadialDamageOrigin;
    var Pawn instigatedBy;
    var PhysicalMaterial PhysicalMaterial;
    var float Damage;
    var byte HitBoneIndex;
};
struct native ScreenShakeStruct 
{
    var Vector RotAmplitude;
    var Vector RotFrequency;
    var Vector RotSinOffset;
    var Vector LocAmplitude;
    var Vector LocFrequency;
    var Vector LocSinOffset;
    var Name ShakeName;
    var float TimeToGo;
    var float TimeDuration;
    var ShakeParams RotParam;
    var ShakeParams LocParam;
    var float FOVAmplitude;
    var float FOVFrequency;
    var float FOVSinOffset;
    var float TargetingDampening;
    var bool bOverrideTargetingDampening;
    var EShakeParam FOVParam;
    
    structdefaultproperties
    {
        RotAmplitude = {X = 100.0, Y = 100.0, Z = 200.0}
        RotFrequency = {X = 10.0, Y = 10.0, Z = 25.0}
        LocAmplitude = {X = 0.0, Y = 3.0, Z = 5.0}
        LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}
        TimeDuration = 1.0
        FOVAmplitude = 2.0
        FOVFrequency = 5.0
    }
};
struct native ShakeParams 
{
    var EShakeParam X;
    var EShakeParam Y;
    var EShakeParam Z;
    var const transient byte Padding;
};
enum EShakeParam
{
    ESP_OffsetRandom,
    ESP_OffsetZero,
};
struct native ScreenShakeAnimStruct 
{
    var CameraAnim Anim;
    var CameraAnim Anim_Left;
    var CameraAnim Anim_Right;
    var CameraAnim Anim_Rear;
    var float AnimPlayRate;
    var float AnimScale;
    var float AnimBlendInTime;
    var float AnimBlendOutTime;
    var float RandomSegmentDuration;
    var bool bUseDirectionalAnimVariants;
    var bool bRandomSegment;
    var bool bSingleInstance;
    
    structdefaultproperties
    {
        AnimPlayRate = 1.0
        AnimScale = 1.0
        AnimBlendInTime = 0.200000003
        AnimBlendOutTime = 0.200000003
    }
};
const LOADING_MOVIE = "LoadingMovie";

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}