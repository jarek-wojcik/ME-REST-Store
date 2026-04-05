Class SFXCustomAction_SwatTurn extends SFXCustomAction_ProceduralMoveBase
    config(Game);

var(SFXCustomAction_SwatTurn) BodyStance BS_Start_Mid;
var(SFXCustomAction_SwatTurn) BodyStance BS_Loop_Mid;
var(SFXCustomAction_SwatTurn) BodyStance BS_End_Mid;
var(SFXCustomAction_SwatTurn) BodyStance BS_ShortStart;
var transient CoverReference SwatTurnTarget;
var transient Vector LoopStartLocation;
var SFXCameraMode HighSwatTurnCamera;
var SFXCameraMode LowSwatTurnCamera;
var float fEndBlendInTimeHigh;
var float fEndBlendOutTimeHigh;
var float fShortSwatThreshold;
var float fHighAnimDist;
var float fLowAnimDist;
var transient bool bStartStanding;
var transient bool bEndStanding;
var const bool bRightSwatTurn;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Start_Mid, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_Loop_Mid, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_End_Mid, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_ShortStart, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    local int LeftSlotIdx;
    local int RightSlotIdx;
    local int NumSlots;
    local float LeftRightPct;
    local CoverInfo DstCover;
    local Vector StartToEnd;
    
    bStartStanding = FALSE;
    if (m_oPawn.CoverType == ECoverType.CT_Standing)
    {
        bStartStanding = TRUE;
    }
    if (m_oPawn.Role != ENetRole.ROLE_SimulatedProxy)
    {
        m_oPawn.CurrentLink.UnClaim(m_oPawn, m_oPawn.CurrentSlotIdx, TRUE);
        Super.StartCustomAction();
        m_oPawn.bDisableAnimatedTransitions = TRUE;
        DstCover.Link = CoverLink(SwatTurnTarget.Actor);
        DstCover.SlotIdx = SwatTurnTarget.SlotIdx;
        if (DstCover.Link != None)
        {
            if (m_oAI != None)
            {
                m_oPawn.SetAnchor(DstCover.Link.GetSlotMarker(SwatTurnTarget.SlotIdx));
            }
            Destination = DstCover.Link.GetSlotLocation(SwatTurnTarget.SlotIdx);
            StartToEnd = Normal(Destination - m_oPawn.location);
            if (StartToEnd Dot Vector(m_oPawn.Rotation) < -0.0500000007)
            {
                Destination += Vector(m_oPawn.Rotation) * -30.0;
            }
            NumSlots = DstCover.Link.Slots.Length;
            if (NumSlots == 1)
            {
                LeftSlotIdx = 0;
                RightSlotIdx = 0;
            }
            else
            {
                LeftSlotIdx = DstCover.SlotIdx == NumSlots - 1 ? DstCover.SlotIdx - 1 : DstCover.SlotIdx;
                RightSlotIdx = LeftSlotIdx + 1;
            }
            LeftRightPct = LeftSlotIdx == DstCover.SlotIdx ? 0.0 : 1.0;
            m_oPawn.SetCoverInfo(DstCover.Link, DstCover.SlotIdx, LeftSlotIdx, RightSlotIdx, LeftRightPct);
            if (m_oPC != None || DstCover.Link.Claims.Find(m_oPawn) < 0)
            {
                DstCover.Link.Claim(m_oPawn, DstCover.SlotIdx);
            }
        }
    }
    else
    {
        Super.StartCustomAction();
        DstCover.Link = CoverLink(SwatTurnTarget.Actor);
        DstCover.SlotIdx = SwatTurnTarget.SlotIdx;
        if (DstCover.Link != None)
        {
            Destination = DstCover.Link.GetSlotLocation(SwatTurnTarget.SlotIdx);
            StartToEnd = Normal(Destination - m_oPawn.location);
            if (StartToEnd Dot Vector(m_oPawn.Rotation) < -0.0500000007)
            {
                Destination += Vector(m_oPawn.Rotation) * -30.0;
            }
        }
    }
    LoopStartLocation = m_oPawn.location;
    bEndStanding = FALSE;
    if (m_oPawn.CoverType == ECoverType.CT_Standing)
    {
        bEndStanding = TRUE;
        fEndAnimDist = fHighAnimDist;
    }
    else
    {
        fEndAnimDist = fLowAnimDist;
    }
}
public static function bool CanPerformSwatTurn(BioPawn oPawn, out CoverReference Target)
{
    local int SlotIdx;
    local ECoverDirection DesiredDir;
    local SFXPawn P;
    local BioPlayerController oPC;
    local SFXAI_Core oAI;
    local CoverInfo TempCoverInfo;
    local SFXPawn_Player PlayerPawn;
    local Actor BlockingActor;
    local Vector TargetLocation;
    local Vector HitLocation;
    local Vector HitNormal;
    
    if (!oPawn.bCanSwatTurn || !oPawn.IsInCover())
    {
        return FALSE;
    }
    if (oPawn != None && oPawn.Role == ENetRole.ROLE_SimulatedProxy)
    {
        return TRUE;
    }
    SlotIdx = oPawn.CurrentSlotIdx;
    oPC = BioPlayerController(oPawn.Controller);
    oAI = SFXAI_Core(oPawn.Controller);
    if (oPC != None)
    {
        DesiredDir = default.bRightSwatTurn ? ECoverDirection.CD_Right : ECoverDirection.CD_Left;
        if (int(oPawn.CoverDirection) != int(DesiredDir))
        {
            return FALSE;
        }
        if (oPawn.CoverDirection == ECoverDirection.CD_Left && (oPawn.CurrentLink.Slots[SlotIdx].bCanSwatTurn_Left == FALSE || oPawn.IsAtLeftEdgeSlot() == FALSE))
        {
            return FALSE;
        }
        else if (oPawn.CoverDirection == ECoverDirection.CD_Right && (oPawn.CurrentLink.Slots[SlotIdx].bCanSwatTurn_Right == FALSE || oPawn.IsAtRightEdgeSlot() == FALSE))
        {
            return FALSE;
        }
    }
    else if (oAI != None)
    {
        if (oPawn.CoverDirection == ECoverDirection.CD_Left && (oPawn.CurrentLink.Slots[SlotIdx].bCanSwatTurn_Left == FALSE || oPawn.CurrentLink.IsLeftEdgeSlot(SlotIdx, TRUE) == FALSE))
        {
            return FALSE;
        }
        else if (oPawn.CoverDirection == ECoverDirection.CD_Right && (oPawn.CurrentLink.Slots[SlotIdx].bCanSwatTurn_Right == FALSE || oPawn.CurrentLink.IsRightEdgeSlot(SlotIdx, TRUE) == FALSE))
        {
            return FALSE;
        }
    }
    if (oPawn.CurrentLink.GetSwatTurnTarget(SlotIdx, oPawn.CoverDirection == ECoverDirection.CD_Left ? -1 : 1, TempCoverInfo) == FALSE)
    {
        return FALSE;
    }
    Target.Actor = TempCoverInfo.Link;
    Target.Direction = oPawn.CoverDirection == ECoverDirection.CD_Left ? -1 : 1;
    Target.SlotIdx = TempCoverInfo.SlotIdx;
    if (CoverLink(Target.Actor).IsValidClaim(oPawn, Target.SlotIdx) == FALSE)
    {
        return FALSE;
    }
    PlayerPawn = SFXPawn_Player(oPawn);
    TargetLocation = CoverLink(Target.Actor).GetSlotLocation(Target.SlotIdx);
    BlockingActor = oPawn.Trace(HitLocation, HitNormal, TargetLocation, oPawn.location, TRUE, vect(15.0, 15.0, 15.0), , );
    if (BlockingActor != None && (PlayerPawn == None || SFXPawn_Henchman(BlockingActor) == None))
    {
        return FALSE;
    }
    foreach oPawn.CollidingActors(Class'SFXPawn', P, oPawn.GetCollisionRadius(), TargetLocation, TRUE, , )
    {
        if (P != oPawn && !P.IsDead() && (PlayerPawn == None || SFXPawn_Henchman(P) == None))
        {
            return FALSE;
        }
    }
    return TRUE;
}
public function ClientDoCustomAction(optional bool bForced)
{
    if (m_oPawn != None)
    {
        SwatTurnTarget.Actor = CoverLink(m_oPawn.ReplicatedCustomActionInfo.Target);
        SwatTurnTarget.Direction = int(m_oPawn.ReplicatedCustomActionInfo.TargetLocation.X);
        SwatTurnTarget.SlotIdx = int(m_oPawn.ReplicatedCustomActionInfo.TargetLocation.Y);
    }
    Super(BioCustomAction).ClientDoCustomAction(bForced);
}
public function float GetBlendInTime()
{
    if (bEndStanding)
    {
        return fEndBlendInTimeHigh;
    }
    else
    {
        return fEndBlendInTime;
    }
}
public function float GetBlendOutTime()
{
    if (bEndStanding)
    {
        return fEndBlendOutTimeHigh;
    }
    else
    {
        return fEndBlendOutTime;
    }
}
public function bool GetCustomActionCamera(out SFXCameraMode oNewCameraMode, out float fTransitionIn, out float fTransitionOut)
{
    if (m_oPC != None)
    {
        if (MoveStage != EMoveStage.EMS_End)
        {
            if (bStartStanding)
            {
                if (HighSwatTurnCamera == None)
                {
                    HighSwatTurnCamera = new (m_oPC.GetGameModeDefault()) Class'SFXCameraMode_CoverSwatTurnHigh';
                }
                oNewCameraMode = HighSwatTurnCamera;
            }
            else
            {
                if (LowSwatTurnCamera == None)
                {
                    LowSwatTurnCamera = new (m_oPC.GetGameModeDefault()) Class'SFXCameraMode_CoverSwatTurnLow';
                }
                oNewCameraMode = LowSwatTurnCamera;
            }
            fTransitionIn = fCameraTransitionIn;
            fTransitionOut = fCameraTransitionOut;
            return TRUE;
        }
    }
    return FALSE;
}
public function GetEndAnim(out BodyStance Stance)
{
    if (bEndStanding)
    {
        Stance = BS_End;
    }
    else
    {
        Stance = BS_End_Mid;
    }
}
public function GetLoopAnim(out BodyStance Stance)
{
    local float SwatDistance;
    local Vector TargetLoc;
    local CoverLink targetLink;
    
    targetLink = CoverLink(SwatTurnTarget.Actor);
    if (BS_ShortStart.AnimName.Length > 0 && targetLink != None)
    {
        TargetLoc = targetLink.GetSlotLocation(SwatTurnTarget.SlotIdx);
        SwatDistance = VSize(LoopStartLocation - TargetLoc);
        if (SwatDistance < fShortSwatThreshold)
        {
            Stance = BS_ShortStart;
            return;
        }
    }
    if (bStartStanding)
    {
        Stance = BS_Loop;
    }
    else
    {
        Stance = BS_Loop_Mid;
    }
}
public function GetStartAnim(out BodyStance Stance)
{
    if (bStartStanding)
    {
        Stance = BS_Start;
    }
    else
    {
        Stance = BS_Start_Mid;
    }
}
protected function bool InternalCanDoCustomAction(BioPawn SyncPawn, bool bForced)
{
    return CanPerformSwatTurn(m_oPawn, SwatTurnTarget) || bForced;
}
public function Replicate()
{
    Super(BioCustomAction).Replicate();
    if (m_oPawn != None)
    {
        m_oPawn.ReplicatedCustomActionInfo.Target = SwatTurnTarget.Actor;
        m_oPawn.ReplicatedCustomActionInfo.TargetLocation.X = float(SwatTurnTarget.Direction);
        m_oPawn.ReplicatedCustomActionInfo.TargetLocation.Y = float(SwatTurnTarget.SlotIdx);
    }
}
public function SetMoveStage(EMoveStage NextStage)
{
    local ECoverDirection CoverDir;
    local ECoverAction CoverAction;
    
    Super.SetMoveStage(NextStage);
    if (NextStage == EMoveStage.EMS_Loop)
    {
        LoopStartLocation = m_oPawn.location;
    }
    else if (NextStage == EMoveStage.EMS_End)
    {
        CoverAction = ECoverAction.CA_Default;
        CoverDir = m_oPawn.CoverDirection == ECoverDirection.CD_Right ? ECoverDirection.CD_Left : ECoverDirection.CD_Right;
        if (m_oPC != None)
        {
            if (m_oPawn.CoverDirection == ECoverDirection.CD_Right)
            {
                CoverAction = ECoverAction.CA_PeekLeft;
                CoverDir = ECoverDirection.CD_Left;
                if (m_oPC.PlayerInput != None && m_oPC.PlayerInput.RawJoyRight > m_oPC.DeadZoneThreshold)
                {
                    CoverAction = ECoverAction.CA_Default;
                    CoverDir = ECoverDirection.CD_Right;
                }
            }
            else if (m_oPawn.CoverDirection == ECoverDirection.CD_Left)
            {
                CoverAction = ECoverAction.CA_PeekRight;
                CoverDir = ECoverDirection.CD_Right;
                if (m_oPC.PlayerInput != None && m_oPC.PlayerInput.RawJoyRight < -m_oPC.DeadZoneThreshold)
                {
                    CoverAction = ECoverAction.CA_Default;
                    CoverDir = ECoverDirection.CD_Left;
                }
            }
        }
        if (m_oPawn.Role != ENetRole.ROLE_SimulatedProxy && (OriginalRole == ENetRole.ROLE_None || OriginalRole != ENetRole.ROLE_SimulatedProxy))
        {
            m_oPawn.SetCoverAction(CoverAction);
            m_oPawn.SetCoverDirection(CoverDir);
            m_oPawn.ShouldCrouch(!bEndStanding);
        }
    }
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    m_oPawn.bDisableAnimatedTransitions = TRUE;
    if (SFXAI_Cover(m_oAI) != None)
    {
        SFXAI_Cover(m_oAI).NotifyReachedCover();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fEndBlendInTimeHigh = 0.100000001
    fEndBlendOutTimeHigh = 0.200000003
    fShortSwatThreshold = 350.0
    fHighAnimDist = 80.0
    fLowAnimDist = 50.0
    fEndAnimDist = 50.0
    fEndBlendOutTime = 0.200000003
    fLoopTimeout = 2.0
    StartBlendType = AlphaBlendType.ABT_EaseInOutExponent2
    EndBlendType = AlphaBlendType.ABT_EaseInOutExponent2
    EndRMM = ERootMotionMode.RMM_Accel
    MoveSpeed = 650.0
    fCameraTransitionIn = 0.5
    fCameraTransitionOut = 0.5
    bLockPawnRotation = TRUE
    bTurnOffReticle = TRUE
    bAllowChargeHolding = TRUE
    bDisableCoverAdjust = TRUE
    bReplicateCustomAction = TRUE
    bClientPredictCustomAction = TRUE
    Priority = ECustomActionPriority.CA_Priority_High
}