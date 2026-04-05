Class SFXAI_Core extends SFXAI_NativeBase
    placeable
    hidedropdown
    config(AI);

enum EAITicketType
{
    AI_NoTicket,
    AI_TargetTicket,
    AI_AttackTicket,
};
struct KismetOrder 
{
    var delegate<FireWeaponDelegate> FireCallback;
    var delegate<MoveToDelegate> MoveCallback;
    var Actor oTargetActor;
    var float fDistOffset;
    var float fAttackDuration;
    var bool bWalk;
    var bool bForceShoot;
    var KismetOrderType eOrderType;
};
enum KismetOrderType
{
    KISMET_ORDER_NONE,
    KISMET_ORDER_FIRE_WEAPON,
    KISMET_ORDER_MOVE,
};
enum EAICompletionReasons
{
    AI_Cancelled,
    AI_Success,
    AI_Failed,
    AI_LOS,
    AI_Cooldown,
    AI_Disabled,
};
enum AttackResult
{
    ATTACK_SUCCESS,
    ATTACK_FAIL,
    ATTACK_FAIL_RELOADING,
    ATTACK_FAIL_NO_LOS,
};
const CANCEL_REASON_IN_PLAYER_LINE_OF_FIRE = 16;
const CANCEL_REASON_TARGET_CHANGED = 8;
const CANCEL_REASON_ORDER_CANCELLED = 4;
const CANCEL_REASON_NEW_ORDER = 2;
const CANCEL_REASON_SHOT = 1;

var KismetOrder CurrentKismetOrder;
var delegate<UsePowerDelegate> __UsePowerDelegate__Delegate;
var delegate<FireWeaponDelegate> __FireWeaponDelegate__Delegate;
var delegate<MoveToDelegate> __MoveToDelegate__Delegate;
var delegate<TryInvalidateTargetRange> __TryInvalidateTargetRange__Delegate;
var delegate<TryInvalidateTargetFlank> __TryInvalidateTargetFlank__Delegate;
var Class<SFXAICommand_Base_Combat> DefaultCommand;
var Class<SFXAICommand_Base_Combat> FallbackCommand;
var Class<SFXAICommand_Base_Combat> AggressiveCommand;
var Class<SFXAICommand_Base_Combat> BerserkCommand;
var Class<SFXAICommand_Base_Combat> PendingCommand;
var(SFXAI_Core) Vector AimOverrideLoc;
var transient Vector m_PowerTargetLocation;
var transient Vector m_vPushDirection;
var transient Vector m_vOriginalMoveGoalLocation;
var(SFXAI_Core) Vector2D EvadeDamagePct;
var const Name SyncMeleeAbilityName;
var(SFXAI_Core) Vector2D MoveFireDelayTime;
var(SFXAI_Core) config Vector2D AI_BurstsToFire;
var(SFXAI_Core) const float m_fNearbyEnemyDistance;
var transient float LastFireTime;
var transient float LastDamagedTime;
var transient float LastMeleeTime;
var transient float LastSyncMeleeTime;
var float MeleeAttackInterval;
var float SyncMeleeAttackInterval;
var(SFXAI_Core) float EvadeFrequency;
var transient float LastEvadeTime;
var transient float EvadeDamageTaken;
var transient float EvadeHealthThreshold;
var(SFXAI_Core) float EvadeResetDuration;
var(SFXAI_Core) float PowerEvadeChance;
var(SFXAI_Core) float PartialLeanPct;
var const float MeleeMoveOffset;
var(SFXAI_Core) float CoverLeanAimOffset;
var(SFXAI_Core) float CoverAimOffset;
var(SFXAI_Core) float DirectAimOffset;
var transient float AimInstability;
var transient float LastInstabilityTime;
var config float AI_Acc_InstabilityDecayRate;
var(SFXAI_Core) config float AI_Acc_Base;
var(SFXAI_Core) config float AI_Acc_Target;
var(SFXAI_Core) config float AI_AccMod_Move;
var(SFXAI_Core) config float AI_AccMod_TargMove;
var(SFXAI_Core) config float AI_AccMod_BriefAcquire;
var(SFXAI_Core) config float AI_AccMod_BriefVisibility;
var(SFXAI_Core) config float AI_AccMod_ShortRange;
var(SFXAI_Core) config float AI_AccMod_MediumRange;
var(SFXAI_Core) config float AI_AccMod_LongRange;
var transient int DesiredBurstsToFire;
var(SFXAI_Core) float CancelFirePct;
var float WeaponAimDelay;
var transient Pawn DriveTarget;
var transient Pawn ExecutionTarget;
var transient float m_fFiringArcAngle;
var transient float m_fReloadThreshold;
var transient int m_nCancelReasons;
var transient Actor m_PowerTargetActor;
var transient int m_nReservationID;
var transient int m_nMoveAttemptCounter;
var transient float LastFailedPathTime;
var transient float LastSuccessfulPathTime;
var transient float LastCombatActionTime;
var const float StuckTimeout;
var transient Actor m_RequestedActorToFollow;
var transient Actor m_ActorToFollow;
var transient int m_nPowerCompletionReason;
var transient int m_nWeaponCompletionReason;
var transient int m_nMoveCompletionReason;
var transient float m_fRunThreshold;
var transient Pawn m_oLastBumped;
var transient float m_fLastBumpTime;
var transient BioPawn m_oPushingPawn;
var transient float m_fLastPushTime;
var transient int m_nCurrentAttackID;
var transient SFXWeapon m_oNextWeapon;
var Actor PreferredAnchor;
var float AnchorDistance;
var float TimeOfLastCombatEvent;
var const float TimeUntilAggressive;
var const config int MaxNumAggressive;
var const int m_nTargetTicketCost;
var const float m_fPlayerTargetWeightBonus;
var transient Actor m_oGoalActor;
var transient Actor m_oLastApproachTarget;
var transient float m_fLastApproachDistance;
var transient float m_fLastApproachCheckTime;
var transient float MoveTimerPenalty;
var transient Actor ObjectiveGoalActor;
var config bool bUseTicketing;
var bool bAllowCombatTransitions;
var transient bool m_bPowerProjectileReleased;
var bool bNotifyFriendsOnDeath;
var const bool bReceiveDeathNotifications;
var transient bool bNotifiedNewEnemySoundPlayed;
var transient bool m_bCheckLOS;
var transient bool m_bCancelAction;
var transient bool m_bWaitBeforeNextAttack;
var transient bool m_bClearVelocityAfterMove;
var transient bool m_bUsePowerReservations;
var transient bool bStuck;
var transient bool bGetFirstMoveTargetFailed;
var transient bool m_bAllowedToLeavePlaypen;
var transient bool m_bIgnorePowerSuppression;
var transient bool m_bStayLeanedOut;
var transient bool m_bAvoidDangerLinks;
var transient bool m_bAvoidFireFromPlayerOnly;
var transient bool m_bDelayWeaponUse;
var transient bool m_bFailedTicket;
var transient bool m_bCustomActionFailed;
var transient bool m_bPendingWeaponSwitch;
var transient bool m_bCanResurrect;
var transient bool m_bFollowingActor;
var transient bool bKismetForcedWalk;
var transient bool m_bFirstIdle;
var transient bool bDying;
var transient bool bIsAutoBot;
var transient ECoverAction PendingCoverAction;
var transient ECoverAction BestTargetCoverAction;
var transient AttackResult m_AttackResult;
var EAICombatMood PreviousCombatMood;

