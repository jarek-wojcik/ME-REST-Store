Class SFXAICmd_KillingBlow extends SFXAICommand_Base_Combat within SFXAI_Core;

public function MeleeTimeout()
{
    if (Outer.Enemy != None && VSize(Outer.Enemy.location - Outer.Pawn.location) > Outer.EnemyDistance_Long * 2.0)
    {
        Outer.BeginDefaultCommand();
    }
    else
    {
        SetupTimeout();
    }
}
public function Popped()
{
    Super.Popped();
    if (SFXPawn_PlayerParty(Outer.ExecutionTarget) != None)
    {
        SFXPawn_PlayerParty(Outer.ExecutionTarget).SetExecutioner(None);
    }
    Outer.SetTimer(0.5 + FRand() * 0.200000003, TRUE, 'SelectTarget', );
    Outer.FireTarget = None;
    Outer.Enemy = None;
    Outer.SelectTarget();
}
public function Pushed()
{
    Super.Pushed();
    if (SFXPawn_PlayerParty(Outer.ExecutionTarget) != None)
    {
        SFXPawn_PlayerParty(Outer.ExecutionTarget).SetExecutioner(Outer.Pawn);
    }
    Outer.ClearTimer('SelectTarget');
}
public function SetupTimeout()
{
    local float Time;
    local float RouteCacheDist;
    
    RouteCacheDist = Outer.GetRouteCacheDistance();
    if (RouteCacheDist <= 0.0)
    {
        RouteCacheDist = VSize(Outer.Pawn.location - Outer.Enemy.location) * 1.25;
    }
    Time = RouteCacheDist / Outer.MyBP.CombatGroundSpeed + 3.0;
    Outer.SetTimer(Time, FALSE, 'MeleeTimeout', Self);
}

auto state KillMyFoes 
{
    
Begin:
    Outer.FireTarget = Outer.ExecutionTarget;
    Outer.Enemy = Outer.ExecutionTarget;
    if (Outer.MyBP.IsInCover())
    {
        Outer.InvalidateCover();
    }
    if (Outer.InRange(Outer.Enemy.location, Outer.EnemyDistance_Melee) == FALSE)
    {
        SetupTimeout();
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.Enemy, Outer.MeleeMoveOffset, , FALSE);
    }
    else if (Outer.Pawn.FastTrace(Outer.Enemy.location, Outer.Pawn.location, , ) == FALSE)
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.Enemy, Outer.MeleeMoveOffset, , FALSE);
    }
    else
    {
        Outer.bReachedMoveGoal = TRUE;
    }
    if (Outer.bReachedMoveGoal)
    {
        Outer.Focus = Outer.Enemy;
        Outer.FinishRotation();
        Outer.Sleep(SFXGRI(Outer.WorldInfo.GRI).DifficultyHandler.GetFloat('DelayBeforeExecution', 'MPGlobal'));
        if (SFXPawn_PlayerParty(Outer.Enemy).IsReadyForExecution(SFXPawn(Outer.MyBP)))
        {
            Outer.LastCombatActionTime = Outer.WorldInfo.GameTimeSeconds;
            Outer.MyBP.StartCustomAction(136);
        }
    }
    Outer.BeginDefaultCommand();
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}