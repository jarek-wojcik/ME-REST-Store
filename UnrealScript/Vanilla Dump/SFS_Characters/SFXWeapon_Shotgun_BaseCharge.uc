Class SFXWeapon_Shotgun_BaseCharge extends SFXWeapon_Shotgun_Base
    placeable
    config(Weapon);

public simulated function ConsumeAmmo(byte FireModeNum)
{
    if (ChargeAmount > 0.5 && GetMagazineSize() - AmmoUsedCount >= 2)
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

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
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
    Begin Object Class=ParticleSystemComponent Name=ChargePSC
        ReplacementPrimitive = None
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    GUIZoomReticleClass = Class'SFXGUI_ShotgunReticle'
    ChargeCameraShake = {
                         RotAmplitude = {X = 6.0, Y = 6.0, Z = 0.0}, 
                         RotFrequency = {X = 60.0, Y = 60.0, Z = 60.0}, 
                         LocAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                         ShakeName = 'GethShotgunCharge', 
                         TimeDuration = 1000.0, 
                         FOVAmplitude = 0.0
                        }
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ReloadVent = ReloadVent0
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    ChargeUpPS = ChargePSC
    MaxChargeFireRumble = 120.0
    MinChargeFireRumble = 50.0
    MaxChargeCameraShake = 85.0
    bLoopingFlashEmitter = TRUE
    DefaultFireMode = FireModes.FireMode_FullAuto
    Mesh = WeaponMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}