public function AttackResult Attack()
{
    local Name nmPowerName;
    
    m_AttackResult = AttackResult.ATTACK_FAIL;
    if (MyBP == None)
    {
        return m_AttackResult;
    }
    if (HasValidTarget() == FALSE)
    {
        return m_AttackResult;
    }
    if (MyBP.Weapon != None)
    {
        if (MyBP.IsReloading(TRUE))
        {
            m_AttackResult = AttackResult.ATTACK_FAIL_RELOADING;
            return m_AttackResult;
        }
        else if (MyBP.IsSwitchingWeapons())
        {
            return m_AttackResult;
        }
    }
    Focus = FireTarget;
    if (ChooseAttack(FireTarget, nmPowerName) == FALSE)
    {
        return m_AttackResult;
    }
    if (nmPowerName != 'None')
    {
        Class'SFXAICmd_UsePower'.static.UsePower(Self, nmPowerName);
    }
    else
    {
        ShootWeaponAtFireTarget(MyBP.GetMaxHealth() * CancelFirePct);
    }
    m_AttackResult = AttackResult.ATTACK_SUCCESS;
    return m_AttackResult;
}
public event function BioClearCrossLevelReferences(Level oLevel)
{
    if (m_PowerTargetActor != None && IsActorInLevel(m_PowerTargetActor, oLevel))
    {
        m_PowerTargetActor = None;
    }
    if (m_RequestedActorToFollow != None && IsActorInLevel(m_RequestedActorToFollow, oLevel))
    {
        m_RequestedActorToFollow = None;
    }
    if (m_ActorToFollow != None && IsActorInLevel(m_ActorToFollow, oLevel))
    {
        m_ActorToFollow = None;
    }
}
public function bool CanFireWeapon(Weapon Wpn, byte FireModeNum)
{
    if (int(FireModeNum) == 4)
    {
        return TRUE;
    }
    if (MyBP != None && MyBP.CanFireWeapon() == FALSE)
    {
        return FALSE;
    }
    if (IsReloading())
    {
        return FALSE;
    }
    if (CurrentKismetOrder.eOrderType != KismetOrderType.KISMET_ORDER_FIRE_WEAPON || CurrentKismetOrder.bForceShoot == FALSE)
    {
        if (HasValidTarget() == FALSE)
        {
            return FALSE;
        }
        if (IsFireLineObstructed())
        {
            return FALSE;
        }
    }
    return TRUE;
}
public event function bool EnableAI(bool bEnable, int nRequestedBy)
{
    local int nOriginalFlags;
    
    nOriginalFlags = m_nEnabledFlags;
    if (bEnable)
    {
        m_nEnabledFlags = m_nEnabledFlags & ~nRequestedBy;
    }
    else
    {
        m_nEnabledFlags = m_nEnabledFlags | nRequestedBy;
    }
    if (m_nEnabledFlags == nOriginalFlags)
    {
        return TRUE;
    }
    if (m_nEnabledFlags != 0)
    {
        BeginCombatCommand(Class'SFXAICmd_Disabled');
    }
    else if (IsActorInPlaypen(MyBP) == FALSE)
    {
        if (SFXAICmd_Disabled(CommandList) != None)
        {
            AbortCommand(CommandList);
        }
        BeginCombatCommand(Class'SFXAICmd_ReturnToPlaypen', "Outside of playpen");
    }
    else if (SFXAICmd_Disabled(CommandList) != None)
    {
        BeginDefaultCommand();
    }
    else if (PendingCommand == Class'SFXAICmd_Disabled')
    {
        PendingCommand = None;
    }
    return TRUE;
}
public event function GetActorToFollow(out Actor oActor, out Vector vLocation)
{
    oActor = m_ActorToFollow;
    vLocation = m_ActorToFollow.location;
}
public function Vector GetAimLocation(optional Actor oAimTarget)
{
    local Vector AimLoc;
    local CoverInfo EnemyCover;
    local BioPawn oEnemyPawn;
    local ECoverAction TargetCoverAction;
    local ECoverType CoverSlotType;
    local int EnemyIdx;
    
    if (IsZero(AimOverrideLoc) == FALSE)
    {
        return AimOverrideLoc;
    }
    if (oAimTarget == None)
    {
        oAimTarget = FireTarget;
    }
    oEnemyPawn = BioPawn(oAimTarget);
    EnemyIdx = GetEnemyIndex(Pawn(oAimTarget));
    if (oEnemyPawn != None && EnemyIdx >= 0 && oEnemyPawn.IsInCover() && GetPawnCover(oEnemyPawn, EnemyCover, TRUE))
    {
        TargetCoverAction = GetBestTargetCoverAction(oEnemyPawn, EnemyCover);
        if (TargetCoverAction != ECoverAction.CA_Default)
        {
            CoverSlotType = EnemyCover.Link.Slots[EnemyCover.SlotIdx].CoverType;
            if (EnemyIdx >= 0 && !IsEnemyVisibleByIndex(EnemyIdx))
            {
                AimLoc = EnemyCover.Link.GetSlotViewPoint(EnemyCover.SlotIdx, CoverSlotType, TargetCoverAction);
            }
            else
            {
                AimLoc = GetEnemyLocationByIndex(EnemyIdx, 1);
                if (oEnemyPawn.CoverAction != ECoverAction.CA_PopUp)
                {
                    AimLoc.Z -= CoverLeanAimOffset;
                }
            }
        }
        else
        {
            AimLoc = GetEnemyLocationByIndex(EnemyIdx, 1);
            AimLoc.Z -= CoverAimOffset;
        }
    }
    else if (EnemyIdx >= 0)
    {
        AimLoc = GetEnemyLocationByIndex(EnemyIdx, 1);
        AimLoc.Z += DirectAimOffset;
    }
    else
    {
        AimLoc = FireTarget.location;
    }
    return AimLoc;
}
public function Initialize()
{
    local SFXDifficultyHandler DH;
    
    if (MyBP != None)
    {
        if (MyBP.Squad != None)
        {
            if (!MyBP.Squad.bSquadEnabled)
            {
                m_bInitiallyDisabled = TRUE;
            }
        }
        MoveTimerPenalty = 40.0 / MyBP.CombatGroundSpeed;
    }
    Super(BioAiController).Initialize();
    if (MyBP != None)
    {
        EvadeHealthThreshold = (MyBP.GetMaxHealth() + MyBP.GetMaxShields()) * RandRange(EvadeDamagePct.X, EvadeDamagePct.Y);
    }
    DH = SFXGRI(WorldInfo.GRI).DifficultyHandler;
    if (DH != None && SFXPawn(MyBP) != None)
    {
        SFXPawn(MyBP).AmmoDropPct = DH.GetFloat('AmmoDropPct', 'Global');
    }
}
public function bool IsActorInPlaypen(Actor oActor)
{
    if (oActor != None)
    {
        if (MyBP != None && MyBP.Squad != None)
        {
            if (!MyBP.Squad.HasPlaypen())
            {
                return TRUE;
            }
            else if (MyBP.Squad.IsPositionInPlaypen(oActor.location))
            {
                return TRUE;
            }
            return FALSE;
        }
    }
    return TRUE;
}
public function bool IsReturningToPlaypen()
{
    return SFXAICmd_ReturnToPlaypen(CommandList) != None;
}
public function bool NotifyBump(Actor Other, Vector HitNormal)
{
    local BioCustomAction Action;
    local SFXAI_Core oOtherAI;
    local SFXAICommand Cmd;
    
    m_oLastBumped = Pawn(Other);
    m_fLastBumpTime = WorldInfo.GameTimeSeconds;
    if (m_oLastBumped != None)
    {
        oOtherAI = SFXAI_Core(m_oLastBumped.Controller);
        if (oOtherAI != None)
        {
            oOtherAI.PushPawn(MyBP, HitNormal);
        }
    }
    if (MyBP != None && MyBP.CurrentCustomAction != 0 && MyBP.GetCurrentCustomAction(Action) && Action.NotifyBump(Other, HitNormal))
    {
        return TRUE;
    }
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None && Cmd.NotifyBump(Other, HitNormal))
    {
        return TRUE;
    }
    return Super(Controller).NotifyBump(Other, HitNormal);
}
public function NotifyEnemyVisible(int EnemyIdx, float TimeSinceSeen)
{
    local SFXAICommand Cmd;
    
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        Cmd.NotifyEnemyVisible(EnemyIdx, TimeSinceSeen);
    }
    Super(BioAiController).NotifyEnemyVisible(EnemyIdx, TimeSinceSeen);
}
public function bool NotifyHitWall(Vector HitNormal, Actor Wall)
{
    local BioCustomAction Action;
    local SFXAICommand Cmd;
    
    if (MyBP != None && MyBP.GetCurrentCustomAction(Action) && Action.NotifyHitWall(HitNormal, Wall))
    {
        return TRUE;
    }
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None && Cmd.NotifyHitWall(HitNormal, Wall))
    {
        return TRUE;
    }
    if (MoveTarget != None && MoveTarget == MoveGoal && MoveTimer > 0.0)
    {
        MoveTimer -= MoveTimerPenalty;
    }
    return Super(Controller).NotifyHitWall(HitNormal, Wall);
}
public event function OnEnteredPlaypen()
{
    local SFXAICommand Cmd;
    
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        Cmd.OnEnteredPlaypen();
    }
}
public function OnEnteringStasis()
{
    ReleaseTicket(FireTarget, 1);
    ReleaseTicket(FireTarget, 2, TRUE);
    Super(BioAiController).OnEnteringStasis();
}
public event function OnLeftPlaypen()
{
    if (MyBP == None || MyBP.Squad == None)
    {
        return;
    }
    if (m_bAllowedToLeavePlaypen)
    {
        return;
    }
    if (IsReturningToPlaypen())
    {
        if (MoveGoal != None && MyBP.Squad.IsPositionInPlaypen(MoveGoal.location))
        {
            return;
        }
    }
    BeginCombatCommand(Class'SFXAICmd_ReturnToPlaypen');
}
public function PostBeginPlay()
{
    local SFXDifficultyHandler DH;
    
    DH = SFXGRI(WorldInfo.GRI).DifficultyHandler;
    Super(Controller).PostBeginPlay();
    if (!bDeleteMe && WorldInfo.NetMode != ENetMode.NM_Client && PlayerReplicationInfo == None)
    {
        InitPlayerReplicationInfo();
        if (SFXGRI(WorldInfo.GRI).bMultiplayer && DH != None)
        {
            SetTimer(DH.GetFloat('DownedPlayersCheckFrequency', 'MPGlobal'), TRUE, 'CheckDownedPlayers', );
        }
    }
}
public function bool RELOAD()
{
    local SFXWeapon Weapon;
    
    if (MyBP == None)
    {
        return FALSE;
    }
    Weapon = SFXWeapon(MyBP.Weapon);
    if (Weapon == None)
    {
        return FALSE;
    }
    Weapon.TryReload(FALSE);
    return TRUE;
}
public function Reset()
{
    Super(BioAiController).Reset();
    DriveTarget = None;
    m_bCancelAction = FALSE;
    m_PowerTargetActor = None;
    bStuck = FALSE;
    m_RequestedActorToFollow = None;
    m_ActorToFollow = None;
    m_oNextWeapon = None;
    CurrentKismetOrder.eOrderType = KismetOrderType.KISMET_ORDER_NONE;
    bKismetForcedWalk = FALSE;
    PreferredAnchor = None;
    m_oGoalActor = None;
    m_oLastApproachTarget = None;
    ObjectiveGoalActor = None;
    __UsePowerDelegate__Delegate = None;
    __FireWeaponDelegate__Delegate = None;
    __MoveToDelegate__Delegate = None;
}
public function SwitchWeapon(SFXWeapon oWeapon)
{
    if (MyBP != None)
    {
        CancelAction();
        m_bPendingWeaponSwitch = TRUE;
        m_oNextWeapon = oWeapon;
    }
}
public event function UpdateMovementActions()
{
    local SFXAICommand SFXCommandList;
    
    SFXCommandList = SFXAICommand(CommandList);
    if (SFXCommandList != None)
    {
        SFXCommandList.UpdateMovementActions();
    }
}
public function bool CanAttack(Actor oTarget)
{
    local CoverInfo TargetCover;
    local BioPawn TargetPawn;
    local SFXAI_Core TargetAI;
    local bool bCanAttack;
    local array<ECoverAction> CoverActions;
    local int ActionIndex;
    local Vector AttackOrigin;
    local Vector CoverViewPt;
    local ECoverAction TargetCoverAction;
    local ECoverAction AttackerCoverAction;
    
    TargetCoverAction = ECoverAction.CA_Default;
    AttackerCoverAction = ECoverAction.CA_Default;
    if (Pawn == None || oTarget == None)
    {
        return FALSE;
    }
    TargetPawn = BioPawn(oTarget);
    bCanAttack = FALSE;
    if (GetAttackOrigin(oTarget, AttackOrigin))
    {
        if (TargetPawn != None && TargetPawn.IsInCover() && GetPawnCover(TargetPawn, TargetCover))
        {
            if (TargetPawn.IsLeaning() || TargetPawn.IsBlindFiring())
            {
                CoverViewPt = TargetCover.Link.GetSlotViewPoint(TargetCover.SlotIdx, 0, TargetPawn.CoverAction);
                bCanAttack = CanAISeeByPoints(AttackOrigin, CoverViewPt, Rotator(CoverViewPt - AttackOrigin), FALSE);
            }
            else if (BestTargetCoverAction != ECoverAction.CA_Default)
            {
                CoverViewPt = TargetCover.Link.GetSlotViewPoint(TargetCover.SlotIdx, 0, BestTargetCoverAction);
                bCanAttack = CanAISeeByPoints(AttackOrigin, CoverViewPt, Rotator(CoverViewPt - AttackOrigin), FALSE);
            }
            else
            {
                TargetAI = SFXAI_Core(TargetPawn.Controller);
                if (TargetAI != None)
                {
                    if (TargetAI.GetBestCoverAction(TargetCover, Pawn, TargetCoverAction, AttackerCoverAction))
                    {
                        bCanAttack = TRUE;
                    }
                }
                else
                {
                    TargetCover.Link.GetSlotActions(TargetCover.SlotIdx, CoverActions);
                    if (CoverActions.Length > 0)
                    {
                        for (ActionIndex = 0; ActionIndex < CoverActions.Length; ActionIndex++)
                        {
                            CoverViewPt = TargetCover.Link.GetSlotViewPoint(TargetCover.SlotIdx, 0, CoverActions[ActionIndex]);
                            bCanAttack = CanFireAt(Pawn, CoverViewPt, TRUE);
                            if (bCanAttack)
                            {
                                break;
                            }
                        }
                    }
                    if (!bCanAttack)
                    {
                        bCanAttack = CanFireAt(oTarget, AttackOrigin, TRUE);
                    }
                }
            }
        }
        else
        {
            bCanAttack = CanFireAt(oTarget, AttackOrigin, TRUE);
        }
    }
    return bCanAttack;
}
public function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Vector AimLoc;
    local SFXWeapon Wpn;
    local float InaccuracyPct;
    local float Pct;
    local Rotator AccRot;
    local Rotator AimRot;
    local int EnemyIdx;
    local float AccMinCone;
    local float AccMaxCone;
    
    Wpn = SFXWeapon(W);
    EnemyIdx = -1;
    if (Pawn(FireTarget) != None)
    {
        EnemyIdx = EnemyList.Find('Pawn', Pawn(FireTarget));
    }
    if (Pawn != None && FireTarget != None && Wpn != None)
    {
        AimLoc = GetAimLocation(FireTarget);
        UpdateAccuracy();
        InaccuracyPct = AI_Acc_Base;
        if (MyBP != None && MyBP.CoverType != ECoverType.CT_None)
        {
            InaccuracyPct = AI_Acc_Target;
        }
        if (VSize(Pawn.Velocity) > float(0))
        {
            InaccuracyPct += AI_AccMod_Move;
        }
        if (VSize(FireTarget.Velocity) > float(0))
        {
            InaccuracyPct += AI_AccMod_TargMove;
        }
        Pct = float(Clamp(int(float(1) - (WorldInfo.GameTimeSeconds - TargetAcquisitionTime) / Response_MinEnemySeenTime), 0, 1));
        InaccuracyPct += AI_AccMod_BriefAcquire * Pct;
        if (EnemyIdx >= 0 && IsEnemyVisibleByIndex(EnemyIdx))
        {
            Pct = FClamp(1.0 - (EnemyList[EnemyIdx].LastSeenTime - EnemyList[EnemyIdx].InitialSeenTime) / Response_MinEnemySeenTime, 0.0, 1.0);
            InaccuracyPct += AI_AccMod_BriefVisibility * Pct;
        }
        else
        {
            InaccuracyPct = 1.0;
        }
        if (IsShortRange(AimLoc))
        {
            InaccuracyPct += AI_AccMod_ShortRange;
        }
        else if (IsMediumRange(AimLoc))
        {
            InaccuracyPct += AI_AccMod_MediumRange;
        }
        else
        {
            InaccuracyPct += AI_AccMod_LongRange;
        }
        InaccuracyPct = FClamp(InaccuracyPct, 0.00999999978, 0.99000001);
        InaccuracyPct = InaccuracyPct ** (1.0 - AimInstability);
        InaccuracyPct = FClamp(InaccuracyPct, 0.0, 1.0);
        AccMinCone = Wpn.AI_AccCone_Min.Value;
        AccMaxCone = Wpn.AI_AccCone_Max.Value;
        AccRot.Pitch = int(GetRangeValueByPct(vect2d(AccMinCone, AccMaxCone), InaccuracyPct) * 182.044449);
        AccRot.Yaw = int(GetRangeValueByPct(vect2d(AccMinCone, AccMaxCone), InaccuracyPct) * 182.044449);
        AccRot.Pitch *= 0.5 - FRand();
        AccRot.Yaw *= 0.5 - FRand();
        AimRot = Rotator(AimLoc - StartFireLoc) + AccRot;
        return AimRot;
    }
    return Pawn.Rotation;
}
public function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
    local SFXWeapon Wpn;
    
    if (NewWeapon != PrevWeapon)
    {
        Wpn = SFXWeapon(NewWeapon);
        if (Wpn != None)
        {
            WeaponAimDelay = Wpn.GetAIAimDelay();
        }
    }
    Super(Controller).NotifyChangedWeapon(PrevWeapon, NewWeapon);
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
    local SFXAICommand Cmd;
    
    Super(BioAiController).NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    LastShotAtTime = WorldInfo.GameTimeSeconds;
    LastDamagedTime = WorldInfo.GameTimeSeconds;
    NotifyUnderAttack(TRUE);
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        Cmd.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    }
}
public function NotifyWeaponFinishedFiring(Weapon W, byte FireMode)
{
    local SFXAICommand Cmd;
    
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        Cmd.NotifyWeaponFinishedFiring(W, FireMode);
    }
}
public function NotifyWeaponFired(Weapon W, byte FireMode)
{
    Super(AIController).NotifyWeaponFired(W, FireMode);
    LastFireTime = WorldInfo.GameTimeSeconds;
    LastCombatActionTime = WorldInfo.GameTimeSeconds;
}
public function bool AcquireTicket(Actor oTarget, EAITicketType eTicket, optional int nAttackTicketCost = 1)
{
    local BioPawn oTargetPawn;
    local bool bAcquiredTicket;
    
    if (bUseTicketing)
    {
        if (oTarget == None)
        {
            return FALSE;
        }
        bAcquiredTicket = FALSE;
        oTargetPawn = BioPawn(oTarget);
        if (oTargetPawn != None)
        {
            switch (eTicket)
            {
                case EAITicketType.AI_TargetTicket:
                    bAcquiredTicket = oTargetPawn.AcquireTargetTicket(m_nTargetTicketCost);
                    break;
                case EAITicketType.AI_AttackTicket:
                    if (m_nCurrentAttackID != 0)
                    {
                        bAcquiredTicket = oTargetPawn.HasValidAttackTicket(m_nCurrentAttackID);
                    }
                    if (!bAcquiredTicket)
                    {
                        m_nCurrentAttackID = oTargetPawn.AcquireAttackTicket(nAttackTicketCost);
                        bAcquiredTicket = m_nCurrentAttackID > 0;
                    }
                    break;
                default:
                    break;
            }
            return bAcquiredTicket;
        }
        else
        {
            return TRUE;
        }
    }
    else
    {
        return TRUE;
    }
}
public function AdjustEnemyRating(Pawn EnemyPawn, out float fRating);

