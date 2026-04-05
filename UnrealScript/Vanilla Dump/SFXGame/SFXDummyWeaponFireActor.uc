Class SFXDummyWeaponFireActor extends Actor
    native;

var SFXSeqAct_DummyWeaponFire FireAction;
var Actor OriginActor;
var Actor TargetActor;
var repnotify int ShotCount;

public event simulated function Destroyed()
{
    if (FireAction != None && FireAction.SpawnedWeapon != None)
    {
        FireAction.SpawnedWeapon.WeaponStoppedFiring(FireAction.FiringMode);
        FireAction.SpawnedWeapon.Destroy();
    }
    Super.Destroyed();
}
public event function NotifyShotFired(Actor InOriginActor, Actor InTargetActor)
{
    OriginActor = InOriginActor;
    TargetActor = InTargetActor;
    ShotCount++;
    bForceNetUpdate = TRUE;
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ShotCount')
    {
        if (FireAction != None && OriginActor != None && TargetActor != None)
        {
            if (FireAction.SpawnedWeapon == None)
            {
                FireAction.SpawnDummyWeapon(OriginActor, TargetActor);
            }
            FireAction.AlignWeaponMuzzleToActor(OriginActor, TargetActor);
            FireAction.SpawnedWeapon.DummyFire(FireAction.FiringMode, TargetActor.location, OriginActor, FireAction.InaccuracyDegrees, TargetActor);
        }
    }
}
public event simulated function Tick(float DeltaTime)
{
    if (WorldInfo.NetMode == ENetMode.NM_Client && FireAction != None && FireAction.SpawnedWeapon != None && OriginActor != None && TargetActor != None)
    {
        FireAction.AlignWeaponMuzzleToActor(OriginActor, TargetActor);
    }
}

replication
{
    if (bNetDirty)
        FireAction, OriginActor, TargetActor, ShotCount;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NetUpdateFrequency = 1.0
    NetPriority = 2.70000005
    bAlwaysRelevant = TRUE
    bReplicateMovement = FALSE
    bSkipActorPropertyReplication = TRUE
    bOnlyDirtyReplication = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}