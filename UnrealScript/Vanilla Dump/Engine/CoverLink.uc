Class CoverLink extends NavigationPoint
    native
    placeable
    config(Game);

struct native immutablewhencooked CoverSlot 
{
    var duplicatetransient array<ECoverAction> Actions;
    var(CoverSlot) editconst duplicatetransient array<FireLink> FireLinks;
    var transient array<FireLink> RejectedFireLinks;
    var array<int> ExposedCoverPackedProperties;
    var array<int> DangerCoverPackedProperties;
    var duplicatetransient array<CoverReference> SlipTarget;
    var duplicatetransient array<SlotMoveRef> SlipRefs;
    var(Auto) editconst duplicatetransient array<CoverReference> OverlapClaims;
    var duplicatetransient CoverReference MantleTarget;
    var Vector LocationOffset;
    var Rotator RotationOffset;
    var Pawn SlotOwner;
    var transient float SlotValidAfterTime;
    var int TurnTargetPackedProperties;
    var int CoverTurnTargetPackedProperties;
    var(CoverSlot) int ExtraCost;
    var float LeanTraceDist;
    var(CoverSlot) editconst duplicatetransient CoverSlotMarker SlotMarker;
    var(Auto) bool bLeanLeft;
    var(Auto) bool bLeanRight;
    var(Auto) bool bForceCanPopUp;
    var(Auto) editconst bool bCanPopUp;
    var(Auto) editconst bool bCanMantle;
    var(Auto) editconst bool bCanClimbUp;
    var(Auto) bool bForceCanCoverSlip_Left;
    var(Auto) bool bForceCanCoverSlip_Right;
    var(Auto) editconst bool bCanCoverSlip_Left;
    var(Auto) editconst bool bCanCoverSlip_Right;
    var(Auto) editconst bool bCanSwatTurn_Left;
    var(Auto) editconst bool bCanSwatTurn_Right;
    var(Auto) editconst bool bCanCoverTurn_Left;
    var(Auto) editconst bool bCanCoverTurn_Right;
    var(CoverSlot) bool bEnabled;
    var(CoverSlot) bool bAllowPopup;
    var(CoverSlot) bool bAllowMantle;
    var(CoverSlot) bool bAllowCoverSlip;
    var(CoverSlot) bool bAllowClimbUp;
    var(CoverSlot) bool bAllowSwatTurn;
    var(CoverSlot) bool bAllowCoverTurn;
    var(CoverSlot) bool bForceNoGroundAdjust;
    var(CoverSlot) bool bPlayerOnly;
    var(CoverSlot) bool bUnsafeCover;
    var transient bool bSelected;
    var bool bFailedToFindSurface;
    var(CoverSlot) ECoverType ForceCoverType;
    var(Auto) editconst ECoverType CoverType;
    var(CoverSlot) ECoverLocationDescription LocationDescription;
    
    structdefaultproperties
    {
        TurnTargetPackedProperties = -1
        CoverTurnTargetPackedProperties = -1
        LeanTraceDist = 64.0
        bCanMantle = TRUE
        bCanCoverSlip_Left = TRUE
        bCanCoverSlip_Right = TRUE
        bCanSwatTurn_Left = TRUE
        bCanSwatTurn_Right = TRUE
        bCanCoverTurn_Left = TRUE
        bCanCoverTurn_Right = TRUE
        bEnabled = TRUE
        bAllowPopup = TRUE
        bAllowMantle = TRUE
        bAllowCoverSlip = TRUE
        bAllowSwatTurn = TRUE
        bAllowCoverTurn = TRUE
    }
};
struct native immutablewhencooked SlotMoveRef 
{
    var(SlotMoveRef) BasedPosition Dest;
    var(SlotMoveRef) PolyReference Poly;
    var(SlotMoveRef) int Direction;
};
struct native immutablewhencooked DangerLink 
{
    var(DangerLink) const editconst ActorReference DangerNav;
    var(DangerLink) int DangerCost;
};
struct native immutablewhencooked ExposedLink 
{
    var(ExposedLink) const editconst CoverReference TargetActor;
    var(ExposedLink) byte ExposedScale;
};
struct native immutablewhencooked DynamicLinkInfo 
{
    var Vector LastTargetLocation;
    var Vector LastSrcLocation;
};
struct native immutablewhencooked FireLink 
{
    var array<byte> Interactions;
    var const int PackedProperties_CoverPairRefAndDynamicInfo;
    var bool bFallbackLink;
    var bool bDynamicIndexInited;
    
