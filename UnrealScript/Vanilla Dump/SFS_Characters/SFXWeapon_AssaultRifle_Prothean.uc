Class SFXWeapon_AssaultRifle_Prothean extends SFXWeapon_Heavy_Beam_Base_DLC
    placeable
    config(Weapon);

var string AmmoAmountRTPC;
var ScreenShakeStruct HoldShake;
var Guid ClientEffectFiringGuid;
var config float RechargeRatePerSecond;
var config float PartialRechargeDelay;
var config float FullRechargeDelay;
var float AccumulatedAmmo;
var RvrClientEffectInterface CE_HeatVent;
var config float TimeToHeatUp;
var config float TimeToHeatUpAI;
var config float ProtheanDamageMultiplier;
var float FireStartTime;
var float SteamDelay;
var bool bFireSoundPlaying;
var bool bIsHot;

public simulated function Tick(float DeltaTime)
{
    local SFXPlayerController PC;
    local float ShakeStrength;
    
    Super.Tick(DeltaTime);
    if (IsInState('WeaponFiring', ))
    {
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript(AmmoAmountRTPC, float(GetCurrentTotalAmmo()));
    }
    if (AmmoUsedCount == GetMagazineSize())
    {
        bWeaponCanBeReloaded = TRUE;
    }
    else if (WorldInfo.GameTimeSeconds - LastFireTime >= PartialRechargeDelay)
    {
        bWeaponCanBeReloaded = FALSE;
        RechargeAmmo(DeltaTime);
    }
    if (Instigator != None && IsInState('WeaponFiring', ))
    {
        PC = SFXPlayerController(Instigator.Controller);
        ShakeStrength = FClamp((WorldInfo.GameTimeSeconds - FireStartTime) / TimeToHeatUp, 0.0, 1.0);
        PC.PlayScaledCameraShake(HoldShake, ShakeStrength);
    }
}
public simulated function ConsumeAmmo(byte FireModeNum)
{
    if (bIsHot == TRUE && GetMagazineSize() - AmmoUsedCount > 1)
    {
        AmmoPerShot = 2.0;
    }
    else
    {
        AmmoPerShot = 1.0;
    }
    Super(SFXWeapon).ConsumeAmmo(FireModeNum);
    AmmoPerShot = 1.0;
}
public simulated function WeaponFired(byte FiringMode, bool bViaReplication, optional Vector HitLocation)
{
    Super(SFXWeapon).WeaponFired(FiringMode, bViaReplication, HitLocation);
    LastFireTime = WorldInfo.GameTimeSeconds;
}
public simulated function DoReload()
{
    __OnWeaponReload__Delegate(Self);
    AmmoUsedCount -= 1;
    PlayReloadEject();
    if (SFXPawn_Player(Owner) != None)
    {
        SFXPawn_Player(Owner).bIsFullAmmo = FALSE;
    }
    if (SFXPawn_Player(Owner) != None)
    {
        SFXPawn_Player(Owner).OutOfAmmoTimestamp = 0.0;
    }
}
public simulated function int GetCurrentSpareAmmo()
{
    return 0;
}
public simulated function float GetFireModeBaseDamage()
{
    local float BaseDamage;
    
    BaseDamage = Super(SFXWeapon).GetFireModeBaseDamage();
    if (bIsHot)
    {
        BaseDamage *= ProtheanDamageMultiplier;
    }
    return BaseDamage;
}
public static simulated function ParticleSystem GetWeaponSpecificImpactEffect(SFXPhysicalMaterialImpactEffects ImpactEffects)
{
    return None;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    return None;
}
public simulated function InitDefaultDecalProperties()
{
    DefaultDecalProperties = new (Self) Class'DecalComponent';
    DefaultDecalProperties.Width = 0.0;
    DefaultDecalProperties.Height = 0.0;
    DefaultDecalProperties.TileX = 0.0;
    DefaultDecalProperties.DepthBias = -0.0;
    DefaultDecalProperties.bNoClip = TRUE;
    DefaultDecalProperties.SetDecalMaterial(DefaultDecalMaterial);
}
public simulated function bool IsMuzzleFlashRelevant()
{
    if (Instigator == None || Instigator.IsHumanControlled())
    {
        return TRUE;
    }
    if (WorldInfo.bAggressiveLOD)
    {
        return FALSE;
    }
    return TRUE;
}
public simulated function bool OutOfAmmo()
{
    return FALSE;
}
public function GunIsCold()
{
    local Vector IntensityVector;
    local float IntensityScalar;
    
    bIsHot = FALSE;
    IntensityVector.X = 0.0;
    IntensityVector.Y = 0.0;
    IntensityVector.Z = 0.0;
    IntensityScalar = 0.0;
    PSC_MuzFlashEmitter.SetVectorParameter('Intensity', IntensityVector);
    PSC_MuzFlashEmitter.SetFloatParameter('Intensity', IntensityScalar);
}
public function GunIsHot()
{
    local Vector IntensityVector;
    local float IntensityScalar;
    
    bIsHot = TRUE;
    IntensityVector.X = 1.0;
    IntensityVector.Y = 1.0;
    IntensityVector.Z = 1.0;
    IntensityScalar = 1.0;
    PSC_MuzFlashEmitter.SetVectorParameter('Intensity', IntensityVector);
    PSC_MuzFlashEmitter.SetFloatParameter('Intensity', IntensityScalar);
}
public function PlayLoopingAnim()
{
    WeaponAnimNode.PlayCustomAnim('WPN_ChargeHold', 1.5, 0.0, 0.200000003, TRUE);
}
public simulated function PlayReloadSteam()
{
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(CE_HeatVent, Instigator);
}
public simulated function RechargeAmmo(float DeltaTime)
{
    local int AmmoRounded;
    local float fMagSize;
    
    fMagSize = float(GetMagazineSize());
    AccumulatedAmmo += RechargeRatePerSecond * DeltaTime * fMagSize;
    AccumulatedAmmo = FClamp(AccumulatedAmmo, 0.0, float(AmmoUsedCount));
    if (AccumulatedAmmo >= 1.0)
    {
        AmmoRounded = int(AccumulatedAmmo);
        AmmoUsedCount -= AmmoRounded;
        AccumulatedAmmo -= float(AmmoRounded);
    }
}
public simulated function StopFireSounds()
{
    if (bFireSoundPlaying)
    {
        WeaponPlayWwiseEvent(PowerDownSound);
        bFireSoundPlaying = FALSE;
    }
}

