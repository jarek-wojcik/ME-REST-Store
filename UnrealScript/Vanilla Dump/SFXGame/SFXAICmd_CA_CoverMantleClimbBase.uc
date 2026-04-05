Class SFXAICmd_CA_CoverMantleClimbBase extends SFXAICmd_CustomAction within SFXAI_Core;

var transient Actor OriginalMoveTarget;
var transient NavigationPoint OriginalAnchor;

public function FinishedCustomAction()
{
    if (GetCustomActionMovementState() == TRUE)
    {
        Outer.m_bCustomActionFailed = FALSE;
    }
    else
    {
        Outer.m_bCustomActionFailed = TRUE;
    }
}
public function bool GetCustomActionMovementState()
{
    if (OriginalMoveTarget != None && OriginalAnchor != None)
    {
        if (VSize(Outer.Pawn.location - OriginalMoveTarget.location) < VSize(Outer.Pawn.location - OriginalAnchor.location))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public event function Pushed()
{
    Outer.Focus = None;
    Outer.MyBP.SetDesiredRotation(Rotator(Outer.MoveTarget.location - Outer.Pawn.location));
    OriginalMoveTarget = Outer.MoveTarget;
    OriginalAnchor = Outer.Pawn.Anchor;
    Super.Pushed();
}
public function bool ShouldFinishRotation()
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}