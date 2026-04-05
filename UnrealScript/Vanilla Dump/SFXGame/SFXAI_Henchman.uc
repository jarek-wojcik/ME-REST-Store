Class SFXAI_Henchman extends SFXAI_Cover
    placeable
    config(AI);

struct HenchmanOrder 
{
    var Vector vTargetLocation;
    var Name nmPower;
    var Actor oTargetActor;
    var SFXWeapon oWeapon;
    var bool bInstantOrder;
    var bool bExecutingOrder;
    var bool bPowerUseIsInstant;
    var HenchmanOrderType eOrderType;
};
enum HenchmanOrderType
{
    HENCHMAN_ORDER_NONE,
    HENCHMAN_ORDER_USE_POWER,
    HENCHMAN_ORDER_SWITCH_WEAPON,
    HENCHMAN_ORDER_ATTACK_TARGET,
    HENCHMAN_ORDER_FOLLOW,
    HENCHMAN_ORDER_HOLD_POSITION,
};

var transient array<HenchmanOrder> m_Orders;
var delegate<ReachedInteractionPoint> __ReachedInteractionPoint__Delegate;
var delegate<StoppedWorldInteraction> __StoppedWorldInteraction__Delegate;
var transient Class<SFXAICommand> CurrentCommand;
var transient Vector m_vHoldLocation;
var transient int FindCoverNearHoldLocationCount;
var transient int MaxAttemptsToFindCoverNearHoldLocation;
var transient int m_nTeleportAttemptCounter;
var transient float TetherDistance;
var transient float TetherDistanceWhileExecutingOrder;
var transient float TetherDistanceForFollowOrder;
var transient float DistanceToStartCombatWhileFollowing;
var transient float AttackDelayAfterBeingShot;
var transient float DamagePercentToRemainInCover;
var transient SFXAI_Henchman m_OtherHenchman;
var transient float m_fHeadshotProbability;
var transient float MinDistanceFromTargetForCrouch;
var transient int m_nCoverEvaluationCount;
var transient int m_nBackingAwayCount;
var transient float MaxBackAwayDistance;
var config float HenchmanAttackBonus;
var config float HenchmanDefenseBonus;
var config float HenchmanAttackDuration;
var config float HenchmanDefenseDuration;
var transient bool m_bFollowPlayer;
var transient bool m_bHoldingPosition;
var transient bool m_bResetHenchman;
var transient bool m_bTeleportHenchman;
var transient bool m_bDelayPowerUse;
var transient bool m_bTooFarToAttack;
var transient bool m_bMeleeAttacker;
var transient bool m_bEnemiesPerceived;
var transient bool m_bOriginalStartRootMotion;
var transient bool m_bOriginalStopRootMotion;
var config bool m_bAllowInstantPowerWhileVisible;
var transient bool bUsingInstantPower;
var transient bool m_bBackingAwayFromTarget;
var transient bool PreventSquadPowerUse;