    structdefaultproperties
    {
        Interactions = ""
    }
};
struct native immutablewhencooked FireLinkItem 
{
    var ECoverType SrcType;
    var ECoverAction SrcAction;
    var ECoverType DestType;
    var ECoverAction DestAction;
};
enum EFireLinkID
{
    FLI_FireLink,
    FLI_RejectedFireLink,
};
enum ECoverLocationDescription
{
    CoverDesc_None,
    CoverDesc_InWindow,
    CoverDesc_InDoorway,
    CoverDesc_BehindCar,
    CoverDesc_BehindTruck,
    CoverDesc_OnTruck,
    CoverDesc_BehindBarrier,
    CoverDesc_BehindColumn,
    CoverDesc_BehindCrate,
    CoverDesc_BehindWall,
    CoverDesc_BehindStatue,
    CoverDesc_BehindSandbags,
};
enum ECoverType
{
    CT_None,
    CT_Standing,
    CT_MidLevel,
};
enum ECoverDirection
{
    CD_Default,
    CD_Left,
    CD_Right,
    CD_Up,
};
enum ECoverAction
{
    CA_Default,
    CA_BlindLeft,
    CA_BlindRight,
    CA_LeanLeft,
    CA_LeanRight,
    CA_PopUp,
    CA_BlindUp,
    CA_PeekLeft,
    CA_PeekRight,
    CA_PeekUp,
    CA_SwatTurn,
    CA_Aimback,
};
struct native immutablewhencooked CovPosInfo 
{
    var Vector location;
    var Vector Normal;
    var Vector Tangent;
    var CoverLink Link;
    var int LtSlotIdx;
    var int RtSlotIdx;
    var float LtToRtPct;
    
    structdefaultproperties
    {
        LtSlotIdx = -1
        RtSlotIdx = -1
    }
};
struct native immutablewhencooked TargetInfo 
{
    var Actor Target;
    var int SlotIdx;
    var int Direction;
};
struct native immutablewhencooked CoverInfo 
{
    var(CoverInfo) editconst CoverLink Link;
    var(CoverInfo) editconst int SlotIdx;
};
struct native immutablewhencooked LinkSlotHelper 
{
    var(LinkSlotHelper) array<int> Slots;
    var(LinkSlotHelper) CoverLink Link;
};
struct native immutablewhencooked CoverReference extends ActorReference 
{
    var(CoverReference) int SlotIdx;
    var(CoverReference) int Direction;
};
const COVERLINK_DangerDist = 1536.f;
const COVERLINK_EdgeExposureDot = 0.85f;
const COVERLINK_EdgeCheckDot = 0.25f;
const COVERLINK_ExposureDot = 0.4f;

var(CoverLink) array<CoverSlot> Slots;
var array<DynamicLinkInfo> DynamicLinkInfos;
var array<Pawn> Claims;
var const Vector CircularOrigin;
var const Vector StandingLeanOffset;
var const Vector CrouchLeanOffset;
var const Vector PopupOffset;
var(CoverLink) float InvalidateDistance;
var(CoverLink) float MaxFireLinkDist;
var const float CircularRadius;
var const float AlignDist;
var const float AutoCoverSlotInterval;
var const float StandHeight;
var const float MidHeight;
var const float SlipDist;
var const float TurnDist;
var(CoverLink) float DangerScale;
var const CoverLink NextCoverLink;
var globalconfig bool GLOBAL_bUseSlotMarkers;
var(CoverLink) bool bDisabled;
var(CoverLink) bool bClaimAllSlots;
var bool bAutoSort;
var(CoverLink) bool bAutoAdjust;
var(CoverLink) bool bCircular;
var(CoverLink) bool bLooped;
var(CoverLink) bool bPlayerOnly;
var bool bDynamicCover;
var(Debug) bool bDebug_FireLinks;
var(Debug) bool bDebug_ExposedLinks;
var(Debug) bool bDebug_DangerLinks;
var(CoverLink) const ECoverLocationDescription LocationDescription;

