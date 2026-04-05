Class SFXParticleModule_CameraEffect extends BioParticleModuleBase
    native
    editinlinenew
    collapsecategories;

var(Attenuation) editinline RawDistributionFloat RawIntensityVsDistanceDistribution;
var(ProgrammaticShake) export ScreenShakeStruct ProgrammaticShake;
var(Attenuation) float MaxRange;
var(FrameBuffer) PostProcessChain FrameBufferEffect;
var(FrameBuffer) float Duration;
var(SFXParticleModule_CameraEffect) bool bPlayerImpact;
var(Attenuation) bool bUseIntensityCurve;
var(ProgrammaticShake) bool bPlayProgrammaticShake;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ProgrammaticShake = {
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
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}