public function AdjustRatingByTickets(out float out_Rating, int EnemyIdx)
{
    local float fTicketAdjustmentFactor;
    local BioPawn oEnemyPawn;
    local int MaxTargetTickets;
    
    if (EnemyIdx < 0 || EnemyIdx >= EnemyList.Length)
    {
        return;
    }
    oEnemyPawn = BioPawn(EnemyList[EnemyIdx].Pawn);
    if (oEnemyPawn != None)
    {
        MaxTargetTickets = oEnemyPawn.GetMaxTargetTickets();
        fTicketAdjustmentFactor = float(MaxTargetTickets - oEnemyPawn.m_nTargetTickets);
        if (oEnemyPawn == FireTarget)
        {
            fTicketAdjustmentFactor += float(m_nTargetTicketCost);
        }
        fTicketAdjustmentFactor = MaxTargetTickets > 0 ? fTicketAdjustmentFactor / float(MaxTargetTickets) : 0.0;
        if (fTicketAdjustmentFactor <= float(0))
        {
            fTicketAdjustmentFactor = 0.00999999978;
        }
        out_Rating *= fTicketAdjustmentFactor;
    }
}
public function ApplyBasePathConstraints()
{
    if (!m_bAllowedToLeavePlaypen && m_nEnabledFlags == 0)
    {
        Class'SFXPath_WithinPlaypen'.static.WithinPlaypen(MyBP, IsReturningToPlaypen());
    }
}
public function AssignGoHereDelegates(delegate<TryInvalidateTargetRange> RangeDel, delegate<TryInvalidateTargetFlank> FlankDel)
{
    __TryInvalidateTargetRange__Delegate = RangeDel;
    __TryInvalidateTargetFlank__Delegate = FlankDel;
}
public final function BeginCombatCommand(Class<SFXAICommand_Base_Combat> CmdClass, optional coerce string Reason, optional bool bForced)
{
    local Class<SFXAICommand_Base_Combat> CurClass;
    local SFXAICommand_Base_Combat CurCommand;
    
    if (CommandList != None)
    {
        CurCommand = SFXAICommand_Base_Combat(CommandList);
        if (CurCommand != None)
        {
            CurClass = SFXAICommand_Base_Combat(CommandList).Class;
        }
    }
    if (!bForced)
    {
        if (CmdClass != None && !bAllowCombatTransitions)
        {
            return;
        }
        if (CurClass != None && CmdClass == CurClass)
        {
            return;
        }
        if (CommandList != None && !CommandList.AllowTransitionTo(CmdClass))
        {
            PendingCommand = CmdClass;
            return;
        }
    }
    PendingCommand = None;
    if (CmdClass != None && CmdClass != CurClass)
    {
        StopFiring();
    }
    if (CommandList != None)
    {
        AbortCommand(CommandList);
    }
    if (CmdClass != None)
    {
        CmdClass.static.InitCommand(Self);
    }
    else
    {
        GotoState('Idle', 'Begin', , );
    }
}
public final function BeginDefaultCommand(optional coerce string Reason, optional bool bForced)
{
    if (CombatMood == EAICombatMood.AI_Berserk && BerserkCommand != None)
    {
        BeginCombatCommand(BerserkCommand, Reason, bForced);
    }
    else if (CombatMood == EAICombatMood.AI_Aggressive && AggressiveCommand != None)
    {
        BeginCombatCommand(AggressiveCommand, Reason, bForced);
    }
    else if (CombatMood == EAICombatMood.AI_Fallback && FallbackCommand != None)
    {
        BeginCombatCommand(FallbackCommand, Reason, bForced);
    }
    else
    {
        BeginCombatCommand(DefaultCommand, Reason, bForced);
    }
}
public function CalculateGrenadeArc(float MinSpeed, float MaxSpeed, float MaxRange, out float InitialSpeed, out Vector InitialDirection)
{
    local Vector TargetLocation;
    local Vector VectToTarget;
    local float DistToTarget;
    local BioPawn EnemyTarget;
    local bool bAdjustForStandingPawn;
    local float TravelTime;
    local float InitialVerticalSpeed;
    local float Angle;
    
    if (FireTarget != None)
    {
        TargetLocation = GetAimLocation(FireTarget);
        bAdjustForStandingPawn = FALSE;
        EnemyTarget = BioPawn(FireTarget);
        if (EnemyTarget != None && !EnemyTarget.bIsCrouched)
        {
            bAdjustForStandingPawn = TRUE;
        }
        VectToTarget = TargetLocation - MyBP.location;
        DistToTarget = VSize(VectToTarget);
        InitialSpeed = Lerp(MinSpeed, MaxSpeed / 2.0, DistToTarget / MaxRange);
        if (bAdjustForStandingPawn)
        {
            TargetLocation.Z -= 50.0;
        }
        else
        {
            TargetLocation.Z -= 25.0;
        }
        if (SuggestTossVelocity(InitialDirection, TargetLocation, MyBP.location, InitialSpeed, 0.0, 0.200000003))
        {
            InitialSpeed = VSize(InitialDirection);
            InitialDirection = Normal(InitialDirection);
        }
        else if (Abs(VectToTarget.Z) < 100.0)
        {
            if (bAdjustForStandingPawn && DistToTarget > 100.0)
            {
                DistToTarget -= 100.0;
            }
            else if (DistToTarget > 50.0)
            {
                DistToTarget -= 50.0;
            }
            InitialDirection = VectToTarget;
            InitialDirection.Z = 0.0;
            InitialDirection = Normal(InitialDirection);
            InitialDirection.Z = 0.577000022;
            InitialDirection = Normal(InitialDirection);
            InitialSpeed = Sqrt(Abs(WorldInfo.GetGravityZ() * DistToTarget / 0.865999997));
            InitialSpeed = FClamp(InitialSpeed, MinSpeed, MaxSpeed);
        }
        else
        {
            DistToTarget = VSize2D(VectToTarget);
            if (VectToTarget.Z < 0.0)
            {
                if (bAdjustForStandingPawn && DistToTarget > 200.0)
                {
                    DistToTarget -= 200.0;
                }
                else if (DistToTarget > 100.0)
                {
                    DistToTarget -= 100.0;
                }
            }
            TravelTime = DistToTarget / InitialSpeed;
            InitialVerticalSpeed = VectToTarget.Z / TravelTime - 0.5 * GetGravityZ() * TravelTime;
            InitialDirection = VectToTarget;
            InitialDirection.Z = 0.0;
            Angle = Atan(InitialVerticalSpeed / InitialSpeed);
            InitialDirection = Normal(InitialDirection);
            InitialDirection.Z = Angle;
            InitialDirection = Normal(InitialDirection);
            InitialSpeed = Sqrt(Square(InitialSpeed) + Square(InitialVerticalSpeed));
            InitialSpeed = FClamp(InitialSpeed, MinSpeed, MaxSpeed);
        }
    }
}
public function CancelAction(optional int nReason)
{
    local SFXAICommand Cmd;
    local bool bCancel;
    
    bCancel = TRUE;
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        bCancel = Cmd.CancelCommand(nReason);
    }
    CurrentKismetOrder.eOrderType = KismetOrderType.KISMET_ORDER_NONE;
    if (bCancel)
    {
        m_bCancelAction = TRUE;
        if (nReason > 0)
        {
            m_nCancelReasons = m_nCancelReasons | nReason;
        }
    }
}
public function bool CanChoosePower(SFXPowerCustomAction oPower, Actor oTarget, optional bool bPlayerRequest)
{
    return oPower.CanUsePower(oTarget);
}
public function bool CanFireWeaponNoLOS(Weapon Wpn, byte FireModeNum)
{
    if (int(FireModeNum) == 4)
    {
        return TRUE;
    }
    if (MyBP != None && MyBP.CanFireWeapon() == FALSE)
    {
        return FALSE;
    }
    if (CurrentKismetOrder.eOrderType != KismetOrderType.KISMET_ORDER_FIRE_WEAPON || CurrentKismetOrder.bForceShoot == FALSE)
    {
        if (HasValidTarget() == FALSE)
        {
            return FALSE;
        }
    }
    if (IsReloading())
    {
        return FALSE;
    }
    return TRUE;
}
public function bool CanShootWeapon(Actor oTarget)
{
    return TRUE;
}
public function bool CanSwitchMood(EAICombatMood NewMood)
{
    if (NewMood == EAICombatMood.AI_NoMood)
    {
        return FALSE;
    }
    if (CombatMood == EAICombatMood.AI_Berserk)
    {
        return FALSE;
    }
    if (PreviousCombatMood != EAICombatMood.AI_NoMood)
    {
        return FALSE;
    }
    if (int(CombatMood) != int(NewMood))
    {
        if (NewMood == EAICombatMood.AI_Berserk)
        {
        }
        return TRUE;
    }
    return FALSE;
}
public final function bool CanTurretFireAt(Actor TestActor)
{
    local SFXVehicle_MountedGun V;
    
    V = SFXVehicle_MountedGun(Pawn);
    if (V != None && TestActor != None)
    {
        if (V.IsWithinRotationClamps(TestActor.location))
        {
            return CanFireAt(TestActor, V.location, TRUE);
        }
    }
    return FALSE;
}
public function CheckDownedPlayers()
{
    local PlayerController PC;
    local SFXDifficultyHandler DH;
    
    DH = SFXGRI(WorldInfo.GRI).DifficultyHandler;
    if (DH != None && MyBP.CanDoCustomAction(136))
    {
        foreach WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            if (Pawn != None && PC.Pawn != None && ShouldKillPlayer(PC.Pawn) && VSize(PC.Pawn.location - Pawn.location) < DH.DownedDistanceRange)
            {
                ExecutionTarget = PC.Pawn;
                BeginCombatCommand(Class'SFXAICmd_KillingBlow');
                break;
            }
        }
    }
}
public function CheckInterruptCombatTransitions()
{
    local Pawn NearbyPawn;
    local int EnemyIdx;
    
    NearbyPawn = None;
    if (HasNearbyEnemy(NearbyPawn))
    {
        TimeOfLastCombatEvent = WorldInfo.GameTimeSeconds;
        if (ReactToNearbyEnemy(NearbyPawn))
        {
            return;
        }
    }
    if (Pawn(FireTarget) != None && MyBP != None && MyBP.IsInCover() && IsFlankedByTarget(FireTarget))
    {
        EnemyIdx = GetEnemyIndex(Pawn(FireTarget));
        if (EnemyIdx != -1)
        {
            TimeOfLastCombatEvent = WorldInfo.GameTimeSeconds;
            if (ReactToFlank(Pawn(FireTarget)))
            {
                return;
            }
        }
    }
    if (CurrentKismetOrder.eOrderType != KismetOrderType.KISMET_ORDER_NONE)
    {
        BeginCombatCommand(Class'SFXAICmd_KismetOrder');
    }
    else if (IsCombatStale())
    {
        SetCombatMood(4);
    }
}
public function CheckPendingWeaponSwitch();

