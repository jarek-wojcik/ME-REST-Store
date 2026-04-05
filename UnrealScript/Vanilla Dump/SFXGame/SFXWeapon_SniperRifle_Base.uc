Class SFXWeapon_SniperRifle_Base extends SFXWeapon
    placeable
    abstract
    config(Weapon);

var config ScaledFloat ZoomTimeDilation;
var config ScaledFloat ZoomTimeDilationDuration;
var config ScaledFloat OwnerTimeDilationCounterScale;
var WwiseEvent ActivateSniperZoomWwiseEvent;
var WwiseEvent DeActivateSniperZoomWwiseEvent;
var float SniperRifleDamagePenalty;

public simulated function SetZoomed(bool bState)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_TimeDilation Effect;
    
    Super.SetZoomed(bState);
    if (SFXPawn_Player(Owner) != None && SFXPawn_Player(Owner).IsLocallyControlled())
    {
        if (bState)
        {
            SFXPawn_Player(Owner).PlaySound(ActivateSniperZoomWwiseEvent, TRUE);
            bPlayZoomSound = TRUE;
            ShouldAutoReload();
            if (ZoomTimeDilation.Value > 1.0 && ZoomTimeDilationDuration.Value > float(0))
            {
                Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
                if (Manager != None)
                {
                    Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_TimeDilation', Name);
                    Effect = SFXGameEffect_TimeDilation(Manager.CreateEffect(Class'SFXGameEffect_TimeDilation', Name, ZoomTimeDilationDuration.Value, 1, ZoomTimeDilation.Value - 1.0, SFXPawn(Owner).Controller));
                    if (Effect != None)
                    {
                        Effect.OwnerCounterScale = OwnerTimeDilationCounterScale.Value;
                        Effect.OnApplied();
                    }
                }
            }
        }
        else
        {
            Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None)
            {
                Manager.RemoveEffectsByTypeAndCategory(Class'SFXGameEffect_TimeDilation', Name);
            }
            if (bPlayZoomSound)
            {
                SFXPawn_Player(Owner).PlaySound(DeActivateSniperZoomWwiseEvent, TRUE);
                bPlayZoomSound = FALSE;
            }
        }
    }
}
public simulated function float GetFireModeBaseDamage()
{
    local float BaseDamage;
    
    BaseDamage = Super.GetFireModeBaseDamage();
    if (bIsZoomed == FALSE && SFXPawn_Player(Owner) != None)
    {
        BaseDamage = Damage.Value * SniperRifleDamagePenalty;
    }
    return BaseDamage;
}
public static function EAttachSlot GetStoreQualification()
{
    return EAttachSlot.EASlot_LeftShoulder;
}
public simulated function DecalComponent GetWeaponSpecificDecalData(SFXPhysicalMaterialDecals DecalEffects, out float FadeTime)
{
    local int DecalLength;
    
    FadeTime = DecalEffects.SniperRifleFadeTime;
    DecalLength = DecalEffects.SniperRifle.Length;
    if (DecalLength > 0)
    {
        return DecalEffects.SniperRifle[Rand(DecalLength)];
    }
    return None;
}
public static simulated function ParticleSystem GetWeaponSpecificImpactEffect(SFXPhysicalMaterialImpactEffects ImpactEffects)
{
    return ImpactEffects.SniperRifle;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        return ImpactSounds.SniperRifle_Player;
    }
    return ImpactSounds.SniperRifle;
}
public simulated function ScaleWeapon()
{
    Super.ScaleWeapon();
    Class'SFXGame'.static.ReCalculate(ZoomTimeDilation);
    Class'SFXGame'.static.ReCalculate(ZoomTimeDilationDuration);
    Class'SFXGame'.static.ReCalculate(OwnerTimeDilationCounterScale);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ForceFeedbackWaveform Name=EjectRumble0
        Samples = ({Duration = 0.150000006, LeftAmplitude = 45, RightAmplitude = 45, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
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
    Begin Object Class=SFXCameraMode_SniperAim Name=SniperAimPopup0
        Offset = {X = 85.0, Y = -32.0, Z = -38.0}
        HookOffset = {X = 0.0, Y = 5.0, Z = 28.0}
        CameraName = 'SniperPopup'
    End Object
    Begin Object Class=SFXCameraMode_SniperAim Name=SniperLeanLeftCrouch0
        Offset = {X = 125.0, Y = 115.0, Z = 20.0}
        HookOffset = {X = 25.0, Y = 15.0, Z = 75.0}
        HookName = 'CoverSlot'
        CameraName = 'SniperLeanLeftCrouch'
    End Object
    Begin Object Class=SFXCameraMode_SniperAim Name=SniperLeanLeftStand0
        Offset = {X = 125.0, Y = 110.0, Z = 20.0}
        HookOffset = {X = 25.0, Y = 15.0, Z = 115.0}
        HookName = 'CoverSlot'
        CameraName = 'SniperLeanLeftStand'
    End Object
    Begin Object Class=SFXCameraMode_SniperAim Name=SniperLeanRightCrouch0
        Offset = {X = 135.0, Y = -110.0, Z = 20.0}
        HookOffset = {X = 25.0, Y = -10.0, Z = 65.0}
        HookName = 'CoverSlot'
        CameraName = 'SniperLeanRightCrouch'
    End Object
    Begin Object Class=SFXCameraMode_SniperAim Name=SniperLeanRightStand0
        Offset = {X = 125.0, Y = -115.0, Z = 20.0}
        HookOffset = {X = 25.0, Y = -12.0, Z = 115.0}
        HookName = 'CoverSlot'
        CameraName = 'SniperLeanRightStand'
    End Object
    Begin Object Class=SFXCameraMode_SniperAim Name=SniperTightAim0
        Offset = {X = 85.0, Y = -32.0, Z = -38.0}
        HookOffset = {X = 0.0, Y = 5.0, Z = 28.0}
        CameraName = 'CombatTightAim'
    End Object
    Begin Object Class=SFXCameraSetup Name=CameraSetup0
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
        Begin Template Class=SFXCameraMode_Combat Name=CombatCam0
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
        Begin Template Class=SFXCameraMode_CombatStorm Name=CombatStormCam0
        End Template
        Begin Template Class=SFXCameraMode_EnterCover Name=EnterCoverCam0
        End Template
        Begin Template Class=SFXCameraMode_Explore Name=ExploreCam0
        End Template
        Begin Template Class=SFXCameraMode_ExploreStorm Name=ExploreStormCam0
        End Template
        Begin Template Class=SFXCameraMode_HipAimCover Name=BlindUp0
        End Template
        Begin Template Class=SFXCameraMode_HitReaction Name=HitReact0
        End Template
        Begin Template Class=SFXCameraMode_LadderDown Name=LadderDown0
        End Template
        Begin Template Class=SFXCameraMode_LadderUp Name=LadderUp0
        End Template
        Begin Template Class=SFXCameraMode_Melee Name=MeleeCam0
        End Template
        Begin Template Class=SFXCameraMode_Roll Name=RollCam0
        End Template
        Begin Template Class=SFXCameraMode_SplitScreenCombat Name=SSCombatCam0
        End Template
        Begin Template Class=SFXCameraTransition_ZoomSnap Name=ZoomSnapTransition0
        End Template
        CombatCam = CombatCam0
        RollCam = RollCam0
        CombatTightAim = SniperTightAim0
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
        AimbackTightAim = SniperTightAim0
        BlindLeftCrouch = BlindLeftCrouch0
        BlindLeftStand = BlindLeftStand0
        BlindRightCrouch = BlindRightCrouch0
        BlindRightStand = BlindRightStand0
        BlindUp = BlindUp0
        PopUp = SniperAimPopup0
        LeanLeftCrouch = SniperLeanLeftCrouch0
        LeanLeftStand = SniperLeanLeftStand0
        LeanRightCrouch = SniperLeanRightCrouch0
        LeanRightStand = SniperLeanRightStand0
        PowerCoverPopup = PowerCover0
        PowerCoverMidLeanLeft = PowerCoverMidLeft0
        PowerCoverMidLeanRight = PowerCoverMidRight0
        PowerCoverStdLeanLeft = PowerCoverStdLeft0
        PowerCoverStdLeanRight = PowerCoverStdRight0
    End Object
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
    ZoomTimeDilation = {
                        Bonuses = (), 
                        X = 1.0, 
                        Y = 1.0, 
                        MaxLevel = 100, 
                        Level = 0, 
                        Value = 0.0, 
                        StaticBonus = 1.0
                       }
    ZoomTimeDilationDuration = {
                                Bonuses = (), 
                                X = 1.5, 
                                Y = 1.5, 
                                MaxLevel = 100, 
                                Level = 0, 
                                Value = 0.0, 
                                StaticBonus = 1.0
                               }
    OwnerTimeDilationCounterScale = {
                                     Bonuses = (), 
                                     X = 0.400000006, 
                                     Y = 0.400000006, 
                                     MaxLevel = 100, 
                                     Level = 0, 
                                     Value = 0.0, 
                                     StaticBonus = 1.0
                                    }
    ActivateSniperZoomWwiseEvent = WwiseEvent'Wwise_Weapons_P_Mantis.Play_wep_p_mantis_scope_in'
    DeActivateSniperZoomWwiseEvent = WwiseEvent'Wwise_Weapons_P_Mantis.Play_wep_p_mantis_scope_out'
    SniperRifleDamagePenalty = 0.5
    MinZoomAimError = {X = 0.0, Y = 0.0}
    MaxZoomAimError = {X = 0.0, Y = 0.0}
    ZoomAccFirePenalty = {X = 0.5, Y = 0.5}
    ZoomAccFireInterpSpeed = {X = 12.0, Y = 12.0}
    MinZoomCrosshairRange = {X = 15.0, Y = 15.0}
    MaxZoomCrosshairRange = {X = 30.0, Y = 30.0}
    AimModes = ({ScopeResource = 'None', ZoomFOV = 10.0, FrictionMultiplier = 1.0, AdhesionMultiplier = 1.0, bScoped = TRUE}
               )
    ZoomSnapList = ({OuterSnapAngle = 5.0, InnerSnapAngle = 0.5, SnapOffsetMag = 15.0, AimNode = EAimNodes.AimNode_Cover}, 
                    {OuterSnapAngle = 10.0, InnerSnapAngle = 5.0, SnapOffsetMag = 5.0, AimNode = EAimNodes.AimNode_Chest}, 
                    {OuterSnapAngle = 0.0, InnerSnapAngle = 0.0, SnapOffsetMag = 0.0, AimNode = EAimNodes.AimNode_Head}
                   )
    ResearchUpgradeIds = (474, 475)
    AllowableWeaponMods = ("SFXGameContent.SFXWeaponMod_SniperRifleDamage", "SFXGameContent.SFXWeaponMod_SniperRifleTimeDilation", "SFXGameContent.SFXWeaponMod_SniperRifleAccuracy", "SFXGameContent.SFXWeaponMod_SniperRifleReloadSpeed", "SFXGameContent.SFXWeaponMod_SniperRifleConstraintDamage")
    DefaultModOptions = ("SFXGameContent.SFXWeaponMod_SniperRifleTimeDilation", "SFXGameContent.SFXWeaponMod_SniperRifleDamage", "SFXGameContent.SFXWeaponMod_SniperRifleReloadSpeed", "SFXGameContent.SFXWeaponMod_SniperRifleAccuracy", "SFXGameContent.SFXWeaponMod_SniperRifleConstraintDamage")
    FrictionMultiplierRange = {X = 0.0, Y = 0.189999998}
    SwitchPriority = 2
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    ImpactScale = 1.5
    PSC_ReloadVent = ReloadVent0
    IdealMinRange = 2000.0
    IdealTargetDistance = 3500.0
    IdealMaxRange = 5000.0
    IconRef = 2
    GUIClassName = $338204
    GUIClassDescription = $340846
    GUIWeaponOrder = 40
    NuiSpeechName = $696421
    MinZoomSnapDistance = 1000.0
    MaxZoomSnapDistance = 10000.0
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    DamageUpgradeId = 72
    CameraSetup = CameraSetup0
    bWeaponCanBeReloaded = TRUE
    DefaultFireMode = FireModes.FireMode_SemiAuto
    AnimType = WeaponAnimType.WeaponAnimType_Sniper
    AttachSlot = EAttachSlot.EASlot_LeftShoulder
    VocalizationType = ESFXVocalizationWeapon.SFXVocalizationWeapon_SniperRifle
    InstantHitMomentum = (0.0, 10.0, 1.0, 1.0)
    Mesh = WeaponMesh
    bInstantHit = TRUE
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}