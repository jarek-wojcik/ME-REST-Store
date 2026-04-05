Class SFXWeapon_SMG_Base extends SFXWeapon
    placeable
    abstract
    config(Weapon);

public static function EAttachSlot GetStoreQualification()
{
    return EAttachSlot.EASlot_Holster;
}
public static simulated function ParticleSystem GetWeaponSpecificImpactEffect(SFXPhysicalMaterialImpactEffects ImpactEffects)
{
    return ImpactEffects.AutoPistol;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        return ImpactSounds.AutoPistol_Player;
    }
    return ImpactSounds.AutoPistol;
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
        Template = ParticleSystem'BioVFX_C_Reload.Particles.Reload_VentHeat_Small'
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
    ResearchUpgradeIds = (456, 457)
    AllowableWeaponMods = ("SFXGameContent.SFXWeaponMod_SMGDamage", "SFXGameContent.SFXWeaponMod_SMGMagSize", "SFXGameContent.SFXWeaponMod_SMGAccuracy", "SFXGameContent.SFXWeaponMod_SMGStability", "SFXGameContent.SFXWeaponMod_SMGConstraintDamage")
    DefaultModOptions = ("SFXGameContent.SFXWeaponMod_SMGDamage", "SFXGameContent.SFXWeaponMod_SMGStability", "SFXGameContent.SFXWeaponMod_SMGAccuracy", "SFXGameContent.SFXWeaponMod_SMGMagSize", "SFXGameContent.SFXWeaponMod_SMGConstraintDamage")
    MeleePowerName = 'Pistol_Whip'
    SwitchPriority = 60
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ReloadVent = ReloadVent0
    IdealTargetDistance = 1000.0
    IdealMaxRange = 2500.0
    IconRef = 7
    GUIClassName = $338200
    GUIClassDescription = $340841
    GUIWeaponOrder = 10
    NuiSpeechName = $696420
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    DamageUpgradeId = 426
    bWeaponCanBeReloaded = TRUE
    AimNodeProfileID = AimProfiles.AimProfile_Pistol
    IKProfileID = IKProfiles.IKProfile_Pistol
    AttachSlot = EAttachSlot.EASlot_Holster
    VocalizationType = ESFXVocalizationWeapon.SFXVocalizationWeapon_SMG
    Mesh = WeaponMesh
    bInstantHit = TRUE
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}