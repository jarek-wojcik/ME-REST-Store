Class BioSeqAct_OrbitalGame extends SeqAct_Latent;

var(Audio) array<WwiseBaseSoundObject> MineralStartEvents;
var(Audio) array<WwiseBaseSoundObject> MineralStopEvents;
var(Audio) array<string> MineralRTPCNames;
var(Audio) string LandingSiteIndicator_RTPCName;
var(Audio) array<WwiseBaseSoundObject> AnomalyDetectedVO;
var(Audio) array<WwiseBaseSoundObject> ProbeLaunchedVO;
var(Config) Rotator ReticleRotStart;
var(Config) Rotator ReticleRotMaxClamp;
var(Config) Rotator ReticleRotMinClamp;
var(Actors) InterpActor Planet;
var(Actors) InterpActor Clouds;
var(Actors) InterpActor Probe;
var(Actors) InterpActor Ring;
var(Actors) InterpActor ScanSphere;
var(Actors) Emitter ProbeTrail;
var(ParticleSystems) ParticleSystem LandingSiteMarker;
var(ParticleSystems) ParticleSystem Reticle;
var(ParticleSystems) ParticleSystem ScanReticle;
var(ParticleSystems) ParticleSystem LaunchReticle;
var(ParticleSystems) ParticleSystem ScanWipe;
var(ParticleSystems) ParticleSystem ScanDirection;
var(ParticleSystems) ParticleSystem ScanBlip;
var(ParticleSystems) ParticleSystem ProbeImpact;
var(ParticleSystems) ParticleSystem ProbeLocationMarker;
var(Audio) WwiseBaseSoundObject ProbeImpactSound;
var(Audio) WwiseBaseSoundObject MineralRecoverySound_None;
var(Audio) WwiseBaseSoundObject MineralRecoverySound_Small;
var(Audio) WwiseBaseSoundObject MineralRecoverySound_Medium;
var(Audio) WwiseBaseSoundObject MineralRecoverySound_Large;
var(Audio) WwiseBaseSoundObject ProbeLaunchSound_NoProbes;
var(Audio) WwiseBaseSoundObject LandingSiteIndicator;
var(Audio) WwiseBaseSoundObject AnomalyStaticStart;
var(Audio) WwiseBaseSoundObject AnomalyStaticStop;
var transient BioPlanet CurrentPlanet;

public event function Activated()
{
    local BioCameraBehaviorGalaxy GalaxyCam;
    local BioPlayerController PC;
    local SFXGameModeOrbital GameMode;
    
    GalaxyCam = GetGalaxyCamera();
    CurrentPlanet = GalaxyCam.GetActivePlanet();
    if (CurrentPlanet == None)
    {
        EndAction();
        return;
    }
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    if (PC != None)
    {
        PC.GameModeManager2.EnableMode(12);
        GameMode = SFXGameModeOrbital(PC.GameModeManager2.HACK_GetOrbitalMode());
        if (GameMode != None)
        {
            CurrentPlanet.LoadPlanetData(Planet, GameMode.TemporaryComponents);
        }
    }
}
public event function bool Update(float DeltaTime)
{
    local BioPlayerController PC;
    local SFXGameModeOrbital GameMode;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    if (PC != None)
    {
        GameMode = SFXGameModeOrbital(PC.GameModeManager2.HACK_GetOrbitalMode());
        if (GameMode == None || !PC.GameModeManager2.IsActive(12))
        {
            bCancelled = TRUE;
        }
    }
    if (bAborted)
    {
        bAborted = FALSE;
        return TRUE;
    }
    return FALSE;
}
public function EndAction()
{
    OutputLinks[0].bHasImpulse = TRUE;
    bAborted = TRUE;
}
public function BioCameraBehaviorGalaxy GetGalaxyCamera()
{
    return BioCameraBehaviorGalaxy(BioWorldInfo(GetWorldInfo()).GetLocalPlayerController().GameModeManager2.HACK_GetCameraMode(11));
}
public function SignalProbeImpact()
{
    OutputLinks[2].bHasImpulse = TRUE;
}
public function SignalProbeLaunch()
{
    OutputLinks[1].bHasImpulse = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReticleRotStart = {Pitch = 0, Yaw = 32768, Roll = 0}
    ReticleRotMaxClamp = {Pitch = 6000, Yaw = 38000, Roll = 0}
    ReticleRotMinClamp = {Pitch = -6000, Yaw = 24576, Roll = 0}
    InputLinks = ({
                   LinkDesc = "Activate", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Exit", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "LaunchProbe", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "ProbeImpact", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    bManualHandleOutputs = TRUE
}