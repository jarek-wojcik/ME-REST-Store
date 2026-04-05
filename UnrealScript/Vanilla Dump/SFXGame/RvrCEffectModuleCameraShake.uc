Class RvrCEffectModuleCameraShake extends RvrClientEffectModule
    native
    editinlinenew;

var(RvrCEffectModuleCameraShake) protectedwrite float ShakeScale;
var(RvrCEffectModuleCameraShake) protectedwrite float RadialShake_InnerRadius;
var(RvrCEffectModuleCameraShake) protectedwrite float RadialShake_OuterRadius;
var(RvrCEffectModuleCameraShake) protectedwrite float RadialShake_Falloff;
var(RvrCEffectModuleCameraShake) protectedwrite export CameraShake Shake;
var(RvrCEffectModuleCameraShake) protectedwrite bool bDoControllerVibration;
var(RvrCEffectModuleCameraShake) protectedwrite bool bRadialShake;
var(RvrCEffectModuleCameraShake) protectedwrite bool bOrientTowardRadialEpicenter;
var(RvrCEffectModuleCameraShake) protectedwrite ECameraAnimPlaySpace PlaySpace;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CameraShake Name=Shake0
        RotOscillation = {
                          Pitch = {Amplitude = 150.0, Frequency = 40.0}, 
                          Yaw = {Amplitude = 75.0, Frequency = 30.0}, 
                          Roll = {Amplitude = 150.0, Frequency = 60.0}
                         }
        OscillationDuration = 1.0
    End Object
    ShakeScale = 1.0
    RadialShake_InnerRadius = 128.0
    RadialShake_OuterRadius = 512.0
    RadialShake_Falloff = 2.0
    Shake = Shake0
    bDoControllerVibration = TRUE
    m_pInstanceClass = Class'RvrCEffectModuleCameraShakeInstance'
    m_bSoftStopsAreHard = TRUE
}