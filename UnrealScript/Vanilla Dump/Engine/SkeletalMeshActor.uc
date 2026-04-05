Class SkeletalMeshActor extends Actor
    native
    placeable;

struct native SkelMeshActorControlTarget 
{
    var(SkelMeshActorControlTarget) Name ControlName;
    var(SkelMeshActorControlTarget) Actor TargetActor;
};
struct CheckpointRecord 
{
    var bool bHidden;
    var Rotator Rotation;
    
    structdefaultproperties
    {
        bHidden = FALSE
        Rotation = {Pitch = 0, Yaw = 0, Roll = 0}
    }
};

var(SkeletalMeshActor) array<SkelMeshActorControlTarget> ControlTargets;
var transient clearcrosslevel array<InterpGroup> InterpGroupList;
var(SkeletalMeshActor) editinline export SkeletalMeshComponent SkeletalMeshComponent;
var(SkeletalMeshActor) const editinline editconst export LightEnvironmentComponent LightEnvironment;
var editinline export AudioComponent FacialAudioComp;
var transient repnotify SkeletalMesh ReplicatedMesh;
var repnotify MaterialInterface ReplicatedMaterial;
var transient Actor AimTarget;
var(SkeletalMeshActor) bool bDamageAppliesImpulse;
var(Gears) const bool bCheckpointSaveRotation;
var(SkeletalMeshActor) bool bShouldDoAnimNotifies;

public event simulated function BeginAnimControl(InterpGroup InInterpGroup)
{
    MAT_BeginAnimControl(InInterpGroup);
}
public event simulated function Destroyed()
{
    Super.Destroyed();
    InterpGroupList.Length = 0;
    UpdateAnimSetList();
}
public event simulated function FinishAnimControl(InterpGroup InInterpGroup)
{
    MAT_FinishAnimControl(InInterpGroup);
}
public event simulated function FaceFXAsset GetActorFaceFXAsset()
{
    if (SkeletalMeshComponent.SkeletalMesh != None)
    {
        return SkeletalMeshComponent.GetBioFaceFXAsset();
    }
    else
    {
        return None;
    }
}
public event simulated function AudioComponent GetFaceFXAudioComponent()
{
    return FacialAudioComp;
}
public native function SkeletalMeshComponent GetHeadSkelMeshComponent();

public native function SkeletalMeshComponent GetPrimarySkelMeshComponent();

public native function MAT_BeginAnimControl(InterpGroup InInterpGroup);

public native function MAT_FinishAnimControl(InterpGroup InInterpGroup);

