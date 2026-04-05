Class InterpActor extends DynamicSMActor
    native
    placeable;

struct CheckpointRecord 
{
    var Vector location;
    var Rotator Rotation;
    var ECollisionType CollisionType;
    var bool bHidden;
    var bool bIsShutdown;
    var bool bNeedsPositionReplication;
    
    structdefaultproperties
    {
        location = {X = 0.0, Y = 0.0, Z = 0.0}
        Rotation = {Pitch = 0, Yaw = 0, Roll = 0}
        CollisionType = ECollisionType.COLLIDE_CustomDefault
        bHidden = FALSE
        bIsShutdown = FALSE
        bNeedsPositionReplication = FALSE
    }
};

var NavigationPoint MyMarker;
var float MaxZVelocity;
var float StayOpenTime;
var(InterpActor) SoundCue OpenSound;
var(InterpActor) SoundCue OpeningAmbientSound;
var(InterpActor) SoundCue OpenedSound;
var(InterpActor) SoundCue CloseSound;
var(InterpActor) SoundCue ClosingAmbientSound;
var(InterpActor) SoundCue ClosedSound;
var editinline export AudioComponent AmbientSoundComponent;
var bool bShouldSaveForCheckpoint;
var bool bMonitorMover;
var bool bMonitorZVelocity;
var(InterpActor) bool bDestroyProjectilesOnEncroach;
var(InterpActor) bool bContinueOnEncroachPhysicsObject;
var(InterpActor) bool bStopOnEncroach;
var(InterpActor) bool bShouldShadowParentAllAttachedActors;
var bool bIsLift;

