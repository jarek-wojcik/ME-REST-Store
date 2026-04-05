Class VolumeTimer extends Info;

var PhysicsVolume V;

public event function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    V = PhysicsVolume(Owner);
    SetTimer(V.PainInterval, TRUE, , );
}
public event function Timer()
{
    V.TimerPop(Self);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}