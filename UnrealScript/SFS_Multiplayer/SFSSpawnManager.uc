Class SFSSpawnManager extends SFSCore within SFSBotManager;

var array<Class<MapSpawnsContainer>> MapSpawnContainers;
var int nearbyDistance;

public function SpawnPoint findSpawnPoint(SFXAI_Core AIController, SFXPawn Player)
{
    local SFXGameInfoMP Gimp;
    local string MapName;
    local SpawnPoint SpawnPoint;
    local NavigationPoint AlternativeStart;
    local array<SpawnPoint> spawnPoints;
    local Class<MapSpawnsContainer> spawnContainer;
    
    Gimp = SFXGameInfoMP(Class'Engine'.static.GetCurrentWorldInfo().Game);
    MapName = GetMapName(Gimp);
    spawnContainer = getSpawnContainer(MapName);
    if (spawnContainer != None)
    {
        spawnPoints = RandomOrder(spawnContainer.default.spawnPoints);
        foreach spawnPoints(SpawnPoint, )
        {
            if (!isSpawnPointOccupied(SpawnPoint.location))
            {
                log(Self.Name, "Using Spawn Point: " $ SpawnPoint.location, Outer.Outer);
                return SpawnPoint;
            }
        }
    }
    log(Self.Name, "No Spawn Container found for map name: " $ MapName, Outer.Outer);
    log(Self.Name, "No unoccupied spawn points found, falling back on FindPlayerStart()", Outer.Outer);
    AlternativeStart = Gimp.FindPlayerStart(AIController, AIController.GetTeamNum());
    if (AlternativeStart != None)
    {
        SpawnPoint.location = AlternativeStart.location;
        SpawnPoint.Rotation = AlternativeStart.Rotation;
        return SpawnPoint;
    }
    else
    {
        log(Self.Name, "No alternative start found, falling back PlayerLocation", Outer.Outer);
        SpawnPoint.location = Player.location;
        SpawnPoint.Rotation = Player.Rotation;
        return SpawnPoint;
    }
}
public function bool isSpawnPointOccupied(Vector SpawnPoint)
{
    local array<SFXPawn> Bots;
    local SFXPawn Bot;
    local bool Result;
    
    Result = FALSE;
    Bots = Outer.AllBots;
    foreach Bots(Bot, )
    {
        if (isNearby(Bot.location, SpawnPoint))
        {
            log(Self.Name, "Bot " $ Bot.Name $ " is nearby spawn point " $ SpawnPoint, Outer.Outer);
            Result = TRUE;
        }
    }
    log(Self.Name, "Spawn Point Occupied: " $ SpawnPoint $ " " $ Result, Outer.Outer);
    return Result;
}
public function bool isNearby(Vector location1, Vector location2)
{
    local float DistanceXY;
    
    DistanceXY = VSize(location1 - location2);
    log(Self.Name, "Distance between vectors:" $ location1 $ " and " $ location2 $ " is " $ DistanceXY, Outer.Outer);
    DistanceXY = Abs(DistanceXY);
    return DistanceXY <= float(default.nearbyDistance);
}
public function Class<MapSpawnsContainer> getSpawnContainer(string MapName)
{
    local Class<MapSpawnsContainer> Result;
    
    foreach default.MapSpawnContainers(Result, )
    {
        if (Result.default.MapName == MapName)
        {
            return Result;
        }
    }
    return None;
}
public function array<SpawnPoint> RandomOrder(array<SpawnPoint> InArray)
{
    local array<SpawnPoint> ShuffledArray;
    local int Index;
    local int RandomIndex;
    local SpawnPoint Temp;
    
    ShuffledArray = InArray;
    for (Index = ShuffledArray.Length - 1; Index > 0; Index--)
    {
        RandomIndex = Rand(Index + 1);
        Temp = ShuffledArray[Index];
        ShuffledArray[Index] = ShuffledArray[RandomIndex];
        ShuffledArray[RandomIndex] = Temp;
    }
    return ShuffledArray;
}
public function string GetMapName(SFXGameInfoMP Gimp)
{
    local SFXEngine Engine;
    local string Result;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    Result = Gimp.GetURLMap();
    //Class'LoggingUtilsMP'.static.log("MapName is: " $ Result);
    return Result;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bDebug = TRUE
    nearbyDistance = 100
    MapSpawnContainers = (Class'FirebaseWhiteSpawnsContainer', 
                          Class'FireBaseWhiteHazardSpawnsContainer', 
                          Class'FirebaseGiantSpawnsContainer', 
                          Class'FirebaseGiantHazardSpawnsContainer', 
                          Class'FirebaseVancouverSpawnsContainer', 
                          Class'FirebaseDaggerSpawnsContainer', 
                          Class'FirebaseDaggerHazardSpawnsContainer', 
                          Class'FirebaseHydraSpawnsContainer', 
                          Class'FirebaseJadeSpawnsContainer', 
                          Class'FirebaseCondorSpawnsContainer', 
                          Class'FirebaseGhostSpawnsContainer', 
                          Class'FirebaseGhostHazardSpawnsContainer', 
                          Class'FirebaseReactorSpawnsContainer', 
                          Class'FirebaseReactorHazardSpawnsContainer', 
                          Class'FirebaseGoddessSpawnsContainer', 
                          Class'FirebaseLondonSpawnsContainer', 
                          Class'FirebaseRioSpawnsContainer', 
                          Class'FirebaseGlacierSpawnsContainer', 
                          Class'FirebaseGlacierHazardSpawnsContainer', 
                          Class'MarsArchivesSpawnsContainer'
                         )
}