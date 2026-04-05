Class SFXAICmd_Berserk extends SFXAICommand_Base_Combat within SFXAI_Cover;

public function bool ShouldMoveToTarget()
{
    local float fDistToTarget;
    
    fDistToTarget = VSize(Outer.FireTarget.location - Outer.Pawn.location);
    return fDistToTarget > 300.0;
}

auto state Combat extends InCombat 
{
    
Begin:
    if (Outer.FireTarget == None)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            Outer.Sleep(1.0);
        }
    }
    if (Outer.ShouldFindBerserkCover())
    {
        Class'SFXAICmd_AcquireCover'.static.AcquireNewCover(Outer, Outer.AtCover_Aggressive, Outer.FireTarget);
    }
    else if (ShouldMoveToTarget())
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.FireTarget, 50.0, TRUE);
    }
    Outer.ShootWeaponAtFireTarget();
    Outer.Sleep(0.5);
    goto 'Begin';
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}