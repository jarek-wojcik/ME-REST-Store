Class KAsset extends Actor
    native
    placeable
    nativereplication;

var(KAsset) const editinline editconst export SkeletalMeshComponent SkeletalMeshComponent;
var transient repnotify SkeletalMesh ReplicatedMesh;
var transient repnotify PhysicsAsset ReplicatedPhysAsset;
var(KAsset) bool bDamageAppliesImpulse;
var(KAsset) bool bWakeOnLevelStart;
var(KAsset) bool bBlockPawns;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        SkeletalMeshComponent.WakeRigidBody();
    }
}
public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (bWakeOnLevelStart)
    {
        SkeletalMeshComponent.WakeRigidBody();
    }
    ReplicatedMesh = SkeletalMeshComponent.SkeletalMesh;
    ReplicatedPhysAsset = SkeletalMeshComponent.PhysicsAsset;
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ReplicatedMesh')
    {
        SkeletalMeshComponent.SetSkeletalMesh(ReplicatedMesh);
    }
    else if (VarName == 'ReplicatedPhysAsset')
    {
        SkeletalMeshComponent.SetPhysicsAsset(ReplicatedPhysAsset);
    }
}
public event simulated function TakeDamage(float Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Vector ApplyImpulse;
    
    Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (bDamageAppliesImpulse && DamageType.default.KDamageImpulse > float(0))
    {
        if (VSize(Momentum) < 0.00100000005)
        {
            return;
        }
        CheckHitInfo(HitInfo, SkeletalMeshComponent, Normal(Momentum), HitLocation);
        ApplyImpulse = Momentum * DamageType.default.KDamageImpulse;
        if (HitInfo.HitComponent != None)
        {
            HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);
        }
    }
}
public simulated function TakeRadiusDamage(Controller instigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0, optional TraceHitInfo HitInfo)
{
    if (bDamageAppliesImpulse && DamageType.default.RadialDamageImpulse > float(0) && Role == ENetRole.ROLE_Authority)
    {
        CollisionComponent.AddRadialImpulse(HurtOrigin, DamageRadius, DamageType.default.RadialDamageImpulse * Momentum, 1, DamageType.default.bRadialDamageVelChange);
    }
}
public function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    Attachment.SetBase(Self, , SkeletalMeshComponent, Action.BoneName);
}
public simulated function OnTeleport(SeqAct_Teleport inAction)
{
    local Actor destActor;
    local Vector vLocation;
    local Rotator rRotation;
    
    if (inAction.SFXGetTeleportLocAndRot(vLocation, rRotation, destActor))
    {
        SkeletalMeshComponent.SetRBPosition(vLocation);
    }
    else
    {
        inAction.ScriptLog("No Destination for" @ inAction @ "on" @ Self);
    }
}
public final function SetMeshAndPhysAsset(SkeletalMesh NewMesh, PhysicsAsset NewPhysAsset)
{
    SkeletalMeshComponent.SetSkeletalMesh(NewMesh);
    ReplicatedMesh = NewMesh;
    SkeletalMeshComponent.SetPhysicsAsset(NewPhysAsset);
    ReplicatedPhysAsset = NewPhysAsset;
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (Role == ENetRole.ROLE_Authority)
        ReplicatedMesh, ReplicatedPhysAsset;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Object
    Begin Object Class=SkeletalMeshComponent Name=KAssetSkelMeshComponent
        PhysicsWeight = 1.0
        bSkipAllUpdateWhenPhysicsAsleep = TRUE
        bHasPhysicsAssetInstance = TRUE
        bUpdateKinematicBonesFromAnimation = FALSE
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        RBChannel = ERBCollisionChannel.RBCC_GameplayPhysics
        CollideActors = TRUE
        BlockActors = TRUE
        BlockZeroExtent = TRUE
        BlockRigidBody = TRUE
        RBCollideWithChannels = {Default = TRUE, GameplayPhysics = TRUE, EffectPhysics = TRUE, BlockingVolume = TRUE}
    End Object
    SkeletalMeshComponent = KAssetSkelMeshComponent
    bDamageAppliesImpulse = TRUE
    Components = (MyLightEnvironment, KAssetSkelMeshComponent)
    CollisionComponent = KAssetSkelMeshComponent
    bNoDelete = TRUE
    bAlwaysRelevant = TRUE
    bUpdateSimulatedPosition = TRUE
    bNetInitialRotation = TRUE
    bCollideActors = TRUE
    bBlockActors = TRUE
    bProjTarget = TRUE
    bEdShouldSnap = TRUE
    Physics = EPhysics.PHYS_RigidBody
    RemoteRole = ENetRole.ROLE_SimulatedProxy
    TickGroup = ETickingGroup.TG_PostAsyncWork
}