public event function Attach(Actor Other)
{
    local int i;
    local SeqEvent_Mover MoverEvent;
    
    if (!IsTimerActive('FinishedOpen'))
    {
        for (i = 0; i < GeneratedEvents.Length; i++)
        {
            MoverEvent = SeqEvent_Mover(GeneratedEvents[i]);
            if (MoverEvent != None)
            {
                MoverEvent.NotifyAttached(Other);
            }
        }
    }
}
public event function Detach(Actor Other)
{
    local int i;
    local SeqEvent_Mover MoverEvent;
    
    for (i = 0; i < GeneratedEvents.Length; i++)
    {
        MoverEvent = SeqEvent_Mover(GeneratedEvents[i]);
        if (MoverEvent != None)
        {
            MoverEvent.NotifyDetached(Other);
        }
    }
}
public event function bool EncroachingOn(Actor Other)
{
    local int i;
    local SeqEvent_Mover MoverEvent;
    local Pawn P;
    local Vector Height;
    local Vector HitLocation;
    local Vector HitNormal;
    local bool bLandingPawn;
    
    if (bContinueOnEncroachPhysicsObject && Other.Physics == EPhysics.PHYS_RigidBody)
    {
        return FALSE;
    }
    if (Other.bDestroyedByInterpActor)
    {
        Other.Destroy();
        return FALSE;
    }
    if (Other.Base == Self || Normal(Velocity) Dot Normal(Other.location - location) >= 0.0)
    {
        P = Pawn(Other);
        if (P != None)
        {
            if (P.Physics == EPhysics.PHYS_Falling && Velocity.Z > 0.0)
            {
                Height = P.GetCollisionHeight() * vect(0.0, 0.0, 1.0);
                if (TraceComponent(HitLocation, HitNormal, StaticMeshComponent, P.location - Height, P.location + Height, P.GetCollisionExtent()))
                {
                    if (P.location.Z < location.Z)
                    {
                        P.SetLocation(HitLocation + Height, );
                    }
                    bLandingPawn = TRUE;
                }
            }
            else if (P.Base != Self && P.Controller != None && P.Controller.PendingMover != None && P.Controller.PendingMover == Self)
            {
                P.Controller.UnderLift(LiftCenter(MyMarker));
            }
        }
        else if (bDestroyProjectilesOnEncroach && Other.IsA('Projectile'))
        {
            Projectile(Other).Explode(Other.location, -Normal(Velocity));
            return FALSE;
        }
        if (!bLandingPawn)
        {
            for (i = 0; i < GeneratedEvents.Length; i++)
            {
                MoverEvent = SeqEvent_Mover(GeneratedEvents[i]);
                if (MoverEvent != None)
                {
                    MoverEvent.NotifyEncroachingOn(Other);
                }
            }
            return bStopOnEncroach;
        }
    }
    return FALSE;
}
public event simulated function InterpolationChanged(SeqAct_Interp InterpAction)
{
    PlayMovingSound(InterpAction.bReversePlayback);
}
public event simulated function InterpolationFinished(SeqAct_Interp InterpAction)
{
    local DoorMarker DoorNav;
    local Controller C;
    local SoundCue StoppedSound;
    
    if (AmbientSoundComponent != None)
    {
        AmbientSoundComponent.Stop();
    }
    StoppedSound = InterpAction.bReversePlayback ? ClosedSound : OpenedSound;
    if (StoppedSound != None)
    {
        PlaySound(StoppedSound, TRUE);
    }
    DoorNav = DoorMarker(MyMarker);
    if (InterpAction.bReversePlayback)
    {
        if (Attached.Length > 0)
        {
            SetTimer(StayOpenTime, FALSE, 'Restart', );
        }
        if (DoorNav != None)
        {
            DoorNav.MoverClosed();
        }
    }
    else
    {
        SetTimer(StayOpenTime, FALSE, 'FinishedOpen', );
        if (DoorNav != None)
        {
            DoorNav.MoverOpened();
        }
    }
    if (bMonitorMover)
    {
        foreach WorldInfo.AllControllers(Class'Controller', C)
        {
            if (C.PendingMover == Self)
            {
                C.MoverFinished();
            }
        }
    }
    if (InterpAction.bNoResetOnRewind && InterpAction.bRewindOnPlay)
    {
        ForceNetRelevant();
        bUpdateSimulatedPosition = TRUE;
        bReplicateMovement = TRUE;
    }
}
public event simulated function InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
    ClearTimer('Restart');
    ClearTimer('FinishedOpen');
    PlayMovingSound(InterpAction.bReversePlayback);
    bShouldSaveForCheckpoint = TRUE;
}
public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (bShouldShadowParentAllAttachedActors)
    {
        SetShadowParentOnAllAttachedComponents();
    }
    if (OpeningAmbientSound != None || ClosingAmbientSound != None)
    {
        AmbientSoundComponent = new (Self) Class'AudioComponent';
        AttachComponent(AmbientSoundComponent);
    }
    if (Base != None && (bHardAttach || BaseSkelComponent != None && BaseBoneName != 'None'))
    {
        bShouldSaveForCheckpoint = FALSE;
    }
}
public event function RanInto(Actor Other)
{
    local int i;
    local SeqEvent_Mover MoverEvent;
    
    if (bDestroyProjectilesOnEncroach && Other.IsA('Projectile'))
    {
        Projectile(Other).Explode(Other.location, -Normal(Velocity));
    }
    else if (Other.bDestroyedByInterpActor)
    {
        Other.Destroy();
    }
    else if (bIsLift)
    {
        return;
    }
    else
    {
        for (i = 0; i < GeneratedEvents.Length; i++)
        {
            MoverEvent = SeqEvent_Mover(GeneratedEvents[i]);
            if (MoverEvent != None)
            {
                MoverEvent.NotifyEncroachingOn(Other);
            }
        }
    }
}
public simulated native function SetShadowParentOnAllAttachedComponents();