public final function CheckTimedCombatTransition()
{
    local SFXAICommand_Base_Combat CurCommand;
    
    CurCommand = SFXAICommand_Base_Combat(CommandList);
    if (CurCommand == None)
    {
        return;
    }
    SetTimer(CurCommand.GetTransitionCheckTime(), FALSE, 'CheckTimedCombatTransition', );
    if (IgnoreTimeTransitions())
    {
        return;
    }
    CheckInterruptCombatTransitions();
}
public function bool ChooseAttack(Actor oTarget, out Name nmPowerName)
{
    local SFXWeapon oWeapon;
    local int nRequiresAttackTicket;
    local Vector AttackOrigin;
    local ECoverAction AttackerCoverAction;
    local ECoverAction TargetCoverAction;
    
    nRequiresAttackTicket = 0;
    if (ChooseDefensivePower(nmPowerName))
    {
        return TRUE;
    }
    if (MyBP == None || oTarget == None)
    {
        return FALSE;
    }
    if (IsTargetInFiringArc(MyBP, oTarget, m_fFiringArcAngle) == FALSE)
    {
        return FALSE;
    }
    if (Vehicle(oTarget) != None)
    {
        if (VSize(oTarget.location - MyBP.location) > MyBP.SightRadius)
        {
            return FALSE;
        }
    }
    if (FRand() <= GetPowerUsePercent())
    {
        ChooseAttackPower(oTarget, nmPowerName, nRequiresAttackTicket, AttackOrigin);
    }
    if (nmPowerName == 'None')
    {
        oWeapon = SFXWeapon(MyBP.Weapon);
        if (oWeapon == None)
        {
            return FALSE;
        }
        if (CanShootWeapon(oTarget) == FALSE)
        {
            return FALSE;
        }
        if (ShouldReload() && RELOAD())
        {
            m_AttackResult = AttackResult.ATTACK_FAIL_RELOADING;
            return FALSE;
        }
        nRequiresAttackTicket = 1;
    }
    if (MyBP.IsInCover())
    {
        if (GetBestCoverAction(Cover, FireTarget, AttackerCoverAction, TargetCoverAction) == FALSE)
        {
            m_AttackResult = AttackResult.ATTACK_FAIL_NO_LOS;
            return FALSE;
        }
        PendingCoverAction = AttackerCoverAction;
        BestTargetCoverAction = TargetCoverAction;
    }
    if (nRequiresAttackTicket > 0)
    {
        if (AcquireTicket(oTarget, 2) == FALSE)
        {
            m_bFailedTicket = TRUE;
            if (nmPowerName != 'None')
            {
                ClearPowerReservation(nmPowerName);
            }
            return FALSE;
        }
    }
    if (m_bCheckLOS && CanAttack(oTarget) == FALSE)
    {
        ReleaseTicket(oTarget, 2);
        m_AttackResult = AttackResult.ATTACK_FAIL_NO_LOS;
        if (nmPowerName != 'None')
        {
            ClearPowerReservation(nmPowerName);
        }
        return FALSE;
    }
    return TRUE;
}
public function bool ChooseAttackPower(Actor oTarget, out Name nmPower, out int nRequiresAttackTicket, out Vector AttackOrigin, optional bool bPlayerRequest)
{
    local int nIndex;
    local SFXPowerCustomAction oPower;
    local array<SFXPowerCustomAction> Powers;
    local Vector ProjectileOrigin;
    local int nNewIndex;
    local bool bAdded;
    
    if (MyBP == None || MyBP.PowerManager == None || oTarget == None)
    {
        return FALSE;
    }
    for (nIndex = 0; nIndex < MyBP.PowerManager.Powers.Length; nIndex++)
    {
        oPower = SFXPowerCustomAction(MyBP.PowerManager.Powers[nIndex]);
        if (oPower != None)
        {
            if (oPower.AISelectable || bIsAutoBot)
            {
                if (oPower.PowerType == EPowerType.PowerType_Instant || oPower.PowerType == EPowerType.PowerType_Projectile || oPower.PowerType == EPowerType.PowerType_Melee)
                {
                    if (CanChoosePower(oPower, oTarget, bPlayerRequest))
                    {
                        if (oPower.PowerType == EPowerType.PowerType_Melee)
                        {
                            Powers.Length = 0;
                            Powers.AddItem(oPower);
                            break;
                            continue;
                        }
                        for (nNewIndex = 0; nNewIndex < Powers.Length; nNewIndex++)
                        {
                            if (oPower.Rank > Powers[nNewIndex].Rank)
                            {
                                Powers.InsertItem(nNewIndex, oPower);
                                bAdded = TRUE;
                                break;
                            }
                        }
                        if (!bAdded)
                        {
                            Powers.AddItem(oPower);
                        }
                        bAdded = FALSE;
                    }
                }
            }
        }
    }
    if (Powers.Length == 0)
    {
        return FALSE;
    }
    if (Powers.Length == 1)
    {
        oPower = Powers[0];
    }
    else if (FRand() <= 0.5)
    {
        oPower = Powers[0];
    }
    else
    {
        oPower = Powers[Rand(Powers.Length)];
    }
    if (oPower.MaximumRange.CurrentValue >= 1000.0)
    {
        nRequiresAttackTicket = 1;
    }
    if (RequestPowerReservation(oPower.PowerName) == FALSE)
    {
        return FALSE;
    }
    if (oPower.PowerType == EPowerType.PowerType_Projectile)
    {
        if (oPower.GetProjectileAttachPoint(ProjectileOrigin))
        {
            AttackOrigin = ProjectileOrigin;
        }
    }
    if (IsZero(AttackOrigin))
    {
        AttackOrigin = MyBP.GetPawnViewLocation();
    }
    nmPower = oPower.PowerName;
    return TRUE;
}
public function bool ChooseDefensivePower(out Name nmPower)
{
    local int nIndex;
    local SFXPowerCustomAction oPower;
    local array<SFXPowerCustomAction> Powers;
    
    if (MyBP == None || MyBP.PowerManager == None)
    {
        return FALSE;
    }
    for (nIndex = 0; nIndex < MyBP.PowerManager.Powers.Length; nIndex++)
    {
        oPower = SFXPowerCustomAction(MyBP.PowerManager.Powers[nIndex]);
        if (oPower != None)
        {
            if (oPower.AISelectable)
            {
                if (oPower.PowerType == EPowerType.PowerType_Buff)
                {
                    if (CanChoosePower(oPower, None))
                    {
                        Powers.AddItem(oPower);
                    }
                }
            }
        }
    }
    if (Powers.Length == 0)
    {
        return FALSE;
    }
    if (Powers.Length == 1)
    {
        oPower = Powers[0];
    }
    else
    {
        oPower = Powers[Rand(Powers.Length)];
    }
    if (RequestPowerReservation(oPower.PowerName) == FALSE)
    {
        return FALSE;
    }
    nmPower = oPower.PowerName;
    return TRUE;
}
public final function CleanUpStaleAI()
{
    local Vehicle Turret;
    local SFXModule_Damage DamageMod;
    
    if (WorldInfo.GameTimeSeconds - LastSuccessfulPathTime < 3.0 || LastSuccessfulPathTime > LastFailedPathTime)
    {
        bStuck = FALSE;
    }
    if (bStuck)
    {
        if (WorldInfo.GameTimeSeconds - LastCombatActionTime > StuckTimeout && WorldInfo.TimeSeconds - Pawn.LastRenderTime > StuckTimeout && GetMinDistanceToAnyPlayer() > 1000.0)
        {
            Turret = Vehicle(Pawn);
            if (Turret != None)
            {
                Turret.DriverLeave(TRUE);
            }
            DamageMod = Pawn.GetModule(Class'SFXModule_Damage');
            if (DamageMod == None || DamageMod.KillForStasis(TRUE, Pawn.LastHitBy, Class'SFXDamageType_Suicide') == FALSE)
            {
                Pawn.Destroy();
                Destroy();
            }
        }
        else
        {
            SetTimer(5.0, FALSE, 'CleanUpStaleAI', );
        }
    }
}
public function ClearCancelAction()
{
    m_bCancelAction = FALSE;
    m_nCancelReasons = 0;
}
public function ClearGoHereDelegates()
{
    __TryInvalidateTargetRange__Delegate = None;
    __TryInvalidateTargetFlank__Delegate = None;
}
public function ClearPowerReservation(Name nmPower, optional bool bSkipProjectilePowers = FALSE)
{
    if (!m_bUsePowerReservations)
    {
        return;
    }
    if (m_nReservationID == 0)
    {
        return;
    }
    if (MyBP == None)
    {
        return;
    }
}
public function DoMeleeAttack()
{
    LastCombatActionTime = WorldInfo.GameTimeSeconds;
    MyBP.StartCustomAction(133);
}
public function DrawDifficulty(BioCheatManager CM);

public function DrawLocationMarker(Vector vLocation, optional float fSize = 10.0, optional int nRed = 255, optional int nGreen = 0, optional int nBlue = 0)
{
    local Vector vStart;
    local Vector vEnd;
    
    if (MyBP == None)
    {
        return;
    }
    vStart = vLocation;
    vStart.X -= fSize;
    vEnd = vLocation;
    vEnd.X += fSize;
    MyBP.DrawDebugLine(vStart, vEnd, byte(nRed), byte(nGreen), byte(nBlue), TRUE);
    vStart = vLocation;
    vStart.Z -= fSize;
    vEnd = vLocation;
    vEnd.Z += fSize;
    MyBP.DrawDebugLine(vStart, vEnd, byte(nRed), byte(nGreen), byte(nBlue), TRUE);
}
public function float FindClosestApproachDistance(Actor oActor)
{
    local Goal_AtActor oAtGoalEval;
    local Actor FirstMoveTarget;
    
    if (MyBP == None || oActor == None)
    {
        return 0.0;
    }
    if (m_oLastApproachTarget == oActor && WorldInfo.GameTimeSeconds - m_fLastApproachCheckTime < 5.0)
    {
        return m_fLastApproachDistance;
    }
    m_oLastApproachTarget = oActor;
    m_fLastApproachDistance = 0.0;
    if (!IsActorInPlaypen(oActor))
    {
        m_fLastApproachCheckTime = WorldInfo.GameTimeSeconds;
        if (Class'Goal_AtActor'.static.AtActor(MyBP, oActor, MoveOffset, TRUE))
        {
            oAtGoalEval = Goal_AtActor(MyBP.PathGoalList);
            m_oGoalActor = oAtGoalEval.GoalActor;
            Class'Path_TowardGoal'.static.TowardGoal(MyBP, oActor);
            ApplyBasePathConstraints();
            FirstMoveTarget = FindPathToward(oActor, FALSE, , );
            if (FirstMoveTarget != None)
            {
                if (RouteGoal != m_oGoalActor)
                {
                    m_fLastApproachDistance = VSize(RouteGoal.location - oActor.location);
                }
            }
            RouteCache_Empty();
        }
    }
    return m_fLastApproachDistance;
}
public function FindDrivablePawn()
{
    local SFXPawn MyPawn;
    local SFXPawn P;
    local SFXVehicle_MountedGun TestVehicle;
    
    MyPawn = SFXPawn(MyBP);
    if (MyPawn != None)
    {
        if (MyPawn.bCanDriveAtlas)
        {
            foreach WorldInfo.AllPawns(Class'SFXPawn', P)
            {
                if (P != MyPawn && P.CanBeDrivenBy(MyPawn))
                {
                    P.TryToDriveMe(MyPawn);
                    return;
                }
            }
        }
        if (MyPawn.bCanUseTurrets)
        {
            foreach WorldInfo.AllPawns(Class'SFXVehicle_MountedGun', TestVehicle)
            {
                if (TestVehicle != None && TestVehicle.CanBeDrivenBy(MyPawn))
                {
                    TestVehicle.AITryToDriveMe(MyPawn);
                }
            }
        }
    }
}
public function NavigationPoint FindSuppressionPoint(Actor Target, EAICombatRange Range, optional float MinDistance, optional float MaxDistance)
{
    local BioPawn PawnTarget;
    local float SuppressionRange;
    local bool bFlank;
    local NavigationPoint SuppressionPoint;
    
    if (Target != None)
    {
        PawnTarget = BioPawn(Target);
        SuppressionRange = GetCombatRange(Range);
        bFlank = FALSE;
        if (PawnTarget != None)
        {
            bFlank = PawnTarget.IsInCover() || PawnTarget.CoverAction == ECoverAction.CA_Aimback;
        }
        if (Class'SFXGoal_SuppressionPoint'.static.SuppressPoint(MyBP, Target, SuppressionRange, bFlank, MinDistance))
        {
            ApplyBasePathConstraints();
            if (MaxDistance > 0.0)
            {
                Class'Path_WithinDistanceEnvelope'.static.StayWithinEnvelopeToLoc(MyBP, MyBP.location, MaxDistance, 0.0, FALSE, -1.0, FALSE);
            }
            if (FindPathToward(Target, , , ) != None)
            {
                SuppressionPoint = NavigationPoint(RouteGoal);
                RouteCache_Empty();
                LastSuccessfulPathTime = WorldInfo.GameTimeSeconds;
            }
            else
            {
                LastFailedPathTime = WorldInfo.GameTimeSeconds;
            }
        }
    }
    return SuppressionPoint;
}
public function FireWeaponAtTarget(Actor oTarget, bool bCheckLOS, bool bForceShoot, float fAttackDuration, optional delegate<FireWeaponDelegate> FireDelegate)
{
    local SFXAICommand Cmd;
    local bool bHandledByCommand;
    
    bHandledByCommand = FALSE;
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        bHandledByCommand = Cmd.FireWeaponAtTarget(oTarget, bCheckLOS, bForceShoot, fAttackDuration, FireDelegate);
    }
    if (!bHandledByCommand)
    {
        if (CurrentKismetOrder.eOrderType == KismetOrderType.KISMET_ORDER_NONE)
        {
            m_bCheckLOS = bCheckLOS;
            CurrentKismetOrder.bForceShoot = bForceShoot;
            CurrentKismetOrder.fAttackDuration = fAttackDuration;
            CurrentKismetOrder.FireCallback = FireDelegate;
            CurrentKismetOrder.eOrderType = KismetOrderType.KISMET_ORDER_FIRE_WEAPON;
            CurrentKismetOrder.oTargetActor = oTarget;
        }
        else if (FireDelegate != None)
        {
            FireDelegate(2);
        }
    }
}
public delegate function FireWeaponDelegate(int nReason);

