Class PhysicsVolume extends Volume
    native
    placeable
    nativereplication;

struct CheckpointRecord 
{
    var bool bPainCausing;
    
    structdefaultproperties
    {
        bPainCausing = FALSE
    }
};

var(PhysicsVolume) Class<DamageType> DamageType;
var(PhysicsVolume) interp Vector ZoneVelocity;
var(PhysicsVolume) float GroundFriction;
var(PhysicsVolume) float TerminalVelocity;
var(PhysicsVolume) const float DamagePerSec;
var(PhysicsVolume) int Priority;
var(PhysicsVolume) float FluidFriction;
var(PhysicsVolume) float PainInterval;
var(PhysicsVolume) float RigidBodyDamping;
var(PhysicsVolume) float MaxDampingForce;
var Info PainTimer;
var Controller DamageInstigator;
var PhysicsVolume NextPhysicsVolume;
var(PhysicsVolume) bool bVelocityAffectsWalking;
var(PhysicsVolume) bool bPainCausing;
var(PhysicsVolume) bool bAIShouldIgnorePain;
var(PhysicsVolume) bool bEntryPain;
var bool BACKUP_bPainCausing;
var(PhysicsVolume) bool bDestructive;
var(PhysicsVolume) bool bNoInventory;
var(PhysicsVolume) bool bMoveProjectiles;
var(PhysicsVolume) bool bBounceVelocity;
var(PhysicsVolume) bool bNeutralZone;
var(PhysicsVolume) bool bCrowdAgentsPlayDeathAnim;
var(PhysicsVolume) bool bPhysicsOnContact;
var bool bWaterVolume;

public event function ActorEnteredVolume(Actor Other);

public event function ActorLeavingVolume(Actor Other);

public event simulated function CollisionChanged();

public function Destroyed()
{
    Super(Actor).Destroyed();
    if (bPainCausing)
    {
        PainTimer.Destroy();
    }
}
public native function float GetGravityZ();

public native function float GetRBPhysicsGravityScaling();

public native function Vector GetZoneVelocityForActor(Actor TheActor);

public simulated function OnToggle(SeqAct_Toggle inAction)
{
    if (!bStatic || RemoteRole > ENetRole.ROLE_None)
    {
        Super.OnToggle(inAction);
    }
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bPainCausing = BACKUP_bPainCausing;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bPainCausing = FALSE;
    }
    else if (inAction.InputLinks[2].bHasImpulse)
    {
        bPainCausing = !bPainCausing && BACKUP_bPainCausing;
    }
}
public event function PawnEnteredVolume(Pawn Other);

public event function PawnLeavingVolume(Pawn Other);

public event function PhysicsChangedFor(Actor Other);

public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    BACKUP_bPainCausing = bPainCausing;
    if (Role < ENetRole.ROLE_Authority)
    {
        return;
    }
    if (bPainCausing)
    {
        PainTimer = Spawn(Class'VolumeTimer', Self);
    }
}
public function Reset()
{
    bPainCausing = BACKUP_bPainCausing;
    bForceNetUpdate = TRUE;
}
public event simulated function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    Super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    if (Other == None || Other.bStatic)
    {
        return;
    }
    if (bNoInventory && DroppedPickup(Other) != None && Other.Owner == None)
    {
        Other.LifeSpan = 1.5;
        return;
    }
    if (bMoveProjectiles && ZoneVelocity != vect(0.0, 0.0, 0.0))
    {
        if (Other.Physics == EPhysics.PHYS_Projectile)
        {
            Other.Velocity += ZoneVelocity;
        }
        else if (Other.Base == None && Other.IsA('Emitter') && Other.Physics == EPhysics.PHYS_None)
        {
            Other.SetPhysics(6);
            Other.Velocity += ZoneVelocity;
        }
    }
    if (bPainCausing)
    {
        if (Other.bDestroyInPainVolume)
        {
            Other.VolumeBasedDestroy(Self);
            return;
        }
        if (bEntryPain && Other.bCanBeDamaged)
        {
            if (KActor(Other) == None)
            {
                CausePainTo(Other);
            }
        }
    }
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    bPainCausing = Record.bPainCausing;
}
public function CausePainTo(Actor Other)
{
    if (DamagePerSec > float(0))
    {
        if (WorldInfo.bSoftKillZ && Other.Physics != EPhysics.PHYS_Walking)
        {
            return;
        }
        if (DamageType == None || DamageType == Class'DamageType')
        {
        }
        Other.TakeDamage(DamagePerSec * PainInterval, DamageInstigator, location, vect(0.0, 0.0, 0.0), DamageType, , Self);
    }
    else
    {
        Other.HealDamage(int(-DamagePerSec * PainInterval), DamageInstigator, DamageType);
    }
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bPainCausing = bPainCausing;
}
public function ModifyPlayer(Pawn PlayerPawn);

public function NotifyPawnBecameViewTarget(Pawn P, PlayerController PC);

public function OnSetDamageInstigator(SeqAct_SetDamageInstigator Action)
{
    DamageInstigator = Action.GetController(Action.DamageInstigator);
}
public function bool ShouldSaveForCheckpoint()
{
    return bPainCausing != BACKUP_bPainCausing;
}
public function TimerPop(VolumeTimer T)
{
    local Actor A;
    
    if (T == PainTimer)
    {
        if (!bPainCausing)
        {
            return;
        }
        foreach TouchingActors(Class'Actor', A, )
        {
            if (A.bCanBeDamaged && !A.bStatic)
            {
                if (KActor(A) == None)
                {
                    CausePainTo(A);
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        BlockZeroExtent = TRUE
    End Template
    DamageType = Class'DamageType'
    GroundFriction = 8.0
    TerminalVelocity = 3500.0
    FluidFriction = 0.300000012
    PainInterval = 1.0
    MaxDampingForce = 1000000.0
    bVelocityAffectsWalking = TRUE
    bEntryPain = TRUE
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    NetUpdateFrequency = 0.100000001
    CollisionComponent = BrushComponent0
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    bForceAllowKismetModification = TRUE
}