simulated state Reloading 
{
    public simulated function DoAReload()
    {
        Super(SFXWeapon).DoAReload();
        SetTimer(SteamDelay, FALSE, 'PlayReloadSteam', );
    }
    
    stop;
};
state WeaponFiring 
{
    public simulated function StopFire(byte FireModeNum)
    {
        Super(SFXWeapon).StopFire(FireModeNum);
        StopFireSounds();
    }
    public event simulated function EndState(Name NextStateName)
    {
        Super(SFXWeapon).EndState(NextStateName);
        StopFireSounds();
        GunIsCold();
        WeaponAnimNode.StopCustomAnim(0.200000003);
        ClearTimer('GunIsHot');
        ClearTimer('PlayLoopingAnim');
        if (bIsHot)
        {
            WeaponAnimNode.PlayCustomAnim('WPN_ChargeRelease', 1.0);
        }
        Super(SFXWeapon).EndState(NextStateName);
    }
    public simulated function BeginState(Name PreviousStateName)
    {
        GetModule(Class'SFXModule_GameEffectManager').RemoveEffectsByType(Class'SFXGameEffect_WeaponVFXChange');
        GunIsCold();
        FireStartTime = WorldInfo.GameTimeSeconds;
        Super(SFXWeapon).BeginState(PreviousStateName);
        if (!bFireSoundPlaying)
        {
            WeaponPlayWwiseEvent(PowerUpSound);
            bFireSoundPlaying = TRUE;
        }
        WeaponAnimNode.PlayCustomAnim('WPN_ChargeUp', 1.0);
        Super(SFXWeapon).BeginState(PreviousStateName);
        if (SFXPawn_Player(Owner) != None)
        {
            SetTimer(TimeToHeatUp, FALSE, 'GunIsHot', );
            SetTimer(TimeToHeatUp, FALSE, 'PlayLoopingAnim', );
        }
        else if (SFXPawn_Henchman(Owner) != None)
        {
            SetTimer(TimeToHeatUpAI, FALSE, 'GunIsHot', );
        }
    }
    
    stop;
};
state Inactive 
{
    public event simulated function BeginState(Name PreviousStateName)
    {
        StopFireSounds();
        Super(SFXWeapon).BeginState(PreviousStateName);
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
        Samples = ({Duration = 0.100000001, LeftAmplitude = 35, RightAmplitude = 35, LeftFunction = EWaveformFunction.WF_Sin90to180, RightFunction = EWaveformFunction.WF_Sin90to180}
                  )
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ParticleSystemComponent Name=AmmoPowerHologram
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ParticleSystemComponent Name=AmmoPowerIconHologram
        ReplacementPrimitive = None
    End Template
    Begin Object Class=ParticleSystemComponent Name=MuzFlashPSC0
        Template = ParticleSystem'BioVFX_C_Wpn_HEN_PR.Particles.HEN_PR_Beam'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
        bIgnoreHiddenActorsMembership = TRUE
    End Object
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ParticleSystemComponent Name=ReloadVent0
        ReplacementPrimitive = None
    End Template
    Begin Object Class=ParticleSystemComponent Name=ShellCasingPSC0
        Template = ParticleSystem'BioVFX_C_Reload.Particles.Reload_VentHeat_Geth_2'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        AnimSet = AnimSet'BIOG_HMM_CB_HEN_PR.HMM_CB_ProtheanRifleReload'
    End Object
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_ASL_R_HEN_PR.ASLm.WPN_ASLm_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_f_HEN_PR.PHY_WPN_ASLm'
        AnimSets = (AnimSet'BIOG_WPN_A_HEN_PR.WPN_ASLm_Main')
        ReplacementPrimitive = None
    End Template
    HoldShake = {
                 RotAmplitude = {X = 25.0, Y = 25.0, Z = 40.0}, 
                 RotFrequency = {X = 100.0, Y = 50.0, Z = 50.0}, 
                 RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 LocAmplitude = {X = 4.0, Y = 0.0, Z = 0.0}, 
                 LocFrequency = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 ShakeName = 'ProtheanGunShake', 
                 TimeToGo = 0.0, 
                 TimeDuration = 0.100000001, 
                 RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                 LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                 FOVAmplitude = 0.0, 
                 FOVFrequency = 0.0, 
                 FOVSinOffset = 0.0, 
                 TargetingDampening = 0.0, 
                 bOverrideTargetingDampening = FALSE, 
                 FOVParam = EShakeParam.ESP_OffsetRandom
                }
    RechargeRatePerSecond = 0.349999994
    PartialRechargeDelay = 1.5
    FullRechargeDelay = 5.0
    CE_HeatVent = RvrClientEffect'BioVFX_C_Wpn_HEN_PR.VCFX.Pro_Overheat'
    TimeToHeatUp = 2.0
    TimeToHeatUpAI = 1.0
    ProtheanDamageMultiplier = 4.0
    SteamDelay = 0.699999988
    BeamInterpSpeed = {X = 20.0, Y = 20.0}
    DecalFrequency = 5
    BeamInterpTime = 0.5
    VFXUpdateInterval = 0.00999999978
    AI_AccCone_Min = {X = 1.20000005, Y = 1.20000005}
    AI_AccCone_Max = {X = 1.79999995, Y = 1.79999995}
    ReloadDuration = {X = 5.0, Y = 5.0}
    Damage = {X = 17.2000008, Y = 21.3999996}
    MagSize = {X = 100.0, Y = 100.0}
    MaxSpareAmmo = {X = 1000000.0, Y = 1000000.0}
    MinAimError = {X = 0.0, Y = 0.0}
    MaxAimError = {X = 0.0, Y = 0.0}
    MinZoomAimError = {X = 0.0, Y = 0.0}
    MaxZoomAimError = {X = 0.0, Y = 0.0}
    RateOfFire = {X = 800.0, Y = 800.0}
    EncumbranceWeight = {X = 2.0, Y = 1.39999998}
    Recoil = {X = 0.0, Y = 0.0}
    ZoomRecoil = {X = 0.0, Y = 0.0}
    AccFirePenalty = {X = 0.0, Y = 0.0}
    AccFireInterpSpeed = {X = 0.0, Y = 0.0}
    ZoomAccFirePenalty = {X = 0.0, Y = 0.0}
    ZoomAccFireInterpSpeed = {X = 0.0, Y = 0.0}
    MinCrosshairRange = {X = 20.0, Y = 20.0}
    MaxCrosshairRange = {X = 20.0, Y = 20.0}
    MinZoomCrosshairRange = {X = 20.0, Y = 20.0}
    MaxZoomCrosshairRange = {X = 20.0, Y = 20.0}
    StatBarAccuracy = {X = 40.0, Y = 40.0}
    StatBarDamage = {X = 17.2000008, Y = 21.3999996}
    StatBarRateOfFire = {X = 800.0, Y = 800.0}
    GUIImage = "GUI_PR_Images.asl_prothean_512x256"
    NotificationImage = "GUI_PR_Images.asl_prothean_256x128"
    WeaponModBodyColours = ({R = 1.0, G = 0.239999995, B = 0.180000007, A = 0.0}, 
                            {R = 1.0, G = 0.74000001, B = 0.300000012, A = 0.0}, 
                            {R = 0.370000005, G = 0.50999999, B = 0.25, A = 0.0}, 
                            {R = 0.379999995, G = 0.389999986, B = 0.649999976, A = 0.0}, 
                            {R = 0.0799999982, G = 0.0900000036, B = 0.150000006, A = 0.0}
                           )
    GUIZoomReticleClass = Class'SFXGUI_WeaponReticleSimple'
    FiringShake = {
                   RotAmplitude = {X = 25.0, Y = 25.0, Z = 40.0}, 
                   RotFrequency = {X = 100.0, Y = 50.0, Z = 50.0}, 
                   LocAmplitude = {X = 4.0, Y = 0.0, Z = 0.0}, 
                   TimeDuration = 0.100000001
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 25.0, Y = 25.0, Z = 40.0}, 
                           RotFrequency = {X = 100.0, Y = 50.0, Z = 50.0}, 
                           LocAmplitude = {X = 4.0, Y = 0.0, Z = 0.0}, 
                           TimeDuration = 0.100000001
                          }
    AI_BurstFireCount = {X = 20.0, Y = 40.0}
    AI_BurstFireDelay = {X = 0.699999988, Y = 1.10000002}
    ReloadAnimInfo = tempAnimInfo
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PS_DefaultImpactEffect = ParticleSystem'BioVFX_C_Wpn_HEN_PR.Particles.HEN_PR_Generic_Impact'
    PS_DefaultMaterialImpactEffect = ParticleSystem'BioVFX_C_Wpn_HEN_PR.Particles.HEN_PR_Generic_Impact'
    DefaultDecalMaterial = None
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    EjectShellCasingTimeRatio = 0.800000012
    SteamSoundThreshold = 1.0
    NoAmmoFireSoundDelay = 0.5
    RateOfFireAI = 1.0
    RecoilInterpSpeed = 1.0
    RecoilFadeSpeed = 1.0
    RecoilZoomFadeSpeed = 1.0
    TraceRange = 4000.0
    IdealTargetDistance = 800.0
    IdealMaxRange = 1000.0
    IconResource = GFxMovieInfo'GUI_SF_ME3_DLC_Prothean.ME3_DLC_Prothean'
    IconRef = 2
    PrettyName = $727492
    ShortPrettyName = $727492
    ShortDescription = $727493
    GeneralDescription = $727494
    DefaultImpactSound = WwiseEvent'Wwise_Weapons_S_Prothean.Play_wep_np_prothean_impact'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_S_Prothean.Play_wep_s_prothean_overheat'
    WeaponSteamReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_noammo_large_alien_sweetener'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    PowerUpSound = WwiseEvent'Wwise_Weapons_S_Prothean.Play_wep_p_prothean_start'
    PowerDownSound = WwiseEvent'Wwise_Weapons_S_Prothean.Play_wep_p_prothean_stop'
    NPCPowerUpSound = WwiseEvent'Wwise_Weapons_S_Prothean.Play_wep_np_prothean_start'
    NPCPowerDownSound = WwiseEvent'Wwise_Weapons_S_Prothean.Play_wep_np_prothean_stop'
    WeaponAcquiredID = 22746
    WeaponAcquiredID_NGP = 22747
    bSuppressTracers = TRUE
    bWeaponCanBeReloaded = FALSE
    bZoomSnapEnabled = FALSE
    bInfiniteAmmo = TRUE
    InstantHitMomentum = (0.0, 1.0, 0.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_Default', Class'SFXDamageType_Prothean', Class'SFXDamageType_Default')
    FireOffset = {X = 61.0, Y = -0.5, Z = 7.25}
    Mesh = WeaponMesh
    DroppedPickupMesh = WeaponMesh
    PickupFactoryMesh = WeaponMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}