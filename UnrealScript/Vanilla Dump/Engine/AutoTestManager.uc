Class AutoTestManager extends Info
    native
    config(Game);

var globalconfig array<string> AutomatedMapTestingList;
var string AutomatedTestingExecCommandToRunAtStartMatch;
var string AutomatedMapTestingTransitionMap;
var string SentinelTaskDescription;
var string SentinelTaskParameter;
var string SentinelTagDesc;
var transient array<Vector> SentinelTravelArray;
var config array<string> CommandsToRunAtEachTravelTheWorldNode;
var transient string CommandStringToExec;
var int AutomatedPerfRemainingTime;
var int AutomatedTestingMapIndex;
var globalconfig int NumAutomatedMapTestingCycles;
var int NumberOfMatchesPlayed;
var int NumMapListCyclesDone;
var transient PlayerController SentinelPC;
var transient int SentinelNavigationIdx;
var transient int SentinelIdx;
var transient int NumRotationsIncrement;
var transient int TravelPointsIncrement;
var config int NumMinutesPerMap;
var bool bAutomatedPerfTesting;
var bool bAutoContinueToNextRound;
var bool bUsingAutomatedTestingMapList;
var bool bAutomatedTestingWithOpen;
var bool bCheckingForFragmentation;
var bool bCheckingForMemLeaks;
var bool bDoingASentinelRun;
var transient bool bSentinelStreamingLevelStillLoading;

public native function AddSentinelPerTimePeriodStats(const Vector InLocation, const Rotator InRotation);

public native function BeginSentinelRun(const string TaskDescription, const string TaskParameter, const string TagDesc);

public native function DoSentinel_MemoryAtSpecificLocation(const Vector InLocation, const Rotator InRotation);

public native function DoSentinel_PerfAtSpecificLocation(const out Vector InLocation, const out Rotator InRotation);

public native function DoSentinel_ViewDependentMemoryAtSpecificLocation(const out Vector InLocation, const out Rotator InRotation);

public native function DoSentinelActionPerLoadedMap();

public native function EndSentinelRun(EAutomatedRunResult RunResult);

public native function GetTravelLocations(Name LevelName, PlayerController PC, out array<Vector> TravelPoints);

public native function HandlePerLoadedMapAudioStats();

