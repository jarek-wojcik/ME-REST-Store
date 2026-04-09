Class SFXWeapon_Heavy_Beam_Base_DLC extends SFXWeapon_AssaultRifle_Base
    placeable
    abstract
    config(Weapon);

var transient Vector vLastHitLocation;
var transient Rotator rPreCalAim;
var(SFXWeapon_Heavy_Beam_Base_DLC) config Vector2D BeamInterpSpeed;
var(SFXWeapon_Heavy_Beam_Base_DLC) int DecalFrequency;
var transient float fCurrentBeamInterpTime;
var(SFXWeapon_Heavy_Beam_Base_DLC) config float BeamInterpTime;
var transient int LastDecalTime;
var transient float LastImpactTime;
var float VFXUpdateInterval;
var transient bool bFiringContinuously;
var transient bool bIsFiring;

public simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    Super(SFXWeapon).ProcessInstantHit(FiringMode, Impact, NumHits);
    vLastHitLocation = Impact.HitLocation;
    bFiringContinuously = TRUE;
}
public simulated function Tick(float DeltaTime)
{
    Super(Actor).Tick(DeltaTime);
    if (bIsFiring)
    {
        if (fCurrentBeamInterpTime < BeamInterpTime)
        {
            fCurrentBeamInterpTime += DeltaTime;
        }
        UpdateBeam(DeltaTime);
    }
}
public simulated function Rotator GetAdjustedAim(Vector StartFireLoc)
{
    if (Instigator.IsHumanControlled())
    {
        return Super(SFXWeapon).GetAdjustedAim(StartFireLoc);
    }
    return rPreCalAim;
}
public simulated function StartFire(byte FireModeNum)
{
    fCurrentBeamInterpTime = 0.0;
    CalcFireStart();
    bIsFiring = TRUE;
    Super(SFXWeapon).StartFire(FireModeNum);
}
public simulated function StopFire(byte FireModeNum)
{
    bIsFiring = FALSE;
    Super(Weapon).StopFire(FireModeNum);
}
public simulated function DecalComponent GetWeaponSpecificDecalData(SFXPhysicalMaterialDecals DecalEffects, out float FadeTime)
{
    return None;
}
public static simulated function ParticleSystem GetWeaponSpecificImpactEffect(SFXPhysicalMaterialImpactEffects ImpactEffects)
{
    return None;
}
public simulated function WwiseEvent GetWeaponSpecificImpactSound(SFXPhysicalMaterialImpactSounds ImpactSounds)
{
    return ImpactSounds.ParticleBeam;
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
public simulated function PlayMuzzleFlashEffect()
{
    if (!bPlayingMuzzleFlashEffect && !bSuppressMuzzleFlash && IsMuzzleFlashRelevant())
    {
        bPlayingMuzzleFlashEffect = TRUE;
        if (PSC_MuzFlashEmitter != None)
        {
            ClearTimer('HideMuzzleFlashEmitter');
            PSC_MuzFlashEmitter.SetHidden(FALSE);
            PSC_MuzFlashEmitter.SetActive(TRUE);
            PSC_MuzFlashEmitter.SetVectorParameter('Impact', GetMuzzleLoc());
            PSC_MuzFlashEmitter.SetVectorParameter('Impact_lag', GetMuzzleLoc());
        }
    }
}
public simulated function SpawnImpactEffects(ImpactInfo Impact)
{
    if (WorldInfo.GameTimeSeconds - LastImpactTime > VFXUpdateInterval)
    {
        LastImpactTime = WorldInfo.GameTimeSeconds;
        Super(SFXWeapon).SpawnImpactEffects(Impact);
    }
}
public simulated function StopMuzzleFlashEffect()
{
    if (bPlayingMuzzleFlashEffect)
    {
        bPlayingMuzzleFlashEffect = FALSE;
        if (PSC_MuzFlashEmitter != None)
        {
            PSC_MuzFlashEmitter.SetActive(FALSE);
            SetTimer(0.100000001, FALSE, 'HideMuzzleFlashEmitter', );
        }
    }
    bFiringContinuously = FALSE;
}
public function CalcFireStart()
{
    local Vector StartFireLoc;
    local Vector FireDir;
    local Vector TargetLatVel;
    local Vector ToTarget;
    local SFXAI_Core AI;
    local int Direction;
    local float fVelBasedTrackingOffset;
    local float fPitchMaxError;
    local Vector TargetLoc;
    
    StartFireLoc = Instigator.GetWeaponStartTraceLocation();
    rPreCalAim = Super(SFXWeapon).GetAdjustedAim(StartFireLoc);
    AI = SFXAI_Core(Instigator.Controller);
    if (AI != None && AI.FireTarget != None)
    {
        TargetLoc = AI.GetAimLocation();
        vLastHitLocation = TargetLoc;
        FireDir = Normal(Vector(rPreCalAim));
        TargetLatVel = AI.FireTarget.Velocity - AI.FireTarget.Velocity Dot FireDir * FireDir;
        ToTarget = TargetLoc - StartFireLoc;
        Direction = 1;
        if (GetVectorSide(ToTarget, ToTarget + TargetLatVel) < 0)
        {
            Direction = -1;
        }
        fVelBasedTrackingOffset = 3.0;
        fPitchMaxError = 500.0;
        rPreCalAim.Yaw += int(float(Direction) * VSize(TargetLatVel) * fVelBasedTrackingOffset);
        rPreCalAim.Pitch += int((1.0 - 2.0 * FRand()) * fPitchMaxError);
    }
}
protected function PreCalculateAdjustedAim(float fDeltaTime)
{
    local Vector StartFireLoc;
    local Rotator rTargetAim;
    local Rotator rCurrentAim;
    local float fInterpSpeed;
    local SFXAI_Core AI;
    
    AI = SFXAI_Core(AIController);
    if (AI != None)
    {
        StartFireLoc = Instigator.GetWeaponStartTraceLocation();
        rTargetAim = Rotator(AI.GetAimLocation() - StartFireLoc);
        rCurrentAim = Rotator(vLastHitLocation - StartFireLoc);
        if (BeamInterpTime == float(0))
        {
            fInterpSpeed = BeamInterpSpeed.X;
        }
        else
        {
            fInterpSpeed = Lerp(BeamInterpSpeed.X, BeamInterpSpeed.Y, fCurrentBeamInterpTime / BeamInterpTime);
        }
        rPreCalAim = RInterpTo(rCurrentAim, rTargetAim, fDeltaTime, fInterpSpeed);
    }
}
public simulated function UpdateBeam(float DeltaTime)
{
    if (PSC_MuzFlashEmitter != None)
    {
        PSC_MuzFlashEmitter.SetVectorParameter('Impact', vLastHitLocation);
        PSC_MuzFlashEmitter.SetVectorParameter('Impact_lag', vLastHitLocation);
    }
    PreCalculateAdjustedAim(DeltaTime);
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
    PSC_OutOfAmmoEffect = OutOfAmmoEffect0
    OutOfAmmoRumble = OutOfAmmoRumble0
    WeaponFireWaveForm = ForceFeedbackWaveformBase
    EjectRumble = EjectRumble0
    PSC_ReloadVent = ReloadVent0
    AmmoPowerPSCO = AmmoPowerHologram
    AmmoPowerIconPSCO = AmmoPowerIconHologram
    Mesh = WeaponMesh
    PickupFactoryMesh = PickupMesh
    Components = (WeaponMesh)
    Modules = (GEMod0, ModManager0)
}