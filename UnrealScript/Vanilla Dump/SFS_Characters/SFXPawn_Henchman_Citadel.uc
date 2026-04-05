Class SFXPawn_Henchman_Citadel extends SFXPawn_Henchman
    placeable
    abstract
    config(Game);

var float MinPowerRank;

public simulated function PostBeginPlay()
{
    local Class<SFXPowerCustomActionBase> PowerClass;
    local SFXPowerCustomAction Power;
    local int TotalCost;
    local int idx;
    
    Super.PostBeginPlay();
    if (PowerManager == None)
    {
        return;
    }
    foreach SquadScreenPowerOrder(PowerClass, )
    {
        Power = SFXPowerCustomAction(PowerManager.GetPowerByClass(PowerClass));
        if (Power == None || Power.Rank >= MinPowerRank)
        {
            continue;
        }
        Power.Rank = MinPowerRank;
        Power.OnPowerRankIncreased();
        TotalCost = 0;
        for (idx = 0; idx < int(MinPowerRank); idx++)
        {
            TotalCost += Power.RankCosts[idx];
        }
        TalentPoints -= TotalCost;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=SFXModule_Gestures Name=GestMod01
        Begin Template Class=BioGestureAnimSetMgr Name=oAnimSetMgr
        End Template
        m_pAnimSetMgr = oAnimSetMgr
    End Template
    Begin Template Class=BioDynamicLightEnvironmentComponent Name=BioLightEnvComponent0
    End Template
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=FootstepShakeFF0
    End Template
    Begin Template Class=SFXModule_AimAssistTarget Name=AimAssistMod
    End Template
    Begin Template Class=SFXModule_Audio Name=AudioModule
    End Template
    Begin Template Class=SFXModule_Conversation Name=ConvoMod01
    End Template
    Begin Template Class=SFXModule_DamageParty Name=DmgMod1
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_Locomotion Name=Locomotion0
    End Template
    Begin Template Class=SFXModule_LookAt Name=LookAtMod01
    End Template
    Begin Template Class=SFXModule_Radar Name=RadarMod1
    End Template
    Begin Template Class=SFXModule_Radar Name=RadarModule
    End Template
    Begin Template Class=SFXModule_Timeline Name=TimelineMod0
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
    Begin Template Class=SkeletalMeshComponent Name=BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SFXLoadoutData Name=HenchLoadout0
    End Template
    Begin Template Class=SFXPowerManager Name=PowerMgr
    End Template
    MinPowerRank = 3.0
    FootstepForceFeedback = FootstepShakeFF0
    HeadMesh = HeadMesh0
    m_oHairMesh = HairMesh0
    m_oHeadGearMesh = GearMesh0
    LightEnvironment = BioLightEnvComponent0
    Loadout = HenchLoadout0
    PowerManager = PowerMgr
    Mesh = BioPawnSkeletalMeshComponent
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder, None, BioLightEnvComponent0, BioPawnSkeletalMeshComponent, HeadMesh0, HairMesh0, GearMesh0)
    Modules = (GEMod0, 
               RadarModule, 
               AimAssistMod, 
               GestMod01, 
               ConvoMod01, 
               LookAtMod01, 
               AudioModule, 
               TimelineMod0, 
               Locomotion0, 
               RadarMod1, 
               DmgMod1
              )
    CollisionComponent = CollisionCylinder
}