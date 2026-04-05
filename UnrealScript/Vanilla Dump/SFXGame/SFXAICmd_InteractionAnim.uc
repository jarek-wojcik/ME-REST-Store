Class SFXAICmd_InteractionAnim extends SFXAICmd_CustomAction within SFXAI_Core;

var transient SFXCustomAction_InteractionPointAnim InteractionCustomAction;

public function NotifyNewEnemy(Pawn NewEnemy)
{
    Super(SFXAICommand).NotifyNewEnemy(NewEnemy);
    if (Outer.IsTimerActive('WakeOnNotify') == FALSE)
    {
        Outer.SetTimer(FRand() * 0.5, FALSE, 'WakeOnNotify', Self);
    }
}
public function bool NotifyMoodChange()
{
    return TRUE;
}
public function WakeOnNotify()
{
    if (InteractionCustomAction != None)
    {
        InteractionCustomAction.TriggerEnd();
    }
}

state CustomAction 
{
    public function GetInteractionAction()
    {
        local BioCustomAction CurrentAction;
        
        if (Outer.MyBP.GetCurrentCustomAction(CurrentAction))
        {
            InteractionCustomAction = SFXCustomAction_InteractionPointAnim(CurrentAction);
        }
    }
    
Begin:
    if (ShouldFinishRotation())
    {
        Outer.FinishRotation();
    }
    if (ExecuteCustomAction())
    {
        if (Outer.MyBP != None && Outer.MyBP.IsDead() == FALSE)
        {
            GetInteractionAction();
            if (!Outer.HasAnyEnemies())
            {
                if (InteractionCustomAction != None)
                {
                    InteractionCustomAction.TriggerStart();
                }
            }
        }
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
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}