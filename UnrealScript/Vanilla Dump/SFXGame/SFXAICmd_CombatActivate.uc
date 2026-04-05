Class SFXAICmd_CombatActivate extends SFXAICmd_CustomAction within SFXAI_Core
    deprecated;

public function NotifyNewEnemy(Pawn NewEnemy)
{
    Super(SFXAICommand).NotifyNewEnemy(NewEnemy);
    if (Outer.IsTimerActive('WakeOnNotify') == FALSE)
    {
        Outer.SetTimer(FRand() * 2.0, FALSE, 'WakeOnNotify', Self);
    }
}
public function Pushed()
{
    Super.Pushed();
    GotoState('CombatActivate', , , );
}
public function WakeOnNotify();


state CombatActivate 
{
    
Begin:
    if (ShouldFinishRotation())
    {
        Outer.FinishRotation();
    }
    if (ExecuteCustomAction())
    {
        if (Outer.MyBP != None && Outer.MyBP.IsDead() == FALSE && Outer.MyBP.Squad != None)
        {
            if (!Outer.HasAnyEnemies())
            {
            }
        }
        Outer.MyBP.SetHidden(FALSE);
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