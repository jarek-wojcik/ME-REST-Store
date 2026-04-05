Class WwiseVolumeTimer extends Info
    native
    transient;

var WwiseVolume m_oVolume;

public function Timer()
{
    if (m_oVolume != None)
    {
        m_oVolume.TimerPop(Self);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}