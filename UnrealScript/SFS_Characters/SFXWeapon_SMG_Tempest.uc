Class SFXWeapon_SMG_Tempest extends SFXWeapon_SMG_Base
    placeable
    config(Weapon);

public simulated function DecalComponent GetWeaponSpecificDecalData(SFXPhysicalMaterialDecals DecalEffects, out float FadeTime)
{
    local int DecalLength;
    
    FadeTime = DecalEffects.SMGFadeTime;
    DecalLength = DecalEffects.SMG.Length;
    if (DecalLength > 0)
    {
        return DecalEffects.SMG[Rand(DecalLength)];
    }
    return None;
}
public static simulated function ParticleSystem GetWeaponSpecificImpactEffect(SFXPhysicalMaterialImpactEffects ImpactEffects)
{
    return ImpactEffects.SMG;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        return ImpactSounds.SMG_Player;
    }
    return ImpactSounds.SMG;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_PST_R.PSTd.WPN_PSTd_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_PSTd'
        AnimSets = (AnimSet'biog_wpn_a.WPN_PSTd_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_PST_R.PSTd.WPN_PSTd_MDL'
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
        Template = ParticleSystem'BioVFX_C_Weapons.Muzzles.Particles.Pistol_SMG_Muzzle'
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
        Samples = ({Duration = 0.25, LeftAmplitude = 65, RightAmplitude = 65, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    AI_AccCone_Min = {X = 1.39999998, Y = 1.39999998}
    AI_AccCone_Max = {X = 2.9000001, Y = 2.9000001}
    ReloadDuration = {X = 1.5, Y = 1.5}
    Damage = {X = 35.7000008, Y = 44.5999985}
    MagSize = {X = 50.0, Y = 50.0}
    MaxSpareAmmo = {X = 350.0, Y = 440.0}
    MinAimError = {X = 2.9000001, Y = 2.9000001}
    MaxAimError = {X = 5.0, Y = 5.0}
    MinZoomAimError = {X = 0.600000024, Y = 0.600000024}
    MaxZoomAimError = {X = 3.5, Y = 3.5}
    RateOfFire = {X = 650.0, Y = 650.0}
    EncumbranceWeight = {X = 0.75, Y = 0.349999994}
    Recoil = {X = 0.349999994, Y = 0.349999994}
    ZoomRecoil = {X = 0.5, Y = 0.5}
    AccFirePenalty = {X = 6.5, Y = 6.5}
    AccFireInterpSpeed = {X = 5.0, Y = 5.0}
    ZoomAccFirePenalty = {X = 12.0, Y = 12.0}
    ZoomAccFireInterpSpeed = {X = 12.5, Y = 12.5}
    MinZoomCrosshairRange = {X = 25.0, Y = 25.0}
    MaxZoomCrosshairRange = {X = 75.0, Y = 75.0}
    StatBarAccuracy = {X = 35.0, Y = 35.0}
    StatBarDamage = {X = 35.7000008, Y = 44.5999985}
    StatBarRateOfFire = {X = 650.0, Y = 650.0}
    GUIImage = "gui_codex_images.Weapons.smg_tempest_512x256"
    NotificationImage = "GUI_Icons.Weapons.smg_tempest_256x128"
    WeaponModBodyColours = ({R = 0.449999988, G = 0.119999997, B = 0.0299999993, A = 0.0}, 
                            {R = 0.660000026, G = 0.319999993, B = 0.0399999991, A = 0.0}, 
                            {R = 0.209999993, G = 0.25, B = 0.119999997, A = 0.0}, 
                            {R = 0.25, G = 0.25999999, B = 0.319999993, A = 0.0}, 
                            {R = 0.0299999993, G = 0.0299999993, B = 0.0299999993, A = 0.0}
                           )
    FiringShake = {
                   RotAmplitude = {X = 45.0, Y = 22.0, Z = 11.25}, 
                   RotFrequency = {X = 80.0, Y = 50.0, Z = 20.0}, 
                   TimeDuration = 0.150000006
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 45.0, Y = 22.0, Z = 11.25}, 
                           RotFrequency = {X = 80.0, Y = 50.0, Z = 20.0}, 
                           TimeDuration = 0.075000003
                          }
    TracerInfo = {
                  Scale3D = {X = 1.14999998, Y = 1.14999998, Z = 1.14999998}, 
                  StandardPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail', 
                  PlayerPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail', 
                  AccelRate = 8000.0, 
                  Speed = 18000.0, 
                  MaxSpeed = 20000.0
                 }
    AI_BurstFireCount = {X = 15.0, Y = 25.0}
    AI_BurstFireDelay = {X = 0.649999976, Y = 2.29999995}
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    TracerSpawnOffset = 3.0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    EjectShellCasingTimeRatio = 0.558000028
    LowAmmoSoundThreshold = 12.0
    SteamSoundThreshold = 1.0
    NoAmmoFireSoundDelay = 0.5
    MinRefireTime = 0.100000001
    LazyRateOfFire = 0.00999999978
    RateOfFireAI = 1.0
    RecoilYawScale = 0.200000003
    RecoilYawFrequency = 4.0
    PrettyName = $209731
    ShortPrettyName = $209731
    ShortDescription = $339299
    GeneralDescription = $338215
    FireSound = WwiseEvent'Wwise_Weapons_NP_Tempest.Play_wep_np_tempest_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Tempest.Play_wep_p_tempest_fire'
    FireNoAmmoSound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_dryfire_pistols'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_pistol_normal'
    SteamReloadNotifySound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_reload_air_release'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    WeaponAcquiredID = 21256
    WeaponAcquiredID_NGP = 21594
    bLoopingFlashEmitter = TRUE
    AnimType = WeaponAnimType.WeaponAnimType_AutoPistol
    InstantHitMomentum = (0.0, 1.0, 15.0, 15.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_Default', Class'SFXDamageType_SMG_Tempest', Class'SFXDamageType_SMG_Tempest')
    FireOffset = {X = 19.0, Y = 0.5, Z = 4.0}
    Mesh = WeaponMesh
    AIRating = 20.0
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}