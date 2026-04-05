Class SFXWeapon_AssaultRifle_Base extends SFXWeapon
    placeable
    abstract
    config(Weapon);

var int ShotsTillMissTracer;

public simulated function PlayFireEffects(byte FiringMode, optional Vector HitLocation)
{
    ++ShotsTillMissTracer;
    if (ShotsTillMissTracer == 3)
    {
        ShotsTillMissTracer = 0;
    }
    Super.PlayFireEffects(FiringMode, HitLocation);
}
public static function EAttachSlot GetStoreQualification()
{
    return EAttachSlot.EASlot_RightShoulder;
}
public simulated function DecalComponent GetWeaponSpecificDecalData(SFXPhysicalMaterialDecals DecalEffects, out float FadeTime)
{
    local int DecalLength;
    
    FadeTime = DecalEffects.AssaultRifleFadeTime;
    DecalLength = DecalEffects.AssaultRifle.Length;
    if (DecalLength > 0)
    {
        return DecalEffects.AssaultRifle[Rand(DecalLength)];
    }
    return None;
}
public static simulated function ParticleSystem GetWeaponSpecificImpactEffect(SFXPhysicalMaterialImpactEffects ImpactEffects)
{
    return ImpactEffects.AssaultRifle;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        return ImpactSounds.AssaultRifle_Player;
    }
    return ImpactSounds.AssaultRifle;
}
public simulated function bool ShouldSpawnTracerFX()
{
    return ShotsTillMissTracer > 0 && Super.ShouldSpawnTracerFX();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ForceFeedbackWaveform Name=EjectRumble0
        Samples = ({Duration = 0.150000006, LeftAmplitude = 35, RightAmplitude = 35, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ParticleSystemComponent Name=AmmoPowerHologram
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ParticleSystemComponent Name=AmmoPowerIconHologram
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ParticleSystemComponent Name=ReloadVent0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        ReplacementPrimitive = None
    End Template
    ResearchUpgradeIds = (453, 451)
    AllowableWeaponMods = ("SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy", "SFXGameContent.SFXWeaponMod_AssaultRifleDamage", "SFXGameContent.SFXWeaponMod_AssaultRifleStability", "SFXGameContent.SFXWeaponMod_AssaultRifleMagSize", "SFXGameContent.SFXWeaponMod_AssaultRifleForce")
    DefaultModOptions = ("SFXGameContent.SFXWeaponMod_AssaultRifleAccuracy", "SFXGameContent.SFXWeaponMod_AssaultRifleDamage", "SFXGameContent.SFXWeaponMod_AssaultRifleMagSize", "SFXGameContent.SFXWeaponMod_AssaultRifleStability", "SFXGameContent.SFXWeaponMod_AssaultRifleForce")
    MuzzleIdlePosition = {X = 72.0, Y = 8.0, Z = 45.0}
    SwitchPriority = 80
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ReloadVent = ReloadVent0
    IconRef = 5
    GUIClassName = $338199
    GUIClassDescription = $340840
    GUIWeaponOrder = 0
    NuiSpeechName = $701640
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    DamageUpgradeId = 68
    bWeaponCanBeReloaded = TRUE
    AnimType = WeaponAnimType.WeaponAnimType_Rifle
    VocalizationType = ESFXVocalizationWeapon.SFXVocalizationWeapon_AssaultRifle
    Mesh = WeaponMesh
    bInstantHit = TRUE
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}