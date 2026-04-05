Class SFXAI_Cover extends SFXAI_Core
    placeable
    hidedropdown
    config(AI);

var(SFXAI_Cover) Vector2D NearCoverDelayTime;
var(SFXAI_Cover) Vector2D FarCoverDelayTime;
var(SFXAI_Cover) Vector2D AggressiveCoverDelayTime;
var(SFXAI_Cover) Vector2D ActionDelayTime_Normal;
var(SFXAI_Cover) Vector2D ActionDelayTime_Aggressive;
var(SFXAI_Cover) Vector2D ActionDelayTime_FallBack;
var transient Goal_AtCover MyCoverEval;
var transient float m_fLastCoverEnterTime;
var(SFXAI_Cover) float MaxFireWaitTime;
var(SFXAI_Cover) float FlankReactionTime;
var transient float LastTimeDamageCoverDecaySet;
var export Goal_AtCover AtCover_WeaponRange;
var export Goal_AtCover AtCover_Defensive;
var export Goal_AtCover AtCover_Aggressive;
var export Goal_AtCover AtCover_NearMoveGoal;
var transient bool m_bInvalidatedCover;
var transient bool m_bUsePeriodicCoverCheck;

public event function NotifyPlayerFocus()
{
    if (MyBP != None && MyBP.IsInCover())
    {
        FindNewCover();
    }
}
public simulated function NotifyCoverDisabled(CoverLink Link, int SlotIdx, optional bool bAdjacentIdx)
{
    InvalidateCover();
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
    local float CoverDecay;
    
    if (WorldInfo.GameTimeSeconds - LastTimeDamageCoverDecaySet > 1.0)
    {
        LastTimeDamageCoverDecaySet = WorldInfo.GameTimeSeconds;
        CoverDecay = FMin(float(Damage) / 100.0, 1.0) * 5000.0;
        ApplyCoverDecay(CoverDecay);
    }
    Super.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
}
public function PawnDied(Pawn inPawn)
{
    Super(BioAiController).PawnDied(inPawn);
    if (inPawn == Pawn)
    {
        UnClaimCover();
    }
}
public function bool AcquireCoverGoal(Goal_AtCover GoalEvaluator, Actor GoalActor, out CoverInfo NewCoverGoal)
{
    local CoverSlotMarker Marker;
    
    if (MyBP == None)
    {
        return FALSE;
    }
    if (GoalEvaluator == None)
    {
        return FALSE;
    }
    if (GoalActor == None)
    {
        return FALSE;
    }
    InitializeCoverConstraints(GoalEvaluator, GoalActor);
    if (FindPathToward(GoalActor, , , ) != None)
    {
        Marker = CoverSlotMarker(RouteCache[RouteCache.Length - 1]);
        NewCoverGoal = Marker.OwningSlot;
    }
    if (IsValidCover(NewCoverGoal) == FALSE || NewCoverGoal.Link.Slots[NewCoverGoal.SlotIdx].SlotMarker == None)
    {
        return FALSE;
    }
    if (MyBP.CurrentLink == NewCoverGoal.Link && MyBP.CurrentSlotIdx == NewCoverGoal.SlotIdx)
    {
        return TRUE;
    }
    if (ClaimCover(NewCoverGoal) == FALSE)
    {
        return FALSE;
    }
    return TRUE;
}
public function ApplyCoverDecay(float DecayValue)
{
    local SFXGame GameInfo;
    local CoverSlotMarker CoverSlot;
    
    if (MyBP != None)
    {
        if (MyBP.IsInCover())
        {
            CoverSlot = MyBP.CurrentLink.GetSlotMarker(MyBP.CurrentSlotIdx);
        }
        else
        {
            CoverSlot = CoverSlotMarker(MyBP.Anchor);
        }
        if (CoverSlot != None)
        {
            GameInfo = SFXGame(WorldInfo.Game);
            if (GameInfo != None)
            {
                GameInfo.AddCoverDecay(CoverSlot, int(DecayValue));
            }
        }
    }
}
public final function bool ClaimCover(CoverInfo NewCover)
{
    local bool bResult;
    
    if (IsValidCover(NewCover))
    {
        bReachedCover = FALSE;
        bResult = NewCover.Link.Claim(Pawn, NewCover.SlotIdx);
        if (bResult)
        {
            Cover = NewCover;
        }
    }
    return bResult;
}
public function FindNewCover()
{
    bAcquireNewCover = TRUE;
}
public function float GetActionDelayTime()
{
    if (CombatMood == EAICombatMood.AI_Aggressive)
    {
        return RandRange(ActionDelayTime_Aggressive.X, ActionDelayTime_Aggressive.Y);
    }
    else if (CombatMood == EAICombatMood.AI_Fallback)
    {
        return RandRange(ActionDelayTime_FallBack.X, ActionDelayTime_FallBack.Y);
    }
    else
    {
        return RandRange(ActionDelayTime_Normal.X, ActionDelayTime_Normal.Y);
    }
}
public function bool GetAttackOrigin(Actor oTarget, out Vector AttackOrigin)
{
    local ECoverAction TargetCoverAction;
    local ECoverAction AttackerCoverAction;
    
    if (MyBP != None && MyBP.IsInCover())
    {
        if (MyBP.IsLeaning() || MyBP.IsBlindFiring())
        {
            AttackOrigin = Cover.Link.GetSlotViewPoint(Cover.SlotIdx, 0, MyBP.CoverAction);
        }
        else if (PendingCoverAction != ECoverAction.CA_Default)
        {
            AttackOrigin = Cover.Link.GetSlotViewPoint(Cover.SlotIdx, 0, PendingCoverAction);
        }
        else if (GetBestCoverAction(Cover, oTarget, AttackerCoverAction, TargetCoverAction))
        {
            AttackOrigin = Cover.Link.GetSlotViewPoint(Cover.SlotIdx, 0, AttackerCoverAction);
        }
        else
        {
            return FALSE;
        }
    }
    else
    {
        return Super.GetAttackOrigin(oTarget, AttackOrigin);
    }
    return TRUE;
}
public function float GetCoverDelayTime()
{
    local float Distance;
    
    if (FireTarget == None)
    {
        return 1.0;
    }
    Distance = VSize(Pawn.location - FireTarget.location);
    if (CombatMood == EAICombatMood.AI_Fallback)
    {
        if (Distance < GetCombatRange(1))
        {
            return RandRange(FarCoverDelayTime.X, FarCoverDelayTime.Y);
        }
        else
        {
            return RandRange(NearCoverDelayTime.X, NearCoverDelayTime.Y);
        }
    }
    else if (CombatMood == EAICombatMood.AI_Aggressive)
    {
        return RandRange(AggressiveCoverDelayTime.X, AggressiveCoverDelayTime.Y);
    }
    else
    {
        if (Distance > GetCombatRange(2))
        {
            return RandRange(FarCoverDelayTime.X, FarCoverDelayTime.Y);
        }
        return RandRange(NearCoverDelayTime.X, NearCoverDelayTime.Y);
    }
}
public function InitializeCoverConstraints(Goal_AtCover Evaluator, Actor GoalActor)
{
    local bool bIncludePathCost;
    
    bIncludePathCost = CombatMood != EAICombatMood.AI_Fallback;
    if (MyBP != None && MyBP.Squad != None)
    {
        MyBP.Squad.PathingTowardCombatZone = FALSE;
    }
    Evaluator.Init(Self, GoalActor, bIncludePathCost);
    ApplyBasePathConstraints();
    if (CombatMood == EAICombatMood.AI_Fallback)
    {
        Class'SFXPath_AwayFromGoal'.static.AwayFromGoal(MyBP, GoalActor, 6000.0);
    }
    else if (ShouldPathTowardCombatZone(Evaluator))
    {
        if (MyBP != None && MyBP.Squad != None)
        {
            MyBP.Squad.PathingTowardCombatZone = TRUE;
        }
        Class'SFXPath_TowardCombatZone'.static.TowardCombatZone(MyBP);
    }
    else if (Evaluator.MoveTowardsGoalActor)
    {
        Class'Path_TowardGoal'.static.TowardGoal(MyBP, GoalActor);
    }
}
public function bool IsMovingToCover()
{
    return CoverGoal.Link != None;
}
public function bool MoveToCover(Goal_AtCover GoalEvaluator, Actor GoalActor, optional bool bUsePeriodicCheck = TRUE, optional bool bAllowedToFire = TRUE)
{
    local CoverInfo NewCoverGoal;
    
    MyCoverEval = GoalEvaluator;
    m_bInvalidatedCover = FALSE;
    if (AcquireCoverGoal(GoalEvaluator, GoalActor, NewCoverGoal) == FALSE)
    {
        return FALSE;
    }
    if (MyBP != None && MyBP.CurrentLink == NewCoverGoal.Link && MyBP.CurrentSlotIdx == NewCoverGoal.SlotIdx)
    {
        return TRUE;
    }
    CoverGoal = NewCoverGoal;
    m_bUsePeriodicCoverCheck = bUsePeriodicCheck;
    Class'SFXAICmd_MoveToCover'.static.MoveToCover(Self, m_bUsePeriodicCoverCheck, bAllowedToFire);
    return TRUE;
}
public function NotifyDeathBlow(Class<DamageType> DamageType)
{
    ApplyCoverDecay(10000.0);
    Super.NotifyDeathBlow(DamageType);
}
public function NotifyKnockedOutOfCover()
{
    bAcquireNewCover = TRUE;
}
public function NotifyReachedCover()
{
    local Rotator SlotRot;
    
    bReachedCover = TRUE;
    SlotRot = MyBP.CurrentLink.GetSlotRotation(MyBP.CurrentSlotIdx);
    MyBP.SetDesiredRotation(SlotRot, TRUE);
    m_fLastCoverEnterTime = WorldInfo.GameTimeSeconds;
}
public function NotifyStuck()
{
    if (!bStuck)
    {
        BeginCombatCommand(Class'SFXAICmd_CoverUserStuck');
    }
    Super.NotifyStuck();
}
public function NotifyUnsafeCover()
{
    FindNewCover();
}
public function OnCoverUserEvade(SFXSeqAct_CoverUserEvade Seq)
{
    if (MyBP.CurrentCustomAction == 0)
    {
        if (Seq.InputLinks[0].bHasImpulse && MyBP.CustomActionClasses[56] != None)
        {
            MyBP.StartCustomAction(56);
            Seq.ActivateOutputLink(0);
            return;
        }
        else if (Seq.InputLinks[1].bHasImpulse && MyBP.CustomActionClasses[57] != None)
        {
            MyBP.StartCustomAction(57);
            Seq.ActivateOutputLink(0);
            return;
        }
        else if (Seq.InputLinks[2].bHasImpulse && MyBP.CustomActionClasses[54] != None)
        {
            MyBP.StartCustomAction(54);
            Seq.ActivateOutputLink(0);
            return;
        }
        else if (Seq.InputLinks[3].bHasImpulse && MyBP.CustomActionClasses[55] != None)
        {
            MyBP.StartCustomAction(55);
            Seq.ActivateOutputLink(0);
            return;
        }
    }
    Seq.ActivateOutputLink(1);
}
public function bool ReactToFlank(Pawn FlankingPawn)
{
    ApplyCoverDecay(2000.0);
    SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(87, BioPawn(FlankingPawn), MyBP);
    BeginCombatCommand(Class'SFXAICmd_Reaction_Flank');
    return TRUE;
}
public function bool ReactToNearbyEnemy(Pawn NearbyPawn)
{
    if (DirectWalkCheck(NearbyPawn.location, NearbyPawn) == FALSE)
    {
        if (MyBP.IsInCover())
        {
            if (Vector(MyBP.Rotation) Dot Normal(NearbyPawn.location - MyBP.location) >= 0.5)
            {
                return ReactToFlank(NearbyPawn);
            }
        }
    }
    else if (ShouldMelee(NearbyPawn))
    {
        BeginCombatCommand(Class'SFXAICmd_Base_Melee');
        return TRUE;
    }
    return FALSE;
}
public function bool SetCombatMood(EAICombatMood NewMood, optional float fDuration)
{
    local bool bMoodSet;
    
    bMoodSet = Super.SetCombatMood(NewMood, fDuration);
    if (CombatMood == EAICombatMood.AI_Fallback || CombatMood == EAICombatMood.AI_Aggressive)
    {
        FindNewCover();
    }
    else if (CombatMood == EAICombatMood.AI_Berserk)
    {
        m_bAvoidDangerLinks = FALSE;
    }
    return bMoodSet;
}
public function bool ShouldFindBerserkCover()
{
    return IsTargetStealthed();
}
public function bool ShouldPathTowardCombatZone(Goal_AtCover Evaluator)
{
    local int Index;
    
    if (MyBP == None || MyBP.Squad == None)
    {
        return FALSE;
    }
    if (MyBP.Squad.CombatZones.Length == 0 || MyBP.Squad.IsPositionInCombatZone(MyBP.location))
    {
        return FALSE;
    }
    for (Index = 0; Index < Evaluator.CoverGoalConstraints.Length; Index++)
    {
        if (CovGoal_CombatZones(Evaluator.CoverGoalConstraints[Index]) != None)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public final function UnClaimCover()
{
    if (Cover.Link != None)
    {
        LastCover = Cover;
        Cover.Link.UnClaim(Pawn, Cover.SlotIdx, FALSE);
    }
    Cover.Link = None;
    Cover.SlotIdx = -1;
    bReachedCover = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=Goal_AtCover Name=AtCov_EvalWeaponRange
        CoverGoalConstraints = (CovGoal_WeaponRange0, CovGoal_Enemies0, CovGoal_TeamProx0, CovGoal_MovDistWeapon, CovGoal_CombatZones0)
    End Object
    Begin Object Class=Goal_AtCover Name=AtCov_EvalDefensive
        CoverGoalConstraints = (CovGoal_Enemies0, CovGoal_MovDistDefensive, CovGoal_TeamProx0)
    End Object
    Begin Object Class=Goal_AtCover Name=AtCov_EvalAggressive
        CoverGoalConstraints = (CovGoal_WeaponRange0, CovGoal_Enemies0, CovGoal_TeamProx0, CovGoal_MovDistAggressive, CovGoal_CombatZones0)
    End Object
    Begin Object Class=Goal_AtCover Name=AtCov_EvalNearGoal
        CoverGoalConstraints = (CovGoal_NearMoveGoal, CovGoal_Enemies0)
        AllowStartNodeToBeGoal = TRUE
    End Object
    Begin Object Class=CovGoal_CombatZones Name=CovGoal_CombatZones0
    End Object
    Begin Object Class=CovGoal_Enemies Name=CovGoal_Enemies0
    End Object
    Begin Object Class=CovGoal_GoalProximity Name=CovGoal_NearMoveGoal
        MaxGoalDist = 200.0
        bHardLimits = TRUE
    End Object
    Begin Object Class=CovGoal_MovementDistance Name=CovGoal_MovDistAggressive
        BestCoverDist = 768.0
        MaxCoverDist = 1280.0
        MinCoverDist = 128.0
        bMoveTowardGoal = TRUE
        bHardConstraint = TRUE
    End Object
    Begin Object Class=CovGoal_MovementDistance Name=CovGoal_MovDistDefensive
        BestCoverDist = 384.0
        MaxCoverDist = 768.0
    End Object
    Begin Object Class=CovGoal_MovementDistance Name=CovGoal_MovDistWeapon
        BestCoverDist = 768.0
        MaxCoverDist = 2048.0
        MinCoverDist = 256.0
        MinDistTowardGoal = -256.0
        bMoveTowardGoal = TRUE
    End Object
    Begin Object Class=CovGoal_TeammateProximity Name=CovGoal_TeamProx0
        fTeammateMinDistanceSq = 160000.0
        fProximityPenalty = 500.0
        fSquadLeaderProximityPenalty = 500.0
    End Object
    Begin Object Class=CovGoal_WeaponRange Name=CovGoal_WeaponRange0
        fClosePenalty = 5000.0
        fFarPenalty = 5000.0
    End Object
    NearCoverDelayTime = {X = 5.0, Y = 30.0}
    FarCoverDelayTime = {X = 2.0, Y = 5.0}
    AggressiveCoverDelayTime = {X = 2.0, Y = 4.0}
    ActionDelayTime_Normal = {X = 3.0, Y = 10.0}
    ActionDelayTime_Aggressive = {X = 1.0, Y = 3.0}
    ActionDelayTime_FallBack = {X = 3.0, Y = 10.0}
    AtCover_WeaponRange = AtCov_EvalWeaponRange
    AtCover_Defensive = AtCov_EvalDefensive
    AtCover_Aggressive = AtCov_EvalAggressive
    AtCover_NearMoveGoal = AtCov_EvalNearGoal
    BerserkCommand = Class'SFXAICmd_Berserk'
}