public final native function int AddCoverSlot(Vector SlotLocation, Rotator SlotRotation, optional int SlotIdx = -1, optional bool bForceSlotUpdate);

public native function bool AutoAdjustSlot(int SlotIdx, bool bOnlyCheckLeans);

public final event simulated function bool Claim(Pawn NewClaim, int SlotIdx)
{
    local int idx;
    local bool bResult;
    local bool bDoClaim;
    local PlayerController PC;
    local Pawn PreviousOwner;
    
    if (SlotIdx < 0)
    {
        return FALSE;
    }
    bDoClaim = TRUE;
    if (Slots[SlotIdx].SlotOwner != None)
    {
        bResult = Slots[SlotIdx].SlotOwner == NewClaim;
        bDoClaim = FALSE;
        if (!bResult)
        {
            PC = PlayerController(NewClaim.Controller);
            if (PC != None)
            {
                PreviousOwner = Slots[SlotIdx].SlotOwner;
                bDoClaim = TRUE;
            }
        }
    }
    if (bDoClaim)
    {
        if (bClaimAllSlots)
        {
            for (idx = 0; idx < Slots.Length; idx++)
            {
                if (Slots[idx].SlotOwner == None)
                {
                    Claims[Claims.Length] = NewClaim;
                    Slots[idx].SlotOwner = NewClaim;
                    bResult = TRUE;
                }
            }
        }
        else
        {
            Claims[Claims.Length] = NewClaim;
            Slots[SlotIdx].SlotOwner = NewClaim;
            bResult = TRUE;
        }
        if (PreviousOwner != None && PreviousOwner.Controller != None)
        {
            PreviousOwner.Controller.NotifyCoverClaimViolation(NewClaim.Controller, Self, SlotIdx);
        }
    }
    return bResult;
}
public final simulated native function bool FindSlots(Vector CheckLocation, float MaxDistance, out int LeftSlotIdx, out int RightSlotIdx);

public simulated native function bool GetCoverTurnTarget(int SlotIdx, int Direction, out CoverInfo out_Info);

public event simulated function string GetDebugAbbrev()
{
    return "CL";
}
public final event simulated function string GetDebugString(int SlotIdx)
{
    return "L:" $ GetRightMost(string(Self)) @ "S:" $ SlotIdx;
}
public simulated native function bool GetFireLinkTargetCoverInfo(int SlotIdx, int FireLinkIdx, out CoverInfo out_Info, optional EFireLinkID ArrayID);

public native function bool GetFireLinkTo(int SlotIdx, CoverInfo ChkCover, ECoverAction ChkAction, ECoverType ChkType, out int out_FireLinkIdx, out array<int> out_Items);

public final simulated native function ECoverLocationDescription GetLocationDescription(int SlotIdx);

public final native function GetSlotActions(int SlotIdx, out array<ECoverAction> Actions);

public final simulated native function int GetSlotIdxToLeft(int SlotIdx, optional int Cnt = 1);

public final simulated native function int GetSlotIdxToRight(int SlotIdx, optional int Cnt = 1);

public final simulated native function Vector GetSlotLocation(int SlotIdx, optional bool bForceUseOffset);

public final simulated native function CoverSlotMarker GetSlotMarker(int SlotIdx);

public final simulated native function Rotator GetSlotRotation(int SlotIdx, optional bool bForceUseOffset);

public final simulated native function Vector GetSlotViewPoint(int SlotIdx, optional ECoverType Type, optional ECoverAction Action);

public simulated native function bool GetSwatTurnTarget(int SlotIdx, int Direction, out CoverInfo out_Info);

public native function bool HasFireLinkTo(int SlotIdx, CoverInfo ChkCover, optional bool bAllowFallbackLinks);

public final simulated native function bool IsEdgeSlot(int SlotIdx, optional bool bIgnoreLeans);

public final native function bool IsEnabled();

public final simulated native function bool IsExposedTo(int SlotIdx, CoverInfo ChkSlot, out float out_ExposedScale);

public final simulated native function bool IsLeftEdgeSlot(int SlotIdx, bool bIgnoreLeans);

public final simulated native function bool IsRightEdgeSlot(int SlotIdx, bool bIgnoreLeans);

