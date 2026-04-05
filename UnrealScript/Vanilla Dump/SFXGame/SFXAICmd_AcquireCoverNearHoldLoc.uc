Class SFXAICmd_AcquireCoverNearHoldLoc extends SFXAICmd_AcquireCover within SFXAI_Henchman;

var transient CoverLink OriginalCoverLink;
var transient bool bInitialPlayerOrder;

public static function bool AcquireCoverNearHoldLoc(SFXAI_Henchman AI, Goal_AtCover GoalEvaluator, Actor GoalActor, bool bPlayerOrder, optional bool bUsePeriodicCheck = TRUE, optional bool bAllowedToFire = TRUE)
{
    local SFXAICmd_AcquireCoverNearHoldLoc Cmd;
    
    if (AI != None && AI.MyBP != None && GoalEvaluator != None && GoalActor != None)
    {
        Cmd = new (AI) Class'SFXAICmd_AcquireCoverNearHoldLoc';
        if (Cmd != None)
        {
            Cmd.CoverEvaluator = GoalEvaluator;
            Cmd.CoverGoalActor = GoalActor;
            Cmd.bInitialPlayerOrder = bPlayerOrder;
            Cmd.bDoPeriodicCoverCheck = bUsePeriodicCheck;
            Cmd.bCanShoot = bAllowedToFire;
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}

auto state FindingCoverNearHold extends DebugState 
{
    
Begin:
    Outer.MyCoverEval = CoverEvaluator;
    OriginalCoverLink = Outer.MyBP.CurrentLink;
    Outer.InitializeCoverConstraints(CoverEvaluator, CoverGoalActor);
    Outer.FindPathTowardIterative(CoverGoalActor, FALSE, 2000);
    if (Outer.MoveTarget == None)
    {
        Outer.LastFailedPathTime = Outer.WorldInfo.GameTimeSeconds;
        Outer.bReachedMoveGoal = FALSE;
        if (bInitialPlayerOrder)
        {
            SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(7, Outer.MyBP, , , , TRUE);
        }
        Outer.PopCommand(Self);
    }
    Outer.LastSuccessfulPathTime = Outer.WorldInfo.GameTimeSeconds;
    NewCoverGoal = CoverSlotMarker(Outer.RouteCache[Outer.RouteCache.Length - 1]).OwningSlot;
    if (Outer.IsValidCover(NewCoverGoal) == FALSE || NewCoverGoal.Link.Slots[NewCoverGoal.SlotIdx].SlotMarker == None)
    {
        Outer.PopCommand(Self);
    }
    if (Outer.MyBP.CurrentLink == NewCoverGoal.Link && Outer.MyBP.CurrentSlotIdx == NewCoverGoal.SlotIdx)
    {
        Outer.bReachedCover = TRUE;
        Outer.PopCommand(Self);
    }
    if (Outer.ClaimCover(NewCoverGoal) == FALSE)
    {
        Outer.PopCommand(Self);
    }
    Outer.CoverGoal = NewCoverGoal;
    if (bInitialPlayerOrder)
    {
        if (OriginalCoverLink == None || Outer.CoverGoal.Link != None && Outer.CoverGoal.Link != OriginalCoverLink)
        {
            SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(9, Outer.MyBP, , , , TRUE);
        }
        else
        {
            SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(7, Outer.MyBP, , , , TRUE);
        }
    }
    Outer.m_bUsePeriodicCoverCheck = bDoPeriodicCoverCheck;
    Class'SFXAICmd_MoveToCover'.static.MoveToCover(Outer, Outer.m_bUsePeriodicCoverCheck, bCanShoot);
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}