public simulated function ShutDown()
{
    Super(Actor).ShutDown();
    bShouldSaveForCheckpoint = TRUE;
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local Actor OldBase;
    local SkeletalMeshComponent OldBaseComp;
    local Name OldBaseBoneName;
    local array<Actor> OldAttached;
    local array<Vector> OldLocations;
    local int i;
    
    if (Record.bIsShutdown)
    {
        ShutDown();
    }
    else
    {
        OldAttached = Attached;
        while (i < OldAttached.Length)
        {
            if (OldAttached[i] != None && OldAttached[i].bJustTeleported)
            {
                OldLocations[i] = OldAttached[i].location;
                i++;
                continue;
            }
            OldAttached.Remove(i, 1);
        }
        OldBase = Base;
        OldBaseComp = BaseSkelComponent;
        OldBaseBoneName = BaseBoneName;
        SetLocation(Record.location, );
        SetRotation(Record.Rotation);
        SetBase(OldBase, , OldBaseComp, OldBaseBoneName);
        for (i = 0; i < OldAttached.Length; i++)
        {
            if (OldAttached[i] != None)
            {
                OldAttached[i].SetLocation(OldLocations[i], );
                OldAttached[i].SetBase(Self, , , );
            }
        }
        if (int(Record.CollisionType) != int(ReplicatedCollisionType))
        {
            SetCollisionType(Record.CollisionType);
            ForceNetRelevant();
        }
        if (Record.bHidden != bHidden)
        {
            SetHidden(Record.bHidden);
            SetForcedInitialReplicatedProperty(BoolProperty'Actor.bHidden', bHidden == default.bHidden);
            ForceNetRelevant();
        }
        if (Record.bNeedsPositionReplication)
        {
            bUpdateSimulatedPosition = TRUE;
            bReplicateMovement = TRUE;
            ForceNetRelevant();
        }
    }
    bShouldSaveForCheckpoint = TRUE;
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.location = location;
    Record.Rotation = Rotation;
    Record.bHidden = bHidden;
    Record.CollisionType = ReplicatedCollisionType;
    Record.bNeedsPositionReplication = RemoteRole == ENetRole.ROLE_SimulatedProxy && bUpdateSimulatedPosition;
    Record.bIsShutdown = Physics == EPhysics.PHYS_None && bHidden;
}
public function FinishedOpen()
{
    local int i;
    local SeqEvent_Mover MoverEvent;
    
    for (i = 0; i < GeneratedEvents.Length; i++)
    {
        MoverEvent = SeqEvent_Mover(GeneratedEvents[i]);
        if (MoverEvent != None)
        {
            MoverEvent.NotifyFinishedOpen();
        }
    }
}
public simulated function PlayMovingSound(bool bClosing)
{
    local SoundCue SoundToPlay;
    local SoundCue AmbientToPlay;
    
    if (bClosing)
    {
        SoundToPlay = CloseSound;
        AmbientToPlay = OpeningAmbientSound;
    }
    else
    {
        SoundToPlay = OpenSound;
        AmbientToPlay = ClosingAmbientSound;
    }
    if (SoundToPlay != None)
    {
        PlaySound(SoundToPlay, TRUE);
    }
    if (AmbientToPlay != None)
    {
        AmbientSoundComponent.Stop();
        AmbientSoundComponent.SoundCue = AmbientToPlay;
        AmbientSoundComponent.Play();
    }
}
public function Restart()
{
    local Actor A;
    
    foreach BasedActors(Class'Actor', A)
    {
        Attach(A);
    }
}
public function bool ShouldSaveForCheckpoint()
{
    return bShouldSaveForCheckpoint || RemoteRole == ENetRole.ROLE_SimulatedProxy;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled = FALSE
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent0
        WireframeColor = {B = 255, G = 0, R = 255, A = 255}
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        RBCollideWithChannels = {Default = TRUE, BlockingVolume = TRUE}
    End Template
    bShouldSaveForCheckpoint = TRUE
    bDestroyProjectilesOnEncroach = TRUE
    bContinueOnEncroachPhysicsObject = TRUE
    bStopOnEncroach = TRUE
    bShouldShadowParentAllAttachedActors = TRUE
    StaticMeshComponent = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, StaticMeshComponent0)
    NetUpdateFrequency = 1.0
    NetPriority = 2.70000005
    TickFrequencyAtEndDistance = 0.100000001
    TickFrequencyDecreaseDistanceStart = 4000.0
    TickFrequencyDecreaseDistanceEnd = 8000.0
    CollisionComponent = StaticMeshComponent0
    bNoDelete = TRUE
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    bBlocksTeleport = TRUE
    Physics = EPhysics.PHYS_Interpolating
    RemoteRole = ENetRole.ROLE_None
}