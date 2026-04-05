Class AnimNotify_ViewShake extends AnimNotify_Scripted
    native
    editinlinenew
    collapsecategories;

var editconst Vector RotAmplitude;
var editconst Vector RotFrequency;
var editconst Vector LocAmplitude;
var editconst Vector LocFrequency;
var(AnimNotify_ViewShake) Name BoneName;
var editconst float Duration;
var editconst float FOVAmplitude;
var editconst float FOVFrequency;
var(AnimNotify_ViewShake) float ShakeRadius;
var(AnimNotify_ViewShake) export CameraShake ShakeParams;
var(AnimNotify_ViewShake) bool bDoControllerVibration;
var(AnimNotify_ViewShake) bool bUseBoneLocation;

public event function Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Vector ViewShakeOrigin;
    
    if (bUseBoneLocation && AnimSeqInstigator != None && AnimSeqInstigator.SkelComponent != None)
    {
        ViewShakeOrigin = AnimSeqInstigator.SkelComponent.GetBoneLocation(BoneName);
    }
    else
    {
        ViewShakeOrigin = Owner.location;
    }
    if (Owner != None)
    {
        Class'Camera'.static.PlayWorldCameraShake(ShakeParams, Owner, ViewShakeOrigin, 0.0, ShakeRadius, 1.0, bDoControllerVibration);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RotAmplitude = {X = 100.0, Y = 100.0, Z = 200.0}
    RotFrequency = {X = 10.0, Y = 10.0, Z = 25.0}
    LocAmplitude = {X = 0.0, Y = 3.0, Z = 6.0}
    LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}
    Duration = 1.0
    FOVAmplitude = 2.0
    FOVFrequency = 5.0
    ShakeRadius = 4096.0
}