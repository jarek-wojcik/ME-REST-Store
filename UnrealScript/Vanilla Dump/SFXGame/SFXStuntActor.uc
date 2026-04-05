Class SFXStuntActor extends Actor
    native;

var(Mesh) editinline export SkeletalMeshComponent BodyMesh;
var(Mesh) editinline export SkeletalMeshComponent HeadMesh;
var(Mesh) editinline export SkeletalMeshComponent HairMesh;
var(Mesh) editinline export SkeletalMeshComponent HeadGearMesh;
var(Mesh) BioMorphFace MorphHead;
var(Lighting) editinline export BioDynamicLightEnvironmentComponent LightEnvironment;
var transient Actor AimTarget;
var(Mesh) bool bHelmetHidesHead;
var(Mesh) bool bHelmetHidesHair;
var(Mesh) bool m_bUpdateSkelWhenNotRendered;
var(SFXStuntActor) bool m_bActive;
var(SFXStuntActor) bool bCausesPlayerPortArms;

public event simulated function BeginAnimControl(InterpGroup InInterpGroup)
{
    local AnimNodeSequence SeqNode;
    local SkeletalMeshComponent MeshComponent;
    local SFXModule_Gestures pGestMod;
    
    SeqNode = AnimNodeSequence(BodyMesh.FindAnimNode('MatineeAnim'));
    pGestMod = GetModule(Class'SFXModule_Gestures');
    if (pGestMod != None)
    {
        pGestMod.m_aBackupAnimSets = BodyMesh.AnimSets;
        pGestMod.m_bInMatinee = TRUE;
    }
    if (SeqNode != None)
    {
        if (InInterpGroup == None)
        {
            BodyMesh.AnimSets.Length = 0;
        }
        else
        {
            InInterpGroup.SFXScriptCopyGroupAnimSets(BodyMesh.AnimSets);
        }
        BodyMesh.bAnimSetUpdated = TRUE;
        SeqNode.SetAnim('None');
    }
    if (BodyMesh != None)
    {
        BodyMesh.bUpdateSkelWhenNotRendered = TRUE;
        foreach ComponentList(Class'SkeletalMeshComponent', MeshComponent)
        {
            MeshComponent.bUpdateSkelWhenNotRendered = TRUE;
        }
    }
}
public simulated function BioBaseRemovedFromWorld()
{
    if (Physics == EPhysics.PHYS_None || Physics == EPhysics.PHYS_Interpolating)
    {
    }
    else
    {
        BioApplyStasis("BaseRemovedFromWorld");
    }
}
public simulated function FellOutOfWorld(Class<DamageType> dmgType);

public event simulated function FinishAnimControl(InterpGroup InInterpGroup)
{
    local SkeletalMeshComponent MeshComponent;
    local SFXModule_Gestures pGestMod;
    
    pGestMod = GetModule(Class'SFXModule_Gestures');
    if (pGestMod != None)
    {
        if (pGestMod.m_bInMatinee)
        {
            pGestMod.m_bInMatinee = FALSE;
            BodyMesh.AnimSets = pGestMod.m_aBackupAnimSets;
            BodyMesh.bAnimSetUpdated = TRUE;
            pGestMod.m_aBackupAnimSets.Length = 0;
        }
    }
    if (BodyMesh != None)
    {
        BodyMesh.bUpdateSkelWhenNotRendered = m_bUpdateSkelWhenNotRendered;
        foreach ComponentList(Class'SkeletalMeshComponent', MeshComponent)
        {
            MeshComponent.bUpdateSkelWhenNotRendered = m_bUpdateSkelWhenNotRendered;
        }
    }
}
public event function FaceFXAsset GetActorFaceFXAsset()
{
    if (BodyMesh != None)
    {
        return BodyMesh.GetBioFaceFXAsset();
    }
    else
    {
        return None;
    }
}
public native function SkeletalMeshComponent GetHeadSkelMeshComponent();

public native function SkeletalMeshComponent GetPrimarySkelMeshComponent();