public event function BioClearCrossLevelReferences(Level oLevel)
{
    local int nIndex;
    
    for (nIndex = 0; nIndex < m_Orders.Length; nIndex++)
    {
        if (m_Orders[nIndex].oTargetActor != None && IsActorInLevel(m_Orders[nIndex].oTargetActor, oLevel))
        {
            m_Orders[nIndex].oTargetActor = None;
        }
    }
}
public function Vector GetAimLocation(optional Actor oAimTarget)
{
    local BioPawn oEnemyPawn;
    local Vector vHeadLocation;
    
    if (SFXWeapon(Pawn.Weapon).IsZoomed())
    {
        if (FRand() <= m_fHeadshotProbability)
        {
            if (oAimTarget == None)
            {
                oAimTarget = FireTarget;
            }
            oEnemyPawn = BioPawn(oAimTarget);
            if (oEnemyPawn != None)
            {
                if (oEnemyPawn.GetAimNodeLocation(1, vHeadLocation, FALSE))
                {
                    return vHeadLocation;
                }
            }
        }
    }
    return Super(SFXAI_Core).GetAimLocation(oAimTarget);
}
public function Initialize()
{
    Super(SFXAI_Core).Initialize();
    EvadeHealthThreshold = 100.0;
    EvadeFrequency = 5.0;
    EvadeResetDuration = 2.0;
    PartialLeanPct = 0.5;
    CancelFirePct = 0.349999994;
    MeleeAttackInterval = 2.0;
}
public function bool IsInCombat(optional bool bForceCheck)
{
    if (MyBP == None)
    {
        return FALSE;
    }
    return MyBP.InCombat();
}
public function NotifyNewEnemy(Pawn NewEnemy, bool bPerceivedDirectly, bool bFirstEnemy)
{
    NotifyNewEnemyBase(NewEnemy, bPerceivedDirectly, bFirstEnemy);
    m_bEnemiesPerceived = TRUE;
}
public function Reset()
{
    Super(SFXAI_Core).Reset();
    m_Orders.Length = 0;
    m_bFollowPlayer = FALSE;
    m_vHoldLocation = vect(0.0, 0.0, 0.0);
    m_bHoldingPosition = FALSE;
    FindCoverNearHoldLocationCount = 0;
    m_nTeleportAttemptCounter = 0;
    m_bDelayPowerUse = FALSE;
    m_bTooFarToAttack = FALSE;
    m_bMeleeAttacker = FALSE;
    m_bEnemiesPerceived = FALSE;
    m_bOriginalStartRootMotion = FALSE;
    m_bOriginalStopRootMotion = FALSE;
    bUsingInstantPower = FALSE;
    m_nCoverEvaluationCount = 0;
    m_bBackingAwayFromTarget = FALSE;
    m_nBackingAwayCount = 0;
    CurrentCommand = None;
}
public event function ResetToIdle(optional bool bTeleport = FALSE)
{
    m_bResetHenchman = TRUE;
    m_bTeleportHenchman = bTeleport;
    if (MyBP != None)
    {
        MyBP.Velocity.X = 0.0;
        MyBP.Velocity.Y = 0.0;
        MyBP.Velocity.Z = 0.0;
        MyBP.m_fGravityScaling = 0.0;
    }
    if (CommandList != None)
    {
        AbortCommand(CommandList);
    }
}
public function StopInteraction()
{
    local SFXAICmd_Disabled Cmd;
    
    if (m_nEnabledFlags != 0)
    {
        Cmd = SFXAICmd_Disabled(CommandList);
        if (Cmd != None)
        {
            Cmd.CancelCommand(2);
        }
        else
        {
            EnableAI(TRUE, 32);
        }
    }
}
public function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
    Super(SFXAI_Core).NotifyChangedWeapon(PreviousWeapon, NewWeapon);
    if (PreviousWeapon != None)
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(20, BioPawn(Pawn), , , , TRUE);
    }
}
public simulated function bool NotifyCoverClaimViolation(Controller NewClaim, CoverLink Link, int SlotIdx)
{
    m_bInvalidatedCover = TRUE;
    MoveTarget = None;
    bReachedMoveGoal = FALSE;
    return TRUE;
}
public function bool AddOrder(HenchmanOrderType eOrder, Actor oTargetActor, Vector vTargetLocation, Name nmPower, SFXWeapon oWeapon, optional int nQueue)
{
    local int nIndex;
    local bool bInstantOrder;
    local int nCurrentIndex;
    local int nQueuePosition;
    
    if (MyBP == None || MyBP.IsDead())
    {
        return FALSE;
    }
    if (m_RequestedActorToFollow != None)
    {
        if (eOrder == HenchmanOrderType.HENCHMAN_ORDER_FOLLOW || eOrder == HenchmanOrderType.HENCHMAN_ORDER_HOLD_POSITION)
        {
            return FALSE;
        }
    }
    if (eOrder == HenchmanOrderType.HENCHMAN_ORDER_USE_POWER)
    {
        bInstantOrder = TRUE;
        nQueuePosition = 0;
        nIndex = -1;
        for (nCurrentIndex = 0; nCurrentIndex < m_Orders.Length; nCurrentIndex++)
        {
            if (m_Orders[nCurrentIndex].eOrderType == HenchmanOrderType.HENCHMAN_ORDER_USE_POWER)
            {
                if (nQueuePosition == nQueue)
                {
                    nIndex = nCurrentIndex;
                    break;
                    continue;
                }
                nQueuePosition++;
            }
        }
        if (nIndex == -1)
        {
            m_Orders.Add(1);
            nIndex = m_Orders.Length - 1;
        }
    }
    else if (eOrder == HenchmanOrderType.HENCHMAN_ORDER_SWITCH_WEAPON)
    {
        bInstantOrder = TRUE;
        RemoveOldSwitchWeaponOrders();
        if (MyBP.Weapon == oWeapon)
        {
            return FALSE;
        }
        m_Orders.Add(1);
        nIndex = m_Orders.Length - 1;
    }
    else
    {
        m_Orders.Add(1);
        nIndex = m_Orders.Length - 1;
    }
    m_Orders[nIndex].eOrderType = eOrder;
    m_Orders[nIndex].oTargetActor = oTargetActor;
    m_Orders[nIndex].vTargetLocation = vTargetLocation;
    m_Orders[nIndex].nmPower = nmPower;
    m_Orders[nIndex].bInstantOrder = bInstantOrder;
    m_Orders[nIndex].oWeapon = oWeapon;
    m_Orders[nIndex].bExecutingOrder = FALSE;
    m_Orders[nIndex].bPowerUseIsInstant = TRUE;
    if (eOrder == HenchmanOrderType.HENCHMAN_ORDER_USE_POWER)
    {
        SetTimer(0.00999999978, FALSE, 'InstantUsePower', );
    }
    return TRUE;
}
public function AdjustEnemyRating(Pawn EnemyPawn, out float fRating)
{
    local BioPawn EnemyBioPawn;
    
    EnemyBioPawn = BioPawn(EnemyPawn);
    if (EnemyBioPawn != None)
    {
        if (EnemyBioPawn.GetHealthPct() <= 0.5)
        {
            fRating *= 1.25;
        }
    }
}
public function AdjustRatingByTickets(out float out_Rating, int EnemyIdx);

