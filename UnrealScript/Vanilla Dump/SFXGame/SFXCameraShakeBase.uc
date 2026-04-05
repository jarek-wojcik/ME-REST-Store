Class SFXCameraShakeBase;

var ScreenShakeStruct TheShake;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TheShake = {
                RotAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                RotFrequency = {X = 0.0, Y = 0.0, Z = 0.0}, 
                RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                LocAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                ShakeName = 'None', 
                TimeToGo = 0.0, 
                TimeDuration = 0.0, 
                RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                FOVAmplitude = 0.0, 
                FOVFrequency = 0.0, 
                FOVSinOffset = 0.0, 
                TargetingDampening = 0.0, 
                bOverrideTargetingDampening = FALSE, 
                FOVParam = EShakeParam.ESP_OffsetRandom
               }
}