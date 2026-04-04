Class SFXWeapon_AssaultRifle_SentryTurret extends SFXWeapon_AssaultRifle_Base
    placeable
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ParticleSystemComponent Name=ReloadVent0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ParticleSystemComponent Name=AmmoPowerHologram
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ParticleSystemComponent Name=AmmoPowerIconHologram
        ReplacementPrimitive = None
    End Template
    Begin Object Class=ParticleSystemComponent Name=MuzFlashPSC0
        Template = ParticleSystem'BioVFX_T_TechBall.Particles.ST_Muzzle'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    AI_AccCone_Min = {X = 1.20000005, Y = 1.20000005}
    AI_AccCone_Max = {X = 1.20000005, Y = 1.20000005}
    Damage = {X = 25.0, Y = 25.0}
    MagSize = {X = 1000.0, Y = 1000.0}
    MaxSpareAmmo = {X = 400.0, Y = 400.0}
    MinAimError = {X = 1.60000002, Y = 1.60000002}
    MaxAimError = {X = 4.0, Y = 4.0}
    MinZoomAimError = {X = 0.349999994, Y = 0.349999994}
    MaxZoomAimError = {X = 1.5, Y = 1.5}
    RateOfFire = {X = 540.0, Y = 540.0}
    Recoil = {X = 3.0, Y = 3.0}
    ZoomRecoil = {X = 1.5, Y = 1.5}
    AccFirePenalty = {X = 320.0, Y = 320.0}
    AccFireInterpSpeed = {X = 420.0, Y = 420.0}
    ZoomAccFirePenalty = {X = 40.0, Y = 40.0}
    ZoomAccFireInterpSpeed = {X = 38.0, Y = 38.0}
    MinZoomCrosshairRange = {X = 25.0, Y = 25.0}
    MaxZoomCrosshairRange = {X = 40.0, Y = 40.0}
    TracerInfo = {
                  Scale3D = {X = 1.25, Y = 1.25, Z = 1.25}, 
                  StaticMesh = StaticMesh'BioVFX_C_Weapons.Tracers.Meshes.Tracer_SMG_Mesh', 
                  StandardPSTemplate = ParticleSystem'BioVFX_T_TechBall.Particles.ST_Tracer_Smoke_Trail', 
                  AccelRate = 8000.0, 
                  Speed = 18000.0, 
                  MaxSpeed = 20000.0
                 }
    AI_BurstFireCount = {X = 3.0, Y = 3.0}
    AI_BurstFireDelay = {X = 2.0, Y = 2.0}
    AI_AimDelay = {X = 1.0, Y = 1.0}
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PS_DefaultImpactEffect = ParticleSystem'BioVFX_C_Wpn_Mtk.Particles.CR2_Generic_Imp'
    PSC_ReloadVent = ReloadVent0
    TracerSpawnOffset = 2.0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    RateOfFireAI = 1.0
    RecoilInterpSpeed = 15.0
    RecoilFadeSpeed = 3.0
    RecoilZoomFadeSpeed = 0.949999988
    RecoilYawScale = 0.200000003
    RecoilYawFrequency = 60.0
    PrettyName = $558975
    ShortPrettyName = $558975
    FireSound = WwiseEvent'Wwise_Weapons_NP_Incisor.Play_wep_np_sentryturret_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_NP_Incisor.Play_wep_np_sentryturret_fire'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    bLoopingFlashEmitter = TRUE
    bCanDropAmmo = FALSE
    bInfiniteAmmo = TRUE
    InstantHitMomentum = (0.0, 1.0, 10.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_Default', Class'SFXDamageType_AssaultRifle', Class'SFXDamageType_Default')
    Mesh = WeaponMesh
    AIRating = 1.0
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}