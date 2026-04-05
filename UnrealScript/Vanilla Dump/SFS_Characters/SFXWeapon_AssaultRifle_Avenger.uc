Class SFXWeapon_AssaultRifle_Avenger extends SFXWeapon_AssaultRifle_Base
    placeable
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_ASL_R.ASLa.WPN_ASLa_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_ASLa'
        AnimSets = (AnimSet'biog_wpn_a.WPN_ASL_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_ASL_R.ASLa.WPN_ASLa_MDL'
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
        Template = ParticleSystem'BioVFX_C_Weapons.Muzzles.Particles.Rifle_Muzzle_02'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=ShellCasingPSC0
        Template = ParticleSystem'BioVFX_C_Reload.Particles.Reload_HeatSinkEject'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        AnimSet = AnimSet'BIOG_HMM_CB_A.HMM_CB_RifleAuto_FastAlternate'
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
        Samples = ({Duration = 0.125, LeftAmplitude = 55, RightAmplitude = 55, LeftFunction = EWaveformFunction.WF_Sin90to180, RightFunction = EWaveformFunction.WF_Sin90to180}
                  )
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    AI_AccCone_Min = {X = 1.20000005, Y = 1.20000005}
    AI_AccCone_Max = {X = 1.79999995, Y = 1.79999995}
    ReloadDuration = {X = 0.800000012, Y = 0.800000012}
    Damage = {X = 38.5999985, Y = 48.2000008}
    MagSize = {X = 30.0, Y = 30.0}
    MaxSpareAmmo = {X = 210.0, Y = 262.0}
    MinAimError = {X = 2.0, Y = 2.0}
    MaxAimError = {X = 6.19999981, Y = 6.19999981}
    MinZoomAimError = {X = 0.200000003, Y = 0.200000003}
    MaxZoomAimError = {X = 1.0, Y = 1.0}
    RateOfFire = {X = 500.0, Y = 500.0}
    EncumbranceWeight = {X = 1.0, Y = 0.5}
    Recoil = {X = 0.100000001, Y = 0.100000001}
    ZoomRecoil = {X = 0.300000012, Y = 0.300000012}
    AccFirePenalty = {X = 10.6999998, Y = 10.6999998}
    AccFireInterpSpeed = {X = 12.0, Y = 12.0}
    ZoomAccFirePenalty = {X = 22.3500004, Y = 22.3500004}
    ZoomAccFireInterpSpeed = {X = 28.0, Y = 28.0}
    MinZoomCrosshairRange = {X = 28.0, Y = 28.0}
    MaxZoomCrosshairRange = {X = 48.0, Y = 48.0}
    StatBarAccuracy = {X = 20.0, Y = 20.0}
    StatBarDamage = {X = 38.5999985, Y = 48.2000008}
    StatBarRateOfFire = {X = 500.0, Y = 500.0}
    GUIImage = "GUI_Codex_Images.Weapons.asl_avenger_512x256"
    NotificationImage = "GUI_Icons.Weapons.asl_avenger_256x128"
    WeaponModBodyColours = ({R = 0.689999998, G = 0.170000002, B = 0.0399999991, A = 0.0}, 
                            {R = 1.0, G = 0.870000005, B = 0.430000007, A = 0.0}, 
                            {R = 0.769999981, G = 0.850000024, B = 0.639999986, A = 0.0}, 
                            {R = 0.349999994, G = 0.449999988, B = 0.230000004, A = 0.0}, 
                            {R = 0.0500000007, G = 0.0599999987, B = 0.0700000003, A = 0.0}
                           )
    FiringShake = {
                   RotAmplitude = {X = 45.0, Y = 22.5, Z = 11.25}, 
                   RotFrequency = {X = 80.0, Y = 50.0, Z = 20.0}, 
                   TimeDuration = 0.200000003
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 55.0, Y = 33.5, Z = 22.25}, 
                           RotFrequency = {X = 90.0, Y = 60.0, Z = 30.0}, 
                           TimeDuration = 0.125
                          }
    TracerInfo = {
                  Scale3D = {X = 2.0, Y = 2.0, Z = 2.0}, 
                  StaticMesh = StaticMesh'BioVFX_C_Weapons.Tracers.Meshes.Tracer_SMG_Mesh', 
                  StandardPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail', 
                  PlayerPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail', 
                  AccelRate = 8000.0, 
                  Speed = 15000.0, 
                  MaxSpeed = 17500.0
                 }
    AI_BurstFireCount = {X = 12.0, Y = 18.0}
    AI_BurstFireDelay = {X = 0.649999976, Y = 1.0}
    ReloadAnimInfo = tempAnimInfo
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    TracerSpawnOffset = 1.0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    EjectShellCasingTimeRatio = 0.421000004
    LowAmmoSoundThreshold = 5.0
    SteamSoundThreshold = 1.0
    NoAmmoFireSoundDelay = 0.5
    MinRefireTime = 0.00999999978
    LazyRateOfFire = 0.00999999978
    RateOfFireAI = 1.0
    RecoilInterpSpeed = 0.0
    RecoilYawScale = 0.25
    RecoilYawFrequency = 0.5
    PrettyName = $589047
    ShortPrettyName = $589047
    ShortDescription = $339266
    GeneralDescription = $338211
    FireSound = WwiseEvent'Wwise_Weapons_NP_Avenger.Play_wep_np_avenger_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Avenger.Play_wep_p_avenger_fire'
    FireNoAmmoSound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_dryfire_machineguns'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_assault_light'
    WeaponExpandSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_assault_expand'
    WeaponCollapseSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_assault_collapse'
    SteamReloadNotifySound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_overheat'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    WeaponAcquiredID = 21224
    WeaponAcquiredID_NGP = 21560
    bLoopingFlashEmitter = TRUE
    InstantHitMomentum = (0.0, 1.0, 7.5, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_Default', Class'SFXDamageType_AssaultRifle', Class'SFXDamageType_Default')
    FireOffset = {X = 61.0, Y = -0.5, Z = 7.25}
    Mesh = WeaponMesh
    AIRating = 1.0
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}