public function ApplyOrderBonus()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    if (MyBP != None)
    {
        Manager = MyBP.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Manager.RemoveEffectsByCategory('HenchmanAttackOrderBonus');
            Manager.RemoveEffectsByCategory('HenchmanMoveOrderBonus');
            Effect = Manager.CreateEffect(Class'SFXGameEffect_PassiveWeaponDamageBonus', 'HenchmanAttackOrderBonus', HenchmanAttackDuration, 1, HenchmanAttackBonus);
            if (Effect != None)
            {
                Effect.OnApplied();
            }
            Effect = Manager.CreateEffect(Class'SFXGameEffect_DamageTakenBonus', 'HenchmanMoveOrderBonus', HenchmanDefenseDuration, 1, HenchmanDefenseBonus);
            if (Effect != None)
            {
                Effect.OnApplied();
            }
        }
    }
}
public function bool ArePowersCoolingDown()
{
    local SFXPowerCustomActionBase oPower;
    
    if (MyBP == None || MyBP.PowerManager == None)
    {
        return FALSE;
    }
    foreach MyBP.PowerManager.Powers(oPower, )
    {
        if (oPower.UsesSharedCooldown && oPower.CurrentCooldownTime > float(0))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool CancelOrder(HenchmanOrderType eOrder, Name nmPower)
{
    local int nIndex;
    
    if (MyBP == None || MyBP.IsDead())
    {
        return FALSE;
    }
    if (m_Orders.Length > 0)
    {
        if (eOrder == HenchmanOrderType.HENCHMAN_ORDER_USE_POWER)
        {
            nIndex = m_Orders.Length - 1;
            if (m_Orders[nIndex].nmPower == nmPower && m_Orders[nIndex].bExecutingOrder == FALSE)
            {
                m_Orders.Remove(nIndex, 1);
                if (IsTimerActive('InstantUsePower'))
                {
                    ClearTimer('InstantUsePower');
                }
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function bool CanChoosePower(SFXPowerCustomAction oPower, Actor oTarget, optional bool bPlayerRequest)
{
    local string sOptionalInfo;
    
    oPower.m_bPlayerOrderedPowerUse = bPlayerRequest;
    if (bPlayerRequest)
    {
        return oPower.CanUsePower(oTarget);
    }
    else
    {
        return oPower.CanUsePower(oTarget) && oPower.ShouldUsePower(oTarget, sOptionalInfo);
    }
}
public function bool CanInstantlyUsePowers()
{
    if (MyBP != None && MyBP.GetTimeSinceLastRender() >= 0.25 || m_bAllowInstantPowerWhileVisible)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool CanQueueOrder()
{
    local int nQueuedInstantOrders;
    
    if (m_nEnabledFlags != 0)
    {
        return FALSE;
    }
    nQueuedInstantOrders = GetInstantOrderCount();
    if (nQueuedInstantOrders > 1)
    {
        return FALSE;
    }
    return TRUE;
}
public function bool CanStartImmediateOrder()
{
    local int nQueuedInstantOrders;
    
    if (m_nEnabledFlags != 0)
    {
        return FALSE;
    }
    nQueuedInstantOrders = GetInstantOrderCount();
    if (nQueuedInstantOrders > 0)
    {
        return FALSE;
    }
    return TRUE;
}
public function bool CanUsePowers(bool bCheckProfileOption)
{
    local SFXPawn Player;
    local PlayerController Controller;
    local SFXPRI PRI;
    
    if (m_bDelayPowerUse)
    {
        return FALSE;
    }
    if (PreventSquadPowerUse)
    {
        return FALSE;
    }
    if (m_OtherHenchman != None)
    {
        if (m_OtherHenchman.FindCommandOfClass(Class'SFXAICmd_UsePower') != None || m_OtherHenchman.ArePowersCoolingDown())
        {
            return FALSE;
        }
    }
    if (bCheckProfileOption && MyBP != None && MyBP.Squad != None)
    {
        Player = SFXPawn(MyBP.Squad.Members[0]);
        if (Player != None)
        {
            if (Player.DrivenVehicle == None && Player.DrivenAtlas == None)
            {
                Controller = PlayerController(Player.Controller);
                if (Controller != None)
                {
                    PRI = SFXPRI(Controller.PlayerReplicationInfo);
                    if (PRI != None && PRI.bSquadUsesPowers == FALSE)
                    {
                        return FALSE;
                    }
                }
            }
        }
    }
    return TRUE;
}
public function CheckInCombat()
{
    if (m_bEnemiesPerceived && (MyBP == None || MyBP.InCombat() == FALSE))
    {
        m_bEnemiesPerceived = FALSE;
        m_vHoldLocation = vect(0.0, 0.0, 0.0);
        m_bHoldingPosition = FALSE;
    }
}
public function CheckLineOfFireClear()
{
    local int nPlayerIsFiring;
    
    if (MyBP == None)
    {
        return;
    }
    if (MyBP.bIsCrouched)
    {
        if (IsInPlayerLineOfFire(nPlayerIsFiring))
        {
            return;
        }
        if (MyBP.IsInCover() == FALSE)
        {
            MyBP.ShouldCrouch(FALSE);
        }
    }
    ClearTimer('CheckLineOfFireClear');
    if (IsInState('Idle', TRUE))
    {
        SetTimer(0.5, TRUE, 'CheckPlayerLineOfFire', );
    }
}
public function CheckMeleeAttacker()
{
    local Vector HitLocation;
    local Vector HitNormal;
    local Actor HitActor;
    
    m_bMeleeAttacker = FALSE;
    if (MyBP == None || FireTarget == None)
    {
        return;
    }
    if (VSize(FireTarget.location - MyBP.location) > float(700))
    {
        return;
    }
    HitActor = FireTarget.Trace(HitLocation, HitNormal, MyBP.location, FireTarget.location, TRUE, vect(0.0, 0.0, 0.0), , );
    if (HitActor != None && HitActor != MyBP)
    {
        return;
    }
    m_bMeleeAttacker = TRUE;
}
public function CheckPlayerLineOfFire()
{
    local int nPlayerIsFiring;
    
    if (MyBP == None)
    {
        return;
    }
    if (IsInPlayerLineOfFire(nPlayerIsFiring))
    {
        if (MyBP.IsInCover())
        {
            if (MyBP.IsLeaning())
            {
                CancelAction(16);
            }
        }
        else if (MyBP.bIsCrouched == FALSE && MyBP.CurrentCustomAction == 0 && IsZero(MyBP.Velocity))
        {
            if (nPlayerIsFiring != 0)
            {
                SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(81, MyBP, , , , TRUE);
            }
            MyBP.ShouldCrouch(TRUE);
            ClearTimer('CheckPlayerLineOfFire');
            SetTimer(3.0, TRUE, 'CheckLineOfFireClear', );
        }
    }
}
public function CheckThreatRadius()
{
    if (IsWithinThreatRadius())
    {
        if (bAcquireNewCover == FALSE && IsMovingToCover() == FALSE)
        {
            bAcquireNewCover = TRUE;
        }
    }
}
public function bool ChooseAttackPower(Actor oTarget, out Name nmPower, out int nRequiresAttackTicket, out Vector AttackOrigin, optional bool bPlayerRequest)
{
    return ChooseAttackPowerHelper(oTarget, bPlayerRequest, nmPower, nRequiresAttackTicket, AttackOrigin);
}
public function bool ChooseAttackPowerHelper(Actor oTarget, bool bPlayerRequest, out Name nmPower, out int nRequiresAttackTicket, out Vector AttackOrigin)
{
    if (bPlayerRequest || CanUsePowers(TRUE))
    {
        return Super(SFXAI_Core).ChooseAttackPower(oTarget, nmPower, nRequiresAttackTicket, AttackOrigin);
    }
    return FALSE;
}
public function bool ChooseDefensivePower(out Name nmPower)
{
    if (CanUsePowers(FALSE) == FALSE)
    {
        return FALSE;
    }
    return Super(SFXAI_Core).ChooseDefensivePower(nmPower);
}
public function FindNewCover()
{
    if (!MyBP.IsInCover() || !m_bHoldingPosition)
    {
        bAcquireNewCover = TRUE;
    }
}
public function int GetInstantOrderCount()
{
    local int nCount;
    local int nIndex;
    
    for (nIndex = 0; nIndex < m_Orders.Length; nIndex++)
    {
        if (m_Orders[nIndex].bInstantOrder)
        {
            nCount++;
        }
    }
    return nCount;
}
public function HenchmanOrder GetNextOrder(HenchmanOrderType eOrder)
{
    local HenchmanOrder oNoneOrder;
    local int nOrder;
    
    for (nOrder = 0; nOrder < m_Orders.Length; ++nOrder)
    {
        if (int(m_Orders[nOrder].eOrderType) == int(eOrder))
        {
            return m_Orders[nOrder];
        }
    }
    return oNoneOrder;
}
public function float GetPeriodicMoveInterval()
{
    return 1.0;
}
public function bool HasAnyEnemies()
{
    local int Index;
    local Pawn EnemyPawn;
    local SFXAI_Core EnemyAI;
    
    if (EnemyList.Length == 0)
    {
        return FALSE;
    }
    for (Index = 0; Index < EnemyList.Length; Index++)
    {
        EnemyPawn = EnemyList[Index].Pawn;
        if (EnemyPawn != None)
        {
            EnemyAI = SFXAI_Core(EnemyPawn.Controller);
            if (EnemyAI != None && EnemyAI.bUnaware == FALSE)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function HenchmanMoveToCover()
{
    m_nCoverEvaluationCount++;
    if (IsTimerActive('FindNewCover'))
    {
        ClearTimer('FindNewCover');
    }
    if (FireTarget == None)
    {
        return;
    }
    Class'SFXAICmd_AcquireCover'.static.AcquireNewCover(Self, AtCover_WeaponRange, FireTarget);
}
public function InstantUsePower()
{
    local Actor TargetActor;
    local Vector TargetLocation;
    local Name PowerName;
    local SFXPowerCustomActionBase Power;
    
    if (MyBP == None || MyBP.PowerManager == None)
    {
        return;
    }
    if (m_Orders.Length == 0 || m_Orders[0].eOrderType != HenchmanOrderType.HENCHMAN_ORDER_USE_POWER)
    {
        return;
    }
    if (m_Orders[0].bPowerUseIsInstant == FALSE)
    {
        return;
    }
    if (m_Orders[0].bExecutingOrder == FALSE)
    {
        if (CanInstantlyUsePowers() == FALSE)
        {
            m_Orders[0].bPowerUseIsInstant = FALSE;
            return;
        }
    }
    TargetActor = m_Orders[0].oTargetActor;
    TargetLocation = m_Orders[0].vTargetLocation;
    PowerName = m_Orders[0].nmPower;
    m_Orders.Remove(0, 1);
    Power = MyBP.PowerManager.GetPower(PowerName);
    if (Power == None)
    {
        return;
    }
    if (Power.PowerType == EPowerType.PowerType_Buff)
    {
        TargetActor = MyBP;
        TargetLocation = location;
    }
    if (!Power.CanUsePower(TargetActor))
    {
        return;
    }
    SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(19, MyBP, BioPawn(TargetActor));
    Power.m_oTargetToAimAt = TargetActor;
    Power.m_vLocationToAimAt = TargetLocation;
    bUsingInstantPower = TRUE;
    Power.StartCustomAction();
    bUsingInstantPower = FALSE;
}
public function bool IsCombatStale()
{
    return FALSE;
}
public function bool IsInMoveTo()
{
    return !IsZero(m_vHoldLocation);
}
public function bool IsInPlayerLineOfFire(out int nPlayerIsFiring)
{
    local BioPlayerSquad PlayerSquad;
    local SFXPawn Player;
    local BioPlayerController PlayerController;
    local SFXPlayerCamera PlayerCamera;
    local Vector vHenchmanLocationWithoutZ;
    local Vector vCameraRotationWithoutZ;
    local float fAngle;
    local float fDistance;
    local float fLineOfFireAngle;
    
    if (MyBP == None || MyBP.IsDead())
    {
        return FALSE;
    }
    if (MyBP.GetTimeSinceLastRender() > 1.0)
    {
        return FALSE;
    }
    PlayerSquad = BioPlayerSquad(MyBP.Squad);
    if (PlayerSquad == None)
    {
        return FALSE;
    }
    Player = SFXPawn(PlayerSquad.m_playerPawn);
    if (Player == None || Player.Weapon == None)
    {
        return FALSE;
    }
    if (Player.DrivenVehicle != None || Player.DrivenAtlas != None)
    {
        return FALSE;
    }
    PlayerController = BioPlayerController(Player.Controller);
    if (PlayerController == None)
    {
        return FALSE;
    }
    PlayerCamera = SFXPlayerCamera(PlayerController.PlayerCamera);
    if (PlayerCamera == None)
    {
        return FALSE;
    }
    nPlayerIsFiring = int(Player.Weapon.IsFiring());
    if (PlayerController.IsZoomed() == FALSE && nPlayerIsFiring == 0)
    {
        return FALSE;
    }
    fDistance = VSize2D(MyBP.location - Player.location);
    if (fDistance > 1000.0)
    {
        return FALSE;
    }
    vHenchmanLocationWithoutZ = MyBP.location - PlayerCamera.CameraCache.POV.location;
    vHenchmanLocationWithoutZ.Z = 0.0;
    vCameraRotationWithoutZ = Vector(PlayerCamera.CameraCache.POV.Rotation);
    vCameraRotationWithoutZ.Z = 0.0;
    fAngle = GetAngleBetween(vHenchmanLocationWithoutZ, vCameraRotationWithoutZ) * 57.2957802;
    fLineOfFireAngle = 6.0;
    if (fDistance <= 500.0)
    {
        fLineOfFireAngle *= 2.0;
    }
    if (fAngle <= fLineOfFireAngle)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool IsWithinThreatRadius()
{
    local BioPawn TargetPawn;
    
    TargetPawn = BioPawn(FireTarget);
    if (MyBP != None && TargetPawn != None)
    {
        if (m_bMeleeAttacker)
        {
            return TRUE;
        }
        if (TargetPawn.ThreatRadiusSquared > 0.0 && VSizeSq(TargetPawn.location - MyBP.location) <= TargetPawn.ThreatRadiusSquared)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool MoveToCoverNearHoldLocation(bool bInitialOrder)
{
    local Actor oMoveIndicator;
    
    if (MyBP == None || MyBP.Squad == None)
    {
        return FALSE;
    }
    oMoveIndicator = MyBP.Squad.GetMemberMoveIndicator(MyBP.Squad.Members.Find(MyBP));
    if (oMoveIndicator == None)
    {
        return FALSE;
    }
    Class'SFXAICmd_AcquireCoverNearHoldLoc'.static.AcquireCoverNearHoldLoc(Self, AtCover_NearMoveGoal, oMoveIndicator, bInitialOrder, FALSE);
    return TRUE;
}
public function NotifyHenchmenLoaded()
{
    local Pawn oSquadMember;
    local SFXAI_Henchman oController;
    local int nIndex;
    local BioBaseSquad Squad;
    
    if (MyBP == None || MyBP.Squad == None)
    {
        return;
    }
    Squad = MyBP.Squad;
    if (Squad.Members.Length >= 3)
    {
        for (nIndex = 0; nIndex < Squad.Members.Length; nIndex++)
        {
            oSquadMember = Squad.Members[nIndex];
            if (oSquadMember != None && oSquadMember != Pawn)
            {
                oController = SFXAI_Henchman(oSquadMember.Controller);
                if (oController != None)
                {
                    m_OtherHenchman = oController;
                    oController.m_OtherHenchman = Self;
                }
            }
        }
    }
}
public function NotifyKnockedOutOfCover()
{
    bAcquireNewCover = TRUE;
}
public function NotifyPowerDelayFinished()
{
    m_bDelayPowerUse = FALSE;
}
public function NotifyStuck()
{
}
public function NotifyUnderAttack(bool bHit)
{
    Super(SFXAI_Core).NotifyUnderAttack(bHit);
    if (MyBP == None)
    {
        return;
    }
    if (SFXAICmd_Combat_Henchman(CommandList) == None)
    {
        return;
    }
    if (IsMovingToCover())
    {
        return;
    }
    if (MyBP.IsInCover())
    {
        if (bHit)
        {
            if (MyBP.IsLeaning())
            {
                CancelAction(1);
                m_bWaitBeforeNextAttack = TRUE;
            }
            else
            {
                bAcquireNewCover = TRUE;
            }
        }
    }
    else
    {
        bAcquireNewCover = TRUE;
    }
}
public function OnCombatStart();

public function OnTargetChanged()
{
    local BioPlayerSquad PlayerSquad;
    
    if (bAILogging)
    {
        PlayerSquad = BioPlayerSquad(MyBP.Squad);
        PlayerSquad.m_playerPawn.ClientMessage(MyBP.GetActorGameName() $ ": " $ FireTarget);
    }
    CheckMeleeAttacker();
    CheckThreatRadius();
    m_bTooFarToAttack = FALSE;
    if (SFXAICmd_Combat_Henchman(CommandList) != None)
    {
        CancelAction(8);
    }
}
public function bool PathfindToHoldLocation()
{
    local Actor oMoveIndicator;
    
    if (MyBP == None || MyBP.Squad == None)
    {
        return FALSE;
    }
    oMoveIndicator = MyBP.Squad.GetMemberMoveIndicator(MyBP.Squad.Members.Find(MyBP));
    if (oMoveIndicator == None)
    {
        return FALSE;
    }
    Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Self, oMoveIndicator);
    return TRUE;
}
public function PowerCooldownFinished()
{
    local SFXPawn_Henchman oPawn;
    
    oPawn = SFXPawn_Henchman(MyBP);
    if (oPawn != None && oPawn.PowerUseDelay > 0.0)
    {
        if (!m_bDelayPowerUse)
        {
            m_bDelayPowerUse = TRUE;
            SetTimer(oPawn.PowerUseDelay, FALSE, 'NotifyPowerDelayFinished', );
        }
    }
}
public delegate function ReachedInteractionPoint();

public function bool ReactToFlank(Pawn FlankingPawn)
{
    return FALSE;
}
public function bool ReactToNearbyEnemy(Pawn NearbyPawn)
{
    if (ShouldMelee(NearbyPawn))
    {
        DoMeleeAttack();
        return TRUE;
    }
    return FALSE;
}
public function RemoveOldSwitchWeaponOrders()
{
    local int nIndex;
    
    for (nIndex = m_Orders.Length - 1; nIndex >= 0; nIndex--)
    {
        if (m_Orders[nIndex].eOrderType == HenchmanOrderType.HENCHMAN_ORDER_SWITCH_WEAPON && m_Orders[nIndex].bExecutingOrder == FALSE)
        {
            m_Orders.Remove(nIndex, 1);
        }
    }
}
public function ResetFarAwayFlag()
{
    m_bTooFarToAttack = FALSE;
}
public function bool RespondToBump(Actor Other, Vector HitNormal)
{
    local BioPawn BumpedPawn;
    
    BumpedPawn = BioPawn(Other);
    if (BumpedPawn != None && BioPlayerController(BumpedPawn.Controller) != None)
    {
        if (SFXAICmd_MoveAwayFromPlayer(CommandList) != None)
        {
            return FALSE;
        }
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(80, BumpedPawn, MyBP, , , TRUE);
        BeginCombatCommand(Class'SFXAICmd_MoveAwayFromPlayer');
        return TRUE;
    }
    return FALSE;
}
public function SetSquadIntoCombat()
{
    local BioPlayerSquad oPlayerSquad;
    
    if (MyBP == None)
    {
        return;
    }
    oPlayerSquad = BioPlayerSquad(MyBP.Squad);
    if (oPlayerSquad == None)
    {
        return;
    }
    oPlayerSquad.SquadEnterCombatMode();
}
public function bool ShouldAttack()
{
    local int nPlayerIsFiring;
    
    if (MyBP == None)
    {
        return FALSE;
    }
    if (MyBP.IsInCover())
    {
        if (MyBP.GetHealthPct() < DamagePercentToRemainInCover)
        {
            return FALSE;
        }
        if (IsInPlayerLineOfFire(nPlayerIsFiring))
        {
            return FALSE;
        }
    }
    return TRUE;
}
public function bool ShouldCancelMove(int nReason)
{
    if (nReason == 2)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool ShouldFollowPlayer()
{
    local BioPlayerSquad oPlayerSquad;
    local float fDistance;
    local SFXPawn Player;
    
    if (MyBP == None)
    {
        return FALSE;
    }
    oPlayerSquad = BioPlayerSquad(MyBP.Squad);
    if (oPlayerSquad == None || oPlayerSquad.m_playerPawn == None)
    {
        return FALSE;
    }
    fDistance = VSize(oPlayerSquad.m_playerPawn.location - MyBP.location);
    if (m_bHoldingPosition || IsZero(m_vHoldLocation) == FALSE || ForcedTarget != None)
    {
        if (fDistance > TetherDistanceWhileExecutingOrder)
        {
            return TRUE;
        }
        return FALSE;
    }
    Player = SFXPawn(MyBP.Squad.Members[0]);
    if (Player.DrivenAtlas != None)
    {
        Player = Player.DrivenAtlas;
    }
    if (m_bFollowPlayer && fDistance >= TetherDistanceForFollowOrder + Player.FollowDistanceModifier)
    {
        return TRUE;
    }
    if (IsInCombat() == FALSE)
    {
        return TRUE;
    }
    if (fDistance >= TetherDistance)
    {
        return TRUE;
    }
    if (FireTarget == None && SelectTarget() == FALSE)
    {
        return TRUE;
    }
    if (m_bTooFarToAttack)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool ShouldMelee(Actor MeleeTarget)
{
    local Vector Direction;
    
    if (FireTarget != None)
    {
        Direction = Normal(FireTarget.location - MyBP.location);
        if (Direction Dot Vector(MyBP.Rotation) < 0.707000017)
        {
            return FALSE;
        }
        return Super(SFXAI_Core).ShouldMelee(FireTarget);
    }
    return FALSE;
}
public function bool ShouldStayLeanedOut()
{
    if (m_Orders.Length > 0)
    {
        if (m_Orders[0].eOrderType == HenchmanOrderType.HENCHMAN_ORDER_USE_POWER)
        {
            if (MyBP.IsInCover() && MyBP.IsInCoverLeaning())
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function bool ShouldWaitForPlayer()
{
    local BioPlayerSquad PlayerSquad;
    local float PlayerDistance;
    local float HenchmanDistance;
    
    if (MyBP != None && FireTarget != None)
    {
        PlayerSquad = MyBP != None ? BioPlayerSquad(MyBP.Squad) : None;
        if (PlayerSquad != None && PlayerSquad.m_playerPawn != None)
        {
            PlayerDistance = VSize(FireTarget.location - PlayerSquad.m_playerPawn.location);
            HenchmanDistance = VSize(FireTarget.location - MyBP.location);
            if (HenchmanDistance + float(1000) < PlayerDistance)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function bool StartFollowingActor(Actor ActorToFollow)
{
    if (MyBP == None || MyBP.IsDead() || ActorToFollow == None)
    {
        return FALSE;
    }
    m_RequestedActorToFollow = ActorToFollow;
    CancelAction(2);
    return TRUE;
}
public delegate function StoppedWorldInteraction(bool bSuccess);

public function bool TeleportNearLeader()
{
    local bool bResult;
    local BioPlayerSquad oPlayerSquad;
    local SFXPawn_Player leader;
    local Vector TargetLocation;
    local Vector vCross;
    local Vector vTeleportLocation;
    local float TeleportOffsetRear;
    local float TeleportOffsetSide;
    
    TeleportOffsetRear = 60.0;
    TeleportOffsetSide = 60.0;
    if (MyBP == None)
    {
        return FALSE;
    }
    oPlayerSquad = BioPlayerSquad(MyBP.Squad);
    if (oPlayerSquad == None || oPlayerSquad.m_playerPawn == None)
    {
        return FALSE;
    }
    if (MyBP == oPlayerSquad.m_playerPawn)
    {
        return FALSE;
    }
    leader = SFXPawn_Player(oPlayerSquad.m_playerPawn);
    if (leader == None)
    {
        return FALSE;
    }
    TargetLocation = leader.location - Vector(leader.Rotation) * TeleportOffsetRear;
    vCross = Vector(leader.Rotation) Cross vect(0.0, 0.0, 1.0);
    if (oPlayerSquad.Members.Length < 2)
    {
        TargetLocation -= vCross * TeleportOffsetSide;
    }
    else
    {
        TargetLocation += vCross * TeleportOffsetSide;
    }
    if (FindNearestOpenLocation(TargetLocation, vTeleportLocation, leader))
    {
        MyBP.SafeSetLocation(vTeleportLocation);
        bResult = TRUE;
    }
    else
    {
        TargetLocation = leader.location + Vector(leader.Rotation * TeleportOffsetRear);
        if (FindNearestOpenLocation(TargetLocation, vTeleportLocation, leader))
        {
            MyBP.SafeSetLocation(vTeleportLocation);
            bResult = TRUE;
        }
    }
    if (bResult)
    {
        MapName_Hench_Teleport(MyBP.location.X, MyBP.location.Y);
    }
    return bResult;
}
public function bool TeleportToActor(Actor oActor, optional bool bForceTeleport, optional bool bOffsetTeleport = TRUE)
{
    local bool bResult;
    
    bResult = Super(SFXAI_Core).TeleportToActor(oActor, bForceTeleport, bOffsetTeleport);
    if (bResult)
    {
        MapName_Hench_Teleport(MyBP.location.X, MyBP.location.Y);
    }
    return bResult;
}
public function TriggerAttackVocalization()
{
    if (BioPawn(FireTarget) != None && MyBP != None)
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(14, MyBP, BioPawn(FireTarget), , , TRUE);
    }
}
public function bool UseInteractionPoint(Actor InteractionPoint, float fFidelityTimeout, delegate<ReachedInteractionPoint> ReachedDelegate, delegate<StoppedWorldInteraction> StoppedDelegate, out int bBusy)
{
    local SFXAICmd_Disabled Cmd;
    
    EnableAI(FALSE, 32);
    if (MyBP.IsDead())
    {
        BeginCombatCommand(Class'SFXAICmd_Resurrect');
        bBusy = 1;
        return FALSE;
    }
    else if (MyBP.IsInState('InRagdoll', ) || MyBP.IsInState('RagdollRecovery', ))
    {
        bBusy = 1;
        return FALSE;
    }
    Cmd = SFXAICmd_Disabled(CommandList);
    if (Cmd == None)
    {
        bBusy = 1;
        return FALSE;
    }
    else
    {
        __ReachedInteractionPoint__Delegate = ReachedDelegate;
        __StoppedWorldInteraction__Delegate = StoppedDelegate;
        return Cmd.UseInteractionPoint(InteractionPoint, fFidelityTimeout);
    }
    return FALSE;
}
public function bool WantsToRun(float fDistance)
{
    local SFXAICommand Cmd;
    
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None && Cmd.ShouldRun())
    {
        return TRUE;
    }
    if (CoverSlotMarker(MoveGoal) != None)
    {
        return TRUE;
    }
    return Super(SFXAI_Core).WantsToRun(fDistance);
}

auto state Idle 
{
    public function Class<SFXAICommand> ChooseCommand()
    {
        local BioPlayerSquad oPlayerSquad;
        local float fDistance;
        
        if (m_bResetHenchman)
        {
            return Class'SFXAICmd_ResetHenchman';
        }
        if (m_RequestedActorToFollow != None)
        {
            m_vHoldLocation = vect(0.0, 0.0, 0.0);
            m_bHoldingPosition = FALSE;
            m_ActorToFollow = m_RequestedActorToFollow;
            return Class'SFXAICmd_HenchFollowActor';
        }
        if (ShouldFollowPlayer())
        {
            if (m_bFollowPlayer == FALSE && ForcedTarget != None)
            {
                SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(4, MyBP, , , , TRUE);
            }
            oPlayerSquad = MyBP != None ? BioPlayerSquad(MyBP.Squad) : None;
            if (oPlayerSquad != None && oPlayerSquad.m_playerPawn != None)
            {
                m_vHoldLocation = vect(0.0, 0.0, 0.0);
                m_bHoldingPosition = FALSE;
                if (SFXPawn(oPlayerSquad.m_playerPawn).DrivenAtlas != None)
                {
                    m_ActorToFollow = SFXPawn(oPlayerSquad.m_playerPawn).DrivenAtlas;
                }
                else
                {
                    m_ActorToFollow = oPlayerSquad.m_playerPawn;
                }
                return Class'SFXAICmd_HenchFollowActor';
            }
        }
        if (MyBP != None && IsZero(m_vHoldLocation) == FALSE && m_bHoldingPosition == FALSE)
        {
            oPlayerSquad = BioPlayerSquad(MyBP.Squad);
            if (oPlayerSquad != None && oPlayerSquad.m_playerPawn != None)
            {
                fDistance = VSize(oPlayerSquad.m_playerPawn.location - m_vHoldLocation);
                if (fDistance <= TetherDistanceWhileExecutingOrder)
                {
                    return Class'SFXAICmd_MoveToHoldLocation';
                }
                SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(11, MyBP, , , , TRUE);
            }
            m_vHoldLocation = vect(0.0, 0.0, 0.0);
        }
        if (HasAnyEnemies() == FALSE && m_bHoldingPosition && ForcedTarget == None)
        {
            return None;
        }
        return Class'SFXAICmd_Combat_Henchman';
    }
    public function NotifyNewEnemy(Pawn NewEnemy, bool bPerceivedDirectly, bool bFirstEnemy)
    {
        Global.NotifyNewEnemy(NewEnemy, bPerceivedDirectly, bFirstEnemy);
    }
    public event function bool NotifyBump(Actor Other, Vector HitNormal)
    {
        if (Super(SFXAI_Core).NotifyBump(Other, HitNormal) == FALSE)
        {
            return RespondToBump(Other, HitNormal);
        }
        return TRUE;
    }
    public function ExecuteOrders()
    {
        if (m_Orders.Length > 0)
        {
            if (CommandList == None)
            {
                Class'SFXAICmd_ExecuteOrders'.static.InitCommand(Self);
            }
            else
            {
                CancelAction(2);
            }
        }
    }
    public function EndState(Name NextStateName)
    {
        Super.EndState(NextStateName);
        ClearTimer('ExecuteOrders');
        ClearTimer('CheckPlayerLineOfFire');
        ClearTimer('CheckInCombat');
    }
    public function BeginState(Name PreviousStateName)
    {
        Super.BeginState(PreviousStateName);
        SetTimer(0.25 + FRand() * 0.25, TRUE, 'ExecuteOrders', );
        SetTimer(0.5, TRUE, 'CheckPlayerLineOfFire', );
        SetTimer(1.0 + FRand() * 0.25, TRUE, 'CheckInCombat', );
    }
    
Begin:
    while (TRUE)
    {
        if (MyBP != None)
        {
            ExecuteOrders();
            CurrentCommand = ChooseCommand();
            if (CurrentCommand != None)
            {
                ClearCancelAction();
                CurrentCommand.static.InitCommand(Self);
            }
            ExecuteOrders();
        }
        Sleep(0.5);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CovGoal_AvoidEnemies Name=CovGoal_AvoidHenchEnemies
    End Object
    Begin Object Class=CovGoal_Enemies Name=CovGoal_HenchEnemies
    End Object
    Begin Object Class=CovGoal_MovementDistance Name=CovGoal_HenchMovDistWeapon
        BestCoverDist = 768.0
        MaxCoverDist = 1500.0
        MinCoverDist = 256.0
    End Object
    Begin Object Class=CovGoal_TeammateProximity Name=CovGoal_HenchTeamProx
        fTeammateMinDistanceSq = 90000.0
        fProximityPenalty = 4000.0
        fSquadLeaderProximityPenalty = 50000.0
        fTeammateMaxDistanceSq = 1000000.0
        fMaxDistancePenalty = 50000.0
        bRestrictMaxDistance = TRUE
    End Object
    Begin Object Class=CovGoal_WeaponRange Name=CovGoal_HenchWeaponRange
        fClosePenalty = 5000.0
        fFarPenalty = 5000.0
    End Object
    Begin Template Class=Goal_AtCover Name=AtCov_EvalAggressive
        Begin Template Class=CovGoal_CombatZones Name=CovGoal_CombatZones0
        End Template
        Begin Template Class=CovGoal_Enemies Name=CovGoal_Enemies0
        End Template
        Begin Template Class=CovGoal_MovementDistance Name=CovGoal_MovDistAggressive
        End Template
        Begin Template Class=CovGoal_TeammateProximity Name=CovGoal_TeamProx0
        End Template
        Begin Template Class=CovGoal_WeaponRange Name=CovGoal_WeaponRange0
        End Template
        CoverGoalConstraints = (CovGoal_WeaponRange0, CovGoal_Enemies0, CovGoal_TeamProx0, CovGoal_MovDistAggressive, CovGoal_CombatZones0)
    End Template
    Begin Template Class=Goal_AtCover Name=AtCov_EvalDefensive
        Begin Template Class=CovGoal_Enemies Name=CovGoal_Enemies0
        End Template
        Begin Template Class=CovGoal_MovementDistance Name=CovGoal_MovDistDefensive
        End Template
        Begin Template Class=CovGoal_TeammateProximity Name=CovGoal_TeamProx0
        End Template
        CoverGoalConstraints = (CovGoal_Enemies0, CovGoal_MovDistDefensive, CovGoal_TeamProx0)
    End Template
    Begin Template Class=Goal_AtCover Name=AtCov_EvalNearGoal
        Begin Template Class=CovGoal_Enemies Name=CovGoal_Enemies0
        End Template
        Begin Template Class=CovGoal_GoalProximity Name=CovGoal_NearMoveGoal
        End Template
        CoverGoalConstraints = (CovGoal_NearMoveGoal, CovGoal_Enemies0)
    End Template
    Begin Template Class=Goal_AtCover Name=AtCov_EvalWeaponRange
        CoverGoalConstraints = (CovGoal_HenchWeaponRange, CovGoal_HenchEnemies, CovGoal_HenchMovDistWeapon, CovGoal_HenchTeamProx, CovGoal_AvoidHenchEnemies)
        AllowStartNodeToBeGoal = TRUE
    End Template
    MaxAttemptsToFindCoverNearHoldLocation = 1
    TetherDistance = 4000.0
    TetherDistanceWhileExecutingOrder = 4000.0
    TetherDistanceForFollowOrder = 500.0
    DistanceToStartCombatWhileFollowing = 800.0
    AttackDelayAfterBeingShot = 1.0
    DamagePercentToRemainInCover = 1.0
    m_fHeadshotProbability = 1.0
    MinDistanceFromTargetForCrouch = 400.0
    MaxBackAwayDistance = 2000.0
    HenchmanAttackBonus = 2.0
    HenchmanDefenseBonus = -0.400000006
    HenchmanAttackDuration = 10.0
    HenchmanDefenseDuration = 10.0
    AtCover_WeaponRange = AtCov_EvalWeaponRange
    AtCover_Defensive = AtCov_EvalDefensive
    AtCover_Aggressive = AtCov_EvalAggressive
    AtCover_NearMoveGoal = AtCov_EvalNearGoal
    m_fNearbyEnemyDistance = 150.0
    m_fRunThreshold = 350.0
    m_bUsePowerReservations = FALSE
    m_bAvoidDangerLinks = TRUE
    m_bAvoidFireFromPlayerOnly = FALSE
    m_bCanResurrect = TRUE
}