public function bool GetAttackOrigin(Actor oTarget, out Vector AttackOrigin)
{
    if (Pawn.Weapon != None)
    {
        AttackOrigin = Pawn.Weapon.GetPhysicalFireStartLoc();
    }
    else
    {
        AttackOrigin = Pawn.GetPawnViewLocation();
    }
    return TRUE;
}
public final function bool GetBestCoverAction(CoverInfo ChkCover, Actor ChkTarget, out ECoverAction AttackerCoverAction, out ECoverAction TargetCoverAction)
{
    local BioPawn PawnTarget;
    local CoverInfo ChkTargetCover;
    local int nIndex;
    local ECoverType Type;
    local int nFireLinkIdx;
    local array<int> FireLinkIndices;
    local CoverSlot Slot;
    local array<FireLinkItem> FireLinkItems;
    local FireLinkItem TempFireLinkItem;
    
    if (MyBP == None)
    {
        return FALSE;
    }
    if (ChkCover.Link == None || ChkCover.SlotIdx < 0)
    {
        return FALSE;
    }
    if (ChkTarget == None)
    {
        ChkTarget = FireTarget != None ? FireTarget : Enemy;
    }
    if (ChkTarget == None)
    {
        return FALSE;
    }
    PawnTarget = BioPawn(ChkTarget);
    if (ChkCover.Link == Cover.Link && ChkCover.SlotIdx == Cover.SlotIdx)
    {
        Type = MyBP.FindCoverType();
    }
    else
    {
        Type = ChkCover.Link.Slots[ChkCover.SlotIdx].CoverType;
    }
    if (PawnTarget != None && GetPawnCover(PawnTarget, ChkTargetCover) && PawnTarget.IsInCover())
    {
        if (ChkCover.Link.GetFireLinkTo(ChkCover.SlotIdx, ChkTargetCover, 0, 0, nFireLinkIdx, FireLinkIndices))
        {
            Slot = ChkCover.Link.Slots[ChkCover.SlotIdx];
            for (nIndex = 0; nIndex < FireLinkIndices.Length; nIndex++)
            {
                ChkCover.Link.UnPackFireLinkInteractionInfo(Slot.FireLinks[nFireLinkIdx].Interactions[FireLinkIndices[nIndex]], TempFireLinkItem.SrcType, TempFireLinkItem.SrcAction, TempFireLinkItem.DestType, TempFireLinkItem.DestAction);
                FireLinkItems[FireLinkItems.Length] = TempFireLinkItem;
            }
        }
    }
    if (FireLinkItems.Length == 0)
    {
        if (ChkCover.Link.Slots[ChkCover.SlotIdx].bLeanLeft && CanFireAt(ChkTarget, ChkCover.Link.GetSlotViewPoint(ChkCover.SlotIdx, Type, 3), TRUE))
        {
            FireLinkItems.Add(1);
            FireLinkItems[FireLinkItems.Length - 1].SrcAction = ECoverAction.CA_LeanLeft;
            FireLinkItems[FireLinkItems.Length - 1].DestAction = ECoverAction.CA_Default;
        }
        if (ChkCover.Link.Slots[ChkCover.SlotIdx].bLeanRight && CanFireAt(ChkTarget, ChkCover.Link.GetSlotViewPoint(ChkCover.SlotIdx, Type, 4), TRUE))
        {
            FireLinkItems.Add(1);
            FireLinkItems[FireLinkItems.Length - 1].SrcAction = ECoverAction.CA_LeanRight;
            FireLinkItems[FireLinkItems.Length - 1].DestAction = ECoverAction.CA_Default;
        }
        if (ChkCover.Link.Slots[ChkCover.SlotIdx].CoverType != ECoverType.CT_Standing && ChkCover.Link.Slots[ChkCover.SlotIdx].bCanPopUp && CanFireAt(ChkTarget, ChkCover.Link.GetSlotViewPoint(ChkCover.SlotIdx, Type, 5), TRUE))
        {
            FireLinkItems.Add(1);
            FireLinkItems[FireLinkItems.Length - 1].SrcAction = ECoverAction.CA_PopUp;
            FireLinkItems[FireLinkItems.Length - 1].DestAction = ECoverAction.CA_Default;
        }
    }
    if (FireLinkItems.Length > 0)
    {
        if (FireLinkItems.Length > 1)
        {
            nIndex = Rand(FireLinkItems.Length);
            AttackerCoverAction = FireLinkItems[nIndex].SrcAction;
            TargetCoverAction = FireLinkItems[nIndex].DestAction;
        }
        else
        {
            AttackerCoverAction = FireLinkItems[0].SrcAction;
            TargetCoverAction = FireLinkItems[0].DestAction;
        }
        if (ShouldPartialLean())
        {
            switch (AttackerCoverAction)
            {
                case ECoverAction.CA_PopUp:
                    AttackerCoverAction = ECoverAction.CA_BlindUp;
                    break;
                case ECoverAction.CA_LeanLeft:
                    AttackerCoverAction = ECoverAction.CA_BlindLeft;
                    break;
                case ECoverAction.CA_LeanRight:
                    AttackerCoverAction = ECoverAction.CA_BlindRight;
                    break;
                default:
            }
        }
        return TRUE;
    }
    return FALSE;
}
public final function EAICustomAction GetBestEvadeDir(Vector DangerPoint, optional Projectile Prj, optional Pawn Shooter)
{
    local Vector X;
    local Vector Y;
    local Vector Z;
    local Vector VectToDanger;
    local Vector VectToProj;
    local bool bLeftOpen;
    local bool bRightOpen;
    local bool bFrontOpen;
    local bool bBackOpen;
    local array<EAICustomAction> Actions;
    local float DotX;
    local float DotY;
    local float DistLeftSq;
    local float DistRightSq;
    local float CheckHeight;
    local Vector ProjectedLoc;
    local Vector Offset;
    local Actor EvadeToward;
    
    GetAxes(Pawn.Rotation, X, Y, Z);
    CheckHeight = Pawn.GetCollisionHeight() * 0.5 + Pawn.MaxStepHeight;
    Offset = Y * 350.0;
    bRightOpen = MyBP.CanDoCustomAction(55) && FastTrace(Pawn.location + Offset, Pawn.location, , ) && !FastTrace(Pawn.location + Offset + vect(0.0, 0.0, -1.0) * CheckHeight, Pawn.location + Offset, Pawn.GetCollisionExtent() * 0.5, );
    bLeftOpen = MyBP.CanDoCustomAction(54) && FastTrace(Pawn.location - Offset, Pawn.location, , ) && !FastTrace(Pawn.location - Offset + vect(0.0, 0.0, -1.0) * CheckHeight, Pawn.location - Offset, Pawn.GetCollisionExtent() * 0.5, );
    if (Prj != None)
    {
        Offset = X * 350.0;
        bFrontOpen = MyBP.CanDoCustomAction(56) && !MyBP.IsInCover() && FastTrace(Pawn.location + Offset, Pawn.location, , ) && !FastTrace(Pawn.location + Offset + vect(0.0, 0.0, -1.0) * CheckHeight, Pawn.location + Offset, Pawn.GetCollisionExtent() * 0.5, );
        bBackOpen = MyBP.CanDoCustomAction(57) && FastTrace(Pawn.location - Offset, Pawn.location, , ) && !FastTrace(Pawn.location - Offset + vect(0.0, 0.0, -1.0) * CheckHeight, Pawn.location - Offset, Pawn.GetCollisionExtent() * 0.5, );
        VectToProj = Normal(Prj.location - Pawn.location);
        if (Prj.Velocity.Z > Prj.Velocity.X && Prj.Velocity.Z > Prj.Velocity.Y)
        {
            if (bFrontOpen)
            {
                Actions.AddItem(56);
            }
            if (bRightOpen)
            {
                Actions.AddItem(55);
            }
            if (bLeftOpen)
            {
                Actions.AddItem(54);
            }
            if (bBackOpen)
            {
                Actions.AddItem(57);
            }
            if (Actions.Length > 0)
            {
                return Actions[Rand(Actions.Length)];
            }
            return EAICustomAction.CA_None;
        }
        if (bFrontOpen && VectToProj Dot X < 0.707000017)
        {
            Actions.AddItem(56);
        }
        if (bBackOpen && VectToProj Dot X > -0.707000017)
        {
            Actions.AddItem(57);
        }
        if (bRightOpen && VectToProj Dot Y < 0.707000017)
        {
            Actions.AddItem(55);
        }
        if (bLeftOpen && VectToProj Dot Y > -0.707000017)
        {
            Actions.AddItem(54);
        }
        if (Actions.Length > 0)
        {
            return Actions[Rand(Actions.Length)];
        }
        return EAICustomAction.CA_None;
    }
    else if (Shooter != None)
    {
        if (bRightOpen && !bLeftOpen)
        {
            return EAICustomAction.CA_RollRight;
        }
        else if (!bRightOpen && bLeftOpen)
        {
            return EAICustomAction.CA_RollLeft;
        }
        else if (bRightOpen && bLeftOpen)
        {
            EvadeToward = MoveGoal;
            if (RouteCache.Length > 0 && RouteCache[0] != None)
            {
                EvadeToward = RouteCache[0];
            }
            if (EvadeToward != None)
            {
                ProjectedLoc = Pawn.location + Offset;
                DistRightSq = VSizeSq2D(ProjectedLoc - EvadeToward.location);
                ProjectedLoc = Pawn.location - Offset;
                DistLeftSq = VSizeSq2D(ProjectedLoc - EvadeToward.location);
                if (DistRightSq < DistLeftSq)
                {
                    return EAICustomAction.CA_RollRight;
                }
                else
                {
                    return EAICustomAction.CA_RollLeft;
                }
            }
            else if (Vector(Shooter.Rotation) Dot Y > 0.0)
            {
                return EAICustomAction.CA_RollLeft;
            }
            else
            {
                return EAICustomAction.CA_RollLeft;
            }
        }
    }
    else
    {
        Offset = X * 350.0;
        bFrontOpen = MyBP.CanDoCustomAction(56) && !MyBP.IsInCover() && FastTrace(Pawn.location + Offset, Pawn.location, , ) && !FastTrace(Pawn.location + Offset + vect(0.0, 0.0, -1.0) * CheckHeight, Pawn.location + Offset, Pawn.GetCollisionExtent() * 0.5, );
        bBackOpen = MyBP.CanDoCustomAction(57) && FastTrace(Pawn.location - Offset, Pawn.location, , ) && !FastTrace(Pawn.location - Offset + vect(0.0, 0.0, -1.0) * CheckHeight, Pawn.location - Offset, Pawn.GetCollisionExtent() * 0.5, );
        VectToDanger = Normal(DangerPoint - Pawn.location);
        DotX = X Dot VectToDanger;
        DotY = Y Dot VectToDanger;
        if (DotX >= 0.707099974 || DotX <= -0.707099974)
        {
            if (bBackOpen && DotX >= 0.707099974)
            {
                return EAICustomAction.CA_RollBackward;
            }
            else if (bFrontOpen && DotX <= -0.707099974)
            {
                return EAICustomAction.CA_RollForward;
            }
            else if (bRightOpen && (DotY < 0.0 || DotY >= 0.0 && !bLeftOpen))
            {
                return EAICustomAction.CA_RollRight;
            }
            else if (bLeftOpen && (DotY >= 0.0 || DotY < 0.0 && !bRightOpen))
            {
                return EAICustomAction.CA_RollLeft;
            }
        }
        else if (bLeftOpen && DotY >= 0.707099974)
        {
            return EAICustomAction.CA_RollLeft;
        }
        else if (bRightOpen && DotY <= -0.707099974)
        {
            return EAICustomAction.CA_RollRight;
        }
        else if (bFrontOpen && (DotX < 0.0 || DotX >= 0.0 && !bBackOpen))
        {
            return EAICustomAction.CA_RollForward;
        }
        else if (bBackOpen && (DotX >= 0.0 || DotX < 0.0 && !bFrontOpen))
        {
            return EAICustomAction.CA_RollBackward;
        }
    }
    return EAICustomAction.CA_None;
}
public function ECoverAction GetBestTargetCoverAction(BioPawn TargetPawn, CoverInfo TargetCover)
{
    if (TargetPawn == None || TargetCover.Link == None)
    {
        return 0;
    }
    if (TargetPawn.CoverAction != ECoverAction.CA_Default && TargetPawn.CoverAction < ECoverAction.CA_PeekLeft)
    {
        BestTargetCoverAction = TargetPawn.CoverAction;
        return TargetPawn.CoverAction;
    }
    if (IsTargetInFiringArc(TargetPawn, MyBP, 0.699999988))
    {
        if (BestTargetCoverAction != ECoverAction.CA_Default)
        {
            return BestTargetCoverAction;
        }
        if (TargetCover.Link.Slots[TargetCover.SlotIdx].bLeanLeft)
        {
            BestTargetCoverAction = ECoverAction.CA_LeanLeft;
            return 3;
        }
        if (TargetCover.Link.Slots[TargetCover.SlotIdx].bLeanRight)
        {
            BestTargetCoverAction = ECoverAction.CA_LeanRight;
            return 4;
        }
        if (TargetCover.Link.Slots[TargetCover.SlotIdx].CoverType != ECoverType.CT_Standing && TargetCover.Link.Slots[TargetCover.SlotIdx].bCanPopUp)
        {
            BestTargetCoverAction = ECoverAction.CA_PopUp;
            return 5;
        }
    }
    return 0;
}
public function KismetOrderType GetCurrentKismetOrder()
{
    return CurrentKismetOrder.eOrderType;
}
public final function float GetMinDistanceToAnyPlayer()
{
    local PlayerController PC;
    local float MinRange;
    local float CurRange;
    
    MinRange = -1.0;
    if (Pawn == None)
    {
        return -1.0;
    }
    foreach WorldInfo.AllControllers(Class'PlayerController', PC)
    {
        if (PC != None && PC.ViewTarget != None)
        {
            CurRange = VSizeSq(PC.ViewTarget.location - Pawn.location);
            if (CurRange < MinRange || MinRange < 0.0)
            {
                MinRange = CurRange;
            }
        }
    }
    return Sqrt(MinRange);
}
public function float GetMoveFireDelayTime()
{
    return RandRange(MoveFireDelayTime.X, MoveFireDelayTime.Y);
}
public function float GetPeriodicMoveInterval()
{
    return 0.25;
}
public function float GetPowerUsePercent()
{
    return MyBP.m_fPowerUsePercent;
}
public function bool HasNearbyEnemy(out Pawn NearbyPawn)
{
    return HasEnemyWithinDistance(m_fNearbyEnemyDistance, NearbyPawn, TRUE);
}
public function bool IgnoreTimeTransitions()
{
    local SFXAICommand Cmd;
    
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None && !Cmd.CanInterruptCurrentCommand())
    {
        return TRUE;
    }
    if (MyBP == None || MyBP.IsDead())
    {
        return TRUE;
    }
    if (MyBP.CurrentCustomAction != 0)
    {
        return TRUE;
    }
    return FALSE;
}
public final function InitialCheckTimedCombatTransition()
{
    CheckTimedCombatTransition();
}
public final event function bool IsAtCover()
{
    return bReachedCover;
}
public function bool IsCombatStale()
{
    local SFXAI_NativeBase C;
    local BioPawn TargetPawn;
    local int NumAggressiveAllies;
    
    TargetPawn = BioPawn(FireTarget);
    if (CombatMood == EAICombatMood.AI_Fallback || CombatMood == EAICombatMood.AI_Aggressive)
    {
        return FALSE;
    }
    else if (WorldInfo.GameTimeSeconds - TimeOfLastCombatEvent < TimeUntilAggressive)
    {
        return FALSE;
    }
    else if (IsInWeaponRange(FireTarget) == FALSE)
    {
        return FALSE;
    }
    else if (TargetPawn == None || TargetPawn.GetHealthPct() <= 0.600000024)
    {
        return FALSE;
    }
    NumAggressiveAllies = 0;
    foreach WorldInfo.AllControllers(Class'SFXAI_NativeBase', C)
    {
        if (C != Self && C.Pawn != None && C.Pawn.IsDead() == FALSE && C.IsFriendly(Self))
        {
            if (C.CombatMood == EAICombatMood.AI_Aggressive)
            {
                NumAggressiveAllies++;
                if (NumAggressiveAllies >= MaxNumAggressive)
                {
                    return FALSE;
                }
            }
        }
    }
    return TRUE;
}
public final function bool IsFireLineObstructed()
{
    if (CurrentKismetOrder.eOrderType != KismetOrderType.KISMET_ORDER_FIRE_WEAPON || CurrentKismetOrder.bForceShoot == FALSE)
    {
        if (IsFriendlyBlockingFireLine())
        {
            return TRUE;
        }
        if (m_bCheckLOS && CanAttack(FireTarget) == FALSE)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool IsFiringWeapon()
{
    local SFXWeapon Weap;
    
    if (Pawn != None)
    {
        Weap = SFXWeapon(Pawn.Weapon);
        if (Weap != None)
        {
            return Weap.IsFiring();
        }
    }
    return FALSE;
}
public function bool IsFlankedByTarget(Actor oTarget, optional bool bUseExactLocation)
{
    local Vector vPawnRotation;
    local Vector vTargetLocation;
    local Vector vVectToTarget;
    local int EnemyIndex;
    local float fDot;
    
    if (MyBP == None || oTarget == None)
    {
        return FALSE;
    }
    vPawnRotation = Vector(MyBP.Rotation);
    EnemyIndex = GetEnemyIndex(Pawn(oTarget));
    if (!bUseExactLocation && EnemyIndex >= 0)
    {
        vTargetLocation = GetEnemyLocationByIndex(EnemyIndex);
    }
    else
    {
        vTargetLocation = oTarget.location;
    }
    vVectToTarget = Normal(vTargetLocation - MyBP.location);
    fDot = vVectToTarget Dot vPawnRotation;
    if (fDot <= 0.5)
    {
        return TRUE;
    }
    return FALSE;
}
public final function bool IsFriendlyBlockingFireLine()
{
    local BioAiController C;
    local Vector FireLine;
    local Vector FireStart;
    local Vector VectToFriendly;
    local float FireLineWidth;
    local float DistFromLine;
    
    if (Pawn == None)
    {
        return FALSE;
    }
    if (FireTarget == None)
    {
        FireTarget = Enemy;
    }
    if (FireTarget == None)
    {
        return FALSE;
    }
    FireStart = Pawn.GetWeaponStartTraceLocation();
    FireLine = Normal(FireTarget.location - FireStart);
    FireLineWidth = 48.0;
    foreach WorldInfo.AllControllers(Class'BioAiController', C)
    {
        if (C != Self && C.Pawn != None && C.Pawn.IsDead() == FALSE && C.IsFriendly(Self) && C.Pawn.Base != MyBP)
        {
            VectToFriendly = Normal(C.Pawn.location - FireStart);
            if (VectToFriendly Dot FireLine > 0.0)
            {
                DistFromLine = FMin(PointDistToLine(C.Pawn.GetPawnViewLocation(), FireLine, FireStart), PointDistToLine(C.Pawn.location, FireLine, FireStart));
                if (DistFromLine < FireLineWidth && VSize(C.Pawn.location - Pawn.location) < VSize(FireTarget.location - Pawn.location))
                {
                    return TRUE;
                }
            }
        }
    }
    return FALSE;
}
public function bool IsInFightingState();

public function bool IsInWeaponRange(Actor oTarget)
{
    local float fDistance;
    local float fWeaponRange;
    
    if (MyBP == None || oTarget == None)
    {
        return FALSE;
    }
    fDistance = VSize(oTarget.location - MyBP.location);
    fWeaponRange = MyBP.GetWeaponRange(4);
    if (fDistance > fWeaponRange)
    {
        return FALSE;
    }
    return TRUE;
}
public final function bool IsTargetStealthed()
{
    local Pawn EnemyPawn;
    local bool bStealthed;
    
    bStealthed = FALSE;
    EnemyPawn = Pawn(FireTarget);
    if (EnemyPawn != None)
    {
        bStealthed = EnemyPawn.IsInvisible();
    }
    return bStealthed;
}
public delegate function MoveToDelegate(int nReason);

public function MoveToGoalExternal(Actor NewMoveGoal, optional float NewMoveOffset, optional bool bImmediateMove, optional bool bForceWalk, optional delegate<MoveToDelegate> MoveDelegate)
{
    local SFXAICommand Cmd;
    local bool bHandledByCommand;
    
    bHandledByCommand = FALSE;
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None && bImmediateMove)
    {
        bHandledByCommand = Cmd.MoveToGoalExternal(NewMoveGoal, NewMoveOffset, bForceWalk, MoveDelegate);
    }
    if (!bHandledByCommand)
    {
        if (bImmediateMove)
        {
            if (CurrentKismetOrder.eOrderType == KismetOrderType.KISMET_ORDER_NONE)
            {
                CurrentKismetOrder.MoveCallback = MoveDelegate;
                CurrentKismetOrder.eOrderType = KismetOrderType.KISMET_ORDER_MOVE;
                CurrentKismetOrder.fDistOffset = NewMoveOffset;
                CurrentKismetOrder.bWalk = bForceWalk;
                CurrentKismetOrder.oTargetActor = NewMoveGoal;
            }
            else if (MoveDelegate != None)
            {
                MoveDelegate(2);
            }
        }
        else
        {
            PreferredAnchor = NewMoveGoal;
            AnchorDistance = NewMoveOffset;
            if (MoveDelegate != None)
            {
                MoveDelegate(1);
            }
        }
    }
}
public function NotifyAiming(Actor AimTarget, bool bAiming);

public function NotifyArmourDestroyed(Name ArmourPiece, Controller instigatedBy)
{
    local SFXAICommand Cmd;
    
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        Cmd.NotifyArmourDestroyed(ArmourPiece, instigatedBy);
    }
}
public function NotifyArmourHit(float Damage, Name ArmourPiece, Controller instigatedBy, Vector HitLocation, Vector Momentum, optional Class<DamageType> DamageType, optional Actor DamageCauser)
{
    local SFXAICommand Cmd;
    
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        Cmd.NotifyArmourHit(Damage, ArmourPiece, instigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    }
}
public function NotifyCombatZoneAdded();

