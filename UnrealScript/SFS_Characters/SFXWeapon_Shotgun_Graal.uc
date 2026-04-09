Class SFXWeapon_Shotgun_Graal extends SFXWeapon_Shotgun_Base
    placeable
    config(Weapon);

var Guid ChargeEffectGuid;
var(SFXWeapon_Shotgun_Graal) instanced ParticleSystemComponent SteamMuzzle;
var(SFXWeapon_Shotgun_Graal) RvrClientEffectInterface CE_ChargeUp;
var(SFXWeapon_Shotgun_Graal) float MaxProjectileCount;
var(SFXWeapon_Shotgun_Graal) float GraalDamageMultiplier;
var(SFXWeapon_Shotgun_Graal) ForceFeedbackWaveform ChargeRumble;
var const config float DirectDamagePercent;
var const config float DoTDamagePercent;
var const config float DOTDuration;

public simulated function FireAmmunition()
{
    local int idx;
    local int ShotsFired;
    
    ShotsFired = int(MaxProjectileCount);
    bSuppressAudio = FALSE;
    bSuppressMuzzleFlash = FALSE;
    Super(SFXWeapon_NativeBase).FireAmmunition();
    bSuppressAudio = TRUE;
    bSuppressMuzzleFlash = TRUE;
    for (idx = 1; idx < ShotsFired; idx++)
    {
        ProjectileFire();
    }
    bSuppressAudio = FALSE;
    bSuppressMuzzleFlash = FALSE;
}
public simulated function float GetFireModeBaseDamage()
{
    local float BaseDamage;
    
    BaseDamage = Super(SFXWeapon).GetFireModeBaseDamage();
    if (ChargeAmount > 0.400000006)
    {
        BaseDamage = Damage.Value * GraalDamageMultiplier;
    }
    return BaseDamage;
}
public simulated function DecalComponent GetWeaponSpecificDecalData(SFXPhysicalMaterialDecals DecalEffects, out float FadeTime)
{
    local int DecalLength;
    
    FadeTime = DecalEffects.HeavyShotgunFadeTime;
    DecalLength = DecalEffects.HeavyShotgun.Length;
    if (DecalLength > 0)
    {
        return DecalEffects.HeavyShotgun[Rand(DecalLength)];
    }
    return None;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        BioPlayerController(Instigator.Controller).ClientStopForceFeedbackWaveform(ChargeRumble);
        return ImpactSounds.GraalShotgun_Player;
    }
    return ImpactSounds.GraalShotgun;
}
public simulated function PlayReloadEject()
{
    if (SFXPawn_Player(Instigator) != None)
    {
        WeaponAnimNode.StopCustomAnim(0.200000003);
        WeaponAnimNode.PlayCustomAnim('WPN_ChargeRelease', 1.0);
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_ChargeUp, ChargeEffectGuid, FALSE);
    }
    Super(SFXWeapon).PlayReloadEject();
}
public simulated function StartChargeEffects()
{
    local RvrClientEffectTarget CETarget;
    
    Super(SFXWeapon).StartChargeEffects();
    if (SFXPawn_Player(Instigator) != None)
    {
        BioPlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform(ChargeRumble);
        CETarget.Instigator = Instigator;
        CETarget.HitBone = 'Flash_2';
        WeaponAnimNode.PlayCustomAnim('WPN_ChargeUp', 1.0);
        WeaponAnimNode.PlayCustomAnim('WPN_ChargeHold', 1.0, 1.0, 0.0, TRUE);
        ChargeEffectGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CE_ChargeUp, CETarget);
    }
    Super(SFXWeapon).StartChargeEffects();
}
public simulated function StopChargeEffects()
{
    BioPlayerController(Instigator.Controller).ClientStopForceFeedbackWaveform(ChargeRumble);
    WeaponAnimNode.StopCustomAnim(0.200000003);
    WeaponAnimNode.PlayCustomAnim('WPN_ChargeRelease', 1.0);
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_ChargeUp, ChargeEffectGuid, FALSE);
    Super(SFXWeapon).StopChargeEffects();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_BLS_R.BLSf.WPN_BLSf_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_BLSf'
        AnimSets = (AnimSet'biog_wpn_a.WPN_BLSf_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_BLS_R.BLSf.WPN_BLSf_MDL'
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
        Template = ParticleSystem'BioVFX_C_Wpn_KShotGun.Particles.Krogan_ShotGun_Muzzle'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=ShellCasingPSC0
        Template = ParticleSystem'BioVFX_C_Reload.Particles.Reload_VentHeat'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=SteamChargePSC0
        Template = ParticleSystem'BioVFX_C_Reload.Particles.Reload_VentHeat'
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBaseCharge
        Samples = ({Duration = 2.0, LeftAmplitude = 75, RightAmplitude = 75, LeftFunction = EWaveformFunction.WF_LinearIncreasing, RightFunction = EWaveformFunction.WF_LinearIncreasing}, 
                   {Duration = 9.85000038, LeftAmplitude = 75, RightAmplitude = 75, LeftFunction = EWaveformFunction.WF_Noise, RightFunction = EWaveformFunction.WF_Noise}
                  )
        bIsLooping = TRUE
    End Object
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        AnimSet = AnimSet'BIOG_HMM_CB_A.HMM_CB_ShotgunAuto_AlternateSlow'
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
        Samples = ({Duration = 0.300000012, LeftAmplitude = 80, RightAmplitude = 80, LeftFunction = EWaveformFunction.WF_Sin90to180, RightFunction = EWaveformFunction.WF_Sin90to180}, 
                   {Duration = 0.100000001, LeftAmplitude = 100, RightAmplitude = 100, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    SteamMuzzle = SteamChargePSC0
    CE_ChargeUp = RvrClientEffectMulti'BioVFX_C_Wpn_KShotGun.VCFX.Graal_Charge_Up_M_VCFX'
    MaxProjectileCount = 6.0
    GraalDamageMultiplier = 2.0
    ChargeRumble = ForceFeedbackWaveformBaseCharge
    DirectDamagePercent = 1.0
    DOTDuration = 1.0
    AI_AccCone_Min = {X = 1.10000002, Y = 1.10000002}
    AI_AccCone_Max = {X = 1.79999995, Y = 1.79999995}
    ReloadDuration = {X = 2.56999993, Y = 2.56999993}
    Damage = {X = 80.0, Y = 100.0}
    MagSize = {X = 3.0, Y = 3.0}
    MaxSpareAmmo = {X = 12.0, Y = 22.0}
    MinAimError = {X = 2.5, Y = 2.5}
    MaxAimError = {X = 5.0, Y = 5.0}
    MinZoomAimError = {X = 0.75, Y = 0.75}
    MaxZoomAimError = {X = 2.5, Y = 2.5}
    RateOfFire = {X = 80.0, Y = 80.0}
    EncumbranceWeight = {X = 2.0, Y = 1.39999998}
    Recoil = {X = 0.275000006, Y = 0.275000006}
    ZoomRecoil = {X = 0.75, Y = 0.75}
    AccFirePenalty = {X = 320.0, Y = 320.0}
    AccFireInterpSpeed = {X = 420.0, Y = 420.0}
    ZoomAccFirePenalty = {X = 40.0, Y = 40.0}
    ZoomAccFireInterpSpeed = {X = 38.0, Y = 38.0}
    MinZoomCrosshairRange = {X = 32.0, Y = 32.0}
    MaxZoomCrosshairRange = {X = 42.0, Y = 42.0}
    StatBarAccuracy = {X = 50.0, Y = 50.0}
    StatBarDamage = {X = 960.0, Y = 1200.0}
    StatBarRateOfFire = {X = 80.0, Y = 80.0}
    GUIImage = "gui_codex_images.Weapons.bls_graal_512x256"
    NotificationImage = "GUI_Icons.Weapons.bls_graal_256x128"
    AllowableWeaponMods = ("SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed", "SFXGameContent.SFXWeaponMod_ShotgunAccuracy", "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage", "SFXGameContent.SFXWeaponMod_ShotgunStability")
    WeaponModBodyColours = ({R = 0.370000005, G = 0.349999994, B = 0.289999992, A = 0.0}, 
                            {R = 0.519999981, G = 0.0799999982, B = 0.0199999996, A = 0.0}, 
                            {R = 0.140000001, G = 0.170000002, B = 0.0700000003, A = 0.0}, 
                            {R = 0.140000001, G = 0.170000002, B = 0.170000002, A = 0.0}, 
                            {R = 0.00999999978, G = 0.00999999978, B = 0.00999999978, A = 0.0}
                           )
    GUIZoomReticleClass = Class'SFXGUI_ShotgunReticle'
    FiringShake = {
                   RotAmplitude = {X = 325.0, Y = 175.0, Z = 100.0}, 
                   RotFrequency = {X = 100.0, Y = 50.0, Z = 50.0}, 
                   LocAmplitude = {X = 4.0, Y = 0.0, Z = 0.0}, 
                   TimeDuration = 0.200000003
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 500.0, Y = 100.0, Z = -500.0}, 
                           RotFrequency = {X = 15.0, Y = 10.0, Z = 10.0}, 
                           LocAmplitude = {X = 10.0, Y = 0.0, Z = 0.0}, 
                           LocFrequency = {X = 15.0, Y = 0.0, Z = 0.0}, 
                           TimeDuration = 0.25999999
                          }
    MuzzleIdlePosition = {X = 72.0, Y = 9.0, Z = 34.0}
    AI_BurstFireCount = {X = 1.0, Y = 1.0}
    AI_BurstFireDelay = {X = 0.649999976, Y = 2.29999995}
    ReloadAnimInfo = tempAnimInfo
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    EjectShellCasingTimeRatio = 0.405000001
    NoAmmoFireSoundDelay = 0.899999976
    LazyRateOfFire = 0.00999999978
    RateOfFireAI = 1.0
    RecoilYawScale = 0.25
    MagneticCorrectionThresholdAngle = 0.0
    MaxMagneticCorrectionAngle = 0.0
    IconRef = 33
    PrettyName = $551037
    ShortPrettyName = $551037
    ShortDescription = $551039
    GeneralDescription = $551038
    FireSound = WwiseEvent'Wwise_Weapons_NP_Graal.Play_wep_np_graal_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Graal.Play_wep_p_graal_fire_high'
    FireNoAmmoSound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_dryfire_shotguns'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_shotgun_heavy'
    WeaponExpandSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_shotgun_expand'
    WeaponCollapseSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_shotgun_collapse'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    PowerUpSound = WwiseEvent'Wwise_Weapons_S_Graal.Play_wep_s_graal_charge_start'
    PowerDownSound = WwiseEvent'Wwise_Weapons_S_Graal.Play_wep_s_graal_charge_stop'
    MaxChargeTime = 2.0
    WeaponAcquiredID = 21242
    WeaponAcquiredID_NGP = 21582
    bCanBlindUp = FALSE
    WeaponFireTypes = (EWeaponFireType.EWFT_InstantHit, EWeaponFireType.EWFT_Projectile, EWeaponFireType.EWFT_Projectile, EWeaponFireType.EWFT_InstantHit, EWeaponFireType.EWFT_InstantHit)
    WeaponProjectiles = (None, Class'SFXProjectile_Graal', Class'SFXProjectile_Graal')
    InstantHitMomentum = (0.0, 40.0, 40.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_HeavyShotgun', Class'SFXDamageType_HeavyShotgun', Class'SFXDamageType_Default')
    FireOffset = {X = 1.0, Y = -1.0, Z = 1.0}
    Mesh = WeaponMesh
    AIRating = 20.0
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}