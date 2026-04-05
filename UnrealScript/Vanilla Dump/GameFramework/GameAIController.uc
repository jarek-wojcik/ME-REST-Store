Class GameAIController extends AIController
    native
    abstract
    config(Game);

var(Debug) config array<Name> AILogFilter;
var string DemoActionString;
var const transient GameAICommand CommandList;
var transient FileLog AILogFile;
var transient bool bHasRunawayCommandList;
var(Debug) config bool bAILogging;
var(Debug) config bool bAILogToWindow;
var(Debug) config bool bFlushAILogEachLine;
var(Debug) config bool bMapBasedLogName;
var(Debug) config bool bAIDrawDebug;
var transient bool bAIBroken;
var config bool bUseIterativePathFinding;

public event function Destroyed()
{
    Super(Controller).Destroyed();
    if (AILogFile != None)
    {
        AILogFile.Destroy();
    }
    if (CommandList != None)
    {
        AbortCommand(CommandList);
    }
}
public function SetDesiredRotation(Rotator TargetDesiredRotation, optional bool InLockDesiredRotation = FALSE, optional bool InUnlockWhenReached = FALSE, optional float InterpolationTime = -1.0)
{
    if (Pawn != None)
    {
        Pawn.SetDesiredRotation(TargetDesiredRotation, InLockDesiredRotation, InUnlockWhenReached, InterpolationTime);
    }
}
public final native function bool AbortCommand(GameAICommand AbortCmd, optional Class<GameAICommand> AbortClass);

public event function AILog_Internal(coerce string LogText, optional Name LogCategory, optional bool bForce);

public final native function CheckCommandCount();

public final native function DumpCommandStack();

public final native function coerce GameAICommand FindCommandOfClass(Class<GameAICommand> SearchClass);

public event function bool GeneratePathToActor(Actor Goal, optional float WithinDistance, optional bool bAllowPartialPath);

public event function bool GeneratePathToLocation(Vector Goal, optional float WithinDistance, optional bool bAllowPartialPath);

public final event simulated function string GetActionString()
{
    local string ActionStr;
    local GameAICommand ActiveCmd;
    
    if (WorldInfo.IsPlayingDemo())
    {
        return DemoActionString;
    }
    else
    {
        ActiveCmd = GetActiveCommand();
        if (ActiveCmd != None)
        {
            ActionStr = ActiveCmd.Class $ ":" $ ActiveCmd.GetStateName();
        }
        else
        {
            ActionStr = default.Class $ ":" $ GetStateName();
        }
        return ActionStr;
    }
}
public final native function GameAICommand GetActiveCommand();

public native function GameAICommand GetAICommandInStack(const Class<GameAICommand> InClass);

public final native function PopCommand(GameAICommand ToBePoppedCommand);

public final native function PushCommand(GameAICommand NewCommand);

protected function RecordDemoAILog(coerce string LogText);


state DebugState 
{
    public function PausedState()
    {
    }
    public function ContinuedState()
    {
    }
    public function PoppedState()
    {
    }
    public function PushedState()
    {
    }
    public function EndState(Name NextStateName)
    {
    }
    public function BeginState(Name PreviousStateName)
    {
    }
    
    stop;
};

replication
{
    if (bDemoRecording)
        DemoActionString;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}