public function NotifyCombatZoneRemoved();

public function NotifyDeathBlow(Class<DamageType> DamageType)
{
    if (SFXPawn(DriveTarget) != None)
    {
        SFXPawn(DriveTarget).DriverDied();
    }
    ReleaseTicket(FireTarget, 1);
    ReleaseTicket(FireTarget, 2, TRUE);
    FireTarget = None;
    bDying = TRUE;
    MyBP.InterruptCustomAction();
    AbortCommand(CommandList);
    Class'SFXAICmd_Fallen'.static.InitCommand(Self);
}
public function NotifyFriendDied(BioPawn FriendPawn)
{
    local SFXAICommand Cmd;
    
    TimeOfLastCombatEvent = WorldInfo.GameTimeSeconds;
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        Cmd.NotifyFriendDied(FriendPawn);
    }
}
public function NotifyKnockedOutOfCover();

public function bool NotifyMoodChange()
{
    local SFXAICommand Cmd;
    
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        return Cmd.NotifyMoodChange();
    }
    return FALSE;
}
public function NotifyNearMiss(Vector HitLocation)
{
    local SFXAICommand Cmd;
    
    Super(BioAiController).NotifyNearMiss(HitLocation);
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        Cmd.NotifyNearMiss(HitLocation);
    }
    LastShotAtTime = WorldInfo.GameTimeSeconds;
    NotifyUnderAttack(FALSE);
}
public function NotifyPendingPowerImpact(Name Label, float TimeBeforeImpact, SFXPowerCustomAction Power, SFXProjectile_PowerCustomAction Projectile)
{
    local SFXAICommand Cmd;
    
    TimeOfLastCombatEvent = WorldInfo.GameTimeSeconds;
    LastCombatActionTime = WorldInfo.GameTimeSeconds;
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        Cmd.NotifyPendingPowerImpact(Label, TimeBeforeImpact, Power, Projectile);
    }
}
public function NotifyPlaypenChanged();

public function NotifyStuck()
{
    if (!IsTimerActive('CleanUpStaleAI'))
    {
        SetTimer(5.0, FALSE, 'CleanUpStaleAI', );
    }
    bStuck = TRUE;
}
public function NotifyUnderAttack(bool bHit)
{
    TimeOfLastCombatEvent = WorldInfo.GameTimeSeconds;
    LastCombatActionTime = WorldInfo.GameTimeSeconds;
}
public function NotifyWeaponDelayFinished()
{
    m_bDelayWeaponUse = FALSE;
}
public final function OnPossessTurret(SFXSeqAct_PossessTurret Action)
{
    if (Action != None && Action.MountedGun != None)
    {
        if (Action.MountedGun.MountingPoint != None)
        {
            Pawn.SetLocation(Action.MountedGun.MountingPoint.location, );
        }
        else
        {
            Pawn.SetLocation(Action.MountedGun.location, );
        }
        Action.MountedGun.AITryToDriveMe(Pawn);
    }
}
public function OnTargetChanged()
{
    CancelAction(8);
}
public function PeriodicMoveCheck()
{
    local SFXAICommand SFXCommandList;
    
    SetMovementSpeed();
    if (m_bFollowingActor)
    {
        if (m_ActorToFollow != None)
        {
            if (DirectWalkCheck(m_ActorToFollow.location, m_ActorToFollow))
            {
                MoveGoal = None;
            }
        }
    }
    SFXCommandList = SFXAICommand(CommandList);
    if (SFXCommandList != None)
    {
        SFXCommandList.PeriodicMoveCheck();
    }
}
public function PlayAmbientVoc()
{
    SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(40, MyBP, None, 0.0, , TRUE);
}
public function PrecisionMove(Vector vLocation, Rotator rRotation)
{
    if (MyBP.VerifyCAHasBeenInstanced(16))
    {
        SFXCustomAction_PrecisionMove(MyBP.CustomActions[16]).SetDestination(vLocation, rRotation, 0.5);
        MyBP.StartCustomAction(16);
    }
}
public function PushPawn(BioPawn oPawn, Vector HitNormal)
{
    if (WorldInfo.GameTimeSeconds - m_fLastPushTime < 0.5 && m_oPushingPawn == oPawn)
    {
        if (MoveTarget != None && MoveTimer > 0.0)
        {
            if (VSizeSq(MyBP.Velocity) < 400.0 && Normal(MoveTarget.location - MyBP.location) Dot HitNormal < 0.5)
            {
                MoveTimer -= MoveTimerPenalty;
            }
        }
    }
    m_oPushingPawn = oPawn;
    m_vPushDirection = HitNormal;
    m_fLastPushTime = WorldInfo.GameTimeSeconds;
}
public function bool ReactToFlank(Pawn FlankingPawn);

