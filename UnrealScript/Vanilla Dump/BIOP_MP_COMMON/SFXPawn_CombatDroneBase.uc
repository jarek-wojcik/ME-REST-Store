Class SFXPawn_CombatDroneBase extends SFXPawn
    placeable
    config(Game);

struct ReplicatedDroneCreator 
{
    var clearcrosslevel BioPawn Creator;
    var int CreatorPowerCustomActionIndex;
};

var delegate<OnDroneKilled> __OnDroneKilled__Delegate;
var repnotify repretry ReplicatedDroneCreator ReplicatedDroneCreatorInfo;
var Actor Caster;
var bool bIsClientSideInitialized;

public event simulated function ReplicatedEvent(Name VarName)
{
    switch (VarName)
    {
        case 'ReplicatedDroneCreatorInfo':
            DroneCreatorInfoUpdated();
            break;
        default:
            Super.ReplicatedEvent(VarName);
            break;
    }
}
public simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc)
{
    __OnDroneKilled__Delegate(Self);
    Super.PlayDying(DamageType, HitLoc);
}
public simulated function Actor GetPetOwner()
{
    return Caster;
}
public simulated function PlayDeathVocalization(BioPawn Killer);

public delegate function OnDroneKilled(SFXPawn_CombatDroneBase oDrone);

public simulated function DroneCreatorInfoUpdated()
{
    local BioCustomAction CreatorCustomAction;
    local SFXPowerCustomAction_CombatDroneBase CombatDroneCustomAction;
    
    if (ReplicatedDroneCreatorInfo.Creator != None && !bIsClientSideInitialized)
    {
        CreatorCustomAction = ReplicatedDroneCreatorInfo.Creator.PowerCustomActions[ReplicatedDroneCreatorInfo.CreatorPowerCustomActionIndex];
        if (CreatorCustomAction != None)
        {
            CombatDroneCustomAction = SFXPowerCustomAction_CombatDroneBase(CreatorCustomAction);
            if (CombatDroneCustomAction != None)
            {
                SetupCasterAndReplication(ReplicatedDroneCreatorInfo.Creator);
                __OnDroneKilled__Delegate = CombatDroneCustomAction.OnDroneKilled;
                CombatDroneCustomAction.SetupSpawnedDrone(Self);
            }
        }
        bIsClientSideInitialized = TRUE;
    }
}
public simulated function SetupCasterAndReplication(Actor NewCaster)
{
    local BioPawn BPOwner;
    
    Caster = NewCaster;
    if (Role == ENetRole.ROLE_Authority)
    {
        BPOwner = BioPawn(Caster);
        if (BPOwner != None)
        {
            ReplicatedDroneCreatorInfo.Creator = BPOwner;
            ReplicatedDroneCreatorInfo.CreatorPowerCustomActionIndex = BPOwner.CurrentPowerCustomAction;
        }
    }
}

replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        ReplicatedDroneCreatorInfo;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
        BlockNonZeroExtent = FALSE
        BlockRigidBody = FALSE
    End Template
    Begin Template Class=BioDynamicLightEnvironmentComponent Name=BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=BioPawnSkeletalMeshComponent
        SkeletalMesh = SkeletalMesh'BIOG_CBT_DRN_NKD_R.NKDa.CBT_DRN_NKDa_MDL'
        PhysicsAsset = PhysicsAsset'BIOG_CBT_DRN_NKD_R.NKDa.CBT_DRN_NKDa_MDL_Physics'
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
        CastShadow = FALSE
        bCastDynamicShadow = FALSE
        Translation = {X = 0.0, Y = 0.0, Z = 40.0}
    End Template
    Begin Template Class=SkeletalMeshComponent Name=HeadMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=HairMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=GearMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=FootstepShakeFF0
    End Template
    Begin Template Class=SFXPowerManager Name=PowerMgr
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_Radar Name=RadarModule
    End Template
    Begin Template Class=SFXModule_AimAssistTarget Name=AimAssistMod
        m_srGameName = $576878
    End Template
    Begin Template Class=SFXModule_Damage Name=DmgMod0
        MaxHealth = {X = 0.0, Y = 0.0}
    End Template
    Begin Template Class=SFXModule_Gestures Name=GestMod01
        Begin Template Class=BioGestureAnimSetMgr Name=oAnimSetMgr
        End Template
        m_pAnimSetMgr = oAnimSetMgr
    End Template
    Begin Template Class=SFXModule_Conversation Name=ConvoMod01
    End Template
    Begin Template Class=SFXModule_LookAt Name=LookAtMod01
    End Template
    Begin Template Class=SFXModule_Audio Name=AudioModule
    End Template
    Begin Template Class=SFXModule_Timeline Name=TimelineMod0
    End Template
    FootstepForceFeedback = FootstepShakeFF0
    bIsPet = TRUE
    bCanDropAmmo = FALSE
    AimNodes = ('None', 
                'Root', 
                'Root', 
                'Root', 
                'Root', 
                'Root', 
                'Root', 
                'Root'
               )
    HeadMesh = HeadMesh0
    m_oHairMesh = HairMesh0
    m_oHeadGearMesh = GearMesh0
    LightEnvironment = BioLightEnvComponent0
    PowerThreshold_Stagger = 25.0
    PowerThreshold_Knockback = 50.0
    PowerManager = PowerMgr
    bSpawnPHATInstance = FALSE
    bKillOnRagdoll = TRUE
    bCanRagdoll = FALSE
    BaseEyeHeight = 50.0
    EyeHeight = 50.0
    Mesh = BioPawnSkeletalMeshComponent
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder, None, BioLightEnvComponent0, BioPawnSkeletalMeshComponent, HeadMesh0, HairMesh0, GearMesh0)
    Modules = (GEMod0, 
               RadarModule, 
               AimAssistMod, 
               DmgMod0, 
               GestMod01, 
               ConvoMod01, 
               LookAtMod01, 
               AudioModule, 
               TimelineMod0
              )
    NetPriority = 1.79999995
    CollisionComponent = CollisionCylinder
    bReplicateInstigator = TRUE
}