public event function OnSetMesh(SeqAct_SetMesh Action)
{
    if (Action.MeshType == EMeshType.MeshType_SkeletalMesh)
    {
        if (Action.NewSkeletalMesh != None && Action.NewSkeletalMesh != SkeletalMeshComponent.SkeletalMesh)
        {
            SkeletalMeshComponent.SetSkeletalMesh(Action.NewSkeletalMesh);
            ReplicatedMesh = Action.NewSkeletalMesh;
        }
    }
}
public event simulated function OnSetSkelControlTarget(SeqAct_SetSkelControlTarget Action)
{
    local int i;
    
    if (Action.SkelControlName == 'None' || Action.TargetActors.Length == 0)
    {
        return;
    }
    for (i = 0; i < ControlTargets.Length; i++)
    {
        if (ControlTargets[i].ControlName == Action.SkelControlName)
        {
            ControlTargets[i].TargetActor = Actor(Action.TargetActors[Rand(Action.TargetActors.Length)]);
            return;
        }
    }
    ControlTargets.Length = ControlTargets.Length + 1;
    ControlTargets[ControlTargets.Length - 1].ControlName = Action.SkelControlName;
    ControlTargets[ControlTargets.Length - 1].TargetActor = Actor(Action.TargetActors[Rand(Action.TargetActors.Length)]);
}
public simulated function OnToggle(SeqAct_Toggle Action)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    if (Action.InputLinks[0].bHasImpulse)
    {
        if (!SeqNode.bPlaying)
        {
            SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0);
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        if (SeqNode.bPlaying)
        {
            SeqNode.StopAnim();
        }
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (SeqNode.bPlaying)
        {
            SeqNode.StopAnim();
        }
        else
        {
            SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0);
        }
    }
}
public event simulated function OnUpdatePhysBonesFromAnim(SeqAct_UpdatePhysBonesFromAnim Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        SkeletalMeshComponent.ForceSkelUpdate();
        SkeletalMeshComponent.UpdateRBBonesFromSpaceBases(TRUE, TRUE);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        if (SkeletalMeshComponent.PhysicsAssetInstance != None)
        {
            SkeletalMeshComponent.PhysicsAssetInstance.SetAllBodiesFixed(TRUE);
        }
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (SkeletalMeshComponent.PhysicsAssetInstance != None)
        {
            SkeletalMeshComponent.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, SkeletalMeshComponent);
        }
    }
}
public event simulated function bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay)
{
    return SkeletalMeshComponent.PlayFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay);
}
public event function PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData)
{
    local Vector Loc;
    local Rotator Rot;
    local ParticleSystemComponent PSC;
    
    if (bShouldDoAnimNotifies == FALSE || AnimNotifyData.bIsExtremeContent == TRUE && WorldInfo.GRI.ShouldShowGore() == FALSE)
    {
        return;
    }
    if (AnimNotifyData.SocketName != 'None')
    {
        SkeletalMeshComponent.GetSocketWorldLocationAndRotation(AnimNotifyData.SocketName, Loc, Rot);
    }
    else if (AnimNotifyData.BoneName != 'None')
    {
        Loc = SkeletalMeshComponent.GetBoneLocation(AnimNotifyData.BoneName);
    }
    else
    {
        Loc = location;
    }
    if (AnimNotifyData.bAttach == TRUE)
    {
        PSC = new (Self) Class'ParticleSystemComponent';
        PSC.SetTemplate(AnimNotifyData.PSTemplate);
        if (AnimNotifyData.SocketName != 'None')
        {
            SkeletalMeshComponent.AttachComponentToSocket(PSC, AnimNotifyData.SocketName);
        }
        else if (AnimNotifyData.BoneName != 'None')
        {
            SkeletalMeshComponent.AttachComponent(PSC, AnimNotifyData.BoneName);
        }
        PSC.ActivateSystem();
        PSC.__OnSystemFinished__Delegate = SkelMeshActorOnParticleSystemFinished;
    }
    else
    {
        WorldInfo.MyEmitterPool.SpawnEmitter(AnimNotifyData.PSTemplate, Loc, rot(0, 0, 1));
    }
}
public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SkeletalMeshComponent.SaveAnimSets();
    if (Role == ENetRole.ROLE_Authority && SkeletalMeshComponent != None)
    {
        ReplicatedMesh = SkeletalMeshComponent.SkeletalMesh;
    }
    if (SkeletalMeshComponent != None && SkeletalMeshComponent.PhysicsAssetInstance != None)
    {
        SkeletalMeshComponent.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, SkeletalMeshComponent);
    }
    if (SkeletalMeshComponent != None && SkeletalMeshComponent.bEnableClothSimulation)
    {
        SkeletalMeshComponent.bAlwaysUpdateMeshObject = FALSE;
    }
    if (bHidden)
    {
        SkeletalMeshComponent.SetClothFrozen(TRUE);
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ReplicatedMesh')
    {
        SkeletalMeshComponent.SetSkeletalMesh(ReplicatedMesh);
    }
    else if (VarName == 'ReplicatedMaterial')
    {
        SkeletalMeshComponent.SetMaterial(0, ReplicatedMaterial);
    }
    else
    {
        Super.ReplicatedEvent(VarName);
    }
}
public event simulated function SetAnimPosition(Name SlotName, int ChannelIndex, Name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    if (SeqNode != None)
    {
        if (SeqNode.AnimSeqName != InAnimSeqName)
        {
            SeqNode.SetAnim(InAnimSeqName);
        }
        SeqNode.bLooping = bLooping;
        SeqNode.SetPosition(InPosition, bFireNotifies);
    }
}
public event simulated function StopActorFaceFXAnim()
{
    SkeletalMeshComponent.StopFaceFXAnim();
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
        ApplyImpulse = Normal(Momentum) * DamageType.default.KDamageImpulse;
        if (HitInfo.HitComponent != None)
        {
            HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);
        }
    }
}
public simulated native function UpdateAnimSetList();

