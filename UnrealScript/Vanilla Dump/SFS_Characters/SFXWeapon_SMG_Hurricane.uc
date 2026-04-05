Class SFXWeapon_SMG_Hurricane extends SFXWeapon_SMG_Base
    placeable
    config(Weapon);

var const float WindUpDelay;
var WwiseEvent PlayerWindUpSound;
var WwiseEvent WindUpSound;
var WwiseEvent PlayerWindDownSound;
var WwiseEvent WindDownSound;

public event simulated function WeaponStoppedFiring(byte FiringMode)
{
    Super(SFXWeapon).WeaponStoppedFiring(FiringMode);
    if (bDummyFireWeapon)
    {
        WeaponPlayWwiseEvent(WindDownSound);
    }
}
public simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
    if (bViaReplication)
    {
        if (int(FiringMode) == 2)
        {
            PlayWindUpEffects();
        }
        else
        {
            PlayWindDownEffects();
        }
    }
    Super(SFXWeapon).FireModeUpdated(FiringMode, bViaReplication);
}
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
public simulated function PlayWindDownEffects()
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        WeaponPlayWwiseEvent(PlayerWindDownSound);
    }
    else
    {
        WeaponPlayWwiseEvent(WindDownSound);
    }
}
public simulated function PlayWindUpEffects()
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        WeaponPlayWwiseEvent(PlayerWindUpSound);
    }
    else
    {
        WeaponPlayWwiseEvent(WindUpSound);
    }
}

simulated state WeaponFiring 
{
    public simulated function EndState(Name NextStateName)
    {
        Super(SFXWeapon).EndState(NextStateName);
        PlayWindDownEffects();
        SetCurrentFireMode(0);
    }
    public simulated function BeginState(Name PreviousStateName)
    {
        SetCurrentFireMode(2);
        PlayWindUpEffects();
    }
    
Begin:
    Sleep(WindUpDelay);
    FireAmmunition();
    TimeWeaponFiring(CurrentFireMode);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_PST_R.PSTk.WPN_PSTk_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_PSTk'
        AnimSets = (AnimSet'biog_wpn_a.WPN_PSTk_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'BIOG_WPN_PST_R.PSTk.WPN_PSTk_MDL'
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
        Samples = ({Duration = 0.200000003, LeftAmplitude = 75, RightAmplitude = 75, LeftFunction = EWaveformFunction.WF_Sin90to180, RightFunction = EWaveformFunction.WF_Sin90to180}
                  )
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    PlayerWindUpSound = WwiseEvent'Wwise_Weapons_P_Hurricane.Play_wep_p_hurricane_start'
    WindUpSound = WwiseEvent'Wwise_Weapons_NP_Hurricane.Play_wep_np_hurricane_start'
    PlayerWindDownSound = WwiseEvent'Wwise_Weapons_P_Hurricane.Play_wep_p_hurricane_stop'
    WindDownSound = WwiseEvent'Wwise_Weapons_NP_Hurricane.Play_wep_np_hurricane_stop'
    AI_AccCone_Min = {X = 1.39999998, Y = 1.39999998}
    AI_AccCone_Max = {X = 2.9000001, Y = 2.9000001}
    ReloadDuration = {X = 1.5, Y = 1.5}
    Damage = {X = 60.4000015, Y = 75.5}
    MagSize = {X = 40.0, Y = 40.0}
    MaxSpareAmmo = {X = 240.0, Y = 300.0}
    MinAimError = {X = 2.75, Y = 2.75}
    MaxAimError = {X = 4.0999999, Y = 4.0999999}
    MinZoomAimError = {X = 1.60000002, Y = 1.60000002}
    MaxZoomAimError = {X = 3.5999999, Y = 3.5999999}
    RateOfFire = {X = 600.0, Y = 600.0}
    EncumbranceWeight = {X = 1.0, Y = 0.5}
    Recoil = {X = 0.949999988, Y = 0.949999988}
    ZoomRecoil = {X = 1.25, Y = 1.25}
    AccFirePenalty = {X = 6.5, Y = 6.5}
    AccFireInterpSpeed = {X = 5.0, Y = 5.0}
    ZoomAccFirePenalty = {X = 12.5, Y = 12.5}
    ZoomAccFireInterpSpeed = {X = 15.0, Y = 15.0}
    MinZoomCrosshairRange = {X = 25.0, Y = 25.0}
    StatBarAccuracy = {X = 15.0, Y = 15.0}
    StatBarDamage = {X = 60.4000015, Y = 75.5}
    StatBarRateOfFire = {X = 1200.0, Y = 1200.0}
    GUIImage = "gui_codex_images.Weapons.smg_hurricane_512x256"
    NotificationImage = "GUI_Icons.Weapons.smg_hurricane_256x128"
    WeaponModBodyColours = ({R = 0.360000014, G = 0.25999999, B = 0.100000001, A = 0.0}, 
                            {R = 1.0, G = 0.889999986, B = 0.50999999, A = 0.0}, 
                            {R = 0.239999995, G = 0.289999992, B = 0.109999999, A = 0.0}, 
                            {R = 0.360000014, G = 0.419999987, B = 0.560000002, A = 0.0}, 
                            {R = 0.0500000007, G = 0.0500000007, B = 0.0500000007, A = 0.0}
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
    LowAmmoSoundThreshold = 10.0
    SteamSoundThreshold = 1.0
    NoAmmoFireSoundDelay = 0.5
    MinRefireTime = 0.150000006
    LazyRateOfFire = 150.0
    RateOfFireAI = 1.0
    AmmoPerShot = 2.0
    RecoilYawScale = 0.200000003
    RecoilYawFrequency = 4.0
    IconRef = 54
    PrettyName = $573100
    ShortPrettyName = $573100
    ShortDescription = $573118
    GeneralDescription = $573085
    FireSound = WwiseEvent'Wwise_Weapons_NP_Hurricane.Play_wep_np_hurricane_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Hurricane.Play_wep_p_hurricane_fire'
    FireNoAmmoSound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_dryfire_pistols'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_pistol_normal'
    SteamReloadNotifySound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_reload_air_release'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    bLoopingFlashEmitter = TRUE
    AnimType = WeaponAnimType.WeaponAnimType_AutoPistol
    InstantHitMomentum = (0.0, 1.0, 20.0, 20.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_Default', Class'SFXDamageType_SMG_Tempest', Class'SFXDamageType_SMG_Tempest')
    FireOffset = {X = 19.0, Y = 0.5, Z = 4.0}
    Mesh = WeaponMesh
    AIRating = 20.0
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}