public function bool ReactToNearbyEnemy(Pawn NearbyPawn);

public function ReleaseTicket(Actor oTarget, EAITicketType eTicket, optional bool bKillAttackTicket = FALSE)
{
    local BioPawn oTargetPawn;
    
    if (bUseTicketing)
    {
        oTargetPawn = BioPawn(oTarget);
        if (oTargetPawn != None)
        {
            switch (eTicket)
            {
                case EAITicketType.AI_TargetTicket:
                    oTargetPawn.ReleaseTargetTicket(m_nTargetTicketCost);
                    break;
                case EAITicketType.AI_AttackTicket:
                    if (m_nCurrentAttackID > 0)
                    {
                        oTargetPawn.ReleaseAttackTicket(m_nCurrentAttackID, bKillAttackTicket);
                        if (bKillAttackTicket)
                        {
                            m_nCurrentAttackID = 0;
                        }
                    }
                    break;
                case EAITicketType.AI_NoTicket:
                    break;
                default:
            }
        }
    }
}
public function bool RequestPowerReservation(Name nmPower, optional bool bForceSuccess = FALSE)
{
    local SFXPowerCustomActionBase oPower;
    local BioWorldInfo oWorldInfo;
    
    if (!m_bUsePowerReservations)
    {
        return TRUE;
    }
    if (MyBP == None || MyBP.PowerManager == None)
    {
        return FALSE;
    }
    oPower = MyBP.PowerManager.GetPower(nmPower);
    if (oPower == None)
    {
        return FALSE;
    }
    oWorldInfo = BioWorldInfo(WorldInfo);
    if (oWorldInfo == None || oWorldInfo.m_oPowerManager == None)
    {
        return FALSE;
    }
    m_nReservationID = oWorldInfo.m_oPowerManager.MakeReservation(oPower, MyBP, bForceSuccess);
    if (m_nReservationID == 0)
    {
        return FALSE;
    }
    return TRUE;
}
public function ResetAimInstability()
{
    AimInstability = 1.0;
    LastInstabilityTime = WorldInfo.GameTimeSeconds;
}
public function ResetCombatMood()
{
    local EAICombatMood OldMood;
    
    OldMood = PreviousCombatMood;
    PreviousCombatMood = EAICombatMood.AI_NoMood;
    SetCombatMood(OldMood);
}
public function ResetEvadeDamage()
{
    EvadeDamageTaken = 0.0;
}
public function bool RespondToBump(Actor Other, Vector HitNormal);

public function bool RespondToPush()
{
    if (WorldInfo.GameTimeSeconds - m_fLastPushTime < 0.300000012 && !MyBP.IsInCover())
    {
        MovePoint = MyBP.location + m_vPushDirection * -300.0;
        MovePoint.Z = MyBP.location.Z;
        MoveOffset = 0.0;
        MoveTimer = 3.0;
        Class'SFXAICmd_MoveToLocation'.static.MoveToLocation(Self, MovePoint, 0.0);
        return TRUE;
    }
    return FALSE;
}
public function bool SelectTarget()
{
    local Actor OldTarget;
    local int idx;
    local int BestIdx;
    local float Rating;
    local float BestRating;
    local float Distance;
    local Pawn EnemyPawn;
    local CoverInfo EnemyCover;
    local bool bResult;
    local Pawn ForcedEnemy;
    
    if (HasValidTarget() && WorldInfo.GameTimeSeconds - TargetAcquisitionTime < 0.100000001)
    {
        return TRUE;
    }
    OldTarget = FireTarget;
    ForcedEnemy = Pawn(ForcedTarget);
    if (ForcedEnemy != None && ForcedEnemy.IsValidTargetFor(Self) && ForcedEnemy.IsInvisible() == FALSE)
    {
        Enemy = ForcedEnemy;
    }
    else
    {
        BestIdx = -1;
        BestRating = -1.0;
        for (idx = 0; idx < EnemyList.Length; idx++)
        {
            EnemyPawn = EnemyList[idx].Pawn;
            if (EnemyPawn == None || EnemyPawn.IsValidTargetFor(Self) == FALSE)
            {
                continue;
            }
            if (EnemyPawn.IsInState('Downed', ))
            {
                continue;
            }
            if (IgnoredTargets.Find(EnemyPawn) >= 0)
            {
                continue;
            }
            if (BioPawn(EnemyPawn) != None && BioPawn(EnemyPawn).Squad != None && IgnoredSquads.Find(BioPawn(EnemyPawn).Squad) >= 0)
            {
                continue;
            }
            if (SFXPawn(EnemyPawn) != None && SFXPawn(EnemyPawn).bIgnoreTarget)
            {
                continue;
            }
            Distance = VSize(GetEnemyLocationByIndex(idx) - Pawn.location);
            if (Distance < EnemyDistance_Melee)
            {
                Rating = GetRangeValueByPct(vect2d(8.0, 4.0), Distance / EnemyDistance_Melee);
            }
            else if (Distance < EnemyDistance_Short)
            {
                Rating = GetRangeValueByPct(vect2d(4.0, 2.0), (Distance - EnemyDistance_Melee) / (EnemyDistance_Short - EnemyDistance_Melee));
            }
            else if (Distance < EnemyDistance_Medium)
            {
                Rating = GetRangeValueByPct(vect2d(2.0, 1.0), (Distance - EnemyDistance_Short) / (EnemyDistance_Medium - EnemyDistance_Short));
            }
            else if (Distance < EnemyDistance_Long)
            {
                Rating = GetRangeValueByPct(vect2d(1.0, 0.5), (Distance - EnemyDistance_Long) / (EnemyDistance_Long - EnemyDistance_Medium));
            }
            else
            {
                Rating = 1000.0 / Distance;
            }
            if (EnemyPawn.IsInvisible())
            {
                Rating *= 0.00999999978;
            }
            if (SFXPawn(EnemyPawn).bIsPet && SFXPawn(Pawn).bIgnoresPets)
            {
                Rating *= 0.00999999978;
            }
            if (EnemyPawn == OldTarget)
            {
                if (m_bFailedTicket)
                {
                    Rating *= 0.600000024;
                    m_bFailedTicket = FALSE;
                }
                else
                {
                    Rating *= 1.5;
                }
            }
            if (EnemyPawn == PreferredTarget)
            {
                Rating *= 1.89999998;
            }
            if (EnemyPawn.IsHumanControlled() || EnemyPawn.DrivenVehicle != None && EnemyPawn.DrivenVehicle.IsHumanControlled())
            {
                Rating *= m_fPlayerTargetWeightBonus;
            }
            if (Pawn.LastHitBy == EnemyPawn.Controller && (Enemy == None || Enemy.Controller == None || Enemy.Controller != Self))
            {
                Rating *= 1.25;
            }
            if (Pawn.LastHitBy != None)
            {
            }
            if (Distance > EnemyDistance_Short && EnemyPawn != PreferredTarget)
            {
                if (IsEnemyVisibleByIndex(idx) == FALSE)
                {
                    if (TimeSinceEnemyVisible(idx) < 5.0)
                    {
                        Rating *= 0.5;
                    }
                    else
                    {
                        Rating *= 0.100000001;
                    }
                }
            }
            if (GetPawnCover(EnemyPawn, EnemyCover) == FALSE)
            {
                Rating *= 1.5;
            }
            if (Distance > EnemyDistance_Short)
            {
                AdjustRatingByTickets(Rating, idx);
            }
            AdjustEnemyRating(EnemyPawn, Rating);
            if (Rating >= 0.0 && (BestRating < 0.0 || Rating > BestRating))
            {
                BestIdx = idx;
                BestRating = Rating;
            }
        }
        if (BestIdx >= 0 && BestIdx < EnemyList.Length)
        {
            Enemy = EnemyList[BestIdx].Pawn;
        }
        else
        {
            Enemy = None;
        }
    }
    bResult = HasValidEnemy();
    if (bResult)
    {
        if (OldTarget != None && ForcedEnemy != Enemy && PreferredTarget != Enemy && IsEnemyVisibleByIndex(BestIdx) == FALSE)
        {
            idx = GetEnemyIndex(Pawn(OldTarget));
            if (idx != -1 && IsEnemyVisibleByIndex(idx) && HasValidTarget(OldTarget))
            {
                if (TimeSinceEnemyVisible(BestIdx) > 3.0 && TimeSinceHurtByEnemy(BestIdx) > 3.0)
                {
                    Enemy = Pawn(OldTarget);
                }
            }
        }
        FireTarget = Enemy;
        ValidateFireTargetLocation();
    }
    else
    {
        FireTarget = None;
    }
    if (OldTarget != FireTarget)
    {
        TargetAcquisitionTime = WorldInfo.GameTimeSeconds;
        ReleaseTicket(OldTarget, 2, TRUE);
        ReleaseTicket(OldTarget, 1);
        AcquireTicket(FireTarget, 1);
        TriggerAttackVocalization();
        OnTargetChanged();
        if (PreferredTarget != None && FireTarget != PreferredTarget && Pawn(PreferredTarget) != None && Pawn(PreferredTarget).IsDead() == FALSE)
        {
        }
    }
    ShotTarget = Pawn(FireTarget);
    return bResult;
}
public function bool SetCombatMood(EAICombatMood NewMood, optional float fDuration)
{
    if (CanSwitchMood(NewMood))
    {
        if (fDuration > 0.0)
        {
            PreviousCombatMood = CombatMood;
            SetTimer(fDuration, FALSE, 'ResetCombatMood', );
        }
        CombatMood = NewMood;
        if (PreviousCombatMood == EAICombatMood.AI_Unaware)
        {
            bUnaware = FALSE;
        }
        switch (CombatMood)
        {
            case EAICombatMood.AI_Unaware:
                bUnaware = TRUE;
                break;
            case EAICombatMood.AI_Fallback:
                break;
            case EAICombatMood.AI_Normal:
                break;
            case EAICombatMood.AI_Aggressive:
                break;
            case EAICombatMood.AI_Berserk:
                break;
            default:
                break;
        }
        if (NotifyMoodChange() == FALSE)
        {
            BeginDefaultCommand();
        }
        return TRUE;
    }
    return FALSE;
}
public function bool SetMoveGoal(Actor NewMoveGoal, optional float NewMoveOffset)
{
    if (NewMoveGoal == None)
    {
        return FALSE;
    }
    MoveGoal = NewMoveGoal;
    MoveOffset = NewMoveOffset;
    return TRUE;
}
public function SetMovementSpeed()
{
    local float fDistance;
    local Vector vMove;
    
    if (MyBP == None)
    {
        return;
    }
    if (MoveGoal != None)
    {
        fDistance = VSize(MoveGoal.location - MyBP.location);
    }
    else
    {
        fDistance = VSize(MovePoint - MyBP.location);
    }
    if (WantsToRun(fDistance))
    {
        if (MyBP.bIsWalking)
        {
            MyBP.SetWalking(FALSE);
        }
    }
    else if (MoveGoal == None || MoveTarget == MoveGoal)
    {
        if (MyBP.bIsWalking == FALSE)
        {
            MyBP.SetWalking(TRUE);
            if (MoveTarget != None)
            {
                vMove = MoveTarget.location - MyBP.location;
                SetMoveTimer(vMove);
            }
        }
    }
    MyBP.SetDesiredSpeed(1.0);
}
public function SetSquadIntoCombat()
{
    if (MyBP == None || MyBP.Squad == None)
    {
        return;
    }
    SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(1, MyBP, , , , TRUE);
}
public function bool ShootWeaponAtFireTarget(optional float DmgThreshold, optional bool bForceShoot)
{
    local int nEnemyIndex;
    
    nEnemyIndex = GetEnemyIndex(Pawn(FireTarget));
    if (nEnemyIndex >= 0)
    {
        if (IsEnemyVisibleByIndex(nEnemyIndex))
        {
            Focus = FireTarget;
        }
        else
        {
            Focus = None;
            SetFocalPoint(GetEnemyLocationByIndex(nEnemyIndex, 1));
        }
    }
    else
    {
        Focus = FireTarget;
    }
    return Class'SFXAICmd_FireWeapon'.static.FireWeapon(Self, DmgThreshold, bForceShoot);
}
public function bool ShouldCancelMove(int nReason)
{
    return TRUE;
}
public function bool ShouldKillPlayer(Pawn PartyPawn)
{
    if (SFXPawn_PlayerParty(PartyPawn) == None)
    {
        return FALSE;
    }
    return SFXPawn_PlayerParty(PartyPawn).IsReadyForExecution(SFXPawn(Pawn));
}
public function bool ShouldMelee(Actor MeleeTarget)
{
    local SFXPawn PawnTarget;
    
    PawnTarget = SFXPawn(MeleeTarget);
    if (PawnTarget != None && !PawnTarget.bCanBeMeleed)
    {
        return FALSE;
    }
    if (MyBP.CurrentCustomAction == 0 && MyBP.CanDoCustomAction(133) && WorldInfo.GameTimeSeconds - LastMeleeTime >= MeleeAttackInterval)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool ShouldPartialLean()
{
    local SFXPawn ChkPawn;
    
    ChkPawn = SFXPawn(MyBP);
    if (ChkPawn == None || ChkPawn.bCanPartialLean == FALSE || PartialLeanPct <= 0.0)
    {
        return FALSE;
    }
    if (FRand() <= PartialLeanPct)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool ShouldPowerEvade()
{
    return FRand() < PowerEvadeChance && (MyBP.HasAnyShieldResistance() == FALSE || !MyBP.IsInCover());
}
public function bool ShouldReload()
{
    local SFXWeapon Weapon;
    local float fMagazineSize;
    local float fRemaining;
    
    if (MyBP == None)
    {
        return FALSE;
    }
    Weapon = SFXWeapon(MyBP.Weapon);
    if (Weapon == None)
    {
        return FALSE;
    }
    if (Weapon.CanReload() == FALSE)
    {
        return FALSE;
    }
    fMagazineSize = float(Weapon.GetMagazineSize());
    if (fMagazineSize > float(0))
    {
        fRemaining = fMagazineSize - float(Weapon.AmmoUsedCount);
        if (fRemaining < fMagazineSize * m_fReloadThreshold)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool ShouldStayLeanedOut()
{
    return FALSE;
}
public function bool ShouldSyncMelee(Actor MeleeTarget)
{
    local SFXPawn PawnTarget;
    
    PawnTarget = SFXPawn(MeleeTarget);
    if (PawnTarget == None || PawnTarget.bCanBeMeleed == FALSE || PawnTarget.CurrentCustomAction == 57 || PawnTarget.CurrentCustomAction == 56 || PawnTarget.CurrentCustomAction == 54 || PawnTarget.CurrentCustomAction == 55 || PawnTarget.CurrentCustomAction == 44 || PawnTarget.CurrentCustomAction == 45 || PawnTarget.CurrentCustomAction == 31 || PawnTarget.CurrentCustomAction == 33 || PawnTarget.CurrentCustomAction == 34 || PawnTarget.CurrentCustomAction == 46 || PawnTarget.CurrentCustomAction == 47)
    {
        return FALSE;
    }
    if (MyBP.CurrentCustomAction == 0 && MyBP.CanDoCustomAction(135, Pawn(MeleeTarget)) && WorldInfo.GameTimeSeconds - LastSyncMeleeTime >= SyncMeleeAttackInterval && WorldInfo.GameTimeSeconds - PawnTarget.GetAbilityTimeStamp(SyncMeleeAbilityName) >= SyncMeleeAttackInterval)
    {
        return TRUE;
    }
    return FALSE;
}
public function StartFiring(optional int InBurstsToFire = -1)
{
    bFire = 1;
    if (InBurstsToFire > 0 || AI_BurstsToFire.X == 0.0 && AI_BurstsToFire.Y == 0.0)
    {
        DesiredBurstsToFire = InBurstsToFire;
    }
    else
    {
        DesiredBurstsToFire = int(AI_BurstsToFire.X + float(Rand(int(AI_BurstsToFire.Y - AI_BurstsToFire.X) + 1)));
    }
}
public function bool StartFollowingActor(Actor ActorToFollow)
{
    local SFXAICommand Cmd;
    
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        return Cmd.StartFollowingActor(ActorToFollow);
    }
    return FALSE;
}
public function StopFollowingActor()
{
    if (m_bFollowingActor)
    {
        CancelAction(4);
    }
    m_RequestedActorToFollow = None;
}
public function float TargetRange()
{
    if (FireTarget != None && MyBP != None)
    {
        return VSizeSq(FireTarget.location - MyBP.location);
    }
    return 999999.0;
}
public function Taunt()
{
    if (FireTarget != None)
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(39, MyBP, BioPawn(FireTarget), 0.0, , TRUE);
    }
}
public function bool TeleportToActor(Actor oActor, optional bool bForceTeleport = FALSE, optional bool bOffsetTeleport = TRUE)
{
    local Vector vDestination;
    local Vector vNearestOpenLocation;
    
    if (MyBP == None || oActor == None)
    {
        return FALSE;
    }
    if (MyBP.GetTimeSinceLastRender() > 0.5 || bForceTeleport)
    {
        if (bOffsetTeleport)
        {
            vDestination = oActor.location - Vector(oActor.Rotation) * 400.0;
        }
        else
        {
            vDestination = oActor.location;
        }
        if (FindNearestOpenLocation(vDestination, vNearestOpenLocation, Pawn(oActor)))
        {
            MyBP.SafeSetLocation(vNearestOpenLocation);
            return TRUE;
        }
    }
    return FALSE;
}
public function TriggerAttackVocalization()
{
    if (BioPawn(FireTarget) != None && MyBP != None)
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(13, MyBP, BioPawn(FireTarget), , , TRUE);
    }
}
public delegate function bool TryInvalidateTargetFlank();

public delegate function bool TryInvalidateTargetRange(float fRangeToTarget);

public function UpdateAccuracy()
{
    local float DeltaTime;
    
    DeltaTime = WorldInfo.GameTimeSeconds - LastInstabilityTime;
    LastInstabilityTime = WorldInfo.GameTimeSeconds;
    if (MyBP != None && FireTarget != None)
    {
        AimInstability *= AI_Acc_InstabilityDecayRate ** DeltaTime;
        if ((FireTarget.location - MyBP.location) Dot Vector(MyBP.Rotation) < 0.899999976)
        {
            AimInstability = 1.0;
        }
        AimInstability = FClamp(AimInstability, 0.0, 1.0);
    }
}
public function UpdateMovementFocus()
{
    local int nEnemyIdx;
    
    if (MyBP.bCanStrafe && HasValidTarget())
    {
        nEnemyIdx = GetEnemyIndex(Pawn(FireTarget));
        if (nEnemyIdx >= 0)
        {
            if (TimeSinceEnemyLocationUpdate(nEnemyIdx) >= 4.0)
            {
                Focus = None;
                SetFocalPoint(GetFireTargetLocation(0));
            }
            else if (!IsEnemyVisibleByIndex(nEnemyIdx))
            {
                Focus = None;
                SetFocalPoint(GetFireTargetLocation(1));
            }
            else
            {
                Focus = FireTarget;
            }
        }
        else
        {
            Focus = FireTarget;
        }
    }
    else
    {
        Focus = MoveTarget;
    }
}
public delegate function UsePowerDelegate(int nReason);

public function UsePowerOnTarget(Name nmPowerToUse, Actor oTarget, optional delegate<UsePowerDelegate> PowerDelegate, optional bool bIgnoreSuppression)
{
    local SFXAICommand Cmd;
    local bool bHandledByCommand;
    
    bHandledByCommand = FALSE;
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        bHandledByCommand = Cmd.UsePowerOnTarget(nmPowerToUse, oTarget, PowerDelegate, bIgnoreSuppression);
    }
    if (!bHandledByCommand)
    {
        if (PowerDelegate != None)
        {
            PowerDelegate(2);
        }
    }
}
public function bool WantsToRun(float fDistance)
{
    return bKismetForcedWalk == FALSE && (MyBP.bCanWalk == FALSE || fDistance > m_fRunThreshold);
}

