Class SFXWeapon_Pistol_Eagle extends SFXWeapon_Pistol_Base
    placeable
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_PST_R.PSTl.WPN_PSTl_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_PSTl'
        AnimSets = (AnimSet'biog_wpn_a.WPN_PSTl_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_PST_R.PSTl.WPN_PSTl_MDL'
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
        Template = ParticleSystem'BioVFX_C_Weapons.Muzzles.Particles.Pistol_Auto'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=ShellCasingPSC0
        Template = ParticleSystem'BioVFX_C_Reload.Particles.Reload_HeatSinkEject'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
        Samples = ({Duration = 0.25, LeftAmplitude = 85, RightAmplitude = 85, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    AI_AccCone_Min = {X = 1.10000002, Y = 1.10000002}
    AI_AccCone_Max = {X = 2.0999999, Y = 2.0999999}
    ReloadDuration = {X = 1.5, Y = 1.5}
    Damage = {X = 42.4000015, Y = 53.0999985}
    MagSize = {X = 18.0, Y = 18.0}
    MaxSpareAmmo = {X = 180.0, Y = 225.0}
    MinAimError = {X = 2.0, Y = 2.0}
    MaxAimError = {X = 6.0, Y = 6.0}
    MinZoomAimError = {X = 0.300000012, Y = 0.300000012}
    MaxZoomAimError = {X = 1.5, Y = 1.5}
    RateOfFire = {X = 400.0, Y = 400.0}
    EncumbranceWeight = {X = 0.600000024, Y = 0.25}
    Recoil = {X = 0.400000006, Y = 0.400000006}
    ZoomRecoil = {X = 0.600000024, Y = 0.600000024}
    AccFirePenalty = {X = 6.0, Y = 6.0}
    AccFireInterpSpeed = {X = 10.0, Y = 10.0}
    ZoomAccFirePenalty = {X = 8.0, Y = 8.0}
    ZoomAccFireInterpSpeed = {X = 12.0, Y = 12.0}
    MinZoomCrosshairRange = {X = 25.0, Y = 25.0}
    MaxZoomCrosshairRange = {X = 45.0, Y = 45.0}
    StatBarAccuracy = {X = 45.0, Y = 45.0}
    StatBarDamage = {X = 42.4000015, Y = 53.0999985}
    StatBarRateOfFire = {X = 400.0, Y = 400.0}
    GUIImage = "gui_codex_images.Weapons.pst_eagle_512x256"
    NotificationImage = "GUI_Icons.Weapons.pst_eagle_256x128"
    WeaponModBodyColours = ({R = 0.370000005, G = 0.349999994, B = 0.289999992, A = 0.0}, 
                            {R = 0.769999981, G = 0.49000001, B = 0.129999995, A = 0.0}, 
                            {R = 0.109999999, G = 0.119999997, B = 0.0700000003, A = 0.0}, 
                            {R = 0.0799999982, G = 0.109999999, B = 0.159999996, A = 0.0}, 
                            {R = 0.0299999993, G = 0.0299999993, B = 0.0299999993, A = 0.0}
                           )
    FiringShake = {
                   RotAmplitude = {X = 50.0, Y = 50.0, Z = 95.0}, 
                   RotFrequency = {X = 25.0, Y = 25.0, Z = 25.0}, 
                   LocAmplitude = {X = 4.0, Y = 0.0, Z = 0.0}, 
                   TimeDuration = 0.0149999997
                  }
    TracerInfo = {
                  Scale3D = {X = 1.20000005, Y = 1.20000005, Z = 1.20000005}, 
                  PlayerPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail_Flak', 
                  AccelRate = 8000.0, 
                  Speed = 18000.0, 
                  MaxSpeed = 20000.0
                 }
    AI_BurstFireCount = {X = 4.0, Y = 6.0}
    AI_BurstFireDelay = {X = 0.649999976, Y = 2.29999995}
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    EjectShellCasingTimeRatio = 0.558000028
    LowAmmoSoundThreshold = 4.0
    SteamSoundThreshold = 1.0
    NoAmmoFireSoundDelay = 0.800000012
    MinRefireTime = 0.0
    LazyRateOfFire = 0.00999999978
    RateOfFireAI = 1.0
    RecoilYawScale = 1.0
    RecoilYawFrequency = 3.0
    IconRef = 53
    PrettyName = $650898
    ShortPrettyName = $650898
    ShortDescription = $650900
    GeneralDescription = $650899
    FireSound = WwiseEvent'Wwise_Weapons_NP_Carnifex.Play_wep_np_eagle_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Carnifex.Play_wep_p_eagle_fire'
    FireNoAmmoSound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_dryfire_pistols'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_pistol_normal'
    SteamReloadNotifySound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_overheat'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    bLoopingFlashEmitter = TRUE
    InstantHitMomentum = (0.0, 1.0, 15.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_Default', Class'SFXDamageType_HeavyPistol', Class'SFXDamageType_Default')
    FireOffset = {X = 19.0, Y = 0.5, Z = 4.0}
    Mesh = WeaponMesh
    AIRating = 20.0
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}