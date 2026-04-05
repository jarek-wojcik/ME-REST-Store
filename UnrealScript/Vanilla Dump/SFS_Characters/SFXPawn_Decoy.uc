Class SFXPawn_Decoy extends SFXPawn
    placeable
    config(Game);

struct ReplicatedDecoyCreator 
{
    var clearcrosslevel BioPawn Creator;
    var int CreatorPowerCustomActionIndex;
};

var delegate<OnDecoyKilled> __OnDecoyKilled__Delegate;
var Guid DecoyVFXGuid;
var repnotify repretry ReplicatedDecoyCreator ReplicatedDecoyCreatorInfo;
var RvrClientEffectInterface CE_DecoyTemplate;
var float Duration;
var float ShockRadius;
var clearcrosslevel SFXPowerCustomAction_Decoy DecoyPower;
var float ShockCooldown;
var float LastTimeShocked;
var WwiseEvent SpawnSound;
var WwiseEvent DeathSound;
var WwiseEvent LoopingSound;
var WwiseEvent StopLoopingSound;
var clearcrosslevel Actor Caster;
var bool bDecoyVFXStopped;
var bool bExplosiveCooldown;
var bool bIsClientSideInitialized;

public event simulated function Destroyed()
{
    Super(BioPawn).Destroyed();
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_DecoyTemplate, DecoyVFXGuid, FALSE);
    ClearTimer('StartDecoyVFX');
}
public simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    PlaySound(SpawnSound, TRUE);
    PlaySound(LoopingSound, TRUE);
}
public event simulated function ReplicatedEvent(Name VarName)
{
    switch (VarName)
    {
        case 'ReplicatedDecoyCreatorInfo':
            DecoyCreatorInfoUpdated();
            break;
        default:
            Super.ReplicatedEvent(VarName);
            break;
    }
}
public simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc)
{
    Super.PlayDying(DamageType, HitLoc);
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_DecoyTemplate, DecoyVFXGuid, FALSE);
    StopSound(StopLoopingSound);
    PlaySound(DeathSound, TRUE);
    __OnDecoyKilled__Delegate(Self);
    ReplicatedDecoyCreatorInfo.Creator = None;
    ClearTimer('ShockCollideTest');
    ClearTimer('StartDecoyVFX');
}
public simulated function Actor GetPetOwner()
{
    return Caster;
}
public simulated function PlayDeathVocalization(BioPawn Killer);

public simulated function DecoyCreatorInfoUpdated()
{
    local BioCustomAction CreatorCustomAction;
    local SFXPowerCustomAction_Decoy DecoyCustomAction;
    
    if (ReplicatedDecoyCreatorInfo.Creator != None && !bIsClientSideInitialized)
    {
        CreatorCustomAction = ReplicatedDecoyCreatorInfo.Creator.PowerCustomActions[ReplicatedDecoyCreatorInfo.CreatorPowerCustomActionIndex];
        if (CreatorCustomAction != None)
        {
            DecoyCustomAction = SFXPowerCustomAction_Decoy(CreatorCustomAction);
            if (DecoyCustomAction != None)
            {
                SetupCasterAndReplication(ReplicatedDecoyCreatorInfo.Creator);
                __OnDecoyKilled__Delegate = DecoyCustomAction.OnDecoyKilled;
                DecoyCustomAction.SetupSpawnedDecoy(Self);
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
            ReplicatedDecoyCreatorInfo.Creator = BPOwner;
            ReplicatedDecoyCreatorInfo.CreatorPowerCustomActionIndex = BPOwner.CurrentPowerCustomAction;
        }
    }
}
public delegate function OnDecoyKilled(SFXPawn_Decoy oDecoy);

public function PlayDyingHelper()
{
    if (!IsDead())
    {
        PlayDying(Class'SFXDamageType_Default', location);
    }
}
public function SetDeathTimer()
{
    SetTimer(Duration, FALSE, 'PlayDyingHelper', Self);
}
public function ShockCollideTest()
{
    local BioPawn oPawn;
    
    if (WorldInfo.GameTimeSeconds - LastTimeShocked > ShockCooldown)
    {
        foreach CollidingActors(Class'BioPawn', oPawn, ShockRadius, location, , , )
        {
            if (int(oPawn.GetTeamNum()) == 1 && DecoyPower != None)
            {
                DecoyPower.CastShock();
                LastTimeShocked = WorldInfo.GameTimeSeconds;
                return;
            }
        }
    }
}
public final simulated function StartDecoyVFX()
{
    local RvrClientEffectTarget Target;
    local RvrClientEffectManager RvrEffectManager;
    
    RvrEffectManager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
    if (RvrEffectManager != None)
    {
        Target.Instigator = Caster;
        Target.HitLocation = location;
        Target.SpawnValue.X = Duration;
        if (bExplosiveCooldown)
        {
            Target.SpawnValue.Z = 1.0;
        }
        DecoyVFXGuid = RvrEffectManager.StartOnTarget(CE_DecoyTemplate, Target);
        if (ShockRadius > 0.0 && DecoyPower != None && Caster.Role == ENetRole.ROLE_Authority)
        {
            SetTimer(1.0, TRUE, 'ShockCollideTest', );
        }
    }
    else
    {
        SetTimer(0.100000001, FALSE, 'StartDecoyVFX', );
    }
}

replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        ReplicatedDecoyCreatorInfo;
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
        CollideActors = FALSE
        BlockRigidBody = FALSE
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
        HealthType = EHealthType.HealthType_Shields
        MaxHealth = {X = 600.0, Y = 600.0}
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
    CE_DecoyTemplate = RvrClientEffect'BioVFX_Hch_Edi.VCFX.Decoy_Hologram_VCFX'
    DeathSound = WwiseEvent'Wwise_Power_Tech_Decoy.Play_power_tech_S_decoy_despawn'
    LoopingSound = WwiseEvent'Wwise_Power_Tech_Decoy.Play_power_tech_S_decoy_duration'
    StopLoopingSound = WwiseEvent'Wwise_Power_Tech_Decoy.Stop_power_tech_S_decoy_duration'
    FootstepForceFeedback = FootstepShakeFF0
    bCanBeMeleed = FALSE
    bIsPet = TRUE
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
    RaceType = ERaceType.RaceType_Machine
    ControllerClass = Class'SFXAI_None'
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
    NetPriority = 1.70000005
    CollisionComponent = CollisionCylinder
    bReplicateInstigator = TRUE
    bBlockActors = FALSE
}