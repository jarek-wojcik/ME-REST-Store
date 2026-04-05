Class AudioComponent extends ActorComponent
    native
    noexport
    editinlinenew
    transient
    collapsecategories;

struct native AudioComponentParam 
{
    var(AudioComponentParam) Name ParamName;
    var(AudioComponentParam) float FloatParam;
    var(AudioComponentParam) SoundNodeWave WaveParam;
};

var(AudioComponent) SoundCue SoundCue;
var const native SoundNode CueFirstNode;
var(AudioComponent) array<AudioComponentParam> InstanceParameters;
var bool bUseOwnerLocation;
var bool bAutoPlay;
var bool bAutoDestroy;
var bool bStopWhenOwnerDestroyed;
var bool bShouldRemainActiveIfDropped;
var bool bWasOccluded;
var transient bool bSuppressSubtitles;
var transient bool bWasPlaying;
var bool bAllowSpatialization;
var transient bool bFinished;
var transient bool bPreviewComponent;
var transient bool bIgnoreForFlushing;
var transient float StereoBleed;
var transient float LFEBleed;
var transient bool bEQFilterApplied;
var transient bool bAlwaysPlay;
var transient bool bIsUISound;
var transient bool bIsMusic;
var transient bool bNoReverb;
var const native duplicatetransient array<Pointer> WaveInstances;
var const native duplicatetransient array<byte> SoundNodeData;
var const native duplicatetransient Object SoundNodeOffsetMap;
var const native duplicatetransient MultiMap_Mirror SoundNodeResetWaveMap;
var const native duplicatetransient Pointer Listener;
var const native duplicatetransient float PlaybackTime;
var const native duplicatetransient PortalVolume PortalVolume;
var native duplicatetransient Vector location;
var const native duplicatetransient Vector ComponentLocation;
var const transient Actor LastOwner;
var native float SubtitlePriority;
var float FadeInStartTime;
var float FadeInStopTime;
var float FadeInTargetVolume;
var float FadeOutStartTime;
var float FadeOutStopTime;
var float FadeOutTargetVolume;
var float AdjustVolumeStartTime;
var float AdjustVolumeStopTime;
var float AdjustVolumeTargetVolume;
var float CurrAdjustVolumeTargetVolume;
var const native SoundNode CurrentNotifyBufferFinishedHook;
var const native Vector CurrentLocation;
var const native float CurrentVolume;
var const native float CurrentPitch;
var const native float CurrentHighFrequencyGain;
var const native int CurrentUseSpatialization;
var const native int CurrentUseSeamlessLooping;
var const native float CurrentVolumeMultiplier;
var const native float CurrentPitchMultiplier;
var const native float CurrentHighFrequencyGainMultiplier;
var const native float CurrentVoiceCenterChannelVolume;
var const native float CurrentVoiceRadioVolume;
var const native Double LastUpdateTime;
var const native float SourceInteriorVolume;
var const native float SourceInteriorLPF;
var const native float CurrentInteriorVolume;
var const native float CurrentInteriorLPF;
var(AudioComponent) float VolumeMultiplier;
var(AudioComponent) float PitchMultiplier;
var(AudioComponent) float HighFrequencyGainMultiplier;
var float OcclusionCheckInterval;
var transient float LastOcclusionCheckTime;
var const editinline export DrawSoundRadiusComponent PreviewSoundRadius;
var delegate<OnAudioFinished> __OnAudioFinished__Delegate;
var delegate<OnQueueSubtitles> __OnQueueSubtitles__Delegate;

public final native function AdjustVolume(float AdjustVolumeDuration, float AdjustVolumeLevel);

public final native function FadeIn(float FadeInDuration, float FadeVolumeLevel);

public final native function FadeOut(float FadeOutDuration, float FadeVolumeLevel);

public final native function bool IsPlaying();

public event function OcclusionChanged(bool bNowOccluded)
{
    VolumeMultiplier *= (bNowOccluded ? 0.5 : 2.0);
}
public delegate function OnAudioFinished(AudioComponent AC);

public delegate function OnQueueSubtitles(array<SubtitleCue> Subtitles, float CueDuration);

public final native function Play();

public final native function ResetToDefaults();

public final native function SetFloatParameter(Name InName, float InFloat);

public final native function SetWaveParameter(Name InName, SoundNodeWave InWave);

public final native function Stop();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bUseOwnerLocation = TRUE
    bAllowSpatialization = TRUE
    FadeInStopTime = -1.0
    FadeInTargetVolume = 1.0
    FadeOutStopTime = -1.0
    FadeOutTargetVolume = 1.0
    AdjustVolumeStopTime = -1.0
    AdjustVolumeTargetVolume = 1.0
    CurrAdjustVolumeTargetVolume = 1.0
    VolumeMultiplier = 1.0
    PitchMultiplier = 1.0
    HighFrequencyGainMultiplier = 1.0
}