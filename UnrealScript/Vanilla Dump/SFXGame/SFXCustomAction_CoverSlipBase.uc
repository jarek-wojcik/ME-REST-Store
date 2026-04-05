Class SFXCustomAction_CoverSlipBase extends SFXCustomAction_SingleAnim
    abstract
    config(Game);

protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    local int SlotIdx;
    
    if (m_oPawn.Role == ENetRole.ROLE_SimulatedProxy || bForced)
    {
        return TRUE;
    }
    if (m_oPawn.IsInCover() == FALSE)
    {
        return FALSE;
    }
    SlotIdx = m_oPawn.CurrentSlotIdx;
    if (m_oPC != None)
    {
        if (m_oPawn.CurrentSlotPct >= 0.100000001 && m_oPawn.CurrentSlotPct <= 0.899999976)
        {
            return FALSE;
        }
        if (m_oPawn.CoverDirection == ECoverDirection.CD_Left && (m_oPawn.CurrentLink.Slots[SlotIdx].bCanCoverSlip_Left == FALSE || m_oPawn.IsAtLeftEdgeSlot() == FALSE))
        {
            return FALSE;
        }
        else if (m_oPawn.CoverDirection == ECoverDirection.CD_Right && (m_oPawn.CurrentLink.Slots[SlotIdx].bCanCoverSlip_Right == FALSE || m_oPawn.IsAtRightEdgeSlot() == FALSE))
        {
            return FALSE;
        }
        if (VSize(m_oPawn.CurrentLink.GetSlotLocation(SlotIdx) - m_oPawn.location) > 50.0)
        {
            return FALSE;
        }
        if (m_oPC.IsLocalPlayerController() && m_oPC.RemappedJoyUp < 0.5)
        {
            return FALSE;
        }
    }
    else if (m_oPawn.CoverDirection == ECoverDirection.CD_Left && (m_oPawn.CurrentLink.Slots[SlotIdx].bCanCoverSlip_Left == FALSE || m_oPawn.CurrentLink.IsLeftEdgeSlot(SlotIdx, TRUE) == FALSE))
    {
        return FALSE;
    }
    else if (m_oPawn.CoverDirection == ECoverDirection.CD_Right && (m_oPawn.CurrentLink.Slots[SlotIdx].bCanCoverSlip_Right == FALSE || m_oPawn.CurrentLink.IsRightEdgeSlot(SlotIdx, TRUE) == FALSE))
    {
        return FALSE;
    }
    return TRUE;
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    if (m_oAI != None && m_oAI.MoveTarget != None)
    {
        if (VSize(m_oPawn.location - m_oAI.MoveTarget.location) < VSize(m_oPawn.location - m_oPawn.Anchor.location))
        {
            m_oAI.ReachedMoveTarget();
            m_oAI.UpdateMovementFocus();
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fAnimBlendInTime = 0.100000001
    bAllowAnimInterrupt = FALSE
    ERootMotionMode = ERootMotionMode.RMM_Accel
    bLockPawnRotation = TRUE
    bAllowChargeHolding = TRUE
    bReplicateCustomAction = TRUE
    bClientPredictCustomAction = TRUE
    bForceLocalSimulation = TRUE
    Priority = ECustomActionPriority.CA_Priority_High
}