public final native function bool IsValidClaim(Pawn ChkClaim, int SlotIdx, optional bool bSkipTeamCheck, optional bool bSkipOverlapCheck);

public function OnToggle(SeqAct_Toggle inAction)
{
    local int SlotIdx;
    local CoverReplicator CoverReplicator;
    
    Super.OnToggle(inAction);
    if (inAction.InputLinks[0].bHasImpulse)
    {
        bDisabled = FALSE;
    }
    else if (inAction.InputLinks[1].bHasImpulse)
    {
        bDisabled = TRUE;
    }
    else
    {
        bDisabled = !bDisabled;
    }
    for (SlotIdx = 0; SlotIdx < Slots.Length; SlotIdx++)
    {
        if (Slots[SlotIdx].SlotMarker != None)
        {
            Slots[SlotIdx].SlotMarker.OnToggle(inAction);
        }
    }
    CoverReplicator = WorldInfo.Game.GetCoverReplicator();
    if (CoverReplicator != None)
    {
        CoverReplicator.NotifyLinkDisabledStateChange(Self);
    }
}
public static simulated native function byte PackFireLinkInteractionInfo(ECoverType SrcType, ECoverAction SrcAction, ECoverType DestType, ECoverAction DestAction);

public final event simulated function RemovedFromWorld()
{
    local int SlotIdx;
    
    for (SlotIdx = 0; SlotIdx < Slots.Length; SlotIdx++)
    {
        NotifySlotOwnerCoverDisabled(SlotIdx);
    }
}
public event simulated function SetDisabled(bool bNewDisabled)
{
    local int SlotIdx;
    local CoverReplicator CoverReplicator;
    
    bDisabled = bNewDisabled;
    if (bDisabled)
    {
        for (SlotIdx = 0; SlotIdx < Slots.Length; SlotIdx++)
        {
            NotifySlotOwnerCoverDisabled(SlotIdx);
        }
    }
    CoverReplicator = WorldInfo.Game.GetCoverReplicator();
    if (CoverReplicator != None)
    {
        CoverReplicator.NotifyLinkDisabledStateChange(Self);
    }
}
public final event simulated function SetInvalidUntil(int SlotIdx, float TimeToBecomeValid)
{
    Slots[SlotIdx].SlotValidAfterTime = TimeToBecomeValid;
    NotifySlotOwnerCoverDisabled(SlotIdx);
}
public event simulated function SetSlotEnabled(int SlotIdx, bool bEnable)
{
    Slots[SlotIdx].bEnabled = bEnable;
    if (!bEnable)
    {
        NotifySlotOwnerCoverDisabled(SlotIdx);
    }
}
public event simulated function ShutDown()
{
    local int SlotIdx;
    
    Super.ShutDown();
    bDisabled = TRUE;
    for (SlotIdx = 0; SlotIdx < Slots.Length; SlotIdx++)
    {
        if (Slots[SlotIdx].SlotMarker != None)
        {
            Slots[SlotIdx].SlotMarker.ShutDown();
        }
    }
}
public final event simulated function bool UnClaim(Pawn OldClaim, int SlotIdx, bool bUnclaimAll)
{
    local int idx;
    local int NumReleased;
    local bool bResult;
    
    if (bUnclaimAll)
    {
        for (idx = 0; idx < Slots.Length; idx++)
        {
            if (Slots[idx].SlotOwner == OldClaim)
            {
                Slots[idx].SlotOwner = None;
                NumReleased++;
                bResult = TRUE;
            }
        }
    }
    else if (!bClaimAllSlots && Slots[SlotIdx].SlotOwner == OldClaim)
    {
        Slots[SlotIdx].SlotOwner = None;
        NumReleased++;
        for (bResult = TRUE; NumReleased > 0; NumReleased--)
        {
            idx = Claims.Find(OldClaim);
            if (idx < 0)
            {
                break;
            }
            Claims.Remove(idx, 1);
        }
        return bResult;
    }
}
public static simulated native function UnPackFireLinkInteractionInfo(const byte PackedByte, out ECoverType SrcType, out ECoverAction SrcAction, out ECoverType DestType, out ECoverAction DestAction);

