Class SFXAICmd_CustomAction extends SFXAICommand within SFXAI_Core;

var transient bool bPendingTransition;

public static function bool StartCustomAction(SFXAI_Core AI, Class<SFXAICmd_CustomAction> AICommandClass)
{
    local SFXAICmd_CustomAction Cmd;
    
    if (AI != None && AICommandClass != None)
    {
        Cmd = new (AI) AICommandClass;
        if (Cmd != None)
        {
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public function bool AllowTransitionTo(Class<GameAICommand> AttemptCommand)
{
    if (!CanInterruptCurrentCommand())
    {
        bPendingTransition = TRUE;
        return FALSE;
    }
    return TRUE;
}
public function bool CanInterruptCurrentCommand()
{
    local BioCustomAction pAction;
    
    Outer.MyBP.GetCurrentCustomAction(pAction);
    if (pAction != None)
    {
        return pAction.CanBeInterrupted();
    }
    return TRUE;
}
public function bool ExecuteCustomAction()
{
    Outer.MyBP.DoCustomAction(Outer.MyBP.CurrentCustomAction, , Outer.MyBP.CurrentPowerCustomAction);
    return TRUE;
}
public function FinishedCustomAction();

public function float GetPostCustomActionSleepTime();

public function bool IsCustomActionComplete()
{
    if (Outer.MyBP == None || Outer.MyBP.CurrentCustomAction == 0)
    {
        return TRUE;
    }
    return FALSE;
}
public event function Popped()
{
    local BioCustomAction CurrentAction;
    
    Super(GameAICommand).Popped();
    if (Outer.bDying != TRUE && Outer.MyBP.Physics == EPhysics.PHYS_RigidBody)
    {
    }
    if (!IsCustomActionComplete())
    {
        Outer.MyBP.GetCurrentCustomAction(CurrentAction);
        CurrentAction.InterruptThisCustomAction();
    }
    Outer.bPreparingMove = FALSE;
    Outer.bPreciseDestination = FALSE;
    Outer.bReachedCover = FALSE;
}
public event function Pushed()
{
    Super(GameAICommand).Pushed();
    Outer.bReachedCover = FALSE;
    Outer.bPreparingMove = TRUE;
    if (Outer.MyBP != None)
    {
        Outer.MyBP.StopMovement(FALSE);
    }
    GotoState('CustomAction', , , );
}
public function bool ShouldFinishPostRotation();

public function bool ShouldFinishRotation();


state CustomAction extends DebugState 
{
    
Begin:
    if (ShouldFinishRotation())
    {
        Outer.FinishRotation();
    }
    if (ExecuteCustomAction())
    {
        do {
            Outer.Sleep(0.100000001);
        } until (IsCustomActionComplete());
        if (ShouldFinishPostRotation())
        {
            Outer.FinishRotation();
        }
        FinishedCustomAction();
        if (GetPostCustomActionSleepTime() > 0.0)
        {
            Outer.Sleep(GetPostCustomActionSleepTime());
        }
    }
    else
    {
        Outer.Sleep(0.5);
    }
    if (bPendingTransition)
    {
        Outer.AbortCommand(Self);
    }
    else
    {
        Outer.PopCommand(Self);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}