Class SFXCustomAction_MoveAlongCover extends BioCustomAction
    config(Game);

var transient CoverInfo m_MoveCoverDestination;
var transient CoverInfo m_MoveCoverFinalDestination;
var transient SFXAI_Cover m_oCoverAI;
var transient Actor m_MoveCoverMarker;
var transient float m_MovementToSlotStart;
var transient bool m_bIsCoverIntermediate;
var transient bool m_bIsInitialized;
var transient bool m_bIsInterrupted;

public function Init(ECoverDirection TargetCoverDir, CoverLink TargetCoverLink, int TargetCoverSlotIdx)
{
    if (TargetCoverDir == ECoverDirection.CD_Default || !IsTargetCoverValid(TargetCoverLink, TargetCoverSlotIdx))
    {
        m_bIsInterrupted = TRUE;
        InterruptThisCustomAction();
        return;
    }
    m_oPawn.CoverDirection = TargetCoverDir;
    m_MoveCoverFinalDestination.Link = TargetCoverLink;
    m_MoveCoverFinalDestination.SlotIdx = TargetCoverSlotIdx;
    m_MoveCoverDestination.Link = TargetCoverLink;
    m_MoveCoverDestination.SlotIdx = m_oPawn.CurrentSlotIdx;
    m_bIsCoverIntermediate = UpdateMoveCoverDestinationSlot();
    m_MoveCoverMarker = m_MoveCoverDestination.Link.Slots[m_MoveCoverDestination.SlotIdx].SlotMarker;
    if (!m_oCoverAI.IsValidCover(m_MoveCoverDestination) || !m_oCoverAI.ClaimCover(m_MoveCoverDestination) || m_MoveCoverMarker == None)
    {
        m_bIsInterrupted = TRUE;
        InterruptThisCustomAction();
        return;
    }
    m_oPawn.CurrentLink.UnClaim(m_oPawn, m_oPawn.CurrentSlotIdx, FALSE);
    m_oPawn.PreviousSlotIdx = m_oPawn.CurrentSlotIdx;
    m_MovementToSlotStart = m_oPawn.WorldInfo.GameTimeSeconds;
    m_oPawn.CurrentSlotDirection = TargetCoverDir;
    m_oPawn.SetPhysics(1);
    m_oPawn.LastPhysicsSetter = Outer;
    m_oPawn.SetDesiredSpeed(1.0);
    m_oAI.bAdjusting = FALSE;
    m_oPawn.bDoUpdateCoverData = FALSE;
    m_bIsInitialized = TRUE;
}
public function ReachedDestination()
{
    local Rotator SlotRot;
    
    m_oPawn.SetAnchor(NavigationPoint(m_MoveCoverMarker));
    if (!m_bIsInterrupted || m_oPawn.IsInCover())
    {
        m_oPawn.SetCoverInfoFromLocation(m_MoveCoverFinalDestination.Link, m_MoveCoverFinalDestination.SlotIdx);
        m_oPawn.LockDesiredRotation(FALSE);
        SlotRot = m_oPawn.CurrentLink.GetSlotRotation(m_oPawn.CurrentSlotIdx);
        m_oPawn.SetDesiredRotation(SlotRot, TRUE);
    }
    m_MoveCoverMarker = None;
    if (!m_bIsInterrupted)
    {
        if (m_bIsCoverIntermediate)
        {
            m_bIsCoverIntermediate = UpdateMoveCoverDestinationSlot();
            if (m_MoveCoverDestination.SlotIdx < 0 || m_MoveCoverDestination.SlotIdx >= m_MoveCoverDestination.Link.Slots.Length)
            {
                m_bIsInterrupted = TRUE;
            }
            else if (m_oCoverAI.IsValidCover(m_MoveCoverDestination) && m_oCoverAI.ClaimCover(m_MoveCoverDestination))
            {
                m_MoveCoverMarker = m_MoveCoverDestination.Link.Slots[m_MoveCoverDestination.SlotIdx].SlotMarker;
            }
        }
    }
    if (m_MoveCoverMarker == None)
    {
        InterruptThisCustomAction();
        return;
    }
    m_oPawn.CurrentLink.UnClaim(m_oPawn, m_oPawn.CurrentSlotIdx, FALSE);
    m_oPawn.PreviousSlotIdx = m_oPawn.CurrentSlotIdx;
    m_MovementToSlotStart = m_oPawn.WorldInfo.GameTimeSeconds;
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    m_bIsInitialized = FALSE;
    m_bIsInterrupted = FALSE;
}
public event function TickCustomAction(float DeltaTime)
{
    local Vector NewVelocity;
    local CoverSlotMarker CurrentCoverSlotMarker;
    local Vector Tangent;
    
    Super.TickCustomAction(DeltaTime);
    if (!m_bIsInitialized)
    {
        return;
    }
    if (m_oAI.MoveTarget == None || m_MoveCoverFinalDestination.Link == None || !m_oPawn.IsInCover() || m_oPawn.WorldInfo.GameTimeSeconds - m_MovementToSlotStart > 3.0)
    {
        m_bIsInterrupted = TRUE;
    }
    else
    {
        if (m_MoveCoverDestination.Link.bCircular)
        {
            Tangent = vect(0.0, 0.0, 1.0) Cross Normal(m_MoveCoverDestination.Link.CircularOrigin - m_oPawn.location);
            NewVelocity = Tangent * m_oPawn.GetMaxSpeed() * (m_oPawn.CurrentSlotDirection == ECoverDirection.CD_Left ? -1.0 : 1.0);
        }
        else if (m_MoveCoverDestination.Link.Slots.Length > 1)
        {
            if (m_MoveCoverDestination.SlotIdx >= 0 && m_MoveCoverDestination.SlotIdx < m_MoveCoverDestination.Link.Slots.Length)
            {
                CurrentCoverSlotMarker = m_MoveCoverDestination.Link.Slots[m_MoveCoverDestination.SlotIdx].SlotMarker;
                if (CurrentCoverSlotMarker != None)
                {
                    NewVelocity = Normal(CurrentCoverSlotMarker.location - m_oPawn.location);
                    NewVelocity *= m_oPawn.GetMaxSpeed() * m_oPawn.DesiredSpeed;
                }
            }
        }
        NewVelocity.Z = 0.0;
        m_oPawn.Velocity = NewVelocity;
    }
    if (m_oPawn.ReachedDestination(m_MoveCoverMarker) || m_bIsInterrupted)
    {
        ReachedDestination();
    }
}
public function bool CanOverrideCustomAction(int OldCustomAction, int NewCustomAction)
{
    if (OldCustomAction == 35 && NewCustomAction == OldCustomAction)
    {
        return TRUE;
    }
    return Super.CanOverrideCustomAction(OldCustomAction, NewCustomAction);
}
public function bool DoReStart(CoverSlotMarker TargetCover)
{
    if (m_MoveCoverFinalDestination.Link == TargetCover.OwningSlot.Link && m_MoveCoverFinalDestination.SlotIdx != TargetCover.OwningSlot.SlotIdx)
    {
        if (bStartedCustomAction)
        {
            m_bIsInterrupted = TRUE;
            ReachedDestination();
        }
        return TRUE;
    }
    return FALSE;
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    if (bForced)
    {
        return TRUE;
    }
    if (m_oPawn == None || !m_oPawn.IsInCover())
    {
        return FALSE;
    }
    m_oCoverAI = SFXAI_Cover(m_oAI);
    if (m_oCoverAI == None && m_oPawn.Role != ENetRole.ROLE_SimulatedProxy)
    {
        return FALSE;
    }
    return TRUE;
}
public function bool IsTargetCoverValid(CoverLink targetLink, int TargetSlotIdx)
{
    local BioPawn P;
    
    if (targetLink == None)
    {
        return FALSE;
    }
    if (TargetSlotIdx == m_oPawn.CurrentSlotIdx || targetLink != m_oPawn.CurrentLink)
    {
        return FALSE;
    }
    if (TargetSlotIdx < 0 || TargetSlotIdx >= targetLink.Slots.Length)
    {
        return FALSE;
    }
    if (!targetLink.IsValidClaim(m_oPawn, TargetSlotIdx))
    {
        return FALSE;
    }
    if (!m_oPawn.FastTrace(m_oPawn.location, targetLink.GetSlotLocation(TargetSlotIdx), , ))
    {
        return FALSE;
    }
    foreach m_oPawn.WorldInfo.AllPawns(Class'BioPawn', P, targetLink.GetSlotLocation(TargetSlotIdx), m_oPawn.GetCollisionRadius())
    {
        if (P != m_oPawn && !P.IsDead())
        {
            return FALSE;
        }
    }
    return TRUE;
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    m_oPawn.CurrentSlotDirection = ECoverDirection.CD_Default;
    m_oPawn.bDoUpdateCoverData = TRUE;
}
public function bool UpdateMoveCoverDestinationSlot()
{
    if (m_oPawn.CurrentSlotIdx < m_MoveCoverFinalDestination.SlotIdx)
    {
        m_MoveCoverDestination.SlotIdx++;
    }
    else
    {
        m_MoveCoverDestination.SlotIdx--;
    }
    return m_MoveCoverFinalDestination.SlotIdx != m_MoveCoverDestination.SlotIdx;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bPushAICommand = FALSE
    bReplicateCustomAction = TRUE
}