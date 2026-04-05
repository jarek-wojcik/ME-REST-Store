Class SFXAICmd_MoveToMeleeRange extends SFXAICommand within SFXAI_Core;

var transient Vector MoveLocation;
var transient Actor MeleeTarget;
var transient float m_fMoveOffset;
var transient bool bMovingToLocation;
var transient bool m_bAllowedToFire;
var transient bool m_bShooting;
var transient bool m_bUsePartialPaths;

public function NotifyEnemyVisible(int EnemyIdx, float TimeSinceSeen)
{
    local Pawn EnemyPawn;
    
    if (TimeSinceSeen > 3.0 && EnemyIdx != -1)
    {
        EnemyPawn = Outer.EnemyList[EnemyIdx].Pawn;
        if (EnemyPawn == MeleeTarget)
        {
            if (Outer.MoveGoal == MeleeTarget && Outer.RouteCache.Length > 0)
            {
                if (VSizeSq(Outer.RouteCache[Outer.RouteCache.Length - 1].location - MeleeTarget.location) > 250000.0)
                {
                    Outer.MoveTarget = None;
                }
            }
            else if (bMovingToLocation)
            {
                if (VSizeSq(MoveLocation - MeleeTarget.location) > 250000.0)
                {
                    Outer.MoveTarget = None;
                }
            }
        }
    }
    Super.NotifyEnemyVisible(EnemyIdx, TimeSinceSeen);
}
public function ApproachTarget()
{
    local Actor DestinationActor;
    local float DestinationOffset;
    
    DestinationActor = GetDestinationActor();
    if (DestinationActor != None)
    {
        DestinationOffset = bMovingToLocation ? 0.0 : m_fMoveOffset;
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, DestinationActor, DestinationOffset, m_bAllowedToFire, m_bUsePartialPaths);
    }
    else
    {
        Outer.bReachedMoveGoal = FALSE;
    }
}
public function Actor GetDestinationActor()
{
    local Pawn MeleePawnTarget;
    local Actor DestinationActor;
    local int EnemyIdx;
    local NavigationPoint Nav;
    local SFXGame G;
    
    MeleePawnTarget = Pawn(MeleeTarget);
    if (MeleePawnTarget != None)
    {
        EnemyIdx = Outer.GetEnemyIndex(MeleePawnTarget);
        if (EnemyIdx != -1)
        {
            if (Outer.IsEnemyVisibleByIndex(EnemyIdx) && !MeleePawnTarget.IsInvisible())
            {
                DestinationActor = MeleeTarget;
                bMovingToLocation = FALSE;
            }
            else if (Outer.EnemyList[EnemyIdx].InitialSeenTime > 0.0)
            {
                foreach MeleePawnTarget.WorldInfo.RadiusNavigationPoints(Class'NavigationPoint', Nav, Outer.EnemyList[EnemyIdx].KnownLocation, FMax(m_fMoveOffset, 200.0))
                {
                    if (Nav.IsUsableAnchorFor(Outer.MyBP))
                    {
                        DestinationActor = Nav;
                    }
                    break;
                }
                if (DestinationActor != None)
                {
                    bMovingToLocation = TRUE;
                    MoveLocation = Outer.EnemyList[EnemyIdx].KnownLocation;
                }
            }
        }
    }
    if (DestinationActor == None)
    {
        DestinationActor = MeleeTarget;
        bMovingToLocation = FALSE;
        G = SFXGame(Outer.WorldInfo.Game);
        if (G != None && G.PerceptionManager != None)
        {
            EnemyIdx = Outer.GetEnemyIndex(MeleePawnTarget);
            if (EnemyIdx != -1)
            {
                G.PerceptionManager.DelayedNoticeEnemy(Outer, MeleePawnTarget, 4, 0.25, 'UpdateEnemyFromMove');
            }
        }
    }
    return DestinationActor;
}
public static function bool MoveToMeleeRange(SFXAI_Core AI, Actor Target, optional float NewMoveOffset, optional bool bInAllowedToFire = TRUE, optional bool bInAllowPartialPath = TRUE)
{
    local SFXAICmd_MoveToMeleeRange Cmd;
    
    if (AI != None && Target != None)
    {
        Cmd = new (AI) Class'SFXAICmd_MoveToMeleeRange';
        if (Cmd != None)
        {
            if (Controller(Target) != None)
            {
                Target = Controller(Target).Pawn;
            }
            Cmd.MeleeTarget = Target;
            Cmd.m_fMoveOffset = NewMoveOffset;
            Cmd.m_bAllowedToFire = bInAllowedToFire;
            Cmd.m_bUsePartialPaths = bInAllowPartialPath;
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}

auto state MovingToMeleeRange extends DebugState 
{
    
Begin:
    if (Outer.MyBP == None || Outer.MyBP.IsDead() || MeleeTarget == None)
    {
        Outer.PopCommand(Self);
    }
    ApproachTarget();
    if (Outer.bReachedMoveGoal && bMovingToLocation)
    {
        Outer.MoveTimer = 2.5;
        Class'SFXAICmd_MoveToLocation'.static.MoveToLocation(Outer, MoveLocation, m_fMoveOffset, m_bAllowedToFire, m_bUsePartialPaths, FALSE);
        Outer.ValidateFireTargetLocation();
    }
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}