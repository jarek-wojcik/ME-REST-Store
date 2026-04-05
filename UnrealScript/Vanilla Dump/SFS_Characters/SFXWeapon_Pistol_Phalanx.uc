Class SFXWeapon_Pistol_Phalanx extends SFXWeapon_Pistol_Base
    placeable
    config(Weapon);

public simulated function DecalComponent GetWeaponSpecificDecalData(SFXPhysicalMaterialDecals DecalEffects, out float FadeTime)
{
    local int DecalLength;
    
    FadeTime = DecalEffects.HandCannonFadeTime;
    DecalLength = DecalEffects.HandCannon.Length;
    if (DecalLength > 0)
    {
        return DecalEffects.HandCannon[Rand(DecalLength)];
    }
    return None;
}
public static simulated function ParticleSystem GetWeaponSpecificImpactEffect(SFXPhysicalMaterialImpactEffects ImpactEffects)
{
    return ImpactEffects.HandCannon;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        return ImpactSounds.HandCannon_Player;
    }
    return ImpactSounds.HandCannon;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_PST_R.PSTe.WPN_PSTe_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_ASLe'
        AnimSets = (AnimSet'biog_wpn_a.WPN_PSTe_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_PST_R.PSTe.WPN_PSTe_MDL'
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
        Template = ParticleSystem'BioVFX_C_Wpn_Phx.Particles.Pistol_Heavy'
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
        Samples = ({Duration = 0.200000003, LeftAmplitude = 70, RightAmplitude = 70, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
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
    Damage = {X = 114.800003, Y = 143.5}
    MagSize = {X = 12.0, Y = 12.0}
    MaxSpareAmmo = {X = 72.0, Y = 90.0}
    MinAimError = {X = 1.0, Y = 1.0}
    MaxAimError = {X = 3.0, Y = 3.0}
    MinZoomAimError = {X = 0.25, Y = 0.25}
    MaxZoomAimError = {X = 1.14999998, Y = 1.14999998}
    RateOfFire = {X = 250.0, Y = 250.0}
    EncumbranceWeight = {X = 0.600000024, Y = 0.25}
    Recoil = {X = 0.130999997, Y = 0.130999997}
    ZoomRecoil = {X = 0.174999997, Y = 0.174999997}
    AccFirePenalty = {X = 260.0, Y = 260.0}
    AccFireInterpSpeed = {X = 420.0, Y = 420.0}
    ZoomAccFirePenalty = {X = 32.0, Y = 32.0}
    ZoomAccFireInterpSpeed = {X = 31.0, Y = 31.0}
    MinZoomCrosshairRange = {X = 21.0, Y = 21.0}
    MaxZoomCrosshairRange = {X = 36.0, Y = 36.0}
    StatBarAccuracy = {X = 55.0, Y = 55.0}
    StatBarDamage = {X = 114.800003, Y = 143.5}
    StatBarRateOfFire = {X = 250.0, Y = 250.0}
    GUIImage = "gui_codex_images.Weapons.pst_phalanx_512x256"
    NotificationImage = "GUI_Icons.Weapons.pst_phalanx_256x128"
    WeaponModBodyColours = ({R = 0.370000005, G = 0.349999994, B = 0.289999992, A = 0.0}, 
                            {R = 1.0, G = 0.910000026, B = 0.610000014, A = 0.0}, 
                            {R = 0.219999999, G = 0.25, B = 0.180000007, A = 0.0}, 
                            {R = 0.300000012, G = 0.419999987, B = 0.589999974, A = 0.0}, 
                            {R = 0.0, G = 0.0, B = 0.0, A = 0.0}
                           )
    FiringShake = {
                   RotAmplitude = {X = 600.0, Y = 100.0, Z = -600.0}, 
                   RotFrequency = {X = 25.0, Y = 10.0, Z = 10.0}, 
                   LocAmplitude = {X = 10.0, Y = 0.0, Z = 0.0}, 
                   LocFrequency = {X = 15.0, Y = 0.0, Z = 0.0}, 
                   TimeDuration = 0.075000003
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 700.0, Y = 100.0, Z = -700.0}, 
                           RotFrequency = {X = 25.0, Y = 15.0, Z = 15.0}, 
                           LocAmplitude = {X = 15.0, Y = 0.0, Z = 0.0}, 
                           LocFrequency = {X = 25.0, Y = 0.0, Z = 0.0}, 
                           TimeDuration = 0.075000003
                          }
    TracerInfo = {
                  Scale3D = {X = 2.0, Y = 2.0, Z = 2.0}, 
                  StandardPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail', 
                  PlayerPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail', 
                  AccelRate = 20000.0, 
                  Speed = 22000.0, 
                  MaxSpeed = 26000.0
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
    LazyRateOfFire = 0.00999999978
    RateOfFireAI = 1.0
    RecoilYawScale = 0.200000003
    RecoilYawFrequency = 0.5
    IconRef = 29
    PrettyName = $546166
    ShortPrettyName = $685049
    ShortDescription = $652049
    GeneralDescription = $652048
    FireSound = WwiseEvent'Wwise_Weapons_NP_Phalanx.Play_wep_np_phalanx_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Phalanx.Play_wep_p_phalanx_fire'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_pistol_normal'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    WeaponAcquiredID = 21249
    WeaponAcquiredID_NGP = 21586
    DefaultFireMode = FireModes.FireMode_SemiAuto
    InstantHitMomentum = (0.0, 15.0, 15.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_PhalanxPistol', Class'SFXDamageType_PhalanxPistol', Class'SFXDamageType_Default')
    Mesh = WeaponMesh
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}