auto state Idle extends DebugState 
{
    public function TriggerCombatIdle()
    {
        local float Dist;
        local SFXNav_InteractionPoint Nav;
        
        if (!HasAnyEnemies())
        {
            if (MyBP != None && WorldInfo != None)
            {
                if (MyBP.Anchor == None)
                {
                    MyBP.SetAnchor(MyBP.GetBestAnchor(MyBP, MyBP.location, FALSE, TRUE, Dist));
                }
                if (CombatIdleNode != None)
                {
                    if (CombatIdleNode.StartInteraction(MyBP))
                    {
                        MyBP.SetAnchor(CombatIdleNode);
                    }
                    CombatIdleNode = None;
                }
                else
                {
                    foreach WorldInfo.RadiusNavigationPoints(Class'SFXNav_InteractionPoint', Nav, MyBP.location, 100.0)
                    {
                        if (Nav.StartInteraction(MyBP))
                        {
                            MyBP.SetAnchor(Nav);
                            break;
                        }
                    }
                }
            }
        }
    }
    public function NotifyNewEnemy(Pawn NewEnemy, bool bPerceivedDirectly, bool bFirstEnemy)
    {
        local SFXAICommand Cmd;
        
        Global.NotifyNewEnemy(NewEnemy, bPerceivedDirectly, bFirstEnemy);
        TimeOfLastCombatEvent = WorldInfo.GameTimeSeconds;
        Cmd = SFXAICommand(CommandList);
        if (Cmd != None)
        {
            Cmd.NotifyNewEnemy(NewEnemy);
            return;
        }
        if (!bNotifiedNewEnemySoundPlayed)
        {
            MyBP.PlayNewEnemySound();
            bNotifiedNewEnemySoundPlayed = TRUE;
        }
        if (MyBP != None && MyBP.IsDead() == FALSE)
        {
            if (m_RequestedActorToFollow != None)
            {
                m_ActorToFollow = m_RequestedActorToFollow;
                Class'SFXAICmd_FollowActor'.static.InitCommand(Self);
            }
            if (IsActorInPlaypen(MyBP) == FALSE)
            {
                BeginCombatCommand(Class'SFXAICmd_ReturnToPlaypen', "Outside of playpen");
            }
            else
            {
                BeginDefaultCommand();
            }
        }
    }
    
Begin:
    if (m_bInitiallyDisabled)
    {
        m_bInitiallyDisabled = FALSE;
        BeginCombatCommand(Class'SFXAICmd_Disabled');
    }
    if (m_bFirstIdle)
    {
        Sleep(0.0500000007);
        m_bFirstIdle = FALSE;
    }
    TriggerCombatIdle();
    if (m_RequestedActorToFollow != None)
    {
        m_ActorToFollow = m_RequestedActorToFollow;
        Class'SFXAICmd_FollowActor'.static.InitCommand(Self);
    }
    if (IsActorInPlaypen(MyBP) == FALSE)
    {
        BeginCombatCommand(Class'SFXAICmd_ReturnToPlaypen', "Outside of playpen");
    }
    else
    {
        while (TRUE)
        {
            if (MyBP != None && MyBP.IsDead() == FALSE)
            {
                if (HasAnyEnemies())
                {
                    if (DefaultCommand != None)
                    {
                        TimeOfLastCombatEvent = WorldInfo.GameTimeSeconds;
                        BeginDefaultCommand();
                    }
                }
            }
            if (CurrentKismetOrder.eOrderType != KismetOrderType.KISMET_ORDER_NONE)
            {
                BeginCombatCommand(Class'SFXAICmd_KismetOrder');
            }
            Sleep(1.0);
        }
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MoveFireDelayTime = {X = 1.0, Y = 3.0}
    m_fNearbyEnemyDistance = 300.0
    MeleeMoveOffset = 50.0
    CoverLeanAimOffset = 35.0
    CoverAimOffset = 45.0
    AI_Acc_InstabilityDecayRate = 0.5
    AI_Acc_Base = 0.00999999978
    AI_Acc_Target = 0.00999999978
    AI_AccMod_Move = 0.100000001
    AI_AccMod_TargMove = 0.150000006
    AI_AccMod_BriefAcquire = 0.25
    AI_AccMod_BriefVisibility = 0.150000006
    AI_AccMod_ShortRange = -0.150000006
    AI_AccMod_MediumRange = -0.0500000007
    m_fFiringArcAngle = 0.5
    m_fReloadThreshold = 0.25
    StuckTimeout = 20.0
    m_fRunThreshold = 150.0
    TimeUntilAggressive = 40.0
    MaxNumAggressive = 2
    m_nTargetTicketCost = 1
    m_fPlayerTargetWeightBonus = 1.5
    bUseTicketing = TRUE
    bAllowCombatTransitions = TRUE
    m_bCheckLOS = TRUE
    m_bClearVelocityAfterMove = TRUE
    m_bUsePowerReservations = TRUE
    m_bAvoidFireFromPlayerOnly = TRUE
    m_bFirstIdle = TRUE
    InUseNodeCostMultiplier = 10.0
}