Class BioSeqAct_MultiLand extends SeqAct_Latent;

var(Config) Rotator ReticleRotStart;
var(Config) Rotator ReticleRotMaxClamp;
var(Config) Rotator ReticleRotMinClamp;
var(Actors) InterpActor Planet;
var(ParticleSystems) ParticleSystem Reticle;
var(ParticleSystems) ParticleSystem LandingSiteMarker;
var(ParticleSystems) float LandingSiteScale;
var transient BioPlanet CurrentPlanet;

public event function Activated()
{
    local BioCameraBehaviorGalaxy GalaxyCam;
    local BioPlayerController PC;
    
    GalaxyCam = GetGalaxyCamera();
    CurrentPlanet = GalaxyCam.GetActivePlanet();
    if (CurrentPlanet == None || CurrentPlanet.IsMultiLand() == FALSE || BioWorldInfo(GetWorldInfo()).CheckConditional(CurrentPlanet.PlanetLandCondition, CurrentPlanet.PlanetLandCondition) == FALSE)
    {
        EndAction();
        return;
    }
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    if (PC != None)
    {
        PC.GameModeManager2.EnableMode(13);
    }
}
public event function bool Update(float DeltaTime)
{
    local BioPlayerController PC;
    local SFXGameModeMultiLand GameMode;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    if (PC != None)
    {
        GameMode = SFXGameModeMultiLand(PC.GameModeManager2.HACK_GetMultiLandMode());
        if (GameMode == None || !PC.GameModeManager2.IsActive(13))
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

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReticleRotStart = {Pitch = 0, Yaw = 59500, Roll = 0}
    ReticleRotMaxClamp = {Pitch = 10500, Yaw = 70000, Roll = 0}
    ReticleRotMinClamp = {Pitch = -10500, Yaw = 48000, Roll = 0}
    LandingSiteScale = 0.25
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
                    LinkDesc = "Aborted", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Cancelled", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    bManualHandleOutputs = TRUE
}