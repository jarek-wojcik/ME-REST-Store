Class SFXCustomAction_Cover90TurnBase extends BioCustomAction
    abstract
    config(Game);

var(SFXCustomAction_Cover90TurnBase) BodyStance BS_Anim;
var(SFXCustomAction_Cover90TurnBase) float fAnimPlayRate;
var(SFXCustomAction_Cover90TurnBase) float fAnimBlendInTime;
var(SFXCustomAction_Cover90TurnBase) float fAnimBlendOutTime;
var(SFXCustomAction_Cover90TurnBase) float fAnimStartTime;
var float CameraTransitionTime;
var transient CoverSlotMarker TurnTarget;
var(SFXCustomAction_Cover90TurnBase) ERootMotionMode ERootMotionMode;
var(SFXCustomAction_Cover90TurnBase) ERootMotionRotationMode ERootMotionRotationMode;
var(SFXCustomAction_Cover90TurnBase) ERootBoneAxis RootBoneX;
var(SFXCustomAction_Cover90TurnBase) ERootBoneAxis RootBoneY;
var(SFXCustomAction_Cover90TurnBase) ERootBoneAxis RootBoneZ;
var AlphaBlendType StartBlendType;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Anim, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public event function ReachedPrecisePosition()
{
    m_oPawn.ClearTimer('AlignmentTimeout', Self);
    PlayCoverTurnAnim();
}
public function StartCustomAction()
{
    local Rotator CurrentSlotRot;
    local Vector CurrentSlotLoc;
    local Vector X;
    local Vector Y;
    local Vector Z;
    local float DistAlongY;
    local Vector TurnStartLoc;
    local float Deg;
    local float PushAmt;
    
    CacheCoverTurnTarget();
    CurrentSlotRot = m_oPawn.CurrentLink.GetSlotRotation(m_oPawn.CurrentSlotIdx);
    CurrentSlotLoc = m_oPawn.CurrentLink.GetSlotLocation(m_oPawn.CurrentSlotIdx);
    GetAxes(CurrentSlotRot, X, Y, Z);
    DistAlongY = VSize(ProjectOnTo(TurnTarget.location - CurrentSlotLoc, Y));
    if (m_oPawn.CoverDirection == ECoverDirection.CD_Left)
    {
        TurnStartLoc = CurrentSlotLoc - (DistAlongY - 65.0) * Y;
    }
    else
    {
        TurnStartLoc = CurrentSlotLoc + (DistAlongY - 65.0) * Y;
    }
    Deg = Acos(Abs(X.X)) * 57.2957802;
    PushAmt = 1.0;
    if (Deg <= 45.0)
    {
        PushAmt *= Deg / 45.0;
    }
    else
    {
        PushAmt *= 1.0 - (Deg - 45.0) / 45.0;
    }
    m_oPawn.Mesh.RootMotionAccelScale.X = 1.0 + PushAmt * 0.200000003;
    m_oPawn.Mesh.RootMotionAccelScale.Y = 1.0 + PushAmt * 0.200000003;
    m_oPawn.Mesh.RootMotionAccelScale.Z = 1.0;
    PushAmt = FClamp(PushAmt, 0.0500000007, 0.200000003);
    TurnStartLoc = TurnStartLoc + -X * (30.0 * PushAmt);
    Super.StartCustomAction();
    SetReachPreciseDestination(TurnStartLoc);
    m_oPawn.SetTimer(0.5, FALSE, 'AlignmentTimeout', Self);
}
public function AlignmentTimeout()
{
    ResetReachPreciseDestination();
    PlayCoverTurnAnim();
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local int SlotIdx;
    local CoverLink TargetCoverLink;
    local CovPosInfo CoverPosInfo;
    
    TargetCoverLink = TurnTarget.OwningSlot.Link;
    SlotIdx = TurnTarget.OwningSlot.SlotIdx;
    if (m_oPC != None)
    {
        if (TargetCoverLink.Slots.Length > 1 && TurnTarget.OwningSlot.SlotIdx == TargetCoverLink.Slots.Length - 1)
        {
            SlotIdx = TurnTarget.OwningSlot.SlotIdx - 1;
        }
        m_oPC.FillCoverPosInfo(TurnTarget.OwningSlot.Link, SlotIdx, TurnTarget.location, Vector(TurnTarget.Rotation), 250.0, CoverPosInfo);
        m_oPC.AcquireCover(CoverPosInfo);
    }
    else if (bForceLocalSimulation)
    {
        m_oPawn.SetCoverInfoFromLocation(TargetCoverLink, SlotIdx);
        if (TargetCoverLink.Slots[SlotIdx].CoverType == ECoverType.CT_MidLevel)
        {
            m_oPawn.ForceCrouch();
        }
    }
    Super.BodyStanceAnimEndNotification(SeqNode, PlayedTime, ExcessTime);
}
public function CacheCoverTurnTarget()
{
    local int Direction;
    local CoverInfo TurnInfo;
    
    Direction = m_oPawn.CoverDirection == ECoverDirection.CD_Left ? -1 : 1;
    if (m_oPawn.CurrentLink.GetCoverTurnTarget(m_oPawn.CurrentSlotIdx, Direction, TurnInfo))
    {
        TurnTarget = TurnInfo.Link.Slots[TurnInfo.SlotIdx].SlotMarker;
    }
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    local int SlotIdx;
    local int Direction;
    local CoverInfo TurnInfo;
    
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
        if (m_oPawn.CoverDirection == ECoverDirection.CD_Left && (m_oPawn.CurrentLink.Slots[SlotIdx].bCanCoverTurn_Left == FALSE || m_oPawn.IsAtLeftEdgeSlot() == FALSE))
        {
            return FALSE;
        }
        else if (m_oPawn.CoverDirection == ECoverDirection.CD_Right && (m_oPawn.CurrentLink.Slots[SlotIdx].bCanCoverTurn_Right == FALSE || m_oPawn.IsAtRightEdgeSlot() == FALSE))
        {
            return FALSE;
        }
        if (VSize(m_oPawn.CurrentLink.GetSlotLocation(SlotIdx) - m_oPawn.location) > 50.0)
        {
            return FALSE;
        }
    }
    else if (m_oPawn.CoverDirection == ECoverDirection.CD_Left && (m_oPawn.CurrentLink.Slots[SlotIdx].bCanCoverTurn_Left == FALSE || m_oPawn.CurrentLink.IsLeftEdgeSlot(SlotIdx, TRUE) == FALSE))
    {
        return FALSE;
    }
    else if (m_oPawn.CoverDirection == ECoverDirection.CD_Right && (m_oPawn.CurrentLink.Slots[SlotIdx].bCanCoverTurn_Right == FALSE || m_oPawn.CurrentLink.IsRightEdgeSlot(SlotIdx, TRUE) == FALSE))
    {
        return FALSE;
    }
    Direction = m_oPawn.CoverDirection == ECoverDirection.CD_Left ? -1 : 1;
    if (m_oPawn.CurrentLink.GetCoverTurnTarget(m_oPawn.CurrentSlotIdx, Direction, TurnInfo))
    {
        if (TurnInfo.Link == None || TurnInfo.Link.IsEnabled() == FALSE)
        {
            return FALSE;
        }
    }
    return TRUE;
}
public function PlayCoverTurnAnim()
{
    local BioPlayerController oPlayer;
    
    if (m_oAI != None)
    {
        if (m_oPawn.IsInCover())
        {
            m_oAI.InvalidateCover();
            if (bNotifyKnockedOutOfCover)
            {
                m_oAI.NotifyKnockedOutOfCover();
            }
        }
    }
    else if (m_oPC != None)
    {
        m_oPC.LeaveCover();
    }
    else if (bForceLocalSimulation)
    {
        m_oPawn.LeaveCover();
    }
    m_oPawn.SetCrouchStateInstantly(FALSE);
    ApplyTimeline(TimelineTemplate, m_oPawn);
    if (m_oPawn.PlayBodyStance(BS_Anim, fAnimPlayRate, fAnimBlendInTime, fAnimBlendOutTime, , FALSE, , fAnimStartTime, StartBlendType) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_Anim, TRUE);
        m_oPawn.Mesh.RootMotionMode = ERootMotionMode;
        if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Anim, RootBoneX, RootBoneY, RootBoneZ);
            m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
        }
        m_oPawn.Mesh.RootMotionRotationMode = ERootMotionRotationMode;
        if (ERootMotionRotationMode != ERootMotionRotationMode.RMRM_Ignore)
        {
            m_oPawn.SetBodyStanceRootRotationOption(BS_Anim, 0, 2, 0);
        }
        oPlayer = BioPlayerController(m_oPawn.Controller);
        if (oPlayer != None)
        {
            oPlayer.GetGameModeDefault().TransitionToFutureSlot(CameraTransitionTime, TurnTarget);
        }
    }
}
public function StopCustomAction()
{
    local int SlotIdx;
    local CoverLink TargetCoverLink;
    
    Super.StopCustomAction();
    RemoveTimeline();
    m_oPawn.StopBodyStance(BS_Anim, fAnimBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Anim, FALSE);
    if (ERootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Anim, 1, 1, 1);
    }
    if (ERootMotionRotationMode != ERootMotionRotationMode.RMRM_Ignore)
    {
        m_oPawn.Mesh.RootMotionRotationMode = m_oPawn.Mesh.default.RootMotionRotationMode;
        m_oPawn.SetBodyStanceRootRotationOption(BS_Anim, 1, 1, 1);
    }
    m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
    if (m_oPC == None && bForceLocalSimulation && !m_oPawn.IsInCover())
    {
        TargetCoverLink = TurnTarget.OwningSlot.Link;
        SlotIdx = TurnTarget.OwningSlot.SlotIdx;
        m_oPawn.SetCoverInfoFromLocation(TargetCoverLink, SlotIdx);
        if (TargetCoverLink.Slots[SlotIdx].CoverType == ECoverType.CT_MidLevel)
        {
            m_oPawn.ForceCrouch();
        }
    }
    m_oPawn.Mesh.RootMotionAccelScale.X = 1.0;
    m_oPawn.Mesh.RootMotionAccelScale.Y = 1.0;
    m_oPawn.Mesh.RootMotionAccelScale.Z = 1.0;
    m_oPawn.bDisableAnimatedTransitions = TRUE;
    TurnTarget = None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fAnimPlayRate = 1.10000002
    ERootMotionMode = ERootMotionMode.RMM_Accel
    RootBoneX = ERootBoneAxis.RBA_Translate
    RootBoneY = ERootBoneAxis.RBA_Translate
    RootBoneZ = ERootBoneAxis.RBA_Discard
    bLockPawnRotation = TRUE
    bDisableMovement = TRUE
    bDisableCoverAdjust = TRUE
    bReplicateCustomAction = TRUE
    bClientPredictCustomAction = TRUE
    bForceLocalSimulation = TRUE
    Priority = ECustomActionPriority.CA_Priority_High
}