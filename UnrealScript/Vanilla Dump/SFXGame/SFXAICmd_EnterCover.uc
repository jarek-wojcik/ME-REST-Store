Class SFXAICmd_EnterCover extends SFXAICommand within SFXAI_Cover;

public static function bool EnterCover(SFXAI_Cover AI)
{
    local SFXAICmd_EnterCover Cmd;
    
    if (AI != None)
    {
        Cmd = new (AI) Class'SFXAICmd_EnterCover';
        if (Cmd != None)
        {
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    GotoState('EnteringCover', , , );
}
public final function SetCoverDirection()
{
    local Vector DirToFireTarget;
    local Rotator CoverDir;
    local Vector X;
    local Vector Y;
    local Vector Z;
    
    if (Outer.FireTarget != None)
    {
        DirToFireTarget = Normal(Outer.GetFireTargetLocation(1) - Outer.MyBP.location);
        CoverDir = Outer.CoverGoal.Link.GetSlotRotation(Outer.CoverGoal.SlotIdx);
        GetAxes(CoverDir, X, Y, Z);
        if (Y Dot DirToFireTarget >= 0.0)
        {
            Outer.MyBP.SetCoverDirection(2);
        }
        else
        {
            Outer.MyBP.SetCoverDirection(1);
        }
    }
    else if (Outer.MyBP.CanDoCoverAction(3))
    {
        Outer.MyBP.SetCoverDirection(1);
    }
    else if (Outer.MyBP.CanDoCoverAction(4))
    {
        Outer.MyBP.SetCoverDirection(2);
    }
}
public final function bool SetCoverType()
{
    if (Outer.MyBP != None && Outer.Cover.Link != None && Outer.Cover.SlotIdx >= 0 && Outer.Cover.SlotIdx < Outer.Cover.Link.Slots.Length)
    {
        Outer.MyBP.SetCoverInfoFromLocation(Outer.Cover.Link, Outer.Cover.SlotIdx);
        return TRUE;
    }
    return FALSE;
}

state EnteringCover extends DebugState 
{
    
Begin:
    if (Outer.MyBP == None || Outer.MyBP.IsDead() || Outer.IsValidCover(Outer.CoverGoal) == FALSE || Outer.CoverGoal.Link.Slots[Outer.CoverGoal.SlotIdx].SlotMarker == None)
    {
        Outer.PopCommand(Self);
    }
    if (!SetCoverType())
    {
    }
    if (Outer.MyBP.CoverType == ECoverType.CT_MidLevel)
    {
        Outer.MyBP.ShouldCrouch(TRUE);
    }
    else
    {
        Outer.MyBP.ShouldCrouch(FALSE);
    }
    SetCoverDirection();
    Outer.AdjustToSlot(Outer.CoverGoal.SlotIdx);
    if (Outer.CoverGoal.Link == None)
    {
    }
    else
    {
        Outer.Pawn.SetAnchor(Outer.CoverGoal.Link.Slots[Outer.CoverGoal.SlotIdx].SlotMarker);
        Outer.MyBP.CurrentLink = Outer.CoverGoal.Link;
        Outer.MyBP.CurrentSlotIdx = Outer.CoverGoal.SlotIdx;
    }
    Outer.NotifyReachedCover();
    Outer.FinishAnimatedTransition();
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}