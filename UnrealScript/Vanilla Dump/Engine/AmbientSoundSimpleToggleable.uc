Class AmbientSoundSimpleToggleable extends AmbientSoundSimple
    native
    placeable
    transient;

struct CheckpointRecord 
{
    var bool bCurrentlyPlaying;
    
    structdefaultproperties
    {
        bCurrentlyPlaying = FALSE
    }
};

var(AmbientSoundSimpleToggleable) float FadeInDuration;
var(AmbientSoundSimpleToggleable) float FadeInVolumeLevel;
var(AmbientSoundSimpleToggleable) float FadeOutDuration;
var(AmbientSoundSimpleToggleable) float FadeOutVolumeLevel;
var repnotify bool bCurrentlyPlaying;
var(AmbientSoundSimpleToggleable) bool bFadeOnToggle;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse || Action.InputLinks[2].bHasImpulse && !AudioComponent.bWasPlaying)
    {
        StartPlaying();
    }
    else
    {
        StopPlaying();
    }
    ForceNetRelevant();
}
public event simulated function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    bCurrentlyPlaying = AudioComponent.bAutoPlay;
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'bCurrentlyPlaying')
    {
        if (bCurrentlyPlaying)
        {
            StartPlaying();
        }
        else
        {
            StopPlaying();
        }
    }
    else
    {
        Super(Actor).ReplicatedEvent(VarName);
    }
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    bCurrentlyPlaying = Record.bCurrentlyPlaying;
    if (bCurrentlyPlaying)
    {
        StartPlaying();
    }
    else
    {
        StopPlaying();
    }
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bCurrentlyPlaying = bCurrentlyPlaying;
}
public simulated function StartPlaying()
{
    if (bFadeOnToggle)
    {
        AudioComponent.FadeIn(FadeInDuration, FadeInVolumeLevel);
    }
    else
    {
        AudioComponent.Play();
    }
    bCurrentlyPlaying = TRUE;
}
public simulated function StopPlaying()
{
    if (bFadeOnToggle)
    {
        AudioComponent.FadeOut(FadeOutDuration, FadeOutVolumeLevel);
    }
    else
    {
        AudioComponent.Stop();
    }
    bCurrentlyPlaying = FALSE;
}

replication
{
    if (Role == ENetRole.ROLE_Authority)
        bCurrentlyPlaying;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SoundNodeAmbient Name=SoundNodeAmbient0
    End Template
    FadeInDuration = 1.0
    FadeInVolumeLevel = 1.0
    FadeOutDuration = 1.0
    SoundNodeInstance = SoundNodeAmbient0
    bAutoPlay = FALSE
    bStatic = FALSE
    bNoDelete = TRUE
}