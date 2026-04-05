Class KActor extends DynamicSMActor
    native
    placeable
    nativereplication;

var const native RigidBodyState RBState;
var PhysEffectInfo ImpactEffectInfo;
var PhysEffectInfo SlideEffectInfo;
var repnotify Vector ReplicatedDrawScale3D;
var transient Vector InitialLocation;
var transient Rotator InitialRotation;
var editinline export ParticleSystemComponent ImpactEffectComponent;
var editinline export AudioComponent ImpactSoundComponent;
var editinline export AudioComponent ImpactSoundComponent2;
var float LastImpactTime;
var editinline export ParticleSystemComponent SlideEffectComponent;
var editinline export AudioComponent SlideSoundComponent;
var float LastSlideTime;
var(StayUprightSpring) float StayUprightTorqueFactor;
var(StayUprightSpring) float StayUprightMaxTorque;
var(KActor) float MaxPhysicsVelocity;
var const native float AngErrorAccumulator;
var(KActor) bool bDamageAppliesImpulse;
var(KActor) repnotify bool bWakeOnLevelStart;
var bool bCurrentSlide;
var bool bSlideActive;
var(StayUprightSpring) bool bEnableStayUprightSpring;
var(KActor) bool bLimitMaxPhysicsVelocity;
var transient bool bNeedsRBStateReplication;
var bool bDisableClientSidePawnInteractions;

