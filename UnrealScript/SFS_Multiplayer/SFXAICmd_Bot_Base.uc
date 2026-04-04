Class SFXAICmd_Bot_Base extends SFXAICmd_Bot_BaseCover within SFXAI_Bot;

var transient Vector vLoc;
var transient float fDist;
var transient NavigationPoint N;
var transient NavigationPoint BestNav;
var transient float Distance;
var transient float BestDistance;
var transient float TargetRadius;

public function bool ShouldAttack()
{
    local SFXPawn_PlayerMP Player;
    
    Player = SFXPawn_PlayerMP(Outer.FireTarget);
    if (Player != None)
    {
        return !Outer.IsTargetStealthed();
    }
    else
    {
        return TRUE;
    }
}
public function FindCloseNavPoint(Actor A)
{
    BestNav = None;
    BestDistance = 100000000.0;
    foreach Outer.WorldInfo.RadiusNavigationPoints(Class'NavigationPoint', N, A.location, TargetRadius)
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
    public function toggleFollowPlayer()
    {
        if (Outer.FollowPlayer)
        {
            //Make the bot unfollow the player if they have a target.
            Outer.ObjectiveGoalActor = Outer.PlayerPawn;
            Outer.TetherDistanceInCombat = 1000.0;
        }
        else
        {
            //Make the bot follow player if they have no fire target
            Outer.ObjectiveGoalActor = None;
            Outer.TetherDistanceInCombat = 10000.0;
        }
    }
    
Begin:
    Outer.FindDrivablePawn();
    Outer.SetCombatMood(3);
    Outer.currentOffset = Outer.DefaultOffset;
    toggleFollowPlayer();
    if (!Outer.FollowPlayer)
    {
        Outer.Goal = "Combat";
    }
    if (Outer.ObjectiveGoalActor != None)
    {
        fDist = VSize(Outer.MyBP.location - Outer.ObjectiveGoalActor.location);
    }
    else
    {
        fDist = 0.0;
    }
    if (Outer.FireTarget == None)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            if (fDist > Outer.TetherDistanceInCombat)
            {
                Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.ObjectiveGoalActor, Outer.currentOffset);
                if (Outer.bGetFirstMoveTargetFailed)
                {
                    FindCloseNavPoint(Outer.ObjectiveGoalActor);
                    if (BestNav != None)
                    {
                        Outer.bGetFirstMoveTargetFailed = FALSE;
                        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, BestNav, Outer.currentOffset);
                    }
                }
            }
            Outer.Sleep(1.0);
        }
    }
    if (Outer.bAcquireNewCover)
    {
        if (fDist > Outer.TetherDistanceInCombat)
        {
            Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.ObjectiveGoalActor, Outer.currentOffset);
            if (Outer.bGetFirstMoveTargetFailed)
            {
                FindCloseNavPoint(Outer.ObjectiveGoalActor);
                if (BestNav != None)
                {
                    Outer.bGetFirstMoveTargetFailed = FALSE;
                    Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, BestNav, Outer.currentOffset);
                }
            }
        }
        else
        {
            Class'SFXAICmd_AcquireCover'.static.AcquireNewCover(Outer, Outer.AtCover_WeaponRange, Outer.FireTarget);
            Outer.SetTimer(Outer.GetCoverDelayTime(), FALSE, 'FindNewCover', );
        }
    }
    if (Outer.bAcquireNewCover == FALSE || Outer.bReachedCover)
    {
        Outer.bAcquireNewCover = FALSE;
        Outer.bReachedCover = FALSE;
        if (fDist > Outer.TetherDistanceInCombat)
        {
            Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.ObjectiveGoalActor, Outer.currentOffset);
            if (Outer.bGetFirstMoveTargetFailed)
            {
                FindCloseNavPoint(Outer.ObjectiveGoalActor);
                if (BestNav != None)
                {
                    Outer.bGetFirstMoveTargetFailed = FALSE;
                    Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, BestNav, Outer.currentOffset);
                }
            }
        }
        if (ShouldAttack() && (fDist < 1000000.0 || FRand() < 0.5))
        {
            Outer.Attack();
            if (!Outer.bAcquireNewCover)
            {
                Outer.Sleep(0.5);
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
    TargetRadius = 1000.0
}