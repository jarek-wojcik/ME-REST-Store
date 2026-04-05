Class SFXPawn_ProtectorDroneBase extends SFXPawn
    placeable
    config(Game);

struct ReplicatedDroneCreator 
{
    var BioPawn Creator;
    var int CreatorPowerCustomActionIndex;
};

var delegate<OnDroneKilled> __OnDroneKilled__Delegate;
var repnotify ReplicatedDroneCreator ReplicatedDroneCreatorInfo;
var Actor Caster;

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

public simulated function DroneCreatorInfoUpdated()
{
    local BioCustomAction CreatorCustomAction;
    local SFXPowerCustomAction_ProtectorDroneBase ProtectorDroneCustomAction;
    
    if (ReplicatedDroneCreatorInfo.Creator != None)
    {
        CreatorCustomAction = ReplicatedDroneCreatorInfo.Creator.PowerCustomActions[ReplicatedDroneCreatorInfo.CreatorPowerCustomActionIndex];
        if (CreatorCustomAction != None)
        {
            ProtectorDroneCustomAction = SFXPowerCustomAction_ProtectorDroneBase(CreatorCustomAction);
            if (ProtectorDroneCustomAction != None)
            {
                SetupCasterAndReplication(ReplicatedDroneCreatorInfo.Creator);
                __OnDroneKilled__Delegate = ProtectorDroneCustomAction.OnDroneKilled;
                ProtectorDroneCustomAction.SetupSpawnedDrone(Self);
            }
        }
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
public delegate function OnDroneKilled(SFXPawn_ProtectorDroneBase oDrone);


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
        BlockZeroExtent = FALSE
        BlockRigidBody = FALSE
        Translation = {X = 0.0, Y = 0.0, Z = 80.0}
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
    bIgnoreTarget = TRUE
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
}