public simulated function OutsideWorldBounds()
{
    if (Role == ENetRole.ROLE_Authority)
    {
        BioApplyStasis("OutsideWorldBounds");
    }
}
public event simulated function PlayFootStepSound(int FootDown)
{
    local SFXModule_Audio AudioModule;
    local TraceHitInfo HitInfo;
    
    AudioModule = GetModule(Class'SFXModule_Audio');
    if (AudioModule != None)
    {
        AudioModule.PlayFootStepSound(FootDown, HitInfo);
    }
}
public simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    if (!m_bActive)
    {
        SetActive(FALSE);
    }
}
public event simulated function SetAnimPosition(Name SlotName, int ChannelIndex, Name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping)
{
    local AnimNodeSequence SeqNode;
    
    SeqNode = AnimNodeSequence(BodyMesh.FindAnimNode('MatineeAnim'));
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
public final function SetHeadGearVisibility(bool bShow)
{
    if (bShow)
    {
        if (HeadGearMesh != None && HeadGearMesh.SkeletalMesh != None)
        {
            if (HeadGearMesh.bAttached == FALSE)
            {
                AttachComponent(HeadGearMesh);
            }
            HeadMesh.SetHidden(bHelmetHidesHead);
            HairMesh.SetHidden(bHelmetHidesHead || bHelmetHidesHair);
        }
    }
    else
    {
        if (HeadGearMesh.bAttached == TRUE)
        {
            DetachComponent(HeadGearMesh);
        }
        HeadMesh.SetHidden(FALSE);
        HairMesh.SetHidden(FALSE);
    }
}
public event simulated function SFXSetAudioComponentRTPCs(ActorComponent pWwiseAudioComponent)
{
    local SFXModule_Audio AudioMod;
    
    AudioMod = GetModule(Class'SFXModule_Audio');
    AudioMod.SFXSetAudioComponentRTPCs(pWwiseAudioComponent);
}
public event simulated function StopActorFaceFXAnim()
{
    if (BodyMesh != None)
    {
        BodyMesh.StopFaceFXAnim();
    }
}
public simulated function OnTeleport(SeqAct_Teleport Action)
{
    local Actor destActor;
    local Vector vLocation;
    local Rotator rRotation;
    
    if (Action.SFXGetTeleportLocAndRot(vLocation, rRotation, destActor))
    {
        if (Action.m_bSFXCreatedBeforeStuntActorLocationChange && BodyMesh != None)
        {
            vLocation.Z -= BodyMesh.Translation.Z;
        }
        if (SetLocation(vLocation, ))
        {
            PlayTeleportEffect(FALSE, TRUE);
            if (Action.bUpdateRotation)
            {
                SetRotation(rRotation);
            }
            if (Action.m_bSnapToFloor)
            {
                MoveActorToFloor();
            }
            ForceNetRelevant();
            bUpdateSimulatedPosition = TRUE;
            bNetDirty = TRUE;
        }
    }
}
public final function OnSetAimTarget(SFXSeqAct_SetAimTarget inAction)
{
    AimTarget = inAction.AimTarget;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicLightEnvironmentComponent Name=BioLightEnv0
    End Object
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 88.0
        CollisionRadius = 30.0
        ReplacementPrimitive = None
        CollideActors = TRUE
        BlockActors = TRUE
        BlockRigidBody = TRUE
    End Object
    Begin Object Class=SFXModule_Audio Name=AudioModule
    End Object
    Begin Object Class=SFXModule_Conversation Name=ConvoMod01
    End Object
    Begin Object Class=SFXModule_Gestures Name=GestMod01
        Begin Template Class=BioGestureAnimSetMgr Name=oAnimSetMgr
        End Template
        m_pAnimSetMgr = oAnimSetMgr
    End Object
    Begin Object Class=SFXModule_LookAt Name=LookAtMod01
    End Object
    Begin Object Class=SFXModule_Wrinkles Name=WrinkleModule
    End Object
    Begin Object Class=SkeletalMeshComponent Name=BodySMC
        bUpdateSkelWhenNotRendered = FALSE
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnv0
        LocalTranslucencySortPriority = -1
        Translation = {X = 0.0, Y = 0.0, Z = -88.0}
    End Object
    Begin Object Class=SkeletalMeshComponent Name=GearSMC
        ParentAnimComponent = BodySMC
        bUpdateSkelWhenNotRendered = FALSE
        MinAutoLODLevel = 1
        ShadowParent = BodySMC
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnv0
        LocalTranslucencySortPriority = -1
    End Object
    Begin Object Class=SkeletalMeshComponent Name=HairSMC
        ParentAnimComponent = BodySMC
        bUpdateSkelWhenNotRendered = FALSE
        MinAutoLODLevel = 1
        ShadowParent = BodySMC
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnv0
    End Object
    Begin Object Class=SkeletalMeshComponent Name=HeadSMC
        ParentAnimComponent = BodySMC
        bUpdateSkelWhenNotRendered = FALSE
        bOverrideParentSkeleton = TRUE
        nmOverrideStartBoneName = 'headBase'
        MinAutoLODLevel = 1
        ShadowParent = BodySMC
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnv0
        TickGroup = ETickingGroup.TG_PostDirtyComponentsWork
    End Object
    BodyMesh = BodySMC
    HeadMesh = HeadSMC
    HairMesh = HairSMC
    HeadGearMesh = GearSMC
    LightEnvironment = BioLightEnv0
    m_bActive = TRUE
    Components = (BioLightEnv0, BodySMC, HeadSMC, HairSMC, GearSMC, CollisionCylinder)
    Modules = (GestMod01, ConvoMod01, LookAtMod01, WrinkleModule, AudioModule)
    CollisionComponent = CollisionCylinder
    bCollideActors = TRUE
    bBlockActors = TRUE
    bEdShouldSnap = TRUE
}