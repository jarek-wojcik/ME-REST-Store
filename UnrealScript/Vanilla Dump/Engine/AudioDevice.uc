Class AudioDevice extends Subsystem
    native
    transient
    config(Engine);

struct native AudioClassInfo 
{
    var const int NumResident;
    var const int SizeResident;
    var const int NumRealTime;
    var const int SizeRealTime;
};
struct native Listener 
{
    var Vector location;
    var Vector Up;
    var Vector Right;
    var Vector Front;
    var const PortalVolume PortalVolume;
};
enum ETTSSpeaker
{
    TTSSPEAKER_Paul,
    TTSSPEAKER_Harry,
    TTSSPEAKER_Frank,
    TTSSPEAKER_Dennis,
    TTSSPEAKER_Kit,
    TTSSPEAKER_Betty,
    TTSSPEAKER_Ursula,
    TTSSPEAKER_Rita,
    TTSSPEAKER_Wendy,
};
enum EDebugState
{
    DEBUGSTATE_None,
    DEBUGSTATE_IsolateDryAudio,
    DEBUGSTATE_IsolateReverb,
    DEBUGSTATE_TestLPF,
    DEBUGSTATE_TestStereoBleed,
    DEBUGSTATE_TestLFEBleed,
    DEBUGSTATE_DisableLPF,
};
enum ESoundClassName
{
    Master,
};

var const native QWord CurrentTick;
var const native Double SoundModeStartTime;
var const native Double SoundModeFadeInStartTime;
var const native Double SoundModeFadeInEndTime;
var const native Double SoundModeEndTime;
var const native Double InteriorStartTime;
var const native Double InteriorEndTime;
var const native Double ExteriorEndTime;
var const native Double InteriorLPFEndTime;
var const native Double ExteriorLPFEndTime;
var const native array<Pointer> Sources;
var const native array<Pointer> FreeSources;
var const native array<Listener> Listeners;
var const editinline transient export array<AudioComponent> AudioComponents;
var const native Pointer CommonAudioPool;
var const native Pointer Effects;
var const native Pointer TextToSpeech;
var const native Object WaveInstanceSourceMap;
var const native Object SoundModes;
var(AudioDevice) Object SoundClasses;
var Object SourceSoundClasses;
var Object CurrentSoundClasses;
var Object DestinationSoundClasses;
var const native InteriorSettings ListenerInteriorSettings;
var const native Name BaseSoundModeName;
var const config int MaxChannels;
var const config int CommonAudioPoolSize;
var const config float LowPassFilterResonance;
var const config float MinCompressedDurationEditor;
var const config float MinCompressedDurationGame;
var const native int CommonAudioPoolFreeBytes;
var const native SoundMode CurrentMode;
var const native int ListenerVolumeIndex;
var const native float InteriorVolumeInterp;
var const native float InteriorLPFInterp;
var const native float ExteriorVolumeInterp;
var const native float ExteriorLPFInterp;
var const editinline export AudioComponent TestAudioComponent;
var transient float TransientMasterVolume;
var transient float LastUpdateTime;
var const native bool bGameWasTicking;
var const native EDebugState DebugState;

public final native function bool SetSoundMode(Name NewMode);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TransientMasterVolume = 1.0
}