Class SFXAICommand_Base_Combat extends SFXAICommand within SFXAI_Core;

var Vector2D InitialTransitionCheckTime;
var Vector2D TransitionCheckTime;
var bool bFiringWeapon;

public final function float GetInitialTransitionCheckTime()
{
    return RandRange(default.InitialTransitionCheckTime.X, default.InitialTransitionCheckTime.Y);
}
public final function float GetTransitionCheckTime()
{
    return RandRange(default.TransitionCheckTime.X, default.TransitionCheckTime.Y);
}
public function Popped()
{
    Super(GameAICommand).Popped();
    Outer.ClearTimer('CheckTimedCombatTransition');
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    Outer.SetTimer(GetInitialTransitionCheckTime(), FALSE, 'CheckTimedCombatTransition', );
}
public function Resumed(Name OldCommandName)
{
    Super.Resumed(OldCommandName);
    if (Outer.PendingCommand != None)
    {
        Outer.BeginCombatCommand(Outer.PendingCommand);
    }
}
public function StopSustainedFire()
{
    if (bFiringWeapon)
    {
        bFiringWeapon = FALSE;
        Outer.CancelAction();
    }
}

state SustainedWeaponFire 
{
    public function PoppedState()
    {
        Super(Object).PoppedState();
        bFiringWeapon = FALSE;
        if (Outer.IsTimerActive('StopSustainedFire', Self))
        {
            Outer.ClearTimer('StopSustainedFire', Self);
        }
    }
    
Begin:
    bFiringWeapon = TRUE;
    Outer.m_bCancelAction = FALSE;
    Outer.FireTarget = Outer.CurrentKismetOrder.oTargetActor;
    Outer.Focus = Outer.FireTarget;
    Outer.SetTimer(Outer.CurrentKismetOrder.fAttackDuration, FALSE, 'StopSustainedFire', Self);
    while (bFiringWeapon && !Outer.m_bCancelAction)
    {
        Outer.ShootWeaponAtFireTarget(0.0, Outer.CurrentKismetOrder.bForceShoot);
        if (Outer.MyBP.IsReloading())
        {
            Outer.Sleep(0.25);
            continue;
        }
        Outer.Sleep(0.100000001);
    }
    if (Outer.CurrentKismetOrder.FireCallback != None)
    {
        Outer.__FireWeaponDelegate__Delegate = Outer.CurrentKismetOrder.FireCallback;
        if (!bFiringWeapon)
        {
            Outer.__FireWeaponDelegate__Delegate(1);
        }
        else if (Outer.m_bCancelAction)
        {
            Outer.__FireWeaponDelegate__Delegate(0);
        }
        else
        {
            Outer.__FireWeaponDelegate__Delegate(2);
        }
        Outer.__FireWeaponDelegate__Delegate = None;
    }
    PopState();
    stop;
};
state InCombat extends DebugState 
{
    public function EndState(Name NextStateName)
    {
        Super.EndState(NextStateName);
        Outer.ClearTimer('SelectTarget');
        Outer.ClearTimer('Taunt');
    }
    public function BeginState(Name PreviousStateName)
    {
        Super.BeginState(PreviousStateName);
        Outer.SetTimer(0.5 + FRand() * 0.200000003, TRUE, 'SelectTarget', );
        Outer.SetTimer(10.0, TRUE, 'Taunt', );
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InitialTransitionCheckTime = {X = 1.0, Y = 1.0}
    TransitionCheckTime = {X = 1.0, Y = 1.0}
    bAbortIfChildFailed = FALSE
}