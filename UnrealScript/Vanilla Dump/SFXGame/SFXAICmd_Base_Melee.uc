Class SFXAICmd_Base_Melee extends SFXAICommand_Base_Combat within SFXAI_Core;

public final function bool IsProtectedByCover(Pawn ChkPawn)
{
    local BioPawn BP;
    local Vector ToMe;
    
    BP = BioPawn(ChkPawn);
    if (BP != None && (BP.IsInCover() || BP.CoverAction == ECoverAction.CA_Aimback))
    {
        ToMe = Normal(Outer.Pawn.location - BP.location);
        if (ToMe Dot Vector(BP.CurrentLink.GetSlotRotation(BP.CurrentSlotIdx)) > 0.707000017)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function MeleeTimeout()
{
    if (Outer.Enemy != None && VSize(Outer.Enemy.location - Outer.Pawn.location) > Outer.EnemyDistance_Melee * 2.0)
    {
        Outer.BeginDefaultCommand();
    }
    else
    {
        SetupTimeout();
    }
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

auto state Melee extends InCombat 
{
    
Begin:
    if (Outer.FireTarget == None)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            Outer.Sleep(1.0);
        }
    }
    if (Outer.MyBP.IsInCover())
    {
        Outer.InvalidateCover();
    }
    if (Outer.InRange(Outer.Enemy.location, Outer.EnemyDistance_Melee) == FALSE || IsProtectedByCover(Outer.Enemy))
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
        Outer.Focus = Outer.FireTarget;
        Outer.FinishRotation();
        if (Outer.MyBP.IsValidTargetFor(Outer.Enemy.Controller))
        {
            Outer.DoMeleeAttack();
        }
    }
    Outer.LastMeleeTime = Outer.WorldInfo.GameTimeSeconds;
    Outer.BeginDefaultCommand();
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}