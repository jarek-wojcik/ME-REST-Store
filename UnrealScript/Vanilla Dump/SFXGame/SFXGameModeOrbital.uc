Class SFXGameModeOrbital extends SFXGameModeGalaxy within BioPlayerController
    config(Input);

var editinline transient export array<ParticleSystemComponent> TemporaryComponents;
var ScreenShakeStruct Shake;
var ScreenShakeStruct BigShake;
var transient Rotator ReticleRot;
var config Rotator ReticleRotStart;
var config Rotator ReticleRotTopLeftClamp;
var config Rotator ReticleRotBottomRightClamp;
var transient Vector ProbeLaunchLocation;
var transient Vector ProbeTargetLocation;
var transient Vector ProbeControlPtLocation;
var transient Vector ScanReticleInputMovement;
var config float PlanetRotationDegreesPerSecond;
var config float ScanningPlanetRotationDegreesPerSecond;
var config float ReticleDegreesPerSecond;
var config float ScanningReticleDegreesPerSecond;
var config float InputAttenuation;
var config float RumbleScale;
var float MoveDist;
var float ProbeControlAxisOffset;
var float ProbeControlTargetOffset;
var float ScannerRotateSpeed;
var float ProbeLaunchTime;
var float ProbeLaunchTimeMax;
var float ScanDist;
var editinline transient export ParticleSystemComponent ReticleEffect;
var editinline transient export ParticleSystemComponent ScanReticleEffect;
var editinline transient export ParticleSystemComponent ScanWipeEffect;
var editinline transient export ParticleSystemComponent ScanBlipEffect;
var editinline transient export ParticleSystemComponent ScanDirectionEffect;
var editinline transient export ParticleSystemComponent LaunchReticleEffect;
var editinline transient export ParticleSystemComponent ProbeExplosionEffect;
var float ScanDirectionPulseLifeTime;
var transient float ScanDirectionPulseTimeToLive;
var transient float ReticleScale;
var transient float Roll;
var transient float fRescaleTime;
var transient float fInitialScale;
var transient float fNewScale;
var transient float fMaxRescaleTime;
var transient float ImpactTime;
var float ImpactTimeMax;
var ForceFeedbackWaveform ScanFFWaveForm;
var editinline transient export WwiseAudioComponent AudioComponent;
var transient float PlanetScanInputMovement;
var bool Scanning;
var transient bool ProbeActive;
var transient bool bRescaling;
var transient bool bExiting;
var transient bool ImpactActive;
var transient bool DrawProbeDebugLines;
var transient bool bMouseLock;