public function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    local bool bOldCollideActors;
    local bool bOldBlockActors;
    local bool bValidBone;
    local bool bValidSocket;
    
    if (SkeletalMeshComponent != None && Action.BoneName != 'None')
    {
        bValidSocket = SkeletalMeshComponent.GetSocketByName(Action.BoneName) != None;
        bValidBone = SkeletalMeshComponent.MatchRefBone(Action.BoneName) != -1;
        if (!bValidBone && !bValidSocket)
        {
        }
    }
    if (bValidBone || bValidSocket)
    {
        bOldCollideActors = Attachment.bCollideActors;
        bOldBlockActors = Attachment.bBlockActors;
        Attachment.SetCollision(FALSE, FALSE, );
        Attachment.SetHardAttach(Action.bHardAttach);
        if (bValidBone && !bValidSocket)
        {
            if (Action.bUseRelativeOffset)
            {
                Attachment.SetLocation(SkeletalMeshComponent.GetBoneLocation(Action.BoneName), );
            }
            if (Action.bUseRelativeRotation)
            {
                Attachment.SetRotation(QuatToRotator(SkeletalMeshComponent.GetBoneQuaternion(Action.BoneName)));
            }
        }
        Attachment.SetBase(Self, , SkeletalMeshComponent, Action.BoneName);
        if (Action.bUseRelativeRotation)
        {
            Attachment.SetRelativeRotation(Attachment.RelativeRotation + Action.RelativeRotation);
        }
        if (Action.bUseRelativeOffset)
        {
            Attachment.SetRelativeLocation(Attachment.RelativeLocation + Action.RelativeOffset);
        }
        Attachment.SetCollision(bOldCollideActors, bOldBlockActors, );
    }
    else
    {
        Super.DoKismetAttachment(Attachment, Action);
    }
}
public simulated function bool IsActorPlayingFaceFXAnim()
{
    return SkeletalMeshComponent != None && SkeletalMeshComponent.IsPlayingFaceFXAnim();
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    SetHidden(Record.bHidden);
    if (bCheckpointSaveRotation)
    {
        SetRotation(Record.Rotation);
    }
    ForceNetRelevant();
    if (RemoteRole != ENetRole.ROLE_None)
    {
        SetForcedInitialReplicatedProperty(BoolProperty'Actor.bHidden', bHidden == default.bHidden);
    }
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.bHidden = bHidden;
    if (bCheckpointSaveRotation)
    {
        Record.Rotation = Rotation;
    }
}
public simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
    local PlayerController PC;
    
    SkeletalMeshComponent.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName, inAction.SoundCueToPlay);
    foreach WorldInfo.AllControllers(Class'PlayerController', PC)
    {
        if (NetConnection(PC.Player) != None)
        {
            PC.ClientPlayActorFaceFXAnim(Self, inAction.FaceFXAnimSetRef, inAction.FaceFXGroupName, inAction.FaceFXAnimName, inAction.SoundCueToPlay);
        }
    }
}
public final function OnSetAimTarget(SFXSeqAct_SetAimTarget inAction)
{
    AimTarget = inAction.AimTarget;
}
public function OnSetMaterial(SeqAct_SetMaterial Action)
{
    SkeletalMeshComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    if (Action.MaterialIndex == 0)
    {
        ReplicatedMaterial = Action.NewMaterial;
        ForceNetRelevant();
    }
}
public function bool ShouldSaveForCheckpoint()
{
    return RemoteRole != ENetRole.ROLE_None || bCheckpointSaveRotation;
}
public simulated function SkelMeshActorOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    SkeletalMeshComponent.DetachComponent(PSC);
}

replication
{
    if (Role == ENetRole.ROLE_Authority)
        ReplicatedMesh, ReplicatedMaterial;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Object
    Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
        Animations = AnimNodeSeq0
        bAlwaysUpdateMeshObject = TRUE
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        RBChannel = ERBCollisionChannel.RBCC_GameplayPhysics
        CollideActors = TRUE
        BlockZeroExtent = TRUE
        RBCollideWithChannels = {Default = TRUE, GameplayPhysics = TRUE, EffectPhysics = TRUE, BlockingVolume = TRUE}
    End Object
    Begin Object Class=AnimNodeSequence Name=AnimNodeSeq0
    End Object
    SkeletalMeshComponent = SkeletalMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, SkeletalMeshComponent0)
    CollisionComponent = SkeletalMeshComponent0
    bNoDelete = TRUE
    bProjTarget = TRUE
    bNoEncroachCheck = TRUE
    bEdShouldSnap = TRUE
}