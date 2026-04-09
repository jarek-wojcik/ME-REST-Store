Class SFXWeapon_Shotgun_Geth extends SFXWeapon_Shotgun_BaseCharge
    placeable
    config(Weapon);

var ScreenShakeStruct FireCameraShake;
var ScreenShakeStruct ImpactCameraShake;
var float TopPitchOffset;
var float TopYawOffset;
var float BottomPitchOffset;
var float BottomYawOffset;
var config float InstantFireDamage;
var config float FirstHitDamage;
var config float SecondHitDamage;
var config float ThirdHitDamage;
var ForceFeedbackWaveform ImpactRumble;
var WwiseEvent PlayerFireHighSound;
var WwiseEvent PlayerFireMedSound;
var WwiseEvent PlayerFireLowSound;
var float MaxImpactCameraShake;
var float MaxImpactRumble;
var(SFXWeapon_Shotgun_Geth) ForceFeedbackWaveform ChargeRumble;

public simulated function ConsumeAmmo(byte FireModeNum)
{
    AmmoPerShot = 1.0;
    Super.ConsumeAmmo(FireModeNum);
}
public simulated function Projectile Internal_ProjectileFire()
{
    local BioPlayerController PC;
    local SFXProjectile_GethShotgun SpawnedProjectile;
    local Rotator AdjustedRot;
    local float fDamageMultiplier;
    local float fRumbleAmplitude;
    local float fCameraAmplitude;
    local Class<SFXProjectile> ProjectileClass;
    
    ProjectileClass = Class<SFXProjectile>(GetProjectileClass());
    if (Instigator == None && Role != ENetRole.ROLE_Authority || Instigator != None && Instigator.Role == ENetRole.ROLE_SimulatedProxy || Instigator != None && Instigator.Role == ENetRole.ROLE_AutonomousProxy && ProjectileClass.default.bClientPredictProjectile == FALSE)
    {
        return None;
    }
    fDamageMultiplier = ChargeAmount * (1.0 - InstantFireDamage) + InstantFireDamage;
    if (Instigator != None && Instigator.IsHumanControlled())
    {
        PC = BioPlayerController(Instigator.Controller);
        if (PC != None && PC.IsLocalPlayerController())
        {
            fRumbleAmplitude = (MaxChargeFireRumble - MinChargeFireRumble) * ChargeAmount + MinChargeFireRumble;
            WeaponFireWaveForm.Samples[0].LeftAmplitude = byte(fRumbleAmplitude);
            WeaponFireWaveForm.Samples[0].RightAmplitude = byte(fRumbleAmplitude);
            WeaponFireWaveForm.Samples[1].LeftAmplitude = byte(fRumbleAmplitude);
            WeaponFireWaveForm.Samples[1].RightAmplitude = byte(fRumbleAmplitude);
            PC.HintSystem.HintEvent('Fire', Class.Name);
            if (PC.PlayerCamera != None)
            {
                fCameraAmplitude = MaxChargeCameraShake * ChargeAmount;
                FireCameraShake.RotAmplitude.X = fCameraAmplitude;
                FireCameraShake.RotAmplitude.Y = fCameraAmplitude;
                FireCameraShake.RotAmplitude.Z = fCameraAmplitude;
                FireCameraShake.RotFrequency.X = fCameraAmplitude;
                FireCameraShake.RotFrequency.Y = fCameraAmplitude;
                FireCameraShake.RotFrequency.Z = fCameraAmplitude;
                SFXPlayerCamera(PC.PlayerCamera).AddScreenShake(FireCameraShake);
            }
        }
    }
    IncrementFlashCount();
    AdjustedRot = Rotator(StartFireDirection);
    AdjustedRot.Pitch += int(TopPitchOffset);
    AdjustedRot.Yaw += int(-TopYawOffset);
    SpawnedProjectile = SFXProjectile_GethShotgun(SFXGRI(WorldInfo.GRI).ObjectPool.GetProjectile(GetProjectileClass(), Self, Self.Instigator, StartFireLocation, AdjustedRot));
    if (SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe)
    {
        if (Instigator != None && Instigator.Role == ENetRole.ROLE_AutonomousProxy)
        {
            SpawnedProjectile.SetPrediction(TRUE, FALSE);
            PredictedProjectiles.AddItem(SpawnedProjectile);
        }
        SpawnedProjectile.DamageMultiplier = fDamageMultiplier;
        SpawnedProjectile.ChargeAmount = ChargeAmount;
        SpawnedProjectile.bSuppressAudio = bSuppressAudio;
        SpawnedProjectile.Init(Vector(AdjustedRot));
    }
    AdjustedRot = Rotator(StartFireDirection);
    AdjustedRot.Pitch += int(TopPitchOffset);
    AdjustedRot.Yaw += int(TopYawOffset);
    SpawnedProjectile = SFXProjectile_GethShotgun(SFXGRI(WorldInfo.GRI).ObjectPool.GetProjectile(GetProjectileClass(), Self, Self.Instigator, StartFireLocation, AdjustedRot));
    if (SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe)
    {
        if (Instigator != None && Instigator.Role == ENetRole.ROLE_AutonomousProxy)
        {
            SpawnedProjectile.SetPrediction(TRUE, FALSE);
            PredictedProjectiles.AddItem(SpawnedProjectile);
        }
        SpawnedProjectile.DamageMultiplier = fDamageMultiplier;
        SpawnedProjectile.ChargeAmount = ChargeAmount;
        SpawnedProjectile.bSuppressAudio = bSuppressAudio;
        SpawnedProjectile.Init(Vector(AdjustedRot));
    }
    AdjustedRot = Rotator(StartFireDirection);
    AdjustedRot.Pitch += int(BottomPitchOffset);
    AdjustedRot.Yaw += int(BottomYawOffset);
    SpawnedProjectile = SFXProjectile_GethShotgun(SFXGRI(WorldInfo.GRI).ObjectPool.GetProjectile(GetProjectileClass(), Self, Self.Instigator, StartFireLocation, AdjustedRot));
    if (SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe)
    {
        if (Instigator != None && Instigator.Role == ENetRole.ROLE_AutonomousProxy)
        {
            SpawnedProjectile.SetPrediction(TRUE, FALSE);
            PredictedProjectiles.AddItem(SpawnedProjectile);
        }
        SpawnedProjectile.DamageMultiplier = fDamageMultiplier;
        SpawnedProjectile.ChargeAmount = ChargeAmount;
        SpawnedProjectile.bSuppressAudio = bSuppressAudio;
        SpawnedProjectile.Init(Vector(AdjustedRot));
    }
    return SpawnedProjectile;
}
public simulated function PlayMuzzleFlashEffect()
{
    local Vector EmitterParameter;
    
    if (!bSuppressMuzzleFlash && IsMuzzleFlashRelevant() && PSC_MuzFlashEmitter != None)
    {
        EmitterParameter.X = ChargeAmount;
        EmitterParameter.Y = ChargeAmount;
        EmitterParameter.Z = ChargeAmount;
        PSC_MuzFlashEmitter.SetVectorParameter('Intensity', EmitterParameter);
    }
    Super(SFXWeapon).PlayMuzzleFlashEffect();
}
public simulated function PlayOwnedFireEffects(byte FireModeNum, Vector HitLocation)
{
    if ((bForceSpawnTracer || ShouldSpawnTracerFX()) && IsZero(HitLocation) == FALSE)
    {
        if (Instigator != None)
        {
            SpawnTracerEffect(HitLocation, VSize(HitLocation - Instigator.location));
        }
        else
        {
            SpawnTracerEffect(HitLocation, VSize(HitLocation - GetMuzzleLoc()));
        }
    }
    if (WeaponPowerFireSound != None)
    {
        WeaponPlayWwiseEvent(WeaponPowerFireSound, 1.0);
    }
    if (Instigator == None)
    {
        WeaponPlayWwiseEvent(FireSound, WeaponLoudness, , 'NoiseType_WeaponFire');
    }
    else if (Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
    {
        SetWeaponRecoil(GetWeaponRecoil() * 182.044449);
        if (!bPlaySoundOncePerBurst)
        {
            if (Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
            {
                if (ChargeAmount >= 1.0)
                {
                    WeaponPlayWwiseEvent(PlayerFireHighSound, WeaponLoudness, , 'NoiseType_WeaponFire');
                }
                else if (ChargeAmount >= 0.5)
                {
                    WeaponPlayWwiseEvent(PlayerFireMedSound, WeaponLoudness, , 'NoiseType_WeaponFire');
                }
                else
                {
                    WeaponPlayWwiseEvent(PlayerFireLowSound, WeaponLoudness, , 'NoiseType_WeaponFire');
                }
            }
            else
            {
                WeaponPlayWwiseEvent(FireSound, WeaponLoudness, , 'NoiseType_WeaponFire');
            }
        }
    }
    else if (SFXAI_Core(Instigator.Controller) == None && bPlaySoundOncePerBurst == FALSE || bAIPlaySoundOncePerBurst == FALSE)
    {
        WeaponPlayWwiseEvent(FireSound, WeaponLoudness, , 'NoiseType_WeaponFire');
    }
}
public simulated function StartChargeEffects()
{
    if (SFXPawn_Player(Instigator) != None)
    {
        BioPlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform(ChargeRumble);
    }
    Super(SFXWeapon).StartChargeEffects();
}
public simulated function StopChargeEffects()
{
    BioPlayerController(Instigator.Controller).ClientStopForceFeedbackWaveform(ChargeRumble);
    Super(SFXWeapon).StopChargeEffects();
}
public simulated function OnProjectileImpact(Actor Impacted, Vector HitLocation, float fProjectileCharge)
{
    local BioPlayerController PC;
    local float fCameraAmplitude;
    local float fRumbleAmplitude;
    
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        PC = BioPlayerController(BioPawn(Instigator).Controller);
        if (PC != None && PC.PlayerCamera != None)
        {
            fRumbleAmplitude = MaxImpactRumble * fProjectileCharge;
            ImpactRumble.Samples[0].LeftAmplitude = byte(fRumbleAmplitude);
            ImpactRumble.Samples[0].RightAmplitude = byte(fRumbleAmplitude);
            fCameraAmplitude = MaxImpactCameraShake * fProjectileCharge;
            ImpactCameraShake.RotAmplitude.X = fCameraAmplitude;
            ImpactCameraShake.RotAmplitude.Y = fCameraAmplitude;
            ImpactCameraShake.RotAmplitude.Z = fCameraAmplitude;
            ImpactCameraShake.RotFrequency.X = fCameraAmplitude;
            ImpactCameraShake.RotFrequency.Y = fCameraAmplitude;
            ImpactCameraShake.RotFrequency.Z = fCameraAmplitude;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_BLS_R.BLSd.WPN_BLSd_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_BLSd'
        AnimSets = (AnimSet'biog_wpn_a.WPN_BLSd_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_BLS_R.BLSd.WPN_BLSd_MDL'
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
    Begin Template Class=ParticleSystemComponent Name=ChargePSC
        Template = ParticleSystem'BioVFX_C_Wpn_Gsg.Particles.Charge_GSG'
        ReplacementPrimitive = None
    End Template
    Begin Object Class=ParticleSystemComponent Name=MuzFlashPSC0
        Template = ParticleSystem'BioVFX_C_Wpn_Gsg.Particles.Muzzle_GSG'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=ShellCasingPSC0
        Template = ParticleSystem'BioVFX_C_Wpn_Gsg.Particles.Reload_VentHeat_GSG'
        bAutoActivate = FALSE
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
        Samples = ({Duration = 0.400000006, LeftAmplitude = 120, RightAmplitude = 120, LeftFunction = EWaveformFunction.WF_Sin90to180, RightFunction = EWaveformFunction.WF_Sin90to180}, 
                   {Duration = 0.100000001, LeftAmplitude = 120, RightAmplitude = 120, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    FireCameraShake = {
                       RotAmplitude = {X = 75.0, Y = 75.0, Z = 75.0}, 
                       RotFrequency = {X = 75.0, Y = 75.0, Z = 75.0}, 
                       RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                       LocAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                       LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                       LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                       ShakeName = 'GethShotgunFire', 
                       TimeToGo = 0.0, 
                       TimeDuration = 0.600000024, 
                       RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                       LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                       FOVAmplitude = 2.0, 
                       FOVFrequency = 5.0, 
                       FOVSinOffset = 0.0, 
                       TargetingDampening = 0.0, 
                       bOverrideTargetingDampening = FALSE, 
                       FOVParam = EShakeParam.ESP_OffsetRandom
                      }
    ImpactCameraShake = {
                         RotAmplitude = {X = 75.0, Y = 75.0, Z = 75.0}, 
                         RotFrequency = {X = 75.0, Y = 75.0, Z = 75.0}, 
                         RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                         LocAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                         LocFrequency = {X = 1.0, Y = 10.0, Z = 20.0}, 
                         LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                         ShakeName = 'GethShotgunImpact', 
                         TimeToGo = 0.0, 
                         TimeDuration = 0.400000006, 
                         RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                         LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                         FOVAmplitude = 2.0, 
                         FOVFrequency = 5.0, 
                         FOVSinOffset = 0.0, 
                         TargetingDampening = 0.0, 
                         bOverrideTargetingDampening = FALSE, 
                         FOVParam = EShakeParam.ESP_OffsetRandom
                        }
    TopPitchOffset = 100.0
    TopYawOffset = 200.0
    BottomPitchOffset = -100.0
    InstantFireDamage = 0.449999988
    FirstHitDamage = 1.0
    SecondHitDamage = 0.300000012
    ThirdHitDamage = 0.300000012
    PlayerFireHighSound = WwiseEvent'Wwise_Weapons_P_GethShot.Play_wep_p_gethshot_fire_high'
    PlayerFireMedSound = WwiseEvent'Wwise_Weapons_P_GethShot.Play_wep_p_gethshot_fire_med'
    PlayerFireLowSound = WwiseEvent'Wwise_Weapons_P_GethShot.Play_wep_p_gethshot_fire_low'
    MaxImpactCameraShake = 75.0
    MaxImpactRumble = 80.0
    ChargeRumble = ForceFeedbackWaveformBaseCharge
    AI_AccCone_Min = {X = 1.20000005, Y = 1.20000005}
    AI_AccCone_Max = {X = 1.79999995, Y = 1.79999995}
    ReloadDuration = {X = 2.56999993, Y = 2.56999993}
    Damage = {X = 714.200012, Y = 892.700012}
    MagSize = {X = 5.0, Y = 5.0}
    MaxSpareAmmo = {X = 15.0, Y = 25.0}
    MinAimError = {X = 0.0, Y = 0.0}
    MaxAimError = {X = 0.0, Y = 0.0}
    MinZoomAimError = {X = 0.0, Y = 0.0}
    MaxZoomAimError = {X = 0.0, Y = 0.0}
    RateOfFire = {X = 60.0, Y = 60.0}
    EncumbranceWeight = {X = 2.0, Y = 1.39999998}
    Recoil = {X = 1.75, Y = 1.75}
    ZoomRecoil = {X = 2.5, Y = 2.5}
    AccFirePenalty = {X = 3.1500001, Y = 3.1500001}
    AccFireInterpSpeed = {X = 8.0, Y = 8.0}
    ZoomAccFirePenalty = {X = 2.5, Y = 2.5}
    ZoomAccFireInterpSpeed = {X = 12.0, Y = 12.0}
    MinZoomCrosshairRange = {X = 60.0, Y = 70.0}
    MaxZoomCrosshairRange = {X = 60.0, Y = 70.0}
    StatBarAccuracy = {X = 40.0, Y = 40.0}
    StatBarDamage = {X = 1142.71997, Y = 1428.31995}
    StatBarRateOfFire = {X = 60.0, Y = 60.0}
    GUIImage = "gui_codex_images.Weapons.bls_gethplasma_512x256"
    NotificationImage = "GUI_Icons.Weapons.bls_gethplasma_256x128"
    WeaponModMeshOverrides = ({
                               SocketOverrideNames = ('Barrel', 'Barrel_2'), 
                               SocketName = 'Barrel'
                              }
                             )
    WeaponModBodyColours = ({R = 0.370000005, G = 0.349999994, B = 0.289999992, A = 0.0}, 
                            {R = 0.620000005, G = 0.49000001, B = 0.25999999, A = 0.0}, 
                            {R = 0.159999996, G = 0.180000007, B = 0.280000001, A = 0.0}, 
                            {R = 0.360000014, G = 0.409999996, B = 0.409999996, A = 0.0}, 
                            {R = 0.129999995, G = 0.129999995, B = 0.159999996, A = 0.0}
                           )
    FiringShake = {
                   RotAmplitude = {X = 700.0, Y = 100.0, Z = -700.0}, 
                   RotFrequency = {X = 25.0, Y = 15.0, Z = 15.0}, 
                   LocAmplitude = {X = 15.0, Y = 0.0, Z = 0.0}, 
                   LocFrequency = {X = 25.0, Y = 0.0, Z = 0.0}, 
                   TimeDuration = 0.219999999
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 700.0, Y = 100.0, Z = -700.0}, 
                           RotFrequency = {X = 25.0, Y = 15.0, Z = 15.0}, 
                           LocAmplitude = {X = 15.0, Y = 0.0, Z = 0.0}, 
                           LocFrequency = {X = 25.0, Y = 0.0, Z = 0.0}, 
                           TimeDuration = 0.219999999
                          }
    TracerInfo = {
                  Scale3D = {X = 1.25, Y = 1.25, Z = 1.25}, 
                  StaticMesh = StaticMesh'BioVFX_C_Weapons.Tracers.Meshes.Tracer_Geth_Mesh', 
                  AccelRate = 10000.0, 
                  Speed = 9500.0, 
                  MaxSpeed = 12000.0
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
    FlashlightFireColor = {B = 255, G = 255, R = 100, A = 0}
    FlashlightFireBrightnessIncrease = 2.5
    FlashlightFireRadiusIncrease = 0.75
    EjectShellCasingTimeRatio = 0.405000001
    LowAmmoSoundThreshold = 2.0
    SteamSoundThreshold = 2.0
    NoAmmoFireSoundDelay = 0.899999976
    MinRefireTime = 1.02999997
    LazyRateOfFire = 75.0
    RateOfFireAI = 0.25
    RoundsPerBurst = 0.0
    RecoilYawScale = 0.5
    IdealTargetDistance = 1200.0
    IdealMaxRange = 3000.0
    MagneticCorrectionThresholdAngle = 0.0
    MaxMagneticCorrectionAngle = 0.0
    IconRef = 20
    PrettyName = $560869
    ShortPrettyName = $560869
    ShortDescription = $560871
    GeneralDescription = $560870
    FireSound = WwiseEvent'Wwise_Weapons_NP_GethShot.Play_wep_np_gethshot_fire'
    FireNoAmmoSound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_dryfire_shotguns'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_shotgun_heavy'
    WeaponSteamReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_noammo_large_alien_sweetener'
    WeaponExpandSound = WwiseEvent'Wwise_Weapons_S_GethShot.Play_wep_s_gethshot_expand'
    WeaponCollapseSound = WwiseEvent'Wwise_Weapons_S_GethShot.Play_wep_s_gethshot_collapse'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    ChargeUpPS = ChargePSC
    PowerUpSound = WwiseEvent'Wwise_Weapons_S_GethShot.Play_wep_s_gethshot_charge_start'
    PowerDownSound = WwiseEvent'Wwise_Weapons_S_GethShot.Play_wep_s_gethshot_charge_stop'
    MaxChargeTime = 2.0
    WeaponAcquiredID = 21241
    WeaponAcquiredID_NGP = 21581
    DefaultFireMode = FireModes.FireMode_SemiAuto
    bCanBlindUp = FALSE
    WeaponFireTypes = (EWeaponFireType.EWFT_InstantHit, EWeaponFireType.EWFT_Projectile, EWeaponFireType.EWFT_Projectile, EWeaponFireType.EWFT_InstantHit, EWeaponFireType.EWFT_InstantHit)
    WeaponProjectiles = (None, Class'SFXProjectile_GethShotgun', Class'SFXProjectile_GethShotgun')
    InstantHitMomentum = (0.0, 40.0, 40.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_GethShotgun', Class'SFXDamageType_GethShotgun', Class'SFXDamageType_Default')
    FireOffset = {X = 66.0, Y = -1.0, Z = 1.0}
    Mesh = WeaponMesh
    AIRating = 20.0
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}