public event function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    SetTimer(1.0, TRUE, , );
}
public event function StartAutomatedMapTestTimer()
{
    SetTimer(5.0, TRUE, 'StartAutomatedMapTestTimerWorker', );
}
public event function Timer()
{
    if (bAutomatedPerfTesting && AutomatedPerfRemainingTime > 0 && !bAutoContinueToNextRound)
    {
        AutomatedPerfRemainingTime--;
        if (AutomatedPerfRemainingTime <= 0)
        {
            ConsoleCommand("EXIT");
        }
    }
}
public function bool CheckForSentinelRun()
{
    if (bDoingASentinelRun)
    {
        if (SentinelTaskDescription ~= "TravelTheWorld")
        {
            WorldInfo.Game.DoTravelTheWorld();
            return TRUE;
        }
        else
        {
            BeginSentinelRun(SentinelTaskDescription, SentinelTaskParameter, SentinelTagDesc);
            SetTimer(3.0, TRUE, 'DoTimeBasedSentinelStatGathering', );
        }
    }
    return FALSE;
}
public function CloseAutomatedMapTestTimer()
{
    if (Len(AutomatedMapTestingTransitionMap) > 0)
    {
        if (AutomatedTestingMapIndex < 0)
        {
            WorldInfo.Game.RestartGame();
        }
    }
    else
    {
        WorldInfo.Game.RestartGame();
    }
}
public function DoTimeBasedSentinelStatGathering()
{
    local PlayerController PC;
    local Vector ViewLocation;
    local Rotator ViewRotation;
    
    foreach LocalPlayerControllers(Class'PlayerController', PC)
    {
        break;
    }
    PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
    if (SentinelTaskDescription != "FlyThrough" && SentinelTaskDescription != "FlyThroughSplitScreen")
    {
        if (PC.Pawn != None)
        {
            ViewLocation = PC.Pawn.location;
        }
    }
    AddSentinelPerTimePeriodStats(ViewLocation, ViewRotation);
}
public function DoTravelTheWorld()
{
    GotoState('TravelTheWorld', , , );
}
public function string GetNextAutomatedTestingMap()
{
    local string MapName;
    local PlayerController PC;
    local bool bResetMapIndex;
    
    if (bUsingAutomatedTestingMapList)
    {
        if (AutomatedTestingMapIndex >= 0 && Len(AutomatedMapTestingTransitionMap) > 0)
        {
            AutomatedTestingMapIndex++;
            AutomatedTestingMapIndex *= float(-1);
            MapName = AutomatedMapTestingTransitionMap;
        }
        else
        {
            if (Len(AutomatedMapTestingTransitionMap) > 0)
            {
                AutomatedTestingMapIndex *= float(-1);
            }
            if (++AutomatedTestingMapIndex >= AutomatedMapTestingList.Length)
            {
                AutomatedTestingMapIndex = 0;
                NumMapListCyclesDone++;
                bResetMapIndex = TRUE;
            }
            MapName = AutomatedMapTestingList[AutomatedTestingMapIndex];
        }
        if (bAutomatedTestingWithOpen)
        {
            if (NumMapListCyclesDone >= NumAutomatedMapTestingCycles && NumAutomatedMapTestingCycles != 0)
            {
                if (bCheckingForMemLeaks)
                {
                    ConsoleCommand("DEFERRED_STOPMEMTRACKING_AND_DUMP");
                }
            }
        }
        else
        {
            foreach WorldInfo.AllControllers(Class'PlayerController', PC)
            {
                if (bResetMapIndex)
                {
                    PC.PlayerReplicationInfo.AutomatedTestingData.NumMapListCyclesDone++;
                }
                if (PC.PlayerReplicationInfo.AutomatedTestingData.NumMapListCyclesDone >= NumAutomatedMapTestingCycles && NumAutomatedMapTestingCycles != 0)
                {
                    if (bCheckingForMemLeaks)
                    {
                        ConsoleCommand("DEFERRED_STOPMEMTRACKING_AND_DUMP");
                    }
                }
            }
        }
        return MapName;
    }
    return "";
}
public function IncrementAutomatedTestingMapIndex()
{
    if (bUsingAutomatedTestingMapList)
    {
        if (bAutomatedTestingWithOpen)
        {
        }
        else if (AutomatedTestingMapIndex >= 0)
        {
            AutomatedTestingMapIndex++;
        }
    }
}
public function IncrementNumberOfMatchesPlayed()
{
    NumberOfMatchesPlayed++;
}
public function InitializeOptions(string Options)
{
    local string InOpt;
    
    AutomatedPerfRemainingTime = 60 * WorldInfo.Game.TimeLimit;
    bAutomatedPerfTesting = WorldInfo.Game.ParseOption(Options, "AutomatedPerfTesting") ~= "1" || WorldInfo.Game.ParseOption(Options, "gAPT") ~= "1";
    bCheckingForFragmentation = WorldInfo.Game.ParseOption(Options, "CheckingForFragmentation") ~= "1" || WorldInfo.Game.ParseOption(Options, "gCFF") ~= "1";
    bCheckingForMemLeaks = WorldInfo.Game.ParseOption(Options, "CheckingForMemLeaks") ~= "1" || WorldInfo.Game.ParseOption(Options, "gCFML") ~= "1";
    bDoingASentinelRun = WorldInfo.Game.ParseOption(Options, "DoingASentinelRun") ~= "1" || WorldInfo.Game.ParseOption(Options, "gDASR") ~= "1";
    SentinelTaskDescription = WorldInfo.Game.ParseOption(Options, "SentinelTaskDescription");
    if (SentinelTaskDescription == "")
    {
        SentinelTaskDescription = WorldInfo.Game.ParseOption(Options, "gSTD");
    }
    SentinelTaskParameter = WorldInfo.Game.ParseOption(Options, "SentinelTaskParameter");
    if (SentinelTaskParameter == "")
    {
        SentinelTaskParameter = WorldInfo.Game.ParseOption(Options, "gSTP");
    }
    SentinelTagDesc = WorldInfo.Game.ParseOption(Options, "SentinelTagDesc");
    if (SentinelTagDesc == "")
    {
        SentinelTagDesc = WorldInfo.Game.ParseOption(Options, "gSTDD");
    }
    InOpt = WorldInfo.Game.ParseOption(Options, "AutoContinueToNextRound");
    if (InOpt != "")
    {
        bAutoContinueToNextRound = bool(InOpt);
    }
    InOpt = WorldInfo.Game.ParseOption(Options, "bUsingAutomatedTestingMapList");
    if (InOpt != "")
    {
        bUsingAutomatedTestingMapList = bool(InOpt);
    }
    if (bUsingAutomatedTestingMapList)
    {
        if (AutomatedMapTestingList.Length == 0)
        {
            bUsingAutomatedTestingMapList = FALSE;
        }
    }
    InOpt = WorldInfo.Game.ParseOption(Options, "bAutomatedTestingWithOpen");
    if (InOpt != "")
    {
        bAutomatedTestingWithOpen = bool(InOpt);
    }
    AutomatedTestingExecCommandToRunAtStartMatch = WorldInfo.Game.ParseOption(Options, "AutomatedTestingExecCommandToRunAtStartMatch");
    AutomatedMapTestingTransitionMap = WorldInfo.Game.ParseOption(Options, "AutomatedMapTestingTransitionMap");
    InOpt = WorldInfo.Game.ParseOption(Options, "AutomatedTestingMapIndex");
    if (InOpt != "")
    {
        AutomatedTestingMapIndex = int(InOpt);
    }
    if (bAutomatedTestingWithOpen)
    {
        InOpt = WorldInfo.Game.ParseOption(Options, "NumberOfMatchesPlayed");
        if (InOpt != "")
        {
            NumberOfMatchesPlayed = int(InOpt);
        }
        InOpt = WorldInfo.Game.ParseOption(Options, "NumMapListCyclesDone");
        if (InOpt != "")
        {
            NumMapListCyclesDone = int(InOpt);
        }
    }
    else
    {
        AutomatedMapTestingTransitionMap = "";
    }
}
public function StartAutomatedMapTestTimerWorker()
{
    local int LevelIdx;
    
    if (WorldInfo != None)
    {
        for (LevelIdx = 0; LevelIdx < WorldInfo.StreamingLevels.Length; ++LevelIdx)
        {
            if (WorldInfo.StreamingLevels[LevelIdx].bHasLoadRequestPending == TRUE)
            {
                return;
            }
        }
        if (bCheckingForMemLeaks)
        {
            if (Len(AutomatedMapTestingTransitionMap) > 0)
            {
                if (AutomatedTestingMapIndex < 0)
                {
                    WorldInfo.DoMemoryTracking();
                }
            }
            else
            {
                WorldInfo.DoMemoryTracking();
            }
        }
    }
    ClearTimer('StartAutomatedMapTestTimerWorker');
    SetTimer(15.0, FALSE, 'CloseAutomatedMapTestTimer', );
}
public function StartMatch()
{
    local PlayerController PC;
    
    if (bAutomatedTestingWithOpen)
    {
        IncrementNumberOfMatchesPlayed();
    }
    else
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            PC.IncrementNumberOfMatchesPlayed();
            break;
        }
    }
    IncrementAutomatedTestingMapIndex();
    if (bCheckingForFragmentation)
    {
        ConsoleCommand("MemFragCheck");
    }
    if (AutomatedTestingExecCommandToRunAtStartMatch != "")
    {
        ConsoleCommand(AutomatedTestingExecCommandToRunAtStartMatch);
    }
}

