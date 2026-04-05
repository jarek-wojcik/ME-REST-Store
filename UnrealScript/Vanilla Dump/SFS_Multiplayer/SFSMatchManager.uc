Class SFSMatchManager extends SFSManager within SFXPawn;

function HandleEvent(SFSEvent E)
{
    switch (E.eType)
    {
        case SFSEventType.EVT_DisableWaveMechanic:
            log(Self.Name, "DisablingWaveMechanic", Outer);
            DisableWaveMechanic();
            break;
        default:
    }
}
public function DisableWaveMechanic()
{
    DisableWaves();
    RemoveAllGameAI();
}
public function DisableWaves()
{
    local SFXEngine Engine;
    local BioWorldInfo World;
    local array<Actor> waveCoordinators;
    local Actor waveCoordinatorActor;
    local SFXWaveCoordinator WaveCoordinator;
    local SFXWave Wave;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    World = Engine.GetRealWorldInfo();
    World.FindActorsOfClass(Class'SFXWaveCoordinator', waveCoordinators);
    if (waveCoordinators.Length > 0)
    {
        foreach waveCoordinators(waveCoordinatorActor, )
        {
            if (SFXWaveCoordinator(waveCoordinatorActor) != None)
            {
                WaveCoordinator = SFXWaveCoordinator(waveCoordinatorActor);
                log(Self.Name, "Found WaveCoordinator: " $ WaveCoordinator, Outer);
                break;
            }
        }
        foreach WaveCoordinator.ActiveWaves(Wave, )
        {
            log(Self.Name, "Removing Wave: " $ Wave, Outer);
            Wave.IsActive = FALSE;
            Wave.IsLoading = FALSE;
            WaveCoordinator.ClearAllTimers(Wave);
            WaveCoordinator.ActiveWaves.RemoveItem(Wave);
        }
    }
}
public function RemoveAllGameAI()
{
    local SFXEngine Engine;
    local BioWorldInfo World;
    local SFXPawn AIEnemy;
    local Actor Actor;
    local SFXAI_Core AI;
    local array<Actor> Actors;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    World = Engine.GetRealWorldInfo();
    World.FindActorsOfClass(Class'SFXPawn', Actors);
    foreach Actors(Actor, )
    {
        if (SFXPawn(Actor) != None)
        {
            AIEnemy = SFXPawn(Actor);
            AI = SFXAI_Core(AIEnemy.Controller);
            if (AI != None)
            {
                if (AI.PlayerReplicationInfo.bBot && AI.PlayerReplicationInfo.Group != Class'SFSBotManager'.default.botGroup)
                {
                    log(Self.Name, "Removing AI Enemy: " $ AIEnemy $ " Controlled by: " $ AI, Outer);
                    AIEnemy.Destroy();
                    AI.Destroy();
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ListenedEventTypes = (SFSEventType.EVT_DisableWaveMechanic)
}