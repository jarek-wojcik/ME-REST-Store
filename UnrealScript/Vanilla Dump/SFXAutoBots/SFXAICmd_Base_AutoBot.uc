Class SFXAICmd_Base_AutoBot extends SFXAICmd_Base_Cover within SFXAI_AutoBot;

var transient Vector vLoc;
var transient float fDist;
var transient NavigationPoint N;
var transient NavigationPoint BestNav;
var transient float Distance;
var transient float BestDistance;

public function bool ShouldAttack()
{
    return TRUE;
}
public function FindCloseNavPoint(Actor A)
{
    BestNav = None;
    BestDistance = 100000000.0;
    foreach Outer.WorldInfo.RadiusNavigationPoints(Class'NavigationPoint', N, A.location, 500.0)
    {
        if (N != None && N.IsUsableAnchorFor(Outer.MyBP))
        {
            Distance = VSize(N.location - A.location);
            if (BestNav == None || Distance < BestDistance)
            {
                BestDistance = Distance;
                BestNav = N;
            }
        }
    }
}

auto state Combat 
{
    
Begin:
    Outer.FindDrivablePawn();
    if (Outer.ObjectiveGoalActor != None)
    {
        fDist = VSizeSq(Outer.MyBP.location - Outer.ObjectiveGoalActor.location);
    }
    else
    {
        fDist = 0.0;
        Outer.SetCombatMood(4);
    }
    if (Outer.FireTarget == None)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            if (fDist > 250000.0)
            {
                Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.ObjectiveGoalActor, 100.0);
                if (Outer.bGetFirstMoveTargetFailed)
                {
                    FindCloseNavPoint(Outer.ObjectiveGoalActor);
                    if (BestNav != None)
                    {
                        Outer.bGetFirstMoveTargetFailed = FALSE;
                        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, BestNav, 100.0);
                        if (Outer.bGetFirstMoveTargetFailed)
                        {
                        }
                    }
                }
            }
            Outer.Sleep(1.0);
        }
    }
    if (Outer.bAcquireNewCover)
    {
        if (fDist > 0.0 && fDist < 250000.0)
        {
            if (BioWorldInfo(Outer.WorldInfo) != None)
            {
                if (BioCheatManagerNonNative(BioWorldInfo(Outer.WorldInfo).GetLocalPlayerController().CheatManager) != None)
                {
                    BioCheatManagerNonNative(BioWorldInfo(Outer.WorldInfo).GetLocalPlayerController().CheatManager).MPBotsUse(Outer.MyBP, Outer.ObjectiveGoalActor);
                }
            }
        }
        if (fDist > 250000.0)
        {
            Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.ObjectiveGoalActor, 100.0);
            if (Outer.bGetFirstMoveTargetFailed)
            {
                FindCloseNavPoint(Outer.ObjectiveGoalActor);
                if (BestNav != None)
                {
                    Outer.bGetFirstMoveTargetFailed = FALSE;
                    Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, BestNav, 100.0);
                    if (Outer.bGetFirstMoveTargetFailed)
                    {
                    }
                }
            }
        }
        else
        {
            if (Outer.CombatMood == EAICombatMood.AI_Aggressive && !Outer.IsTargetStealthed())
            {
                Class'SFXAICmd_AcquireCover'.static.AcquireNewCover(Outer, Outer.AtCover_Aggressive, Outer.FireTarget);
            }
            else
            {
                Class'SFXAICmd_AcquireCover'.static.AcquireNewCover(Outer, Outer.AtCover_WeaponRange, Outer.FireTarget);
            }
            if (Outer.bReachedCover == FALSE && Outer.CombatMood == EAICombatMood.AI_Aggressive && !Outer.IsTargetStealthed())
            {
                Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.FireTarget, 50.0);
                Outer.bAcquireNewCover = FALSE;
            }
            Outer.SetTimer(Outer.GetCoverDelayTime(), FALSE, 'FindNewCover', );
        }
    }
    if (Outer.bAcquireNewCover == FALSE || Outer.bReachedCover)
    {
        Outer.bAcquireNewCover = FALSE;
        Outer.bReachedCover = FALSE;
        if (fDist > 250000.0)
        {
            Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.ObjectiveGoalActor, 100.0);
            if (Outer.bGetFirstMoveTargetFailed)
            {
                FindCloseNavPoint(Outer.ObjectiveGoalActor);
                if (BestNav != None)
                {
                    Outer.bGetFirstMoveTargetFailed = FALSE;
                    Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, BestNav, 100.0);
                    if (Outer.bGetFirstMoveTargetFailed)
                    {
                    }
                }
            }
        }
        if (ShouldAttack() && (fDist < 1000000.0 || FRand() < 0.5))
        {
            Outer.Attack();
            if (!Outer.bAcquireNewCover)
            {
                Outer.Sleep(1.0);
            }
        }
    }
    Outer.Sleep(0.100000001);
    goto 'Begin';
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}