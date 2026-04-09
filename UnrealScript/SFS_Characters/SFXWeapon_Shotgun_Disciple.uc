Class SFXWeapon_Shotgun_Disciple extends SFXWeapon_Shotgun_Base
    placeable
    config(Weapon);

public simulated function DecalComponent GetWeaponSpecificDecalData(SFXPhysicalMaterialDecals DecalEffects, out float FadeTime)
{
    local int DecalLength;
    
    FadeTime = DecalEffects.FlakGunFadeTime;
    DecalLength = DecalEffects.FlakGun.Length;
    if (DecalLength > 0)
    {
        return DecalEffects.FlakGun[Rand(DecalLength)];
    }
    return None;
}
public static simulated function ParticleSystem GetWeaponSpecificImpactEffect(SFXPhysicalMaterialImpactEffects ImpactEffects)
{
    return ImpactEffects.FlakGun;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        return ImpactSounds.FlakGun_Player;
    }
    return ImpactSounds.FlakGun;
}
public simulated function InitDefaultDecalProperties()
{
    Super(SFXWeapon).InitDefaultDecalProperties();
    DefaultDecalProperties.Width = 50.0;
    DefaultDecalProperties.Height = 50.0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_BLS_R.BLSg.WPN_BLSg_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_BLSg'
        AnimSets = (AnimSet'biog_wpn_a.WPN_BLSg_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_BLS_R.BLSg.WPN_BLSg_MDL'
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
        Template = ParticleSystem'BioVFX_C_Wpn_Disciple.Particles.Disciple_muzzle'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=ShellCasingPSC0
        Template = ParticleSystem'BioVFX_C_Wpn_Disciple.Particles.Reload_VentHeat_Disciple'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        AnimSet = AnimSet'BIOG_HMM_CB_A.HMM_CB_ShotgunAuto_AlternateFast'
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
        Samples = ({Duration = 0.400000006, LeftAmplitude = 80, RightAmplitude = 80, LeftFunction = EWaveformFunction.WF_Sin90to180, RightFunction = EWaveformFunction.WF_Sin90to180}, 
                   {Duration = 0.100000001, LeftAmplitude = 80, RightAmplitude = 80, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
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
    ReloadDuration = {X = 2.26999998, Y = 2.26999998}
    Damage = {X = 46.2999992, Y = 57.7999992}
    MagSize = {X = 4.0, Y = 4.0}
    MaxSpareAmmo = {X = 24.0, Y = 34.0}
    MinAimError = {X = 0.0, Y = 0.0}
    MaxAimError = {X = 0.0, Y = 0.0}
    MinZoomAimError = {X = 0.0, Y = 0.0}
    MaxZoomAimError = {X = 0.0, Y = 0.0}
    RateOfFire = {X = 75.0, Y = 75.0}
    EncumbranceWeight = {X = 1.0, Y = 0.5}
    Recoil = {X = 1.75, Y = 1.75}
    ZoomRecoil = {X = 3.75, Y = 3.75}
    AccFirePenalty = {X = 3.1500001, Y = 3.1500001}
    AccFireInterpSpeed = {X = 8.0, Y = 8.0}
    ZoomAccFirePenalty = {X = 2.5, Y = 2.5}
    ZoomAccFireInterpSpeed = {X = 12.0, Y = 12.0}
    MinZoomCrosshairRange = {X = 60.0, Y = 60.0}
    MaxZoomCrosshairRange = {X = 60.0, Y = 60.0}
    StatBarAccuracy = {X = 10.0, Y = 10.0}
    StatBarDamage = {X = 370.399994, Y = 462.399994}
    StatBarRateOfFire = {X = 75.0, Y = 75.0}
    GUIImage = "gui_codex_images.Weapons.bls_disciple_512x256"
    NotificationImage = "GUI_Icons.Weapons.bls_disciple_256x128"
    WeaponModBodyColours = ({R = 0.460000008, G = 0.479999989, B = 0.839999974, A = 0.0}, 
                            {R = 1.0, G = 0.689999998, B = 0.200000003, A = 0.0}, 
                            {R = 0.540000021, G = 0.589999974, B = 0.439999998, A = 0.0}, 
                            {R = 0.899999976, G = 0.0700000003, B = 0.0, A = 0.0}, 
                            {R = 0.0, G = 0.0, B = 0.0, A = 0.0}
                           )
    GUIZoomReticleClass = Class'SFXGUI_ShotgunReticle'
    FiringShake = {
                   RotAmplitude = {X = 75.0, Y = 100.0, Z = 175.0}, 
                   RotFrequency = {X = 100.0, Y = 50.0, Z = 50.0}, 
                   LocAmplitude = {X = 4.0, Y = 0.0, Z = 0.0}, 
                   TimeDuration = 0.150000006
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 700.0, Y = 100.0, Z = -700.0}, 
                           RotFrequency = {X = 25.0, Y = 15.0, Z = 15.0}, 
                           LocAmplitude = {X = 15.0, Y = 0.0, Z = 0.0}, 
                           LocFrequency = {X = 25.0, Y = 0.0, Z = 0.0}, 
                           TimeDuration = 0.150000006
                          }
    TracerInfo = {
                  Scale3D = {X = 1.25, Y = 1.25, Z = 1.25}, 
                  StandardPSTemplate = ParticleSystem'BioVFX_C_Wpn_Disciple.Particles.Disciple_Smoke_Trail', 
                  PlayerPSTemplate = ParticleSystem'BioVFX_C_Wpn_Disciple.Particles.Disciple_Smoke_Trail', 
                  AccelRate = 10000.0, 
                  Speed = 8000.0, 
                  MaxSpeed = 10000.0
                 }
    MuzzleIdlePosition = {X = 72.0, Y = 9.0, Z = 34.0}
    AI_BurstFireCount = {X = 1.0, Y = 3.0}
    AI_BurstFireDelay = {X = 0.649999976, Y = 2.29999995}
    ReloadAnimInfo = tempAnimInfo
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    EjectShellCasingTimeRatio = 0.455000013
    LowAmmoSoundThreshold = 1.0
    NoAmmoFireSoundDelay = 0.899999976
    LazyRateOfFire = 0.00999999978
    RateOfFireAI = 1.0
    RecoilYawScale = 0.5
    IconRef = 47
    PrettyName = $581148
    ShortPrettyName = $581148
    ShortDescription = $581149
    GeneralDescription = $581150
    FireSound = WwiseEvent'Wwise_Weapons_NP_Disciple.Play_wep_np_disciple_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Disciple.Play_wep_p_disciple_fire'
    FireNoAmmoSound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_dryfire_shotguns'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_shotgun_heavy'
    WeaponSteamReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_noammo_large_alien_sweetener'
    WeaponExpandSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_shotgun_expand'
    WeaponCollapseSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_shotgun_collapse'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    WeaponAcquiredID = 21239
    WeaponAcquiredID_NGP = 21579
    AnimType = WeaponAnimType.WeaponAnimType_AutoShotgun
    InstantHitMomentum = (0.0, 80.0, 80.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_Disciple', Class'SFXDamageType_Disciple', Class'SFXDamageType_Default')
    FireOffset = {X = 66.0, Y = -1.0, Z = 1.0}
    Mesh = WeaponMesh
    AIRating = 20.0
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}