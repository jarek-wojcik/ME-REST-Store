Class SFXPawn_CombatDrone extends SFXPawn_CombatDroneBase
    placeable
    config(Game);

var Guid DroneVFXGuid;
var Vector ClientEffectParameters;
var RvrClientEffectInterface CE_DroneTemplate;
var RvrClientEffectInterface CE_PlayerDroneTemplate;
var transient MaterialInstanceConstant MIC_DroneHealth;
var WwiseEvent SpawnSound;
var WwiseEvent DeathSound;
var WwiseEvent LoopingSound;
var WwiseEvent StopLoopingSound;
var bool bDroneVFXStopped;

public simulated function PostBeginPlay()
{
    Super(SFXPawn).PostBeginPlay();
    PlaySound(SpawnSound, TRUE);
    PlaySound(LoopingSound, TRUE);
}
public simulated function TakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local SFXModule_Damage DamageMod;
    
    Super(BioPawn).TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    DamageMod = GetModule(Class'SFXModule_Damage');
    if (DamageMod != None)
    {
        MIC_DroneHealth.SetScalarParameterValue('f_Health', DamageMod.GetHealthRatio());
    }
}
public simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc)
{
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(None, DroneVFXGuid, FALSE);
    StopSound(StopLoopingSound);
    PlaySound(DeathSound, TRUE);
    Super.PlayDying(DamageType, HitLoc);
}
public simulated function SetupCasterAndReplication(Actor NewCaster)
{
    Super.SetupCasterAndReplication(NewCaster);
    StartDroneVFX();
}
public final simulated function StartDroneVFX()
{
    local RvrClientEffectTarget Target;
    local RvrClientEffectManager RvrEffectManager;
    
    RvrEffectManager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
    if (RvrEffectManager != None)
    {
        Target.Instigator = Self;
        Target.SpawnValue = ClientEffectParameters;
        Target.HitNormal = Vector(Rotation);
        if (SFXPawn_Player(Caster) != None && SFXPawn_Player(Caster).IsLocallyControlled())
        {
            DroneVFXGuid = RvrEffectManager.StartOnTarget(CE_PlayerDroneTemplate, Target);
        }
        else
        {
            DroneVFXGuid = RvrEffectManager.StartOnTarget(CE_DroneTemplate, Target);
        }
        MIC_DroneHealth.SetScalarParameterValue('f_Health', 1.0);
    }
    else
    {
        SetTimer(0.100000001, FALSE, 'StartDroneVFX', );
    }
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
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
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
    End Template
    Begin Template Class=SFXModule_Damage Name=DmgMod0
        HealthType = EHealthType.HealthType_Shields
        MaxHealth = {X = 300.0, Y = 300.0}
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
    CE_DroneTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.TechBall_01_VCFX'
    CE_PlayerDroneTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.TechBall_01_Player_VCFX'
    MIC_DroneHealth = MaterialInstanceConstant'BioVFX_T_TechBall.Materials.Hud_TechBall_Flare_INST'
    SpawnSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_S_combatdrone_spawn'
    DeathSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_S_combatdrone_death'
    LoopingSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_S_combatdrone_duration'
    StopLoopingSound = WwiseEvent'Wwise_Power_Tech_Drone.Stop_power_tech_S_combatdrone_duration'
    FootstepForceFeedback = FootstepShakeFF0
    bCanBeMeleed = FALSE
    PowerCustomActionClasses = (None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                Class'SFXPowerCustomAction_CombatDroneZap', 
                                Class'SFXPowerCustomAction_CombatDroneShock', 
                                Class'SFXPowerCustomAction_CombatDroneRocket'
                               )
    HeadMesh = HeadMesh0
    m_oHairMesh = HairMesh0
    m_oHeadGearMesh = GearMesh0
    LightEnvironment = BioLightEnvComponent0
    PowerManager = PowerMgr
    bDisablePlayerPortArmsEvenIfFriendly = TRUE
    RaceType = ERaceType.RaceType_Machine
    ControllerClass = Class'SFXAI_CombatDrone'
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
    CollisionComponent = CollisionCylinder
    bBlockActors = FALSE
}