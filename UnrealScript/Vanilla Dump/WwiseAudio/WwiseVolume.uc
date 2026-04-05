Class WwiseVolume extends Volume
    native
    abstract;

var transient WwiseVolumeTimer m_oTrackTimer;

public function PostBeginPlay()
{
    Super.PostBeginPlay();
    m_oTrackTimer = Spawn(Class'WwiseVolumeTimer', Self);
    m_oTrackTimer.SetTimer(1.0, TRUE, , );
    m_oTrackTimer.m_oVolume = Self;
}
public function TimerPop(WwiseVolumeTimer T);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}