public event function ApplyImpulse(Vector ImpulseDir, float ImpulseMag, Vector HitLocation, optional TraceHitInfo HitInfo, optional Class<DamageType> DamageType)
{
    local Vector AppliedImpulse;
    
    AppliedImpulse = Normal(ImpulseDir) * ImpulseMag;
    if (HitInfo.HitComponent != None)
    {
        HitInfo.HitComponent.AddImpulse(AppliedImpulse, HitLocation, HitInfo.BoneName);
    }
    else
    {
        CollisionComponent.AddImpulse(AppliedImpulse, HitLocation);
    }
}
public event simulated function Destroyed()
{
    if (ImpactEffectInfo.Sound != None)
    {
        if (ImpactSoundComponent != None)
        {
            ImpactSoundComponent.bAutoDestroy = TRUE;
        }
        if (ImpactSoundComponent2 != None)
        {
            ImpactSoundComponent2.bAutoDestroy = TRUE;
        }
    }
    if (SlideEffectInfo.Sound != None)
    {
        SlideSoundComponent.bAutoDestroy = TRUE;
    }
    Super(Actor).Destroyed();
}
public event simulated function FellOutOfWorld(Class<DamageType> dmgType)
{
    ShutDown();
    Super(Actor).FellOutOfWorld(dmgType);
}
public final native function PhysicalMaterial GetKActorPhysMaterial();

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        StaticMeshComponent.WakeRigidBody();
    }
}
public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (bWakeOnLevelStart && StaticMeshComponent != None)
    {
        StaticMeshComponent.WakeRigidBody();
    }
    else
    {
        bNeedsRBStateReplication = !bNoDelete;
    }
    ReplicatedDrawScale3D = DrawScale3D * 1000.0;
    if (StaticMeshComponent != None && StaticMeshComponent.bNotifyRigidBodyCollision)
    {
        SetPhysicalCollisionProperties();
    }
    InitialLocation = location;
    InitialRotation = Rotation;
    if (bDisableClientSidePawnInteractions && Role != ENetRole.ROLE_Authority && StaticMeshComponent != None)
    {
        StaticMeshComponent.SetRBCollidesWithChannel(2, FALSE);
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    local Vector NewDrawScale3D;
    
    if (VarName == 'bWakeOnLevelStart')
    {
        if (bWakeOnLevelStart)
        {
            StaticMeshComponent.WakeRigidBody();
        }
    }
    else if (VarName == 'ReplicatedDrawScale3D')
    {
        NewDrawScale3D = ReplicatedDrawScale3D / 1000.0;
        SetDrawScale3D(NewDrawScale3D);
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}
public simulated function Reset()
{
    StaticMeshComponent.SetRBLinearVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBAngularVelocity(vect(0.0, 0.0, 0.0));
    StaticMeshComponent.SetRBPosition(InitialLocation);
    StaticMeshComponent.SetRBRotation(InitialRotation);
    if (!bWakeOnLevelStart)
    {
        StaticMeshComponent.PutRigidBodyToSleep();
    }
    else
    {
        StaticMeshComponent.WakeRigidBody();
    }
    ResolveRBState();
    bForceNetUpdate = TRUE;
    Super(Actor).Reset();
}
public final native function ResolveRBState();

public event simulated function SpawnedByKismet()
{
    if (StaticMeshComponent.bNotifyRigidBodyCollision)
    {
        SetPhysicalCollisionProperties();
    }
    InitialLocation = location;
    InitialRotation = Rotation;
}
public event simulated function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    Super(Actor).TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (bDamageAppliesImpulse && DamageType.default.KDamageImpulse > float(0))
    {
        if (VSize(Momentum) < 0.00100000005)
        {
            return;
        }
        ApplyImpulse(Momentum, DamageType.default.KDamageImpulse, HitLocation, HitInfo, DamageType);
    }
}
public simulated function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo)
{
    local int idx;
    local SeqEvent_TakeDamage DmgEvt;
    
    for (idx = 0; idx < GeneratedEvents.Length; idx++)
    {
        DmgEvt = SeqEvent_TakeDamage(GeneratedEvents[idx]);
        if (DmgEvt != None)
        {
            DmgEvt.HandleDamage(Self, instigatedBy, DamageType, BaseDamage, , DamageCauser);
        }
    }
    if (bDamageAppliesImpulse && DamageType.default.RadialDamageImpulse > float(0) && Role == ENetRole.ROLE_Authority)
    {
        CollisionComponent.AddRadialImpulse(HurtOrigin, DamageRadius, DamageType.default.RadialDamageImpulse * Momentum, 1, DamageType.default.bRadialDamageVelChange);
    }
    Super(Actor).TakeRadiusDamage(instigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser);
}
public simulated function OnTeleport(SeqAct_Teleport inAction)
{
    local Actor destActor;
    local Vector vLocation;
    local Rotator rRotation;
    
    if (inAction.SFXGetTeleportLocAndRot(vLocation, rRotation, destActor))
    {
        StaticMeshComponent.SetRBPosition(vLocation);
        StaticMeshComponent.SetRBRotation(rRotation);
        PlayTeleportEffect(FALSE, TRUE);
    }
}
public simulated function SetPhysicalCollisionProperties()
{
    local PhysicalMaterial PhysMat;
    
    PhysMat = GetKActorPhysMaterial();
    ImpactEffectInfo = PhysMat.FindPhysEffectInfo(0);
    SlideEffectInfo = PhysMat.FindPhysEffectInfo(1);
    if (ImpactEffectInfo.Effect != None)
    {
        ImpactEffectComponent = new (Self) Class'ParticleSystemComponent';
        AttachComponent(ImpactEffectComponent);
        ImpactEffectComponent.bAutoActivate = FALSE;
        ImpactEffectComponent.SetTemplate(ImpactEffectInfo.Effect);
    }
    if (ImpactEffectInfo.Sound != None)
    {
        ImpactSoundComponent = new (Self) Class'AudioComponent';
        AttachComponent(ImpactSoundComponent);
        ImpactSoundComponent.SoundCue = ImpactEffectInfo.Sound;
        ImpactSoundComponent2 = new (Self) Class'AudioComponent';
        AttachComponent(ImpactSoundComponent2);
        ImpactSoundComponent2.SoundCue = ImpactEffectInfo.Sound;
    }
    if (SlideEffectInfo.Effect != None)
    {
        SlideEffectComponent = new (Self) Class'ParticleSystemComponent';
        AttachComponent(SlideEffectComponent);
        SlideEffectComponent.bAutoActivate = FALSE;
        SlideEffectComponent.SetTemplate(SlideEffectInfo.Effect);
    }
    if (SlideEffectInfo.Sound != None)
    {
        SlideSoundComponent = new (Self) Class'AudioComponent';
        AttachComponent(SlideSoundComponent);
        SlideSoundComponent.SoundCue = SlideEffectInfo.Sound;
    }
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (!bNeedsRBStateReplication && Role == ENetRole.ROLE_Authority)
        RBState;
    if (bNetInitial && Role == ENetRole.ROLE_Authority)
        ReplicatedDrawScale3D, bWakeOnLevelStart;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent0
        WireframeColor = {B = 128, G = 255, R = 0, A = 255}
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        RBChannel = ERBCollisionChannel.RBCC_GameplayPhysics
        BlockRigidBody = TRUE
        RBCollideWithChannels = {Default = TRUE, GameplayPhysics = TRUE, EffectPhysics = TRUE, BlockingVolume = TRUE}
    End Template
    ReplicatedDrawScale3D = {X = 1000.0, Y = 1000.0, Z = 1000.0}
    StayUprightTorqueFactor = 1000.0
    StayUprightMaxTorque = 1500.0
    MaxPhysicsVelocity = 350.0
    bDamageAppliesImpulse = TRUE
    bNeedsRBStateReplication = TRUE
    bDisableClientSidePawnInteractions = TRUE
    StaticMeshComponent = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    bPawnCanBaseOn = FALSE
    bSafeBaseIfAsleep = TRUE
    Components = (MyLightEnvironment, StaticMeshComponent0)
    CollisionComponent = StaticMeshComponent0
    bNoDelete = TRUE
    bAlwaysRelevant = TRUE
    bUpdateSimulatedPosition = TRUE
    bNetInitialRotation = TRUE
    bCanBeDamaged = TRUE
    bBlocksNavigation = TRUE
    bProjTarget = TRUE
    bBlocksTeleport = TRUE
    bNoEncroachCheck = TRUE
    Physics = EPhysics.PHYS_RigidBody
    TickGroup = ETickingGroup.TG_PostAsyncWork
}