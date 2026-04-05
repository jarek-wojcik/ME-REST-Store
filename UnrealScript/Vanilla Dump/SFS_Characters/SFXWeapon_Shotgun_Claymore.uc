Class SFXWeapon_Shotgun_Claymore extends SFXWeapon_Shotgun_Base
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
        SkeletalMesh = SkeletalMesh'BIOG_WPN_BLS_R.BLSc.WPN_BLSc_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_BLSc'
        AnimSets = (AnimSet'biog_wpn_a.WPN_BLSc_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_BLS_R.BLSc.WPN_BLSc_MDL'
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
        Template = ParticleSystem'BioVFX_C_Weapons.Muzzles.Particles.Shotgun_Muzzle_FlakGun'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=ShellCasingPSC0
        Template = ParticleSystem'BioVFX_C_Reload.Particles.Reload_HeatSinkEject'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        AnimSet = AnimSet'BIOG_HMM_CB_A.HMM_CB_ShotgunAuto_AlternateSlow'
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
        Samples = ({Duration = 0.300000012, LeftAmplitude = 90, RightAmplitude = 90, LeftFunction = EWaveformFunction.WF_Sin90to180, RightFunction = EWaveformFunction.WF_Sin90to180}, 
                   {Duration = 0.100000001, LeftAmplitude = 100, RightAmplitude = 100, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    PelletSpread = ({X = -256.0, Y = 256.0}, 
                    {X = -256.0, Y = -256.0}, 
                    {X = 256.0, Y = -256.0}, 
                    {X = 256.0, Y = 256.0}, 
                    {X = -512.0, Y = 512.0}, 
                    {X = -512.0, Y = -512.0}, 
                    {X = 512.0, Y = 512.0}, 
                    {X = 128.0, Y = -128.0}
                   )
    AI_AccCone_Min = {X = 1.10000002, Y = 1.10000002}
    AI_AccCone_Max = {X = 1.60000002, Y = 1.60000002}
    ReloadDuration = {X = 2.56999993, Y = 2.56999993}
    Damage = {X = 152.800003, Y = 191.0}
    MaxSpareAmmo = {X = 8.0, Y = 18.0}
    MinAimError = {X = 0.0, Y = 0.0}
    MaxAimError = {X = 0.0, Y = 0.0}
    MinZoomAimError = {X = 0.0, Y = 0.0}
    MaxZoomAimError = {X = 0.0, Y = 0.0}
    RateOfFire = {X = 64.0, Y = 64.0}
    EncumbranceWeight = {X = 2.5, Y = 2.0}
    Recoil = {X = 4.36000013, Y = 4.36000013}
    ZoomRecoil = {X = 5.5, Y = 5.5}
    AccFirePenalty = {X = 3.1500001, Y = 3.1500001}
    AccFireInterpSpeed = {X = 8.0, Y = 8.0}
    ZoomAccFirePenalty = {X = 2.5, Y = 2.5}
    ZoomAccFireInterpSpeed = {X = 12.0, Y = 12.0}
    StatBarAccuracy = {X = 10.0, Y = 10.0}
    StatBarDamage = {X = 1222.40002, Y = 1528.0}
    StatBarRateOfFire = {X = 20.0, Y = 20.0}
    GUIImage = "gui_codex_images.Weapons.bls_claymore_512x256"
    NotificationImage = "GUI_Icons.Weapons.bls_claymore_256x128"
    WeaponModBodyColours = ({R = 1.0, G = 1.0, B = 1.0, A = 0.0}, 
                            {R = 1.0, G = 0.870000005, B = 0.439999998, A = 0.0}, 
                            {R = 0.939999998, G = 0.340000004, B = 0.0700000003, A = 0.0}, 
                            {R = 0.449999988, G = 0.50999999, B = 0.839999974, A = 0.0}, 
                            {R = 0.25999999, G = 0.280000001, B = 0.310000002, A = 0.0}
                           )
    GUIZoomReticleClass = Class'SFXGUI_ShotgunReticle'
    FiringShake = {
                   RotAmplitude = {X = 600.0, Y = 100.0, Z = -600.0}, 
                   RotFrequency = {X = 25.0, Y = 10.0, Z = 10.0}, 
                   LocAmplitude = {X = 10.0, Y = 0.0, Z = 0.0}, 
                   LocFrequency = {X = 15.0, Y = 0.0, Z = 0.0}, 
                   TimeDuration = 0.319999993
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 700.0, Y = 100.0, Z = -700.0}, 
                           RotFrequency = {X = 25.0, Y = 15.0, Z = 15.0}, 
                           LocAmplitude = {X = 15.0, Y = 0.0, Z = 0.0}, 
                           LocFrequency = {X = 25.0, Y = 0.0, Z = 0.0}, 
                           TimeDuration = 0.319999993
                          }
    TracerInfo = {
                  Scale3D = {X = 1.5, Y = 1.0, Z = 1.0}, 
                  PlayerPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail_Flak', 
                  AccelRate = 15000.0, 
                  Speed = 3500.0, 
                  MaxSpeed = 15000.0
                 }
    MuzzleIdlePosition = {X = 72.0, Y = 9.0, Z = 34.0}
    AI_BurstFireCount = {X = 1.0, Y = 1.0}
    AI_BurstFireDelay = {X = 0.649999976, Y = 2.29999995}
    ReloadAnimInfo = tempAnimInfo
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PS_DefaultImpactEffect = ParticleSystem'BioVFX_C_Impacts.Generic.Particles.Heavy_Imp'
    DefaultDecalMaterial = MaterialInstanceTimeVarying'BioVFX_C_Blast_Decals.Decals.DECAL_Burn_Red_TimeINST'
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    EjectShellCasingTimeRatio = 0.405000001
    NoAmmoFireSoundDelay = 0.899999976
    LazyRateOfFire = 0.00999999978
    RateOfFireAI = 1.0
    RecoilYawScale = 0.5
    IconRef = 14
    PrettyName = $209736
    ShortPrettyName = $209736
    ShortDescription = $339318
    GeneralDescription = $338221
    FireSound = WwiseEvent'Wwise_Weapons_NP_Claymore.Play_wep_np_claymore_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Claymore.Play_wep_p_claymore_fire'
    FireNoAmmoSound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_dryfire_shotguns'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_shotgun_heavy'
    WeaponExpandSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_shotgun_expand'
    WeaponCollapseSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_shotgun_collapse'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    WeaponAcquiredID = 21238
    WeaponAcquiredID_NGP = 21578
    bNotRegularWeaponGUI = TRUE
    InstantHitMomentum = (0.0, 50.0, 50.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_FlakGun', Class'SFXDamageType_FlakGun', Class'SFXDamageType_Default')
    FireOffset = {X = 1.0, Y = -1.0, Z = 1.0}
    Mesh = WeaponMesh
    AIRating = 30.0
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}