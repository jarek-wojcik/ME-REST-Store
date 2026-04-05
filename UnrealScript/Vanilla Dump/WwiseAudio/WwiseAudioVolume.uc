Class WwiseAudioVolume extends WwiseVolume
    native
    placeable;

var transient Double m_fLastLineCheckTime;
var(Audio) array<WwiseEventPair> WwiseEventArray;
var editinline export WwiseAudioComponentMultiLoc AudioComponent;
var float m_fTimeBetweenLineChecks;
var(WwiseAudioVolume) bool bAutoPlay;
var transient bool bWasPlaying;
var transient bool DrawSoundLocations;
var transient bool m_bIs2D;

public final native function DrawVolume();

public final native function HideVolume();

public final native function myTimerPop();

public function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (WwiseEventArray.Length != 0)
    {
        if (!DrawSoundLocations)
        {
            m_oTrackTimer.SetTimer(0.0500000007, TRUE, , );
        }
    }
}
public final native function Start();

public final native function Stop();

public function TimerPop(WwiseVolumeTimer T)
{
    if (T != m_oTrackTimer)
    {
        return;
    }
    myTimerPop();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    m_fTimeBetweenLineChecks = 1.0
    bAutoPlay = TRUE
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bCollideActors = FALSE
    bForceAllowKismetModification = TRUE
}