state SentinelHandleCauseEventCommand 
{
    
Begin:
    do {
        bSentinelStreamingLevelStillLoading = FALSE;
        for (SentinelIdx = 0; SentinelIdx < WorldInfo.StreamingLevels.Length; ++SentinelIdx)
        {
            if (WorldInfo.StreamingLevels[SentinelIdx].bHasLoadRequestPending == TRUE)
            {
                bSentinelStreamingLevelStillLoading = TRUE;
                Sleep(1.0);
                break;
            }
        }
    } until (!bSentinelStreamingLevelStillLoading);
    if (WorldInfo.Game.CauseEventCommand != "")
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', SentinelPC)
        {
            SentinelPC.ConsoleCommand("ce " $ WorldInfo.Game.CauseEventCommand);
            break;
        }
    }
    if (SentinelTaskDescription == "FlyThrough" || SentinelTaskDescription == "FlyThroughSplitScreen")
    {
        SetTimer(0.5, TRUE, 'DoTimeBasedSentinelStatGathering', );
    }
    stop;
};
state TravelTheWorld 
{
    public function SetIncrementsForLoops(const float NumTravelLocations)
    {
        local float TimeWeGetInSeconds;
        
        TimeWeGetInSeconds = float(NumMinutesPerMap * 60);
        if (CalcTravelTheWorldTime(int(NumTravelLocations), 8) < TimeWeGetInSeconds)
        {
            TravelPointsIncrement = 1;
            NumRotationsIncrement = 1;
            PrintOutTravelWorldTimes(int(CalcTravelTheWorldTime(int(NumTravelLocations), 8)));
        }
        else if (CalcTravelTheWorldTime(int(NumTravelLocations), 4) < TimeWeGetInSeconds)
        {
            TravelPointsIncrement = 1;
            NumRotationsIncrement = 2;
            PrintOutTravelWorldTimes(int(CalcTravelTheWorldTime(int(NumTravelLocations), 4)));
        }
        else
        {
            TravelPointsIncrement = int(CalcTravelTheWorldTime(int(NumTravelLocations), 4) / TimeWeGetInSeconds);
            NumRotationsIncrement = 2;
            PrintOutTravelWorldTimes(int(CalcTravelTheWorldTime(int(NumTravelLocations / float(TravelPointsIncrement)), 4)));
        }
    }
    public function PrintOutTravelWorldTimes(const int TotalTimeInSeconds);
    
    public function float CalcTravelTheWorldTime(const int NumTravelLocations, const int NumRotations)
    {
        local float TotalTimeInSeconds;
        local float PerTravelLocTime;
        
        TotalTimeInSeconds += float(WorldInfo.StreamingLevels.Length) * 2.0;
        TotalTimeInSeconds += 10.0;
        TotalTimeInSeconds += float(WorldInfo.StreamingLevels.Length) * 10.0;
        TotalTimeInSeconds += 10.0;
        TotalTimeInSeconds += 10.0;
        PerTravelLocTime = 0.5 + 4.0 + 1.0 + 0.5 + 1.0 + float(NumRotations) * 1.5 + float(NumRotations) * 1.5;
        TotalTimeInSeconds += PerTravelLocTime * float(NumTravelLocations);
        return TotalTimeInSeconds;
    }
    public function BeginState(Name PreviousStateName)
    {
        local PlayerController PC;
        
        Super(Object).BeginState(PreviousStateName);
        foreach LocalPlayerControllers(Class'PlayerController', PC)
        {
            SentinelPC = PC;
            SentinelPC.Sentinel_SetupForGamebasedTravelTheWorld();
            break;
        }
        SentinelPC.bIsUsingStreamingVolumes = FALSE;
        BeginSentinelRun(SentinelTaskDescription, SentinelTaskParameter, SentinelTagDesc);
    }
    
Begin:
    SentinelPC.Sentinel_PreAcquireTravelTheWorldPoints();
    for (SentinelIdx = 0; SentinelIdx < WorldInfo.StreamingLevels.Length; ++SentinelIdx)
    {
        SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, FALSE, FALSE, TRUE);
    }
    Sleep(10.0);
    WorldInfo.ForceGarbageCollection(TRUE);
    for (SentinelIdx = 0; SentinelIdx < WorldInfo.StreamingLevels.Length; ++SentinelIdx)
    {
        SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, TRUE, TRUE, TRUE);
        Sleep(7.0);
        GetTravelLocations(WorldInfo.StreamingLevels[SentinelIdx].PackageName, SentinelPC, SentinelTravelArray);
        DoSentinelActionPerLoadedMap();
        SentinelPC.ConsoleCommand("FractureAllMeshesToMaximizeMemoryUsage");
        SentinelPC.ConsoleCommand("stat memory");
        Sleep(0.5);
        DoSentinel_MemoryAtSpecificLocation(vect(0.0, 0.0, 0.0), rot(0, 0, 0));
        SentinelPC.ConsoleCommand("stat memory");
        SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, FALSE, FALSE, TRUE);
        Sleep(3.0);
        WorldInfo.ForceGarbageCollection(TRUE);
    }
    if (WorldInfo.StreamingLevels.Length == 0)
    {
        GetTravelLocations(WorldInfo.StreamingLevels[SentinelIdx].PackageName, SentinelPC, SentinelTravelArray);
        DoSentinelActionPerLoadedMap();
        SentinelPC.ConsoleCommand("FractureAllMeshesToMaximizeMemoryUsage");
        SentinelPC.ConsoleCommand("stat memory");
        Sleep(0.5);
        DoSentinel_MemoryAtSpecificLocation(vect(0.0, 0.0, 0.0), rot(0, 0, 0));
        SentinelPC.ConsoleCommand("stat memory");
        Sleep(3.0);
        WorldInfo.ForceGarbageCollection(TRUE);
    }
    SetIncrementsForLoops(float(SentinelTravelArray.Length));
    for (SentinelIdx = 0; SentinelIdx < WorldInfo.StreamingLevels.Length; ++SentinelIdx)
    {
        if (LevelStreamingAlwaysLoaded(WorldInfo.StreamingLevels[SentinelIdx]) != None)
        {
            SentinelPC.ClientUpdateLevelStreamingStatus(WorldInfo.StreamingLevels[SentinelIdx].PackageName, TRUE, TRUE, TRUE);
        }
    }
    SentinelPC.bIsUsingStreamingVolumes = TRUE;
    Sleep(10.0);
    SentinelPC.Sentinel_PostAcquireTravelTheWorldPoints();
    Sleep(10.0);
    SentinelTravelArray.AddItem(SentinelTravelArray[0]);
    SentinelNavigationIdx = 0;
    while (SentinelNavigationIdx < SentinelTravelArray.Length)
    {
        SentinelPC.SetLocation(SentinelTravelArray[SentinelNavigationIdx], );
        SentinelPC.SetRotation(rot(0, 0, 0));
        Sleep(0.5);
        do {
            bSentinelStreamingLevelStillLoading = FALSE;
            for (SentinelIdx = 0; SentinelIdx < WorldInfo.StreamingLevels.Length; ++SentinelIdx)
            {
                if (WorldInfo.StreamingLevels[SentinelIdx].bHasLoadRequestPending == TRUE)
                {
                    bSentinelStreamingLevelStillLoading = TRUE;
                    Sleep(1.0);
                    break;
                }
            }
        } until (!bSentinelStreamingLevelStillLoading);
        WorldInfo.ForceGarbageCollection(TRUE);
        Sleep(1.0);
        if (SentinelNavigationIdx == 0)
        {
            ConsoleCommand("MemLeakCheck");
        }
        SentinelPC.ConsoleCommand("stat memory");
        Sleep(0.5);
        DoSentinel_MemoryAtSpecificLocation(SentinelPC.location, SentinelPC.Rotation);
        SentinelPC.ConsoleCommand("stat memory");
        SentinelPC.ConsoleCommand("stat scenerendering");
        SentinelPC.ConsoleCommand("stat streaming");
        Sleep(1.0);
        SentinelIdx = 0;
        while (SentinelIdx < 8)
        {
            SentinelPC.SetRotation(rot(0, 1, 0) * float((8192 * SentinelIdx)));
            Sleep(1.5);
            DoSentinel_ViewDependentMemoryAtSpecificLocation(SentinelPC.location, SentinelPC.Rotation);
            SentinelIdx += NumRotationsIncrement;
        }
        SentinelPC.ConsoleCommand("stat scenerendering");
        SentinelPC.ConsoleCommand("stat streaming");
        SentinelIdx = 0;
        while (SentinelIdx < 8)
        {
            SentinelPC.SetRotation(rot(0, 1, 0) * float((8192 * SentinelIdx)));
            Sleep(1.5);
            DoSentinel_PerfAtSpecificLocation(SentinelPC.location, SentinelPC.Rotation);
            SentinelIdx += NumRotationsIncrement;
        }
        foreach CommandsToRunAtEachTravelTheWorldNode(CommandStringToExec, )
        {
            ConsoleCommand(CommandStringToExec);
        }
        SentinelNavigationIdx += TravelPointsIncrement;
    }
    ConsoleCommand("MemLeakCheck");
    ConsoleCommand("exit");
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NumMinutesPerMap = 50
}