Class SFXCustomAction_LoopingInteraction extends SFXCustomAction_InteractionPointAnim
    abstract
    config(Game);

enum EInteractionAnimStage
{
    IS_Start,
    IS_Loop,
    IS_End,
};

var(SFXCustomAction_LoopingInteraction) BodyStance BS_InteractionStart;
var(SFXCustomAction_LoopingInteraction) BodyStance BS_InteractionLoop;
var(SFXCustomAction_LoopingInteraction) BodyStance BS_InteractionEnd;
var float fStartBlendInTime;
var float fStartBlendOutTime;
var float fLoopBlendInTime;
var float fLoopBlendOutTime;
var float fEndBlendInTime;
var float fEndBlendOutTime;
var bool bTriggeredEnd;
var EInteractionAnimStage InteractionStage;

public function StartCustomAction()
{
    bTriggeredEnd = FALSE;
    Super.StartCustomAction();
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (InteractionStage == EInteractionAnimStage.IS_Start)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_InteractionStart, FALSE);
        if (bTriggeredEnd)
        {
            InteractionStage = EInteractionAnimStage.IS_End;
            if (m_oPawn.PlayBodyStance(BS_InteractionEnd, 1.0, fEndBlendInTime, fEndBlendOutTime) != 0.0)
            {
                m_oPawn.SetBodyStanceAnimEndNotification(BS_InteractionEnd, TRUE);
            }
        }
        else
        {
            InteractionStage = EInteractionAnimStage.IS_Loop;
            if (m_oPawn.PlayBodyStance(BS_InteractionLoop, 1.0, fLoopBlendInTime, fLoopBlendOutTime, TRUE) == 0.0)
            {
                EndThisCustomAction();
            }
        }
    }
    else if (InteractionStage == EInteractionAnimStage.IS_End)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_InteractionEnd, FALSE);
        EndThisCustomAction();
    }
}
public function StartInteractionAnim()
{
    InteractionStage = EInteractionAnimStage.IS_Start;
    if (BS_InteractionStart.AnimName.Length != 0 && m_oPawn.PlayBodyStance(BS_InteractionStart, 1.0, fStartBlendInTime, fStartBlendOutTime) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_InteractionStart, TRUE);
    }
    else
    {
        InteractionStage = EInteractionAnimStage.IS_Loop;
        if (m_oPawn.PlayBodyStance(BS_InteractionLoop, 1.0, fLoopBlendInTime, fLoopBlendOutTime, TRUE) == 0.0)
        {
        }
    }
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    switch (InteractionStage)
    {
        case EInteractionAnimStage.IS_Start:
            m_oPawn.StopBodyStance(BS_InteractionStart, fStartBlendOutTime);
            m_oPawn.SetBodyStanceAnimEndNotification(BS_InteractionStart, FALSE);
            break;
        case EInteractionAnimStage.IS_Loop:
            m_oPawn.StopBodyStance(BS_InteractionLoop, fLoopBlendOutTime);
            break;
        case EInteractionAnimStage.IS_End:
            m_oPawn.StopBodyStance(BS_InteractionEnd, fEndBlendOutTime);
            m_oPawn.SetBodyStanceAnimEndNotification(BS_InteractionEnd, FALSE);
            break;
        default:
    }
}
public function TriggerEnd()
{
    bTriggeredEnd = TRUE;
    if (InteractionStage == EInteractionAnimStage.IS_Loop)
    {
        InteractionStage = EInteractionAnimStage.IS_End;
        if (m_oPawn.PlayBodyStance(BS_InteractionEnd, 1.0, fEndBlendInTime, fEndBlendOutTime) != 0.0)
        {
            m_oPawn.SetBodyStanceAnimEndNotification(BS_InteractionEnd, TRUE);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fStartBlendInTime = 0.200000003
    fStartBlendOutTime = 0.200000003
    fLoopBlendInTime = 0.200000003
    fLoopBlendOutTime = 0.200000003
    fEndBlendInTime = 0.200000003
    fEndBlendOutTime = 0.200000003
}