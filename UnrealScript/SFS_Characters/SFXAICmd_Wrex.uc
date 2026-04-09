Class SFXAICmd_Wrex extends SFXAICmd_Combat_Henchman within SFXAI_Wrex;

state Combat 
{
    
Begin:
    if (Outer.ForcedTarget != None)
    {
        SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(2, Outer.MyBP, BioPawn(Outer.ForcedTarget), , , TRUE);
        Outer.FireTarget = Outer.ForcedTarget;
        Outer.PreferredTarget = Outer.ForcedTarget;
        Outer.ForcedTarget = None;
    }
    while (TRUE)
    {
        if (Outer.m_Orders.Length > 0)
        {
            Outer.PopCommand(Self);
        }
        if (Outer.FireTarget == None && Outer.SelectTarget() == FALSE)
        {
            Outer.PopCommand(Self);
        }
        if (Outer.ShouldFollowPlayer())
        {
            Outer.PopCommand(Self);
        }
        if (Outer.m_bHoldingPosition == FALSE)
        {
            Outer.m_bAvoidDangerLinks = FALSE;
            if (Outer.EnemyWithinMeleeEngagementDistance() == TRUE)
            {
                Class'SFXAICmd_MoveToMeleeRange'.static.MoveToMeleeRange(Outer, Outer.FireTarget, Outer.MeleeMoveOffset);
            }
        }
        else if (Outer.bAcquireNewCover)
        {
            if (Outer.MyBP.IsInCover() == FALSE)
            {
                Outer.MyBP.ShouldCrouch(FALSE);
            }
            Outer.MoveToCoverNearHoldLocation(FALSE);
            if (!Outer.bReachedMoveGoal)
            {
                if (!IsZero(Outer.m_vHoldLocation) && VSizeSq(Outer.m_vHoldLocation - Outer.MyBP.location) > 90000.0)
                {
                    Outer.PathfindToHoldLocation();
                }
            }
            else
            {
                Outer.FindCoverNearHoldLocationCount = 0;
            }
        }
        if (Outer.ShouldMelee(Outer.FireTarget) == TRUE)
        {
            Outer.DoMeleeAttack();
        }
        if (Outer.ShouldAttack() == TRUE)
        {
            Outer.Attack();
        }
        if (Outer.m_Orders.Length > 0 || Outer.ShouldFollowPlayer())
        {
            Outer.PopCommand(Self);
        }
        Outer.Sleep(0.5);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}