Class CameraShake
    native
    editinlinenew;

struct native VOscillator 
{
    var(VOscillator) FOscillator X;
    var(VOscillator) FOscillator Y;
    var(VOscillator) FOscillator Z;
};
struct native ROscillator 
{
    var(ROscillator) FOscillator Pitch;
    var(ROscillator) FOscillator Yaw;
    var(ROscillator) FOscillator Roll;
};
struct native FOscillator 
{
    var(FOscillator) float Amplitude;
    var(FOscillator) float Frequency;
    var(FOscillator) EInitialOscillatorOffset InitialOffset;
};
enum EInitialOscillatorOffset
{
    EOO_OffsetRandom,
    EOO_OffsetZero,
};

var(Oscillation) ROscillator RotOscillation;
var(Oscillation) VOscillator LocOscillation;
var(Oscillation) FOscillator FOVOscillation;
var(Oscillation) float OscillationDuration;
var(Oscillation) float OscillationBlendInTime;
var(Oscillation) float OscillationBlendOutTime;
var(AnimShake) CameraAnim Anim;
var(AnimShake) float AnimPlayRate;
var(AnimShake) float AnimScale;
var(AnimShake) float AnimBlendInTime;
var(AnimShake) float AnimBlendOutTime;
var(AnimShake) float RandomAnimSegmentDuration;
var(CameraShake) bool bSingleInstance;
var(AnimShake) bool bRandomAnimSegment;

public simulated function float GetLocOscillationMagnitude()
{
    local Vector V;
    
    V.X = LocOscillation.X.Amplitude;
    V.Y = LocOscillation.Y.Amplitude;
    V.Z = LocOscillation.Z.Amplitude;
    return VSize(V);
}
public simulated function float GetRotOscillationMagnitude()
{
    local Vector V;
    
    V.X = RotOscillation.Pitch.Amplitude;
    V.Y = RotOscillation.Yaw.Amplitude;
    V.Z = RotOscillation.Roll.Amplitude;
    return VSize(V);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OscillationBlendInTime = 0.100000001
    OscillationBlendOutTime = 0.200000003
    AnimPlayRate = 1.0
    AnimScale = 1.0
    AnimBlendInTime = 0.200000003
    AnimBlendOutTime = 0.200000003
}