public function Activated()
{
    local BioPlayerController oController;
    local InterpActor oPlanet;
    local BioWorldInfo oWorldInfo;
    
    DoPatchDefaultPropertyUpdates();
    oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    oController.HintSystem.HintEvent('StartPlanetScanner');
    Super(SFXGameModeBase).Activated();
    ReticleRot = ReticleRotStart;
    ProbeLaunchLocation = GetGameData().Probe.location;
    if (AudioComponent == None)
    {
        AudioComponent = Class'WwiseAudioComponent'.static.CreateComponentFromScript(GetGameData().GetWorldInfo());
    }
    oPlanet = GetGameData().Planet;
    if (oPlanet.DrawScale3D.X != Class'BioPlanet'.default.m_fPlanetScale)
    {
        fInitialScale = oPlanet.DrawScale3D.X;
        fNewScale = Class'BioPlanet'.default.m_fPlanetScale;
        bRescaling = TRUE;
    }
    if (ReticleEffect == None)
    {
        ReticleEffect = new Class'ParticleSystemComponent';
        ReticleEffect.SetTemplate(GetGameData().Reticle);
        ReticleEffect.SetAbsolute(FALSE, TRUE, FALSE);
        ReticleEffect.SetScale(ReticleScale);
        GetGameData().Planet.AttachComponent(ReticleEffect);
    }
    ReticleEffect.DeactivateSystem();
    if (ScanReticleEffect == None)
    {
        ScanReticleEffect = new Class'ParticleSystemComponent';
        ScanReticleEffect.SetTemplate(GetGameData().ScanReticle);
        ScanReticleEffect.SetAbsolute(FALSE, TRUE, FALSE);
        ScanReticleEffect.SetScale(ReticleScale);
        ScanReticleEffect.bAutoActivate = FALSE;
        GetGameData().Planet.AttachComponent(ScanReticleEffect);
    }
    ScanReticleEffect.DeactivateSystem();
    if (LaunchReticleEffect == None)
    {
        LaunchReticleEffect = new Class'ParticleSystemComponent';
        LaunchReticleEffect.SetTemplate(GetGameData().LaunchReticle);
        LaunchReticleEffect.SetAbsolute(FALSE, TRUE, FALSE);
        LaunchReticleEffect.SetScale(ReticleScale);
        LaunchReticleEffect.bAutoActivate = FALSE;
        GetGameData().Planet.AttachComponent(LaunchReticleEffect);
    }
    LaunchReticleEffect.DeactivateSystem();
    if (ScanWipeEffect == None && GetGameData().ScanWipe != None)
    {
        ScanWipeEffect = new Class'ParticleSystemComponent';
        ScanWipeEffect.SetTemplate(GetGameData().ScanWipe);
        ScanWipeEffect.SetAbsolute(FALSE, TRUE, FALSE);
        ScanWipeEffect.SetScale(ReticleScale);
        ScanWipeEffect.bAutoActivate = FALSE;
        GetGameData().Planet.AttachComponent(ScanWipeEffect);
    }
    ScanWipeEffect.DeactivateSystem();
    if (ScanBlipEffect == None && GetGameData().ScanBlip != None)
    {
        ScanBlipEffect = new Class'ParticleSystemComponent';
        ScanBlipEffect.SetTemplate(GetGameData().ScanBlip);
        ScanBlipEffect.SetAbsolute(FALSE, FALSE, FALSE);
        ScanBlipEffect.SetScale(ReticleScale * 1.5);
        ScanBlipEffect.bAutoActivate = FALSE;
        GetGameData().Planet.AttachComponent(ScanBlipEffect);
    }
    ScanBlipEffect.DeactivateSystem();
    if (ScanDirectionEffect == None && GetGameData().ScanDirection != None)
    {
        ScanDirectionEffect = new Class'ParticleSystemComponent';
        ScanDirectionEffect.SetTemplate(GetGameData().ScanDirection);
        ScanDirectionEffect.SetAbsolute(FALSE, TRUE, FALSE);
        ScanDirectionEffect.SetScale(ReticleScale);
        ScanDirectionEffect.bAutoActivate = FALSE;
        GetGameData().Planet.AttachComponent(ScanDirectionEffect);
    }
    ScanDirectionEffect.DeactivateSystem();
    if (ProbeExplosionEffect != None)
    {
        ProbeExplosionEffect.DeactivateSystem();
    }
    UpdateReticle(0.0);
    UpdatePlanetRotationFromInput(0.0);
    SetLTriggerLabelVisible(TRUE, Class'BioSFHandler_GalaxyMap'.default.TextScan);
    ToggleMouseLock(TRUE);
    bExiting = FALSE;
}
public event function bool CanExit()
{
    return Super.CanExit() && (!ProbeActive && !Scanning && !ImpactActive && !bRescaling);
}
public function Deactivated()
{
    local int i;
    local BioPlayerController oController;
    local BioWorldInfo oWorldInfo;
    
    oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    oController.HintSystem.HintEvent('ClosePlanetScanner');
    Super(SFXGameModeBase).Deactivated();
    ResetProbe();
    if (ReticleEffect != None)
    {
        ReticleEffect.DeactivateSystem();
    }
    if (ScanReticleEffect != None)
    {
        ScanReticleEffect.DeactivateSystem();
    }
    if (ProbeExplosionEffect != None)
    {
        ProbeExplosionEffect.DeactivateSystem();
    }
    if (LaunchReticleEffect != None)
    {
        LaunchReticleEffect.DeactivateSystem();
    }
    if (ScanWipeEffect != None)
    {
        ScanWipeEffect.DeactivateSystem();
    }
    if (ScanBlipEffect != None)
    {
        ScanBlipEffect.DeactivateSystem();
    }
    if (ScanDirectionEffect != None)
    {
        ScanDirectionEffect.DeactivateSystem();
    }
    Outer.ClientStopForceFeedbackWaveform(ScanFFWaveForm);
    for (i = 0; i < TemporaryComponents.Length; i++)
    {
        TemporaryComponents[i].DeactivateSystem();
        GetGameData().Planet.DetachComponent(TemporaryComponents[i]);
    }
    GetGameData().EndAction();
    SetRTriggerLabelVisible(FALSE, $0);
    SetLTriggerLabelVisible(FALSE, $0);
    ToggleMouseLock(FALSE);
}
public function Update(float DeltaTime)
{
    local Vector oldPos;
    local Vector NewPos;
    local InterpActor Probe;
    local float T;
    local Rotator planetRot;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    Probe = oGameData.Probe;
    if (bRescaling)
    {
        UpdatePlanetScale(DeltaTime);
        return;
    }
    if (bExiting)
    {
        Outer.GameModeManager2.DisableMode(12);
        return;
    }
    if (!ReticleEffect.bIsActive)
    {
        ReticleEffect.ActivateSystem();
    }
    if (!ProbeActive && !Scanning && !ImpactActive)
    {
        planetRot = oGameData.Planet.Rotation;
        planetRot.Yaw += int(oGameData.CurrentPlanet.PlanetRotation * 182.044449 * DeltaTime);
        oGameData.Planet.SetRotation(planetRot);
    }
    if (ProbeActive)
    {
        oldPos = Probe.location;
        ProbeLaunchTime += DeltaTime;
        T = ProbeLaunchTime * ProbeLaunchTime / (ProbeLaunchTimeMax * ProbeLaunchTimeMax);
        if (DrawProbeDebugLines)
        {
            Probe.DrawDebugLine(ProbeLaunchLocation, ProbeTargetLocation, 255, 0, 0);
            Probe.DrawDebugLine(ProbeLaunchLocation, ProbeControlPtLocation, 0, 255, 0);
            Probe.DrawDebugLine(ProbeControlPtLocation, ProbeTargetLocation, 0, 255, 0);
            Probe.DrawDebugLine(VLerp(ProbeLaunchLocation, ProbeControlPtLocation, T), VLerp(ProbeControlPtLocation, ProbeTargetLocation, T), 0, 0, 255);
        }
        NewPos = VLerp(VLerp(ProbeLaunchLocation, ProbeControlPtLocation, T), VLerp(ProbeControlPtLocation, ProbeTargetLocation, T), T);
        Probe.MoveSmooth(NewPos - Probe.location);
        Probe.SetRotation(Rotator(Probe.location - oldPos));
        if (VSize(Probe.location - ProbeTargetLocation) < 10.0 || ProbeLaunchTime >= ProbeLaunchTimeMax)
        {
            ResetProbe();
            ProbeImpact();
        }
    }
    if (ImpactActive)
    {
        ImpactTime += DeltaTime;
        if (ImpactTime >= ImpactTimeMax)
        {
            EndImpact();
        }
    }
    UpdateReticle(DeltaTime);
    UpdatePlanetRotationFromInput(DeltaTime);
    if (Scanning)
    {
        ScanPlanet(DeltaTime);
    }
}
public function BeginExitGalaxyMap(bool resize)
{
    ReticleEffect.DeactivateSystem();
    bExiting = TRUE;
    if (fInitialScale > 0.0 && resize)
    {
        fNewScale = fInitialScale;
        fInitialScale = Class'BioPlanet'.default.m_fPlanetScale;
        bRescaling = TRUE;
    }
}
public function DoPatchDefaultPropertyUpdates()
{
    ReticleScale = 0.219999999;
    ProbeLaunchTimeMax = 2.0;
    ScanDist = 165.0;
}
public function EndImpact()
{
    local SFXGalaxyMapObject oChild;
    local SFXPlanetFeature F;
    local Vector pos;
    local InterpActor Planet;
    local float fDist;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    Planet = oGameData.Planet;
    if (Scanning)
    {
        ScanReticleEffect.ActivateSystem();
    }
    LaunchReticleEffect.DeactivateSystem();
    ImpactActive = FALSE;
    ImpactTime = 0.0;
    pos = (ProbeTargetLocation - Planet.location) / oGameData.CurrentPlanet.m_fPlanetScale << Planet.Rotation;
    if (oGameData.CurrentPlanet != None)
    {
        foreach oGameData.CurrentPlanet.Children(oChild, )
        {
            F = SFXPlanetFeature(oChild);
            if (F == None)
            {
                continue;
            }
            fDist = VSize(F.Position - pos) * oGameData.CurrentPlanet.m_fPlanetScale - 50.0;
            if (fDist <= ScanDist && F.IsVisible())
            {
                F.FeatureProbed();
            }
        }
    }
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    return Outer.GameModeManager2.GameModes[11].GetCameraMode(OldCameraMode, PreserveTarget, TransitionTime, Transition);
}
public function BioSeqAct_OrbitalGame GetGameData()
{
    local SeqAct_Latent SeqAct;
    
    foreach Outer.Pawn.LatentActions(SeqAct, )
    {
        if (BioSeqAct_OrbitalGame(SeqAct) != None)
        {
            return BioSeqAct_OrbitalGame(SeqAct);
        }
    }
    return None;
}
public function Vector GetRelativeReticlePosition()
{
    local Vector V;
    local float PlanetSize;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    if (oGameData.CurrentPlanet != None)
    {
        PlanetSize = oGameData.CurrentPlanet.GetPlanetSize();
    }
    else
    {
        PlanetSize = Class'BioPlanet'.default.DefaultDisplaySize;
    }
    V = Vector(ReticleRot) * PlanetSize;
    return V;
}
public exec function LaunchProbe()
{
    local Vector axisOffset;
    local Vector TargetOffset;
    local BioWorldInfo oWorldInfo;
    local BioPlayerController oController;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    if (Scanning && ProbeActive == FALSE && ImpactActive == FALSE && bRescaling == FALSE && bExiting == FALSE)
    {
        oController.HintSystem.HintEvent('LaunchProbe');
        LaunchReticleEffect.ActivateSystem();
        ScanReticleEffect.DeactivateSystem();
        ScanWipeEffect.DeactivateSystem();
        ScanBlipEffect.DeactivateSystem();
        ScanDirectionEffect.DeactivateSystem();
        ProbeTargetLocation = GetRelativeReticlePosition() + oGameData.Planet.location;
        axisOffset = ProbeTargetLocation - (ProjectOnTo(ProbeTargetLocation - oGameData.Planet.location, ProbeLaunchLocation - oGameData.Planet.location) + oGameData.Planet.location);
        axisOffset = Normal(axisOffset) * ProbeControlAxisOffset;
        TargetOffset = ClampLength(ProbeLaunchLocation - oGameData.Planet.location, ProbeControlTargetOffset);
        ProbeControlPtLocation = oGameData.Planet.location + TargetOffset + axisOffset;
        ProbeActive = TRUE;
        ProbeLaunchTime = 0.0;
        oGameData.Probe.SetHidden(FALSE);
        oGameData.ProbeTrail.SetHidden(FALSE);
        oGameData.ProbeTrail.ParticleSystemComponent.ActivateSystem();
        SFXPlayerCamera(Outer.PlayerCamera).AddScreenShake(Shake);
        SFXPlayerCamera(Outer.PlayerCamera).AddScreenShake(BigShake);
        oGameData.SignalProbeLaunch();
        AudioComponent.Play(oGameData.ProbeLaunchedVO[Rand(oGameData.ProbeLaunchedVO.Length)]);
    }
}
public exec function PlanetLeftRight(float Axis)
{
    PlanetScanInputMovement = FClamp(PlanetScanInputMovement + Axis, -1.0, 1.0);
}
public function ProbeImpact()
{
    local Rotator Rot;
    local InterpActor Planet;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    Planet = oGameData.Planet;
    if (oGameData.ProbeImpact != None)
    {
        ImpactActive = TRUE;
        if (ProbeExplosionEffect == None)
        {
            ProbeExplosionEffect = new Class'ParticleSystemComponent';
        }
        Rot = ReticleRot;
        Rot.Pitch -= int(float(90) * 182.044449);
        ProbeExplosionEffect.SetTranslation(100.0 * Vector(ReticleRot));
        ProbeExplosionEffect.SetRotation(Rot);
        ProbeExplosionEffect.SetScale(ReticleScale);
        ProbeExplosionEffect.SetAbsolute(FALSE, TRUE, FALSE);
        Planet.AttachComponent(ProbeExplosionEffect);
        ProbeExplosionEffect.SetTemplate(oGameData.ProbeImpact);
        ProbeExplosionEffect.ActivateSystem();
        AudioComponent.Play(oGameData.ProbeImpactSound);
        oGameData.SignalProbeImpact();
    }
}
public function ResetProbe()
{
    local InterpActor Probe;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    Probe = oGameData.Probe;
    Probe.SetHidden(TRUE);
    oGameData.ProbeTrail.SetHidden(TRUE);
    ProbeActive = FALSE;
    Probe.SetLocation(ProbeLaunchLocation, );
    oGameData.ProbeTrail.ParticleSystemComponent.DeactivateSystem();
}
public function RingReticleLeftRight(float Axis)
{
    ScanReticleInputMovement.X += Axis * InputAttenuation;
}
public function RingReticleUpDown(float Axis)
{
    ScanReticleInputMovement.Y += Axis * InputAttenuation;
}
public final function ScanPlanet(float fDeltaTime)
{
    local SFXGalaxyMapObject oChild;
    local SFXPlanetFeature F;
    local float fDist;
    local Vector pos;
    local Vector scanPos;
    local Vector toLanding;
    local float distToLanding;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    distToLanding = -1.0;
    if (!oGameData.CurrentPlanet.CanBeScanned())
    {
        return;
    }
    scanPos = GetRelativeReticlePosition();
    pos = scanPos / oGameData.CurrentPlanet.m_fPlanetScale << oGameData.Planet.Rotation;
    if (oGameData.CurrentPlanet != None)
    {
        foreach oGameData.CurrentPlanet.Children(oChild, )
        {
            F = SFXPlanetFeature(oChild);
            if (F != None && F.IsProbeable())
            {
                fDist = VSize(F.Position - pos) * oGameData.CurrentPlanet.m_fPlanetScale;
                if (F.StartEvent != None && F.StopEvent != None)
                {
                    if (fDist <= ScanDist * float(6))
                    {
                        AudioComponent.SetWwiseRTPC(F.RTPCName, fDist / (ScanDist * float(6)));
                    }
                    else
                    {
                        AudioComponent.SetWwiseRTPC(F.RTPCName, 1.0);
                    }
                }
                else if (F.FeatureType == EFeatureType.FEATURE_ANOMOLY)
                {
                    if (distToLanding > fDist || distToLanding < float(0))
                    {
                        ScanBlipEffect.SetTranslation(F.Position);
                        ScanBlipEffect.SetRotation(Rotator(F.Position));
                        toLanding = F.Position - pos;
                        distToLanding = fDist;
                    }
                }
            }
        }
    }
    UpdateAnomalyIndicator(toLanding, fDeltaTime, distToLanding >= float(0));
}
public final exec function SetInputAttenuation(float fAttenuation)
{
    InputAttenuation = fAttenuation;
}
public final exec function SetPlanetRotateRate(float fDegPerSec)
{
    PlanetRotationDegreesPerSecond = fDegPerSec;
}
public final exec function SetPlanetScanRotateRate(float fDegPerSec)
{
    ScanningPlanetRotationDegreesPerSecond = fDegPerSec;
}
public exec function SetProbeControl(float A, float T)
{
    ProbeControlAxisOffset = A;
    ProbeControlTargetOffset = T;
}
public exec function SetProbeTime(float T)
{
    ProbeLaunchTimeMax = T;
}
public final exec function SetReticleRate(float fDegPerSec)
{
    ReticleDegreesPerSecond = fDegPerSec;
}
public exec function SetReticleScale(float Scale)
{
    ReticleScale = Scale;
    ReticleEffect.SetScale(ReticleScale);
    ScanReticleEffect.SetScale(ReticleScale);
    LaunchReticleEffect.SetScale(ReticleScale);
    ScanWipeEffect.SetScale(ReticleScale);
    ScanBlipEffect.SetScale(ReticleScale);
    ScanDirectionEffect.SetScale(ReticleScale);
    ProbeExplosionEffect.SetScale(ReticleScale);
}
public exec function SetScanDist(float A)
{
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    ScanDist = A;
    oGameData.Planet.DrawDebugSphere(oGameData.Planet.location + GetRelativeReticlePosition(), ScanDist, 16, 255, 255, 255, TRUE);
}
public final exec function SetScanReticleRate(float fDegPerSec)
{
    ScanningReticleDegreesPerSecond = fDegPerSec;
}
public exec function setshakelamp(float X, float Y, float Z)
{
    Shake.LocAmplitude.X = X;
    Shake.LocAmplitude.Y = Y;
    Shake.LocAmplitude.Z = Z;
}
public exec function setshakelfreq(float X, float Y, float Z)
{
    Shake.LocFrequency.X = X;
    Shake.LocFrequency.Y = Y;
    Shake.LocFrequency.Z = Z;
}
public exec function setshakeramp(float X, float Y, float Z)
{
    Shake.RotAmplitude.X = X;
    Shake.RotAmplitude.Y = Y;
    Shake.RotAmplitude.Z = Z;
}
public exec function setshakerfreq(float X, float Y, float Z)
{
    Shake.RotFrequency.X = X;
    Shake.RotFrequency.Y = Y;
    Shake.RotFrequency.Z = Z;
}
public exec function setshaket(float T)
{
    Shake.TimeDuration = T;
}
public function ShowHUDAnomalyIndicator()
{
    local BioSFHandler_GalaxyMap oPanel;
    
    oPanel = GetGalaxyMap();
    if (oPanel != None)
    {
        oPanel.Invoke0("showAnomaly");
    }
}
public function ShowProbeImpactVFX(BioPlanet PlanetData, Vector pos, InterpActor Planet)
{
    local ParticleSystemComponent Particle;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    if (GetGameData().ProbeLocationMarker != None)
    {
        Particle = new Class'ParticleSystemComponent';
        Particle.SetTemplate(oGameData.ProbeLocationMarker);
        Particle.SetAbsolute(FALSE, FALSE, FALSE);
        Particle.SetTranslation(pos);
        Particle.SetRotation(Rotator(pos));
        Particle.bAutoActivate = TRUE;
        Planet.AttachComponent(Particle);
        TemporaryComponents.AddItem(Particle);
    }
    PlanetData.SaveProbeImpact(PlanetData.SphereToPlanePos(pos, 100.0));
}
public function StartFeatureSounds()
{
    local SFXGalaxyMapObject oChild;
    local SFXPlanetFeature F;
    local BioWorldInfo BWI;
    local bool LandingSite;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    BWI = BioWorldInfo(oGameData.GetWorldInfo());
    foreach oGameData.CurrentPlanet.Children(oChild, )
    {
        F = SFXPlanetFeature(oChild);
        if (F != None && F.IsVisible())
        {
            if (F.FeatureType == EFeatureType.FEATURE_ANOMOLY)
            {
                LandingSite = TRUE;
            }
            if (F.StartEvent != None && F.StopEvent != None)
            {
                AudioComponent.Play(F.StartEvent);
                AudioComponent.SetWwiseRTPC(F.RTPCName, 1.0);
            }
        }
    }
    if (LandingSite)
    {
        AudioComponent.Play(oGameData.AnomalyStaticStart);
        BWI.GetLocalPlayerController().HintSystem.HintEvent('PlanetScanAnomaly');
    }
}
public exec function StartScanning()
{
    local BioWorldInfo oWorldInfo;
    local BioPlayerController oController;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    if (bRescaling || bExiting)
    {
        return;
    }
    if (oGameData.CurrentPlanet.PlanetLevelType != EBioGalaxyMap_PlanetType.eBioGM_PlanetType_Planet && oGameData.CurrentPlanet.PlanetLevelType != EBioGalaxyMap_PlanetType.eBioGM_PlanetType_PlanetAndRing)
    {
        return;
    }
    oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oController = oWorldInfo.GetLocalPlayerController();
    oController.HintSystem.HintEvent('StartScanning');
    Scanning = TRUE;
    if (!ProbeActive && !ImpactActive)
    {
        ScanReticleEffect.ActivateSystem();
        ScanWipeEffect.ActivateSystem();
    }
    SetLTriggerLabelVisible(FALSE, $0);
    SetRTriggerLabelVisible(TRUE, Class'BioSFHandler_GalaxyMap'.default.TextLaunchProbe);
    Outer.ClientPlayForceFeedbackWaveform(ScanFFWaveForm);
    ScanFFWaveForm.Samples[0].LeftAmplitude = 0;
    ScanFFWaveForm.Samples[0].RightAmplitude = 0;
    StartFeatureSounds();
}
public function StopFeatureSounds()
{
    local SFXGalaxyMapObject oChild;
    local SFXPlanetFeature F;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    foreach oGameData.CurrentPlanet.Children(oChild, )
    {
        F = SFXPlanetFeature(oChild);
        if (F == None)
        {
            continue;
        }
        if (F.StartEvent != None && F.StopEvent != None)
        {
            AudioComponent.Play(F.StopEvent);
        }
    }
}
public exec function StopScanning()
{
    local SFXGalaxyMapObject oChild;
    local SFXPlanetFeature F;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    if (oGameData.CurrentPlanet.PlanetLevelType != EBioGalaxyMap_PlanetType.eBioGM_PlanetType_Planet && oGameData.CurrentPlanet.PlanetLevelType != EBioGalaxyMap_PlanetType.eBioGM_PlanetType_PlanetAndRing)
    {
        return;
    }
    Scanning = FALSE;
    SetLTriggerLabelVisible(TRUE, Class'BioSFHandler_GalaxyMap'.default.TextScan);
    SetRTriggerLabelVisible(FALSE, $0);
    ScanReticleEffect.DeactivateSystem();
    ScanWipeEffect.DeactivateSystem();
    ScanBlipEffect.DeactivateSystem();
    ScanDirectionEffect.DeactivateSystem();
    StopFeatureSounds();
    Outer.ClientStopForceFeedbackWaveform(ScanFFWaveForm);
    foreach oGameData.CurrentPlanet.Children(oChild, )
    {
        F = SFXPlanetFeature(oChild);
        if (F == None)
        {
            continue;
        }
        if (F.StartEvent != None && F.StopEvent != None)
        {
            AudioComponent.Play(F.StopEvent);
        }
    }
    AudioComponent.Play(oGameData.AnomalyStaticStop);
}
public exec function ToggleMouseLock(bool bNewMouseLock)
{
    local BioSFHandler_GalaxyMap oHandler;
    
    bMouseLock = bNewMouseLock;
    oHandler = GetGalaxyMap();
    if (oHandler == None)
    {
        return;
    }
    if (bMouseLock)
    {
        oHandler.SetMouseShown(FALSE);
    }
    else
    {
        oHandler.SetMouseShown(TRUE);
    }
}
public exec function ToggleProbeDebug()
{
    DrawProbeDebugLines = !DrawProbeDebugLines;
}
public function UpdateAnomalyIndicator(Vector toLanding, float DeltaTime, bool flashIndicator)
{
    local Rotator Rot;
    local Vector Dir;
    local float Angle;
    local InterpActor P;
    local float lastRoll;
    local float calcRoll;
    local bool wrapped;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    ScanDirectionPulseTimeToLive -= DeltaTime;
    P = oGameData.Planet;
    wrapped = FALSE;
    lastRoll = Roll;
    Roll += DeltaTime * ScannerRotateSpeed;
    if (Roll > 360.0)
    {
        wrapped = TRUE;
        Roll -= 360.0;
    }
    Rot = ReticleRot;
    calcRoll = Roll * 182.044449;
    Rot.Roll = int(calcRoll);
    ScanWipeEffect.SetRotation(Rot);
    if (flashIndicator == FALSE || ProbeActive == TRUE || ImpactActive)
    {
        return;
    }
    if (VSize(toLanding) * oGameData.CurrentPlanet.m_fPlanetScale < ScanDist)
    {
        if (!ScanBlipEffect.bIsActive)
        {
            ScanBlipEffect.ActivateSystem();
        }
    }
    else if (ScanBlipEffect.bIsActive)
    {
        ScanBlipEffect.DeactivateSystem();
    }
    toLanding = toLanding >> P.Rotation;
    Dir = toLanding << ReticleRot;
    Dir.X = 0.0;
    Dir = Normal(Dir);
    Angle = Atan2(-Dir.Z, Dir.Y) * 57.2957802 + 90.0;
    if (Angle < float(0))
    {
        Angle += 360.0;
    }
    if ((Angle > lastRoll && Angle <= Roll || wrapped && Angle - 360.0 > lastRoll - 360.0 && Angle - 360.0 <= Roll || wrapped && Angle > lastRoll - 360.0 && Angle <= Roll) && ScanDirectionPulseTimeToLive <= 0.0)
    {
        ScanDirectionPulseTimeToLive = ScanDirectionPulseLifeTime;
        Roll = Angle;
        ScanDirectionEffect.ActivateSystem();
        ScanDirectionEffect.SetRotation(Rot);
        ShowHUDAnomalyIndicator();
        if (oGameData.LandingSiteIndicator != None)
        {
            AudioComponent.Play(oGameData.LandingSiteIndicator);
            AudioComponent.SetWwiseRTPC(oGameData.LandingSiteIndicator_RTPCName, VSize(toLanding) / 100.0);
        }
    }
}
public final function UpdatePlanetRotationFromInput(float fDeltaT)
{
    local Rotator Rot;
    local BioSeqAct_OrbitalGame oGameData;
    local float fRotationRate;
    
    oGameData = GetGameData();
    if (ProbeActive || ImpactActive || oGameData == None)
    {
        return;
    }
    Rot = ReticleRot;
    if (oGameData.Planet != None)
    {
        Rot = oGameData.Planet.Rotation;
        fRotationRate = Scanning ? ScanningPlanetRotationDegreesPerSecond : PlanetRotationDegreesPerSecond;
        Rot.Yaw += int(182.044449 * (PlanetScanInputMovement * fRotationRate * fDeltaT));
        oGameData.Planet.SetRotation(Rot);
    }
    PlanetScanInputMovement = 0.0;
}
public function UpdatePlanetScale(float DeltaTime)
{
    local InterpActor oPlanet;
    local Vector vNewScale;
    local Vector vNewRingScale;
    local BioSeqAct_OrbitalGame oGameData;
    
    oGameData = GetGameData();
    fRescaleTime += DeltaTime;
    fRescaleTime = FMin(fRescaleTime, fMaxRescaleTime);
    oPlanet = oGameData.Planet;
    vNewScale.X = FInterpEaseIn(fInitialScale, fNewScale, fRescaleTime / fMaxRescaleTime, 2.0);
    vNewScale.Y = vNewScale.X;
    vNewScale.Z = vNewScale.X;
    oPlanet.SetDrawScale3D(vNewScale);
    if (oGameData.Ring != None)
    {
        vNewRingScale = vNewScale * 6.85500002;
        oGameData.Ring.SetDrawScale3D(vNewRingScale);
    }
    if (oGameData.Clouds != None)
    {
        vNewScale.X *= 1.005;
        vNewScale.Z = vNewScale.X;
        vNewScale.Z = vNewScale.X;
        oGameData.Clouds.SetDrawScale3D(vNewScale);
    }
    if (oGameData.ScanSphere != None)
    {
        oGameData.ScanSphere.SetDrawScale3D(vNewScale);
    }
    if (fRescaleTime >= fMaxRescaleTime)
    {
        bRescaling = FALSE;
        fRescaleTime = 0.0;
    }
}
public final function UpdateReticle(float fDeltaT)
{
    local Rotator Rot;
    local Vector ReticlePos;
    
    UpdateReticleRotationFromInput(fDeltaT);
    Rot = ReticleRot;
    ReticlePos = 100.0 * Vector(ReticleRot);
    ReticleEffect.SetTranslation(ReticlePos);
    ScanReticleEffect.SetTranslation(ReticlePos);
    LaunchReticleEffect.SetTranslation(ReticlePos);
    ScanWipeEffect.SetTranslation(ReticlePos);
    ScanDirectionEffect.SetTranslation(ReticlePos);
    Rot.Pitch -= int(float(90) * 182.044449);
    ReticleEffect.SetRotation(Rot);
    ScanReticleEffect.SetRotation(Rot);
    LaunchReticleEffect.SetRotation(Rot);
}
public final function UpdateReticleRotationFromInput(float fDeltaT)
{
    local float fMovementRate;
    
    if (ProbeActive || ImpactActive)
    {
        return;
    }
    ScanReticleInputMovement.Z = 0.0;
    if (VSize2D(ScanReticleInputMovement) > 1.0)
    {
        ScanReticleInputMovement = Normal(ScanReticleInputMovement);
    }
    fMovementRate = Scanning ? ScanningReticleDegreesPerSecond : ReticleDegreesPerSecond;
    ReticleRot.Yaw -= int(182.044449 * (ScanReticleInputMovement.X * fMovementRate * fDeltaT));
    ReticleRot.Pitch += int(182.044449 * (ScanReticleInputMovement.Y * fMovementRate * fDeltaT));
    if (ReticleRot.Yaw > ReticleRotTopLeftClamp.Yaw || ReticleRot.Yaw < ReticleRotBottomRightClamp.Yaw)
    {
        ReticleRot.Yaw = Clamp(ReticleRot.Yaw, ReticleRotBottomRightClamp.Yaw, ReticleRotTopLeftClamp.Yaw);
        PlanetLeftRight(ScanReticleInputMovement.X);
    }
    ReticleRot.Pitch = Clamp(ReticleRot.Pitch, ReticleRotBottomRightClamp.Pitch, ReticleRotTopLeftClamp.Pitch);
    ScanReticleInputMovement.X = 0.0;
    ScanReticleInputMovement.Y = 0.0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioCameraBehaviorGalaxy Name=GalaxyCam0
    End Template
    Begin Object Class=ForceFeedbackWaveform Name=ScanFFWave
        Samples = ({Duration = 0.0500000007, LeftAmplitude = 100, RightAmplitude = 100, LeftFunction = EWaveformFunction.WF_Sin0to90, RightFunction = EWaveformFunction.WF_Sin90to180}
                  )
        bIsLooping = TRUE
    End Object
    Begin Template Class=SFXCameraTransition_GalaxyMap Name=InstantTransition0
    End Template
    Shake = {
             RotAmplitude = {X = 100.0, Y = 100.0, Z = 80.0}, 
             RotFrequency = {X = 80.0, Y = 80.0, Z = 100.0}, 
             RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
             LocAmplitude = {X = 0.0, Y = 3.0, Z = 5.0}, 
             LocFrequency = {X = 1.0, Y = 10.0, Z = 10.0}, 
             LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
             ShakeName = 'None', 
             TimeToGo = 0.0, 
             TimeDuration = 0.5, 
             RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
             LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
             FOVAmplitude = 2.0, 
             FOVFrequency = 5.0, 
             FOVSinOffset = 0.0, 
             TargetingDampening = 0.0, 
             bOverrideTargetingDampening = FALSE, 
             FOVParam = EShakeParam.ESP_OffsetRandom
            }
    BigShake = {
                RotAmplitude = {X = 0.0, Y = 0.0, Z = 0.0}, 
                RotFrequency = {X = 0.0, Y = 0.0, Z = 0.0}, 
                RotSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                LocAmplitude = {X = 100.0, Y = 0.0, Z = 0.0}, 
                LocFrequency = {X = 10.0, Y = 0.0, Z = 0.0}, 
                LocSinOffset = {X = 0.0, Y = 0.0, Z = 0.0}, 
                ShakeName = 'None', 
                TimeToGo = 0.0, 
                TimeDuration = 0.200000003, 
                RotParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                LocParam = {X = EShakeParam.ESP_OffsetRandom, Y = EShakeParam.ESP_OffsetRandom, Z = EShakeParam.ESP_OffsetRandom, Padding = 0}, 
                FOVAmplitude = 0.0, 
                FOVFrequency = 0.0, 
                FOVSinOffset = 0.0, 
                TargetingDampening = 0.0, 
                bOverrideTargetingDampening = FALSE, 
                FOVParam = EShakeParam.ESP_OffsetRandom
               }
    ReticleRotStart = {Pitch = 639, Yaw = 59569, Roll = 0}
    ReticleRotTopLeftClamp = {Pitch = 9100, Yaw = 65000, Roll = 0}
    ReticleRotBottomRightClamp = {Pitch = -9100, Yaw = 53500, Roll = 0}
    PlanetRotationDegreesPerSecond = 50.0
    ScanningPlanetRotationDegreesPerSecond = 25.0
    ReticleDegreesPerSecond = 90.0
    ScanningReticleDegreesPerSecond = 35.0
    InputAttenuation = 0.0500000007
    RumbleScale = 0.75
    MoveDist = 2.5
    ProbeControlAxisOffset = 500.0
    ProbeControlTargetOffset = 600.0
    ScannerRotateSpeed = 900.0
    ProbeLaunchTimeMax = 2.0
    ScanDist = 165.0
    ScanDirectionPulseLifeTime = 0.75
    ReticleScale = 0.219999999
    fMaxRescaleTime = 0.300000012
    ImpactTimeMax = 1.20000005
    ScanFFWaveForm = ScanFFWave
    DeadZone = 0.200000003
    GalaxyCam = GalaxyCam0
    InstantTransition = InstantTransition0
    Bindings = ({
                 Command = "PC_GalaxyMouseStrafe", 
                 Name = 'MouseX', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_GalaxyMouseMovement", 
                 Name = 'MouseY', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_GalaxyScan", 
                 Name = 'RightMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_GalaxyProbe", 
                 Name = 'LeftMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
}