Class SoundClass
    native;

struct native SoundClassProperties 
{
    var(SoundClassProperties) float Volume;
    var(SoundClassProperties) float Pitch;
    var(SoundClassProperties) float StereoBleed;
    var(SoundClassProperties) float LFEBleed;
    var(SoundClassProperties) float VoiceCenterChannelVolume;
    var(SoundClassProperties) float VoiceRadioVolume;
    var(SoundClassProperties) bool bApplyEffects;
    var(SoundClassProperties) bool bAlwaysPlay;
    var(SoundClassProperties) bool bIsUISound;
    var(SoundClassProperties) bool bIsMusic;
    var(SoundClassProperties) bool bReverb;
    
    structdefaultproperties
    {
        Volume = 1.0
        Pitch = 1.0
        StereoBleed = 0.25
        LFEBleed = 0.5
        bReverb = TRUE
    }
};
struct native export SoundClassEditorData 
{
    var const native int NodePosX;
    var const native int NodePosY;
};

var(SoundClass) array<Name> ChildClassNames;
var const native Object EditorData;
var(SoundClass) SoundClassProperties Properties;
var bool bIsChild;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Properties = {
                  Volume = 1.0, 
                  Pitch = 1.0, 
                  StereoBleed = 0.25, 
                  LFEBleed = 0.5, 
                  VoiceCenterChannelVolume = 0.0, 
                  VoiceRadioVolume = 0.0, 
                  bApplyEffects = FALSE, 
                  bAlwaysPlay = FALSE, 
                  bIsUISound = FALSE, 
                  bIsMusic = FALSE, 
                  bReverb = TRUE
                 }
}