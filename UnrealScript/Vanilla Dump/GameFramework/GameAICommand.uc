Class GameAICommand within GameAIController
    native
    abstract;

var const transient Name ChildStatus;
var transient Name Status;
var const transient GameAICommand ChildCommand;
var transient GameAIController GameAIOwner;
var bool bAllowNewSameClassInstance;
var bool bReplaceActiveSameClassInstance;
var transient bool bAborted;
var bool bIgnoreNotifies;
var transient bool bPendingPop;

public event function string GetDumpString()
{
    return string(Self);
}
public function Paused(GameAICommand NewCommand)
{
}
public function Tick(float DeltaTime);

public event function DrawDebug(HUD H, Name Category);

public final event function InternalPaused(GameAICommand NewCommand)
{
    Paused(NewCommand);
}
public event function InternalPopped()
{
    EndState('None');
    Popped();
    GameAIOwner = None;
    PostPopped();
}
public final event function InternalPrePushed(GameAIController AI)
{
    GameAIOwner = AI;
    PrePushed(AI);
}
public final event function InternalPushed()
{
    GotoState('Auto', , , );
    Pushed();
}
public final event function InternalResumed(Name OldCommandName)
{
    Resumed(OldCommandName);
}
public final event function InternalTick(float DeltaTime)
{
    Tick(DeltaTime);
}
public final native function bool ShouldIgnoreNotifies();

public function bool AllowStateTransitionTo(Name StateName)
{
    return ChildCommand == None || ChildCommand.AllowStateTransitionTo(StateName);
}
public function bool AllowTransitionTo(Class<GameAICommand> AttemptCommand)
{
    return ChildCommand == None || ChildCommand.AllowTransitionTo(AttemptCommand);
}
public function GetDebugOverheadText(PlayerController PC, out array<string> OutText);

public static function bool InitCommand(GameAIController AI)
{
    local GameAICommand Cmd;
    
    if (AI != None)
    {
        Cmd = new (AI) default.Class;
        if (Cmd != None)
        {
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public static function bool InitCommandUserActor(GameAIController AI, Actor UserActor)
{
    return InitCommand(AI);
}
public function Popped()
{
}
public function PostPopped();

public function PrePushed(GameAIController AI);

public function Pushed()
{
}
public function Resumed(Name OldCommandName)
{
}

state DelaySuccess 
{
    
Begin:
    Outer.Sleep(0.100000001);
    Status = 'Success';
    Outer.PopCommand(Self);
    stop;
};
state DelayFailure 
{
    
Begin:
    Outer.Sleep(0.5);
    Status = 'Failure';
    Outer.PopCommand(Self);
    stop;
};
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

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}