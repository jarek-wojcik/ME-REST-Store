Class SFXWeapon_Shotgun_Base extends SFXWeapon
    placeable
    abstract
    config(Weapon);

var config ScaledFloat AccuracyBonus;
var config ScaledFloat ZoomAccuracyBonus;
var(SFXWeapon_Shotgun_Base) array<Vector2D> PelletSpread;
var(SFXWeapon_Shotgun_Base) Rotator LatentFire_AimRotation;
var(SFXWeapon_Shotgun_Base) Vector LatentFire_StartLocation;
var(SFXWeapon_Shotgun_Base) Vector TraceExtent;
var(SFXWeapon_Shotgun_Base) float StartTraceAdjustDist;
var int AmmoRestoredPerReload;
var const float LatentFireTime;
var(SFXWeapon_Shotgun_Base) int LatentFire_CurrentPellet;

public event simulated function DummyFire(byte FireModeNum, Vector TargetLoc, optional Actor AttachedTo, optional float AimErrorDeg, optional Actor TargetActor)
{
    local Vector StartLoc;
    local Rotator InitialRot;
    local Rotator AimRot;
    local float AimErrorUnr;
    local Vector EndTrace;
    local array<ImpactInfo> ImpactList;
    local ImpactInfo RealImpact;
    local int PelletIdx;
    local int idx;
    local bool bAudioWasSuppressed;
    local bool bTracersWereSuppressed;
    local bool bImpactsWereSuppressed;
    
    DummyFireParent = AttachedTo;
    bDummyFireWeapon = TRUE;
    DummyFireTargetLoc = TargetLoc;
    DummyFireTargetActor = TargetActor;
    DummyFireInaccuracy = AimErrorDeg;
    StartLoc = GetPhysicalFireStartLoc();
    InitialRot = Rotator(TargetLoc - StartLoc);
    if (AimErrorDeg != 0.0)
    {
        AimErrorUnr = AimErrorDeg * 182.044006;
        InitialRot.Pitch += int(AimErrorUnr * (0.5 - FRand()));
        InitialRot.Yaw += int(AimErrorUnr * (0.5 - FRand()));
    }
    InitialRot.Roll = int(FRand() * float(65536));
    for (PelletIdx = 0; PelletIdx < PelletSpread.Length; PelletIdx++)
    {
        AimRot = InitialRot;
        AimRot.Pitch += int(PelletSpread[PelletIdx].Y * (FRand() * float(2)) * ZoomAccuracyBonus.Value);
        AimRot.Yaw += int(PelletSpread[PelletIdx].X * (FRand() * float(2)) * ZoomAccuracyBonus.Value);
        EndTrace = StartLoc + Vector(AimRot) * GetTraceRange();
        RealImpact = CalcWeaponFire(StartLoc, EndTrace, ImpactList);
        if (PelletIdx == 0)
        {
            WeaponFired(FireModeNum, FALSE, RealImpact.HitLocation);
        }
        bAudioWasSuppressed = bSuppressAudio;
        if (PelletIdx != 0)
        {
            bSuppressAudio = TRUE;
        }
        bTracersWereSuppressed = bSuppressTracers;
        bImpactsWereSuppressed = bSuppressImpactFX;
        if (PelletIdx >= 4)
        {
            bSuppressTracers = TRUE;
            bSuppressImpactFX = TRUE;
        }
        for (idx = 0; idx < ImpactList.Length; idx++)
        {
            if (ImpactList[idx].HitActor != None)
            {
                CalcRemoteImpactEffects(FireModeNum, ImpactList[idx].HitLocation, FALSE);
            }
        }
        if (PelletIdx < 4)
        {
            SpawnTracerEffect(RealImpact.HitLocation, VSize(RealImpact.HitLocation - GetMuzzleLoc()));
        }
        bSuppressTracers = bTracersWereSuppressed;
        bSuppressImpactFX = bImpactsWereSuppressed;
        bSuppressAudio = bAudioWasSuppressed;
        ImpactList.Length = 0;
    }
}
public simulated function CustomFire()
{
    local Vector StartTrace;
    local Rotator AimRot;
    
    StartTrace = Instigator.GetWeaponStartTraceLocation();
    AimRot = GetAdjustedAim(StartTrace);
    FirePellets(StartTrace, AimRot, CurrentFireMode);
}
public simulated function CalcRemoteImpactEffects(byte FireModeNum, Vector GivenHitLocation, bool bViaReplication)
{
    local Vector StartTrace;
    local Vector EndTrace;
    local Rotator AimRot;
    
    if (Instigator != None)
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
    }
    else
    {
        StartTrace = GetPhysicalFireStartLoc();
    }
    EndTrace = GivenHitLocation;
    AimRot = Rotator(Normal(EndTrace - StartTrace));
    FirePellets(StartTrace, AimRot, FireModeNum);
}
public simulated function DrawDebugShotgunCone(Vector StartLocation, Rotator AimRot)
{
    local float ConeAngleRad;
    
    ConeAngleRad = Sin(1024.0 / float(65536) * float(2) * 3.14159274);
    DrawDebugCone(StartLocation, Vector(AimRot), GetTraceRange(), ConeAngleRad, ConeAngleRad, 16, MakeColor(255, 0, 0, 255), TRUE);
}
public simulated function FinishLatentFire();

