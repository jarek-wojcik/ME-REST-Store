Class PotentialClimbWatcher extends Info
    native;

public event simulated function Tick(float DeltaTime)
{
    local Rotator PawnRot;
    local LadderVolume L;
    local bool bFound;
    
    if (Owner == None || Owner.bDeleteMe || !Pawn(Owner).CanGrabLadder())
    {
        Destroy();
        return;
    }
    PawnRot = Owner.Rotation;
    PawnRot.Pitch = 0;
    foreach Owner.TouchingActors(Class'LadderVolume', L, )
    {
        if (L.Encompasses(Owner))
        {
            if (Vector(PawnRot) Dot L.LookDir > 0.899999976)
            {
                Pawn(Owner).ClimbLadder(L);
                Destroy();
                return;
            }
            else
            {
                bFound = TRUE;
            }
        }
    }
    if (!bFound)
    {
        Destroy();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}