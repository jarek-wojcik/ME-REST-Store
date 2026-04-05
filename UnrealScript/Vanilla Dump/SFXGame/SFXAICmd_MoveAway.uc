Class SFXAICmd_MoveAway extends SFXAICmd_MoveToGoal within SFXAI_Core;

var transient float MaxBackAwayDistance;

public function bool ApplyPathConstraints()
{
    local Vector LastMantleLocation;
    
    if (Outer.MyBP != None && Outer.MoveGoal != None)
    {
        if (Class'Goal_AwayFromPosition'.static.FleeFrom(Outer.MyBP, Outer.MoveGoal.location, int(MaxBackAwayDistance)))
        {
            Class'SFXPath_AvoidClaimedCover'.static.AvoidClaimedCover(Outer.MyBP);
            if (Outer.WorldInfo.GameTimeSeconds - Outer.MyBP.LastMantleTime < 5.0)
            {
                LastMantleLocation = Outer.MyBP.LastMantleLocation;
            }
            if (Outer.MyBP.bCanMantle || Outer.MyBP.bCanClimbUp)
            {
                Class'Path_MinDistBetweenSpecsOfType'.static.EnforceMinDist(Outer.MyBP, 500.0, Class'MantleReachSpec', LastMantleLocation);
            }
            Class'SFXPath_AvoidFireFromCover'.static.AvoidFireFromCover(Outer.MyBP, Outer.m_bAvoidFireFromPlayerOnly);
            return TRUE;
        }
    }
    return FALSE;
}
public function FinishPathGeneration()
{
    Outer.MoveGoal = Outer.RouteGoal;
}
public function bool GetFirstMoveTarget()
{
    if (ApplyPathConstraints() == FALSE)
    {
        return FALSE;
    }
    PushState('PathFinding');
    return TRUE;
}
public static function bool MoveAway(SFXAI_Core AI, Actor AvoidTarget, optional float NewMoveOffset, optional float fMaxBackAwayDistance = 0.0, optional bool bInAllowedToFire = TRUE, optional bool bInAllowPartialPath = TRUE)
{
    local SFXAICmd_MoveAway Cmd;
    
    if (AI != None && AvoidTarget != None)
    {
        Cmd = new (AI) Class'SFXAICmd_MoveAway';
        if (Cmd != None)
        {
            if (Controller(AvoidTarget) != None)
            {
                AvoidTarget = Controller(AvoidTarget).Pawn;
            }
            Cmd.Outer.MoveGoal = AvoidTarget;
            Cmd.Outer.MoveOffset = NewMoveOffset;
            Cmd.MaxBackAwayDistance = fMaxBackAwayDistance;
            Cmd.m_bAllowedToFire = bInAllowedToFire;
            Cmd.m_bUsePartialPaths = bInAllowPartialPath;
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}