Class SFXAICmd_MoveToHoldLocation extends SFXAICommand within SFXAI_Henchman;

public static function bool MoveToHoldLocation(SFXAI_Henchman AI)
{
    local SFXAICmd_MoveToHoldLocation Cmd;
    
    if (AI != None)
    {
        Cmd = new (AI) Class'SFXAICmd_MoveToHoldLocation';
        if (Cmd != None)
        {
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public function Popped()
{
    Outer.ClearTimer('SelectTarget');
    Super(GameAICommand).Popped();
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    Outer.SetTimer(0.5 + FRand() * 0.5, TRUE, 'SelectTarget', );
    GotoState('MovingToHoldLocation', , , );
}
public function Resumed(Name OldCommandName)
{
    Super.Resumed(OldCommandName);
    if (Outer.m_bCancelAction && (Outer.m_nCancelReasons & 2) != 0)
    {
        Outer.PopCommand(Self);
    }
}

state MovingToHoldLocation extends DebugState 
{
    
Begin:
    Outer.m_bHoldingPosition = FALSE;
    Outer.FindCoverNearHoldLocationCount = 0;
    Outer.MyBP.ShouldCrouch(FALSE);
    if (Outer.MyBP == None)
    {
        Outer.PopCommand(Self);
    }
    if (IsZero(Outer.m_vHoldLocation))
    {
        Outer.PopCommand(Self);
    }
    if (Outer.MoveToCoverNearHoldLocation(TRUE))
    {
        if (Outer.bReachedMoveGoal && Outer.MyBP.IsInCover())
        {
            Outer.m_bHoldingPosition = TRUE;
            Outer.PopCommand(Self);
        }
    }
    else
    {
        SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(7, Outer.MyBP, , , , TRUE);
    }
    if (Outer.DirectWalkCheck(Outer.m_vHoldLocation, None))
    {
        Outer.MovePoint = Outer.m_vHoldLocation;
        Outer.MoveOffset = 0.0;
        Outer.MoveTimer = 20.0;
        Class'SFXAICmd_MoveToLocation'.static.MoveToLocation(Outer, Outer.MovePoint, Outer.MoveOffset, TRUE, TRUE, TRUE);
    }
    else
    {
        Outer.PathfindToHoldLocation();
    }
    if ((Outer.m_nMoveCompletionReason == 0 && Outer.bReachedMoveGoal == FALSE && Outer.m_Orders.Length > 0 && Outer.m_Orders[0].eOrderType == HenchmanOrderType.HENCHMAN_ORDER_SWITCH_WEAPON) == FALSE)
    {
        if (Outer.IsInCombat())
        {
            if (Outer.FireTarget == None || VSize(Outer.FireTarget.location - Outer.MyBP.location) > Outer.MinDistanceFromTargetForCrouch)
            {
                Outer.MyBP.ShouldCrouch(TRUE);
            }
        }
        Outer.m_bHoldingPosition = TRUE;
        if (Outer.bReachedMoveGoal == FALSE)
        {
            SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(12, Outer.MyBP, , , , TRUE);
        }
    }
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}