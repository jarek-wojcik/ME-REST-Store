Class SFXWeapon_Pistol_Predator extends SFXWeapon_Pistol_Base
    placeable
    config(Weapon);

public simulated function DecalComponent GetWeaponSpecificDecalData(SFXPhysicalMaterialDecals DecalEffects, out float FadeTime)
{
    local int DecalLength;
    
    FadeTime = DecalEffects.HeavyPistolFadeTime;
    DecalLength = DecalEffects.HeavyPistol.Length;
    if (DecalLength > 0)
    {
        return DecalEffects.HeavyPistol[Rand(DecalLength)];
    }
    return None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_PST_R.PSTa.WPN_PSTa_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_PSTa'
        AnimSets = (AnimSet'biog_wpn_a.WPN_PST_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_PST_R.PSTa.WPN_PSTa_MDL'
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
        Template = ParticleSystem'BioVFX_C_Weapons.Muzzles.Particles.Pistol_Muzzle_Magunm'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=ShellCasingPSC0
        Template = ParticleSystem'BioVFX_C_Reload.Particles.Reload_HeatSinkEject'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        AnimSet = AnimSet'BIOG_HMM_CB_A.HMM_CB_PistolAuto_AlternateFast'
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
        Samples = ({Duration = 0.224999994, LeftAmplitude = 65, RightAmplitude = 65, LeftFunction = EWaveformFunction.WF_LinearDecreasing, RightFunction = EWaveformFunction.WF_LinearDecreasing}
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
    ReloadDuration = {X = 0.699999988, Y = 0.699999988}
    Damage = {X = 58.7999992, Y = 73.5}
    MagSize = {X = 15.0, Y = 15.0}
    MaxSpareAmmo = {X = 90.0, Y = 112.0}
    MinAimError = {X = 1.0, Y = 1.0}
    MaxAimError = {X = 6.0, Y = 6.0}
    MinZoomAimError = {X = 0.300000012, Y = 0.300000012}
    MaxZoomAimError = {X = 1.5, Y = 1.5}
    RateOfFire = {X = 500.0, Y = 500.0}
    EncumbranceWeight = {X = 0.5, Y = 0.200000003}
    Recoil = {X = 4.0, Y = 4.0}
    ZoomRecoil = {X = 1.5, Y = 1.5}
    AccFirePenalty = {X = 6.0, Y = 6.0}
    AccFireInterpSpeed = {X = 20.0, Y = 20.0}
    ZoomAccFirePenalty = {X = 8.0, Y = 8.0}
    ZoomAccFireInterpSpeed = {X = 12.0, Y = 12.0}
    MinZoomCrosshairRange = {X = 25.0, Y = 25.0}
    MaxZoomCrosshairRange = {X = 90.0, Y = 90.0}
    StatBarAccuracy = {X = 55.0, Y = 55.0}
    StatBarDamage = {X = 58.7999992, Y = 73.5}
    StatBarRateOfFire = {X = 250.0, Y = 250.0}
    GUIImage = "GUI_Codex_Images.Weapons.pst_predator_512x256"
    NotificationImage = "GUI_Icons.Weapons.pst_predator_256x128"
    WeaponModBodyColours = ({R = 0.430000007, G = 0.109999999, B = 0.0500000007, A = 0.0}, 
                            {R = 0.860000014, G = 0.409999996, B = 0.0599999987, A = 0.0}, 
                            {R = 0.529999971, G = 0.610000014, B = 0.460000008, A = 0.0}, 
                            {R = 0.0900000036, G = 0.129999995, B = 0.300000012, A = 0.0}, 
                            {R = 0.0199999996, G = 0.0199999996, B = 0.0199999996, A = 0.0}
                           )
    FiringShake = {
                   RotAmplitude = {X = 50.0, Y = 50.0, Z = 95.0}, 
                   RotFrequency = {X = 25.0, Y = 25.0, Z = 25.0}, 
                   LocAmplitude = {X = 4.0, Y = 0.0, Z = 0.0}, 
                   TimeDuration = 0.0149999997
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 50.0, Y = 50.0, Z = 95.0}, 
                           RotFrequency = {X = 25.0, Y = 25.0, Z = 25.0}, 
                           LocAmplitude = {X = 4.0, Y = 0.0, Z = 0.0}, 
                           TimeDuration = 0.0149999997
                          }
    TracerInfo = {
                  Scale3D = {X = 1.25, Y = 1.25, Z = 1.25}, 
                  StaticMesh = StaticMesh'BioVFX_C_Weapons.Tracers.Meshes.Tracer_Generic_Mesh', 
                  StandardPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail', 
                  PlayerPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail', 
                  AccelRate = 18000.0, 
                  Speed = 22000.0, 
                  MaxSpeed = 25000.0
                 }
    MeleePowerName = 'Pistol_Whip'
    AI_BurstFireCount = {X = 5.0, Y = 7.0}
    AI_BurstFireDelay = {X = 0.649999976, Y = 2.29999995}
    ReloadAnimInfo = tempAnimInfo
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    EjectShellCasingTimeRatio = 0.563000023
    LowAmmoSoundThreshold = 3.0
    SteamSoundThreshold = 1.0
    NoAmmoFireSoundDelay = 0.800000012
    LazyRateOfFire = 0.00999999978
    RateOfFireAI = 1.0
    RecoilInterpSpeed = 25.0
    RecoilFadeSpeed = 1.5
    RecoilZoomFadeSpeed = 1.25
    RecoilYawScale = 0.100000001
    PrettyName = $209732
    ShortPrettyName = $209732
    ShortDescription = $339301
    GeneralDescription = $338216
    FireSound = WwiseEvent'Wwise_Weapons_NP_Predator.Play_wep_np_predator_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Predator.Play_wep_p_predator_fire'
    FireNoAmmoSound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_dryfire_pistols'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_pistol_light'
    WeaponExpandSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_pistol_expand'
    WeaponCollapseSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_pistol_collapse'
    SteamReloadNotifySound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_overheat'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    WeaponAcquiredID = 21569
    WeaponAcquiredID_NGP = 21589
    DefaultFireMode = FireModes.FireMode_SemiAuto
    InstantHitMomentum = (0.0, 5.0, 5.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_HeavyPistol', Class'SFXDamageType_HeavyPistol', Class'SFXDamageType_Default')
    FireOffset = {X = 19.0, Y = 0.5, Z = 4.0}
    Mesh = WeaponMesh
    AIRating = 1.0
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}