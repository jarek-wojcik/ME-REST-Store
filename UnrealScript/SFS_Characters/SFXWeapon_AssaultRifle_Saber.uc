Class SFXWeapon_AssaultRifle_Saber extends SFXWeapon_AssaultRifle_Base
    placeable
    config(Weapon);

public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        return ImpactSounds.SniperRifle_Player;
    }
    return ImpactSounds.SniperRifle;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_ASL_R.ASLk.WPN_ASLk_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_ASLk'
        AnimSets = (AnimSet'biog_wpn_a.WPN_ASLk_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_ASL_R.ASLk.WPN_ASLk_MDL'
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
    Begin Object Class=ParticleSystemComponent Name=ShellCasingPSC0
        Template = ParticleSystem'BioVFX_C_Reload.Particles.Reload_HeatSinkEject'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=MuzFlashPSC0
        Template = ParticleSystem'BioVFX_C_Wpn_Saber.Particles.Muzzle_Saber'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        AnimSet = AnimSet'BIOG_HMM_CB_A.HMM_CB_RifleAuto_SlowAlternate'
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
        Samples = ({Duration = 0.300000012, LeftAmplitude = 90, RightAmplitude = 90, LeftFunction = EWaveformFunction.WF_Sin90to180, RightFunction = EWaveformFunction.WF_Sin90to180}, 
                   {Duration = 0.100000001, LeftAmplitude = 100, RightAmplitude = 100, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
        Samples = ({Duration = 0.150000006, LeftAmplitude = 50, RightAmplitude = 50, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}, 
                   {Duration = 0.579999983, LeftAmplitude = 0, RightAmplitude = 0, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}, 
                   {Duration = 0.150000006, LeftAmplitude = 50, RightAmplitude = 50, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    AI_AccCone_Min = {X = 1.04999995, Y = 1.04999995}
    AI_AccCone_Max = {X = 2.04999995, Y = 2.04999995}
    ReloadDuration = {X = 2.9000001, Y = 2.9000001}
    Damage = {X = 350.100006, Y = 437.600006}
    MagSize = {X = 8.0, Y = 8.0}
    MaxSpareAmmo = {X = 40.0, Y = 50.0}
    MinAimError = {X = 2.5, Y = 2.5}
    MaxAimError = {X = 4.5, Y = 4.5}
    MinZoomAimError = {X = 0.100000001, Y = 0.100000001}
    MaxZoomAimError = {X = 0.449999988, Y = 0.449999988}
    RateOfFire = {X = 80.0, Y = 80.0}
    EncumbranceWeight = {X = 2.0, Y = 1.39999998}
    Recoil = {X = 0.811999977, Y = 0.811999977}
    ZoomRecoil = {X = 1.75, Y = 1.75}
    AccFirePenalty = {X = 19.0, Y = 19.0}
    AccFireInterpSpeed = {X = 18.0, Y = 18.0}
    ZoomAccFirePenalty = {X = 37.0, Y = 37.0}
    ZoomAccFireInterpSpeed = {X = 35.0, Y = 35.0}
    MinZoomCrosshairRange = {X = 22.0, Y = 22.0}
    MaxZoomCrosshairRange = {X = 44.0, Y = 44.0}
    StatBarAccuracy = {X = 65.0, Y = 65.0}
    StatBarDamage = {X = 350.100006, Y = 437.600006}
    StatBarRateOfFire = {X = 80.0, Y = 80.0}
    GUIImage = "gui_codex_images.Weapons.asl_saber_512x256"
    NotificationImage = "GUI_Icons.Weapons.asl_saber_256x128"
    ZoomSnapList = ({OuterSnapAngle = 5.0, InnerSnapAngle = 0.5, SnapOffsetMag = 20.0, AimNode = EAimNodes.AimNode_Cover}, 
                    {OuterSnapAngle = 20.0, InnerSnapAngle = 10.0, SnapOffsetMag = 10.0, AimNode = EAimNodes.AimNode_Chest}, 
                    {OuterSnapAngle = 0.0, InnerSnapAngle = 0.0, SnapOffsetMag = 0.0, AimNode = EAimNodes.AimNode_Head}
                   )
    WeaponModBodyColours = ({R = 0.0900000036, G = 0.0299999993, B = 0.00999999978, A = 0.0}, 
                            {R = 0.5, G = 0.300000012, B = 0.159999996, A = 0.0}, 
                            {R = 0.0799999982, G = 0.0900000036, B = 0.0500000007, A = 0.0}, 
                            {R = 0.109999999, G = 0.140000001, B = 0.189999998, A = 0.0}, 
                            {R = 0.00999999978, G = 0.00999999978, B = 0.0199999996, A = 0.0}
                           )
    FiringShake = {
                   RotAmplitude = {X = 500.0, Y = 100.0, Z = -500.0}, 
                   RotFrequency = {X = 15.0, Y = 10.0, Z = 10.0}, 
                   LocAmplitude = {X = 10.0, Y = 0.0, Z = 0.0}, 
                   LocFrequency = {X = 15.0, Y = 0.0, Z = 0.0}, 
                   TimeDuration = 0.25999999
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 700.0, Y = 100.0, Z = -700.0}, 
                           RotFrequency = {X = 25.0, Y = 15.0, Z = 15.0}, 
                           LocAmplitude = {X = 15.0, Y = 0.0, Z = 0.0}, 
                           LocFrequency = {X = 25.0, Y = 0.0, Z = 0.0}, 
                           TimeDuration = 0.25999999
                          }
    TracerInfo = {
                  Scale3D = {X = 1.25, Y = 1.25, Z = 1.25}, 
                  StaticMesh = StaticMesh'BioVFX_C_Weapons.Tracers.Meshes.Tracer_Cryo_Mesh', 
                  StandardPSTemplate = ParticleSystem'BioVFX_C_Wpn_Saber.Particles.Tracer_Smoke_Trail_Saber', 
                  PlayerPSTemplate = ParticleSystem'BioVFX_C_Wpn_Saber.Particles.Tracer_Smoke_Trail_Saber', 
                  AccelRate = 15000.0, 
                  Speed = 18000.0, 
                  MaxSpeed = 27000.0
                 }
    AI_BurstFireCount = {X = 1.0, Y = 2.0}
    AI_BurstFireDelay = {X = 0.800000012, Y = 2.79999995}
    ReloadAnimInfo = tempAnimInfo
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PS_DefaultImpactEffect = ParticleSystem'BioVFX_C_Wpn_Saber.Particles.Saber_Generic_Impact'
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    TracerSpawnOffset = 2.0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    EjectShellCasingTimeRatio = 0.460000008
    LowAmmoSoundThreshold = 2.0
    SteamSoundThreshold = 1.0
    NoAmmoFireSoundDelay = 0.600000024
    MinRefireTime = 0.75
    LazyRateOfFire = 0.00999999978
    RateOfFireAI = 1.0
    RecoilYawScale = 0.200000003
    RecoilYawFrequency = 0.5
    IconRef = 44
    PrettyName = $676841
    ShortPrettyName = $676841
    ShortDescription = $676842
    GeneralDescription = $676843
    FireSound = WwiseEvent'Wwise_Weapons_NP_Saber.Play_wep_np_saber_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Saber.Play_wep_p_saber_fire'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_assault_heavy'
    MinZoomSnapDistance = 1000.0
    MaxZoomSnapDistance = 10000.0
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    WeaponAcquiredID = 21568
    WeaponAcquiredID_NGP = 21567
    DefaultFireMode = FireModes.FireMode_SemiAuto
    InstantHitMomentum = (0.0, 35.0, 35.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_Saber', Class'SFXDamageType_Saber', Class'SFXDamageType_Default')
    Mesh = WeaponMesh
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}