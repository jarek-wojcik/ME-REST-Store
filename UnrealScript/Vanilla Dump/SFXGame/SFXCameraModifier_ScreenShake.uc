Class SFXCameraModifier_ScreenShake extends CameraModifier
    native;

var array<ScreenShakeStruct> Shakes;
var(SFXCameraModifier_ScreenShake) ScreenShakeStruct TestShake;

public final function AddScreenShake(const out ScreenShakeStruct NewShake)
{
    local int ShakeIdx;
    local int NumShakes;
    local Name NewShakeName;
    
    if (NewShake.TimeDuration == float(0))
    {
        return;
    }
    NumShakes = Shakes.Length;
    NewShakeName = NewShake.ShakeName;
    if (NewShakeName != 'None')
    {
        for (ShakeIdx = 0; ShakeIdx < NumShakes; ++ShakeIdx)
        {
            if (Shakes[ShakeIdx].ShakeName == NewShakeName)
            {
                Shakes[ShakeIdx] = InitializeShake(NewShake);
                return;
            }
        }
    }
    Shakes[NumShakes] = InitializeShake(NewShake);
}
public native function bool ModifyCamera(Camera Camera, float DeltaTime, out TPOV OutPOV);

public native function UpdateScreenShake(float DeltaTime, out ScreenShakeStruct Shake, out TPOV OutPOV);

public static final function float InitializeOffset(EShakeParam Param)
{
    switch (Param)
    {
        case EShakeParam.ESP_OffsetRandom:
            return FRand() * float(2) * 3.14159274;
            break;
        case EShakeParam.ESP_OffsetZero:
            return 0.0;
            break;
        default:
    }
    return 0.0;
}
public final function ScreenShakeStruct InitializeShake(ScreenShakeStruct NewShake)
{
    NewShake.TimeToGo = NewShake.TimeDuration;
    if (!IsZero(NewShake.RotAmplitude))
    {
        NewShake.RotSinOffset.X = InitializeOffset(NewShake.RotParam.X);
        NewShake.RotSinOffset.Y = InitializeOffset(NewShake.RotParam.Y);
        NewShake.RotSinOffset.Z = InitializeOffset(NewShake.RotParam.Z);
    }
    if (!IsZero(NewShake.LocAmplitude))
    {
        NewShake.LocSinOffset.X = InitializeOffset(NewShake.LocParam.X);
        NewShake.LocSinOffset.Y = InitializeOffset(NewShake.LocParam.Y);
        NewShake.LocSinOffset.Z = InitializeOffset(NewShake.LocParam.Z);
    }
    if (NewShake.FOVAmplitude != float(0))
    {
        NewShake.FOVSinOffset = InitializeOffset(NewShake.FOVParam);
    }
    return NewShake;
}
public final function ScreenShakeStruct ComposeNewShake(float Duration, Vector newRotAmplitude, Vector newRotFrequency, Vector newLocAmplitude, Vector newLocFrequency, float newFOVAmplitude, float newFOVFrequency)
{
    local ScreenShakeStruct NewShake;
    
    NewShake.TimeDuration = Duration;
    NewShake.RotAmplitude = newRotAmplitude;
    NewShake.RotFrequency = newRotFrequency;
    NewShake.LocAmplitude = newLocAmplitude;
    NewShake.LocFrequency = newLocFrequency;
    NewShake.FOVAmplitude = newFOVAmplitude;
    NewShake.FOVFrequency = newFOVFrequency;
    return NewShake;
}
public final function RemoveAllScreenShakes()
{
    Shakes.Length = 0;
}
public final function RemoveScreenShake(Name ShakeName)
{
    local int idx;
    
    idx = Shakes.Find('ShakeName', ShakeName);
    if (idx != -1)
    {
        Shakes.Remove(idx, 1);
    }
}
public function StartNewShake(float Duration, Vector newRotAmplitude, Vector newRotFrequency, Vector newLocAmplitude, Vector newLocFrequency, float newFOVAmplitude, float newFOVFrequency)
{
    local ScreenShakeStruct NewShake;
    
    if (Duration == -1.0)
    {
        Shakes.Length = 0;
    }
    else
    {
        NewShake = ComposeNewShake(Duration, newRotAmplitude, newRotFrequency, newLocAmplitude, newLocFrequency, newFOVAmplitude, newFOVFrequency);
        AddScreenShake(NewShake);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TestShake = {
                 RotAmplitude = {X = 100.0, Y = 100.0, Z = 200.0}, 
                 RotFrequency = {X = 10.0, Y = 10.0, Z = 25.0}, 
                 RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 LocAmplitude = {X = 0.0, Y = 3.0, Z = 5.0}, 
                 LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                 LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 ShakeName = 'None', 
                 TimeToGo = 0.0, 
                 TimeDuration = 1.0, 
                 RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                 LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                 FOVAmplitude = 2.0, 
                 FOVFrequency = 5.0, 
                 FOVSinOffset = 0.0, 
                 TargetingDampening = 0.0, 
                 bOverrideTargetingDampening = FALSE, 
                 FOVParam = EShakeParam.ESP_OffsetRandom
                }
}