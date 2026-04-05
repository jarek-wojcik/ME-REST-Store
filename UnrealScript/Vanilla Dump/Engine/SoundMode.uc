Class SoundMode
    native;

struct native SoundClassAdjuster 
{
    var(SoundClassAdjuster) editconst Name SoundClass;
    var(SoundClassAdjuster) float VolumeAdjuster;
    var(SoundClassAdjuster) float PitchAdjuster;
    var(SoundClassAdjuster) bool bApplyToChildren;
    var(SoundClassAdjuster) transient ESoundClassName SoundClassName;
    
    structdefaultproperties
    {
        SoundClass = 'Master'
        VolumeAdjuster = 1.0
        PitchAdjuster = 1.0
    }
};
struct native AudioEQEffect 
{
    var transient native Double RootTime;
    var(HighPass) float HFFrequency;
    var(HighPass) float HFGain;
    var(BandPass) float MFCutoffFrequency;
    var(BandPass) float MFBandwidth;
    var(BandPass) float MFGain;
    var(LowPass) float LFFrequency;
    var(LowPass) float LFGain;
};

var(EQ) AudioEQEffect EQSettings;
var(SoundClasses) array<SoundClassAdjuster> SoundClassEffects;
var(SoundMode) float InitialDelay;
var(SoundMode) float FadeInTime;
var(SoundMode) float Duration;
var(SoundMode) float FadeOutTime;
var(EQ) bool bApplyEQ;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EQSettings = {
                  HFFrequency = 2000.0, 
                  HFGain = 1.0, 
                  MFCutoffFrequency = 1000.0, 
                  MFBandwidth = 1.0, 
                  MFGain = 1.0, 
                  LFFrequency = 600.0, 
                  LFGain = 1.0
                 }
    FadeInTime = 0.200000003
    Duration = -1.0
    FadeOutTime = 0.200000003
}