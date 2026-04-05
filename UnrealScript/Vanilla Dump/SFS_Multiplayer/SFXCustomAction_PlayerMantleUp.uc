Class SFXCustomAction_PlayerMantleUp extends SFXCustomAction_SimpleMoveBase
    config(Game);

var(SFXCustomAction_PlayerMantleUp) BodyStance BS_MantleUpOutOfCover;
var(SFXCustomAction_PlayerMantleUp) BodyStance BS_MantleUpInCover;
var transient CoverSlotMarker StartingSlot;
var transient bool bStartInCover;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_MantleUpOutOfCover, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_MantleUpInCover, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    bStartInCover = m_oPawn.IsInCover();
    if (m_oPawn.bRecentlyTookCover && m_oPawn.bStorming == FALSE)
    {
        bStartInCover = FALSE;
    }
    Super.StartCustomAction();
}
public function ClientDoCustomAction(optional bool bForced)
{
    if (m_oPawn != None)
    {
        if (CoverSlotMarker(m_oPawn.ReplicatedCustomActionInfo.Target) != None)
        {
            StartingSlot = CoverSlotMarker(m_oPawn.ReplicatedCustomActionInfo.Target);
        }
        Super.ClientDoCustomAction(bForced);
    }
}
public function BodyStance GetBodyStanceAnim()
{
    if (bStartInCover)
    {
        return BS_MantleUpInCover;
    }
    else
    {
        return BS_MantleUpOutOfCover;
    }
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    local CovPosInfo FoundCover;
    
    if (MovementPath != None)
    {
        return TRUE;
    }
    else if (m_oPawn.IsInCover())
    {
        MovementPath = m_oPawn.CurrentLink.Slots[m_oPawn.CurrentSlotIdx].SlotMarker.GetReachSpecTo(NavigationPoint(m_oPawn.CurrentLink.Slots[m_oPawn.CurrentSlotIdx].MantleTarget.Actor));
        return MovementPath != None;
    }
    else
    {
        if (!m_oPawn.IsLocallyControlled())
        {
            if (m_oPC != None && m_oPC.Role == ENetRole.ROLE_Authority)
            {
                if (m_oPawn.Anchor != None)
                {
                    StartingSlot = CoverSlotMarker(m_oPawn.Anchor);
                }
            }
            else
            {
                StartingSlot = CoverSlotMarker(m_oPawn.ReplicatedCustomActionInfo.Target);
            }
        }
        else if (m_oPC != None && !m_oPawn.ValidAnchor())
        {
            if (m_oPC.GetGameModeDefault().FindCover(FoundCover, TRUE))
            {
                if (FoundCover.LtToRtPct < 0.5)
                {
                    StartingSlot = FoundCover.Link.GetSlotMarker(FoundCover.LtSlotIdx);
                }
                else
                {
                    StartingSlot = FoundCover.Link.GetSlotMarker(FoundCover.RtSlotIdx);
                }
            }
        }
        if (StartingSlot != None)
        {
            MovementPath = StartingSlot.GetReachSpecTo(NavigationPoint(StartingSlot.OwningSlot.Link.Slots[StartingSlot.OwningSlot.SlotIdx].MantleTarget.Actor));
            return MovementPath != None;
        }
    }
    return FALSE;
}
public function Replicate()
{
    Super.Replicate();
    if (m_oPawn != None)
    {
        if (m_oPawn.Anchor != None)
        {
            m_oPawn.ReplicatedCustomActionInfo.Target = StartingSlot;
        }
    }
}
public function ServerStartCustomAction(int NewAction, optional BioPawn Sync, optional int NewPowerAction)
{
    if (m_oPawn != None && m_oPC != None)
    {
        m_oPC.ServerStartCustomActionWithNav(NewAction, StartingSlot, Sync, NewPowerAction);
    }
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    StartingSlot = None;
    bStartInCover = FALSE;
    m_oPawn.SetAnchor(None);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_MantleUpOutOfCover = {
                             AnimName = ('CB_Mount_Up')
                            }
    BS_MantleUpInCover = {
                          AnimName = ('CB_Mount_Up_Cover')
                         }
    MoveDistance = 70.0
    fBlendOutTime = 1.0
    bAlignPawnBeforeMove = FALSE
    RMM = ERootMotionMode.RMM_Translate
    bClientPredictCustomAction = TRUE
}