public final simulated function FirePellets(Vector StartLocation, Rotator AimRotation, byte FireMode)
{
    LatentFire_AimRotation = AimRotation;
    LatentFire_CurrentPellet = 0;
    LatentFire_StartLocation = StartLocation;
    SetTimer(FMax(0.00100000005, LatentFireTime / float(PelletSpread.Length)), TRUE, 'PollLatentFire', );
}
public static function EAttachSlot GetStoreQualification()
{
    return EAttachSlot.EASlot_LowerBack;
}
public simulated function DecalComponent GetWeaponSpecificDecalData(SFXPhysicalMaterialDecals DecalEffects, out float FadeTime)
{
    local int DecalLength;
    
    FadeTime = DecalEffects.ShotgunFadeTime;
    DecalLength = DecalEffects.Shotgun.Length;
    if (DecalLength > 0)
    {
        return DecalEffects.Shotgun[Rand(DecalLength)];
    }
    return None;
}
public static simulated function ParticleSystem GetWeaponSpecificImpactEffect(SFXPhysicalMaterialImpactEffects ImpactEffects)
{
    return ImpactEffects.Shotgun;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    if (SFXPawn_Player(Instigator) != None && Instigator.IsLocallyControlled())
    {
        return ImpactSounds.Shotgun_Player;
    }
    return ImpactSounds.Shotgun;
}
public final simulated function PollLatentFire()
{
    local Vector EndTrace;
    local array<ImpactInfo> ImpactList;
    local ImpactInfo RealImpact;
    local int idx;
    local Rotator AimRot;
    local bool bAudioWasSuppressed;
    local bool bTracersWereSuppressed;
    local bool bImpactsWereSuppressed;
    local Actor Target;
    local float fConeAccuracyBonus;
    
    if (BioAiController(Instigator.Controller) != None)
    {
        Target = BioAiController(Instigator.Controller).FireTarget;
    }
    else if (BioPlayerController(Instigator.Controller) != None)
    {
        Target = BioPlayerController(Instigator.Controller).m_oPlayerSelection.m_oCurrentSelectionTarget;
    }
    if (Target == None || VSize(Instigator.location - Target.location) < float(500))
    {
        fConeAccuracyBonus = AccuracyBonus.Value;
    }
    else if (bIsZoomed || SFXPawn_Henchman(Instigator) != None)
    {
        fConeAccuracyBonus = ZoomAccuracyBonus.Value;
    }
    else
    {
        fConeAccuracyBonus = AccuracyBonus.Value;
    }
    AimRot = LatentFire_AimRotation;
    AimRot.Pitch += int(PelletSpread[LatentFire_CurrentPellet].Y * fConeAccuracyBonus * (0.5 + FRand() * 0.5));
    AimRot.Yaw += int(PelletSpread[LatentFire_CurrentPellet].X * fConeAccuracyBonus * (0.5 + FRand() * 0.5));
    EndTrace = LatentFire_StartLocation + Vector(AimRot) * GetTraceRange();
    RealImpact = CalcWeaponFire(LatentFire_StartLocation, EndTrace, ImpactList, TraceExtent);
    if (LatentFire_CurrentPellet == 0)
    {
        if (Instigator != None && Instigator.IsLocallyControlled())
        {
            SetFlashLocation(RealImpact.HitLocation);
        }
    }
    bAudioWasSuppressed = bSuppressAudio;
    if (LatentFire_CurrentPellet != 0)
    {
        bSuppressAudio = TRUE;
    }
    bTracersWereSuppressed = bSuppressTracers;
    bImpactsWereSuppressed = bSuppressImpactFX;
    if (LatentFire_CurrentPellet >= 16)
    {
        bSuppressTracers = TRUE;
        bSuppressImpactFX = TRUE;
    }
    for (idx = 0; idx < ImpactList.Length; idx++)
    {
        ProcessInstantHit(DefaultFireMode, ImpactList[idx]);
    }
    if (LatentFire_CurrentPellet < 16)
    {
        if (Instigator != None)
        {
            SpawnTracerEffect(RealImpact.HitLocation, VSize(RealImpact.HitLocation - Instigator.location));
        }
        else
        {
            SpawnTracerEffect(RealImpact.HitLocation, VSize(RealImpact.HitLocation - GetMuzzleLoc()));
        }
    }
    bSuppressTracers = bTracersWereSuppressed;
    bSuppressImpactFX = bImpactsWereSuppressed;
    bSuppressAudio = bAudioWasSuppressed;
    if (++LatentFire_CurrentPellet >= PelletSpread.Length)
    {
        ClearTimer('PollLatentFire', Self);
        FinishLatentFire();
    }
}
public simulated function ScaleWeapon()
{
    local int MaxLevelForCalc;
    
    Super.ScaleWeapon();
    MaxLevelForCalc = int(MaxLevel - float(1));
    AccuracyBonus.Level = int(WeaponLevel);
    AccuracyBonus.MaxLevel = MaxLevelForCalc;
    ZoomAccuracyBonus.Level = int(WeaponLevel);
    ZoomAccuracyBonus.MaxLevel = MaxLevelForCalc;
    Class'SFXGame'.static.ReCalculate(AccuracyBonus);
    Class'SFXGame'.static.ReCalculate(ZoomAccuracyBonus);
}
public simulated function bool ShouldSpawnTracerFX()
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=ForceFeedbackWaveform Name=EjectRumble0
        Samples = ({Duration = 0.150000006, LeftAmplitude = 50, RightAmplitude = 50, LeftFunction = EWaveformFunction.WF_Constant, RightFunction = EWaveformFunction.WF_Constant}
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
    AccuracyBonus = {
                     Bonuses = (), 
                     X = 1.0, 
                     Y = 1.0, 
                     MaxLevel = 100, 
                     Level = 0, 
                     Value = 0.0, 
                     StaticBonus = 1.0
                    }
    ZoomAccuracyBonus = {
                         Bonuses = (), 
                         X = 0.75, 
                         Y = 0.75, 
                         MaxLevel = 100, 
                         Level = 0, 
                         Value = 0.0, 
                         StaticBonus = 1.0
                        }
    PelletSpread = ({X = -112.0, Y = 112.0}, 
                    {X = -336.0, Y = -336.0}, 
                    {X = 336.0, Y = -336.0}, 
                    {X = 336.0, Y = 336.0}, 
                    {X = -473.0, Y = 0.0}, 
                    {X = -473.0, Y = 0.0}, 
                    {X = 0.0, Y = 473.0}, 
                    {X = 0.0, Y = -473.0}
                   )
    StartTraceAdjustDist = -64.0
    AmmoRestoredPerReload = 1
    LatentFireTime = 0.100000001
    MinZoomCrosshairRange = {X = 80.0, Y = 80.0}
    MaxZoomCrosshairRange = {X = 95.0, Y = 95.0}
    ZoomSnapList = ({OuterSnapAngle = 5.0, InnerSnapAngle = 0.5, SnapOffsetMag = 20.0, AimNode = EAimNodes.AimNode_Cover}, 
                    {OuterSnapAngle = 20.0, InnerSnapAngle = 10.0, SnapOffsetMag = 10.0, AimNode = EAimNodes.AimNode_Chest}, 
                    {OuterSnapAngle = 0.0, InnerSnapAngle = 0.0, SnapOffsetMag = 0.0, AimNode = EAimNodes.AimNode_Head}
                   )
    ResearchUpgradeIds = (470, 471)
    AllowableWeaponMods = ("SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed", "SFXGameContent.SFXWeaponMod_ShotgunDamage", "SFXGameContent.SFXWeaponMod_ShotgunAccuracy", "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage", "SFXGameContent.SFXWeaponMod_ShotgunStability")
    DefaultModOptions = ("SFXGameContent.SFXWeaponMod_ShotgunAccuracy", "SFXGameContent.SFXWeaponMod_ShotgunDamage", "SFXGameContent.SFXWeaponMod_ShotgunStability", "SFXGameContent.SFXWeaponMod_ShotgunMeleeDamage", "SFXGameContent.SFXWeaponMod_ShotgunReloadSpeed")
    FrictionMultiplierRange = {X = 0.0, Y = 0.25}
    SwitchPriority = 40
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ReloadVent = ReloadVent0
    IdealTargetDistance = 1000.0
    IdealMaxRange = 2500.0
    MagneticCorrectionThresholdAngle = 1.0
    MaxMagneticCorrectionAngle = 0.5
    IconRef = 6
    GUIClassName = $338202
    GUIClassDescription = $340845
    GUIWeaponOrder = 30
    NuiSpeechName = $696422
    MinFrictionDistance = 320.0
    MaxFrictionDistance = 1000.0
    PeakFrictionDistance = 500.0
    PeakFrictionRadiusScale = 0.400000006
    MinZoomSnapDistance = 250.0
    MaxZoomSnapDistance = 1000.0
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    DamageUpgradeId = 71
    bWeaponCanBeReloaded = TRUE
    bFrictionDistanceScalingEnabled = TRUE
    bNoAmmoPowerTracers = TRUE
    DefaultFireMode = FireModes.FireMode_SemiAuto
    AnimType = WeaponAnimType.WeaponAnimType_Shotgun
    AttachSlot = EAttachSlot.EASlot_LowerBack
    VocalizationType = ESFXVocalizationWeapon.SFXVocalizationWeapon_Shotgun
    WeaponFireTypes = (EWeaponFireType.EWFT_InstantHit, EWeaponFireType.EWFT_Custom, EWeaponFireType.EWFT_Custom, EWeaponFireType.EWFT_InstantHit, EWeaponFireType.EWFT_InstantHit)
    InstantHitMomentum = (0.0, 10.0, 1.0, 1.0)
    Mesh = WeaponMesh
    bInstantHit = TRUE
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}