public final simulated function bool AllowLeftTransition(int SlotIdx)
{
    local int NextSlotIdx;
    
    NextSlotIdx = GetSlotIdxToLeft(SlotIdx);
    if (NextSlotIdx >= 0)
    {
        return Slots[NextSlotIdx].bEnabled;
    }
    return FALSE;
}
public final simulated function bool AllowRightTransition(int SlotIdx)
{
    local int NextSlotIdx;
    
    NextSlotIdx = GetSlotIdxToRight(SlotIdx);
    if (NextSlotIdx >= 0)
    {
        return Slots[NextSlotIdx].bEnabled;
    }
    return FALSE;
}
public function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local CoverReplicator CoverReplicator;
    local int i;
    
    Super.ApplyCheckpointRecord(Record);
    bDisabled = Record.bDisabled;
    for (i = 0; i < Slots.Length; i++)
    {
        if (Slots[i].SlotMarker != None)
        {
            Slots[i].SlotMarker.bBlocked = bBlocked;
        }
    }
    CoverReplicator = WorldInfo.Game.GetCoverReplicator();
    if (CoverReplicator != None)
    {
        CoverReplicator.NotifyLinkDisabledStateChange(Self);
    }
}
public function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Super.CreateCheckpointRecord(Record);
    Record.bDisabled = bDisabled;
}
public final simulated function bool IsStationarySlot(int SlotIdx)
{
    return !bCircular && IsEdgeSlot(SlotIdx, FALSE);
}
public simulated function NotifySlotOwnerCoverDisabled(int SlotIdx)
{
    local int LeftIdx;
    local int RightIdx;
    
    if (Slots[SlotIdx].SlotOwner != None && Slots[SlotIdx].SlotOwner.Controller != None)
    {
        Slots[SlotIdx].SlotOwner.Controller.NotifyCoverDisabled(Self, SlotIdx, FALSE);
    }
    LeftIdx = GetSlotIdxToLeft(SlotIdx);
    if (LeftIdx >= 0 && Slots[LeftIdx].SlotOwner != None && Slots[LeftIdx].SlotOwner.Controller != None)
    {
        Slots[LeftIdx].SlotOwner.Controller.NotifyCoverDisabled(Self, SlotIdx, TRUE);
    }
    RightIdx = GetSlotIdxToRight(SlotIdx);
    if (RightIdx >= 0 && Slots[RightIdx].SlotOwner != None && Slots[RightIdx].SlotOwner.Controller != None)
    {
        Slots[RightIdx].SlotOwner.Controller.NotifyCoverDisabled(Self, SlotIdx, TRUE);
    }
}
public function OnModifyCover(SeqAct_ModifyCover Action)
{
    local array<int> SlotIndices;
    local int idx;
    local int SlotIdx;
    local CoverReplicator CoverReplicator;
    
    if (Action.Slots.Length > 0)
    {
        SlotIndices = Action.Slots;
    }
    else
    {
        for (idx = 0; idx < Slots.Length; idx++)
        {
            SlotIndices[SlotIndices.Length] = idx;
        }
    }
    for (idx = 0; idx < SlotIndices.Length; idx++)
    {
        SlotIdx = SlotIndices[idx];
        if (SlotIdx >= 0 && SlotIdx < Slots.Length)
        {
            if (Action.InputLinks[0].bHasImpulse)
            {
                SetSlotEnabled(SlotIdx, TRUE);
                continue;
            }
            if (Action.InputLinks[1].bHasImpulse)
            {
                SetSlotEnabled(SlotIdx, FALSE);
                continue;
            }
            if (Action.InputLinks[2].bHasImpulse)
            {
                if (AutoAdjustSlot(SlotIdx, FALSE) && Slots[SlotIdx].SlotOwner != None && Slots[SlotIdx].SlotOwner.Controller != None)
                {
                    Slots[SlotIdx].SlotOwner.Controller.NotifyCoverAdjusted();
                }
                continue;
            }
            if (Action.InputLinks[3].bHasImpulse)
            {
                if (Action.ManualCoverType != ECoverType.CT_None)
                {
                    Slots[SlotIdx].CoverType = Action.ManualCoverType;
                    if (Slots[SlotIdx].SlotOwner != None && Slots[SlotIdx].SlotOwner.Controller != None)
                    {
                        Slots[SlotIdx].SlotOwner.Controller.NotifyCoverAdjusted();
                    }
                }
                Slots[SlotIdx].bPlayerOnly = Action.bManualAdjustPlayersOnly;
            }
        }
    }
    CoverReplicator = WorldInfo.Game.GetCoverReplicator();
    if (CoverReplicator != None)
    {
        if (Action.InputLinks[0].bHasImpulse)
        {
            CoverReplicator.NotifyEnabledSlots(Self, SlotIndices);
        }
        else if (Action.InputLinks[1].bHasImpulse)
        {
            CoverReplicator.NotifyDisabledSlots(Self, SlotIndices);
        }
        else if (Action.InputLinks[2].bHasImpulse)
        {
            CoverReplicator.NotifyAutoAdjustSlots(Self, SlotIndices);
        }
        else if (Action.InputLinks[3].bHasImpulse)
        {
            CoverReplicator.NotifySetManualCoverTypeForSlots(Self, SlotIndices, Action.ManualCoverType);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 58.0
        CollisionRadius = 48.0
        ReplacementPrimitive = None
    End Template
    Slots = ({
              Actions = (), 
              FireLinks = (), 
              RejectedFireLinks = (), 
              ExposedCoverPackedProperties = (), 
              DangerCoverPackedProperties = (), 
              SlipTarget = (), 
              SlipRefs = (), 
              OverlapClaims = (), 
              MantleTarget = {
                              SlotIdx = 0, 
                              Direction = 0, 
                              Guid = {A = 0, B = 0, C = 0, D = 0}, 
                              Actor = None
                             }, 
              LocationOffset = {X = 64.0, Y = 0.0, Z = 0.0}, 
              RotationOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
              SlotOwner = None, 
              SlotValidAfterTime = 0.0, 
              TurnTargetPackedProperties = -1, 
              CoverTurnTargetPackedProperties = -1, 
              ExtraCost = 0, 
              LeanTraceDist = 64.0, 
              SlotMarker = None, 
              bLeanLeft = FALSE, 
              bLeanRight = FALSE, 
              bForceCanPopUp = FALSE, 
              bCanPopUp = FALSE, 
              bCanMantle = TRUE, 
              bCanClimbUp = FALSE, 
              bForceCanCoverSlip_Left = FALSE, 
              bForceCanCoverSlip_Right = FALSE, 
              bCanCoverSlip_Left = TRUE, 
              bCanCoverSlip_Right = TRUE, 
              bCanSwatTurn_Left = TRUE, 
              bCanSwatTurn_Right = TRUE, 
              bCanCoverTurn_Left = TRUE, 
              bCanCoverTurn_Right = TRUE, 
              bEnabled = TRUE, 
              bAllowPopup = TRUE, 
              bAllowMantle = TRUE, 
              bAllowCoverSlip = TRUE, 
              bAllowClimbUp = FALSE, 
              bAllowSwatTurn = TRUE, 
              bAllowCoverTurn = TRUE, 
              bForceNoGroundAdjust = FALSE, 
              bPlayerOnly = FALSE, 
              bUnsafeCover = FALSE, 
              bSelected = FALSE, 
              bFailedToFindSurface = FALSE, 
              ForceCoverType = ECoverType.CT_None, 
              CoverType = ECoverType.CT_None, 
              LocationDescription = ECoverLocationDescription.CoverDesc_None
             }
            )
    StandingLeanOffset = {X = 0.0, Y = 78.0, Z = 69.0}
    CrouchLeanOffset = {X = 0.0, Y = 70.0, Z = 19.0}
    PopupOffset = {X = 0.0, Y = 0.0, Z = 70.0}
    InvalidateDistance = 64.0
    MaxFireLinkDist = 3000.0
    AlignDist = 36.0
    AutoCoverSlotInterval = 256.0
    StandHeight = 130.0
    MidHeight = 70.0
    SlipDist = 152.0
    TurnDist = 612.0
    DangerScale = 2.0
    GLOBAL_bUseSlotMarkers = TRUE
    bAutoSort = TRUE
    bAutoAdjust = TRUE
    bDebug_FireLinks = TRUE
    CylinderComponent = CollisionCylinder
    bSpecialMove = TRUE
    bBuildLongPaths = FALSE
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}