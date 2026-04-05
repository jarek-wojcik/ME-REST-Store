Class WwiseMusicVolume extends WwiseVolume
    native
    placeable;

var(MusicVolume) Name MusicID;
var(MusicVolume) int MusicPriority;
var editinline transient export WwiseAudioComponent m_pWwiseComponent;
var Pawn m_oTrackPawn;
var int m_nCurrentMusicState;
var(MusicVolume) export WwiseEventPairObject m_pMusicEventPair;
var(MusicVolume) bool InitiallyEnabled;
var bool m_bContainsPawn;
var bool m_bMyMusicIsPlaying;
var bool m_bEnabled;

public final native function bool CheckPriority();

public final native function myTimerPop();

public function PostBeginPlay()
{
    Super.PostBeginPlay();
    m_bEnabled = InitiallyEnabled;
}
public final native function SetContainsPlayer(bool bContainsPlayer);

public final native function SetEnabled(bool bEnabled);

public final native function StartMusic();

public final native function StopMusic();

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
    Begin Object Class=WwiseEventPairObject Name=MusicWwiseEventPair
    End Object
    m_pMusicEventPair = MusicWwiseEventPair
    InitiallyEnabled = TRUE
    m_bEnabled = TRUE
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}