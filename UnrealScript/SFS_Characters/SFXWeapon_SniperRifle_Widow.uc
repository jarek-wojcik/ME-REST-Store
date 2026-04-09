Class SFXWeapon_SniperRifle_Widow extends SFXWeapon_SniperRifle_Base
    placeable
    config(Weapon);

public simulated function DecalComponent GetWeaponSpecificDecalData(SFXPhysicalMaterialDecals DecalEffects, out float FadeTime)
{
    local int DecalLength;
    
    FadeTime = DecalEffects.MassCannonFadeTime;
    DecalLength = DecalEffects.MassCannon.Length;
    if (DecalLength > 0)
    {
        return DecalEffects.MassCannon[Rand(DecalLength)];
    }
    return None;
}
public static simulated function ParticleSystem GetWeaponSpecificImpactEffect(SFXPhysicalMaterialImpactEffects ImpactEffects)
{
    return ImpactEffects.MassCannon;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        return ImpactSounds.MassCannon_Player;
    }
    return ImpactSounds.MassCannon;
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
        SkeletalMesh = SkeletalMesh'biog_wpn_snp_r.SNPc.WPN_SNPc_MDL'
        AnimTreeTemplate = AnimTree'biog_animtree_weapon.BIOG_WPN_Main_O'
        PhysicsAsset = PhysicsAsset'BIOG_PHY_Weapons_F.PHY_WPN_SNPc'
        AnimSets = (AnimSet'biog_wpn_a.WPN_SNPc_Main')
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'biog_wpn_snp_r.SNPc.WPN_SNPc_MDL'
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
        Template = ParticleSystem'BioVFX_C_Weapons.Muzzles.Particles.Sniper_Muzzle_MassCannon'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=ParticleSystemComponent Name=ShellCasingPSC0
        Template = ParticleSystem'BioVFX_C_Reload.Particles.Reload_HeatSinkEject'
        bAutoActivate = FALSE
        ReplacementPrimitive = None
    End Object
    Begin Object Class=SFXAnimSetCookSpec Name=tempAnimInfo
        AnimSet = AnimSet'BIOG_HMM_CB_A.HMM_CB_SniperAuto_AlternateSlow'
    End Object
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
        Samples = ({Duration = 0.649999976, LeftAmplitude = 100, RightAmplitude = 100, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
        Samples = ({Duration = 0.150000006, LeftAmplitude = 50, RightAmplitude = 50, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}, 
                   {Duration = 0.25, LeftAmplitude = 0, RightAmplitude = 0, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}, 
                   {Duration = 0.25, LeftAmplitude = 50, RightAmplitude = 50, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
                  )
    End Template
    Begin Template Class=SFXCameraSetup Name=CameraSetup0
        Begin Template Class=SFXCameraMode_Combat Name=CombatCam0
        End Template
        Begin Template Class=SFXCameraMode_Roll Name=RollCam0
        End Template
        Begin Template Class=SFXCameraMode_Explore Name=ExploreCam0
        End Template
        Begin Template Class=SFXCameraMode_CombatStorm Name=CombatStormCam0
        End Template
        Begin Template Class=SFXCameraMode_ExploreStorm Name=ExploreStormCam0
        End Template
        Begin Template Class=SFXCameraMode_SplitScreenCombat Name=SSCombatCam0
        End Template
        Begin Template Class=SFXCameraMode_EnterCover Name=EnterCoverCam0
        End Template
        Begin Template Class=SFXCameraMode_Melee Name=MeleeCam0
        End Template
        Begin Template Class=SFXCameraMode_LadderUp Name=LadderUp0
        End Template
        Begin Template Class=SFXCameraMode_LadderDown Name=LadderDown0
        End Template
        Begin Template Class=SFXCameraMode_HitReaction Name=HitReact0
        End Template
        Begin Template Class=SFXCameraTransition_ZoomSnap Name=ZoomSnapTransition0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=DefaultCrouch0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=DefaultStand0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=PeekLeftCrouch0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=PeekLeftStand0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=PeekRightCrouch0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=PeekRightStand0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=Aimback0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=BlindLeftCrouch0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=BlindLeftStand0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=BlindRightCrouch0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=BlindRightStand0
        End Template
        Begin Template Class=SFXCameraMode_HipAimCover Name=BlindUp0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=PowerCover0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=PowerCoverMidLeft0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=PowerCoverMidRight0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=PowerCoverStdLeft0
        End Template
        Begin Template Class=SFXCameraMode_Combat Name=PowerCoverStdRight0
        End Template
        CombatCam = CombatCam0
        RollCam = RollCam0
        ExploreCam = ExploreCam0
        CombatStormCam = CombatStormCam0
        ExploreStormCam = ExploreStormCam0
        SSCombatCam = SSCombatCam0
        EnterCoverCam = EnterCoverCam0
        MeleeCam = MeleeCam0
        LadderUp = LadderUp0
        LadderDown = LadderDown0
        HitReact = HitReact0
        ZoomSnapTransition = ZoomSnapTransition0
        DefaultCrouch = DefaultCrouch0
        DefaultStand = DefaultStand0
        PeekLeftCrouch = PeekLeftCrouch0
        PeekLeftStand = PeekLeftStand0
        PeekRightCrouch = PeekRightCrouch0
        PeekRightStand = PeekRightStand0
        DefaultAimback = Aimback0
        BlindLeftCrouch = BlindLeftCrouch0
        BlindLeftStand = BlindLeftStand0
        BlindRightCrouch = BlindRightCrouch0
        BlindRightStand = BlindRightStand0
        BlindUp = BlindUp0
        PowerCoverPopup = PowerCover0
        PowerCoverMidLeanLeft = PowerCoverMidLeft0
        PowerCoverMidLeanRight = PowerCoverMidRight0
        PowerCoverStdLeanLeft = PowerCoverStdLeft0
        PowerCoverStdLeanRight = PowerCoverStdRight0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_WeaponModManager Name=ModManager0
    End Template
    ActivateSniperZoomWwiseEvent = WwiseEvent'Wwise_Weapons_P_Widow.Play_wep_p_widow_scope_in'
    DeActivateSniperZoomWwiseEvent = WwiseEvent'Wwise_Weapons_P_Widow.Play_wep_p_widow_scope_out'
    AI_AccCone_Min = {X = 1.04999995, Y = 1.04999995}
    AI_AccCone_Max = {X = 1.04999995, Y = 1.04999995}
    ReloadDuration = {X = 2.97000003, Y = 2.97000003}
    Damage = {X = 867.0, Y = 1083.80005}
    MaxSpareAmmo = {X = 7.0, Y = 17.0}
    MinAimError = {X = 1.60000002, Y = 1.60000002}
    MaxAimError = {X = 3.0999999, Y = 3.0999999}
    RateOfFire = {X = 70.0, Y = 70.0}
    EncumbranceWeight = {X = 2.5, Y = 2.0}
    Recoil = {X = 5.0, Y = 5.0}
    ZoomRecoil = {X = 3.0, Y = 3.0}
    AccFirePenalty = {X = 0.5, Y = 0.5}
    AccFireInterpSpeed = {X = 8.0, Y = 8.0}
    StatBarAccuracy = {X = 75.0, Y = 75.0}
    StatBarDamage = {X = 867.0, Y = 1083.80005}
    StatBarRateOfFire = {X = 20.0, Y = 20.0}
    GUIImage = "gui_codex_images.Weapons.snp_widow_512x256"
    NotificationImage = "GUI_Icons.Weapons.snp_widow_256x128"
    ZoomSnapList = ({OuterSnapAngle = 5.0, InnerSnapAngle = 0.5, SnapOffsetMag = 20.0, AimNode = EAimNodes.AimNode_Cover}, 
                    {OuterSnapAngle = 20.0, InnerSnapAngle = 10.0, SnapOffsetMag = 10.0, AimNode = EAimNodes.AimNode_Chest}, 
                    {OuterSnapAngle = 0.0, InnerSnapAngle = 0.0, SnapOffsetMag = 0.0, AimNode = EAimNodes.AimNode_Head}
                   )
    WeaponModBodyColours = ({R = 0.300000012, G = 0.0900000036, B = 0.0199999996, A = 0.0}, 
                            {R = 1.0, G = 0.660000026, B = 0.209999993, A = 0.0}, 
                            {R = 0.180000007, G = 0.280000001, B = 0.230000004, A = 0.0}, 
                            {R = 0.270000011, G = 0.310000002, B = 0.310000002, A = 0.0}, 
                            {R = 0.0, G = 0.0, B = 0.0, A = 0.0}
                           )
    GUIZoomReticleClass = Class'SFXGUI_StandardSniperZoomReticle'
    FiringShake = {
                   RotAmplitude = {X = 1100.0, Y = 200.0, Z = -1100.0}, 
                   RotFrequency = {X = 45.0, Y = 25.0, Z = 45.0}, 
                   LocAmplitude = {X = 25.0, Y = 0.0, Z = 0.0}, 
                   LocFrequency = {X = 25.0, Y = 0.0, Z = 0.0}, 
                   TimeDuration = 0.319999993
                  }
    TightAimFiringShake = {
                           RotAmplitude = {X = 145.0, Y = 65.0, Z = 105.0}, 
                           RotFrequency = {X = 100.0, Y = 50.0, Z = 50.0}, 
                           LocAmplitude = {X = 4.0, Y = 0.0, Z = 0.0}, 
                           TimeDuration = 0.300000012
                          }
    TracerInfo = {
                  Scale3D = {X = 2.5, Y = 1.0, Z = 1.0}, 
                  StaticMesh = StaticMesh'BioVFX_C_Weapons.Tracers.Meshes.Tracer_Cannon_Mesh', 
                  StandardPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail_Sniper', 
                  PlayerPSTemplate = ParticleSystem'BioVFX_C_Weapons.Tracers.Particles.Tracer_Smoke_Trail_Sniper', 
                  AccelRate = 15000.0, 
                  Speed = 18000.0, 
                  MaxSpeed = 22000.0
                 }
    MuzzleIdlePosition = {X = 98.0, Y = 8.0, Z = 33.0}
    AI_BurstFireCount = {X = 1.0, Y = 1.0}
    AI_BurstFireDelay = {X = 0.25, Y = 0.349999994}
    ReloadAnimInfo = tempAnimInfo
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PS_DefaultImpactEffect = ParticleSystem'BioVFX_C_Impacts.Generic.Particles.HeavySniper_Imp'
    ImpactScale = 2.0
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    EjectShellCasingTimeRatio = 0.463
    NoAmmoFireSoundDelay = 1.0
    RateOfFireAI = 1.0
    RecoilInterpSpeed = 40.0
    RecoilZoomFadeSpeed = 3.0
    RecoilYawScale = 0.600000024
    DistancePenetrated = 50.0
    IconRef = 12
    PrettyName = $209739
    ShortPrettyName = $209739
    ShortDescription = $339324
    GeneralDescription = $338248
    FireSound = WwiseEvent'wwise_weapons_np_widow.Play_wep_np_widow_fire'
    PlayerFireSound = WwiseEvent'Wwise_Weapons_P_Widow.Play_wep_p_widow_fire'
    FireNoAmmoSound = WwiseEvent'Wwise_Weapons_Standard_LowAmmo.Play_weapon_dryfire_shotguns'
    WeaponReloadSound = WwiseEvent'Wwise_Weapons_Generic.Play_wep_g_reload_sniper_heavy'
    WeaponExpandSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_sniper_expand'
    WeaponCollapseSound = WwiseEvent'Wwise_Generic_Gameplay.Play_foley_weapon_sniper_collapse'
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    CameraSetup = CameraSetup0
    WeaponAcquiredID = 21237
    WeaponAcquiredID_NGP = 21577
    bNotRegularWeaponGUI = TRUE
    InstantHitMomentum = (0.0, 75.0, 75.0, 1.0)
    InstantHitDamageTypes = (None, Class'SFXDamageType_SniperRifle_Widow', Class'SFXDamageType_SniperRifle_Widow', Class'SFXDamageType_Default')
    Mesh = WeaponMesh
    AIRating = 20.0
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}