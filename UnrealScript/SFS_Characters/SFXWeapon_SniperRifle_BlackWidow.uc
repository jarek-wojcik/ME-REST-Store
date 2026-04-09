Class SFXWeapon_SniperRifle_BlackWidow extends SFXWeapon_SniperRifle_Widow
    placeable
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ParticleSystemComponent Name=OutOfAmmoEffect0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=WeaponMesh
        SkeletalMesh = SkeletalMesh'biog_wpn_snp_r.SNPj.WPN_SNPj_MDL'
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SkeletalMeshComponent Name=PickupMesh
        SkeletalMesh = SkeletalMesh'biog_wpn_snp_r.SNPj.WPN_SNPj_MDL'
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
    Begin Template Class=ParticleSystemComponent Name=MuzFlashPSC0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ParticleSystemComponent Name=ShellCasingPSC0
        ReplacementPrimitive = None
    End Template
    Begin Template Class=SFXAnimSetCookSpec Name=tempAnimInfo
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=OutOfAmmoRumble0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformBase
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=EjectRumble0
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
    Damage = {X = 514.099976, Y = 642.599976}
    MagSize = {X = 3.0, Y = 3.0}
    MaxSpareAmmo = {X = 15.0, Y = 25.0}
    RateOfFire = {X = 60.0, Y = 60.0}
    Recoil = {X = 5.5, Y = 5.5}
    StatBarDamage = {X = 514.099976, Y = 642.599976}
    StatBarRateOfFire = {X = 50.0, Y = 50.0}
    GUIImage = "gui_codex_images.Weapons.snp_blackwidow_512x256"
    NotificationImage = "GUI_Icons.Weapons.snp_blackwidow_256x128"
    ReloadAnimInfo = tempAnimInfo
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ShellCasing = ShellCasingPSC0
    PSC_ReloadVent = ReloadVent0
    PSC_MuzFlashEmitter = MuzFlashPSC0
    LowAmmoSoundThreshold = 1.0
    RecoilZoomFadeSpeed = 2.0
    DistancePenetrated = 25.0
    PrettyName = $692577
    ShortPrettyName = $692577
    ShortDescription = $707215
    GeneralDescription = $707214
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    CameraSetup = CameraSetup0
    WeaponAcquiredID = 21246
    Mesh = WeaponMesh
    DroppedPickupMesh = PickupMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}