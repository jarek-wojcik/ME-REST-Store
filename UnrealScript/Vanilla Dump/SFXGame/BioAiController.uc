Class BioAiController extends GameAIController
    native
    placeable
    hidedropdown
    config(AI);

enum eWalkWaypointsTypes
{
    WWT_Linear,
    WWT_Looping,
    WWT_OutAndBack,
    WWT_OutAndBackLooping,
    WWT_Random,
};
const MAXSEARCHPATHLENGTH = 2000.0f;
const TIMER_ADJUSTTOSLOT_LIMIT = 5.f;
const AI_NearbyHurtDistance = 500;
const AI_FlinchDistance = 35.0f;
const AI_NearMissDistance = 200;
struct native EnemyInfo 
{
    var Vector KnownLocation;
    var Vector InterpLocation;
    var CoverInfo Cover;
    var Pawn Pawn;
    var float InterpTime;
    var float InitialSeenTime;
    var float LastSeenTime;
    var float LastFailedPathTime;
    var float LastKnownLocUpdateTime;
    var float LastHurtByTime;
    var bool bVisible;
};
struct native DelayUpdateInfo 
{
    var Name EventName;
    var Controller Controller;
    var float UpdateTime;
    var EPerceptionType Type;
};
enum ELocationType
{
    LT_Known,
    LT_Interp,
    LT_Exact,
};
enum EPerceptionType
{
    PT_Sight,
    PT_Heard,
    PT_HurtBy,
    PT_NotifySight,
    PT_Force,
};

var array<EnemyInfo> EnemyList;
var array<DelayUpdateInfo> DelayUpdateList;
var array<Actor> IgnoredTargets;
var array<BioBaseSquad> IgnoredSquads;
var Vector MovePoint;
var CoverInfo Cover;
var CoverInfo CoverGoal;
var CoverInfo LastCover;
var float EnemyListLastUpdateTime;
var SFXSeqAct_AIFactory2 SpawnFactory;
var config float InterpEnemyLocSpeed;
var config float Response_MinEnemySeenTime;
var config float Response_MinEnemyHearTime;
var Actor FireTarget;
var Actor ForcedTarget;
var Actor PreferredTarget;
var float TargetAcquisitionTime;
var(BioAiController) float EnemyDistance_Short;
var(BioAiController) float EnemyDistance_Medium;
var(BioAiController) float EnemyDistance_Long;
var(BioAiController) float EnemyDistance_Melee;
var float m_fActivateTime;
var BioPawn MyBP;
var Actor MoveGoal;
var float MoveOffset;
var float AdjustToSlotTime;
var float UnawarePeripheralVision;
var(Debug) config bool bDebug_AI;
var(Debug) config bool bDebug_AIRange;
var(Debug) config bool bDebug_AIEnemyList;
var(Debug) config bool bDebug_ThreatRadius;
var bool bAcquireNewCover;
var const bool bHighCoverOnly;
var bool bReachedMoveGoal;
var bool bReachedCover;
var transient bool bDisableFriendlyNotifications;
var transient bool bUnaware;

public native function bool AdjustSteeringMoveSpeed(Vector vSteering);

public final latent native function AdjustToSlot(int TargetSlotIdx);

public event function AutoAcquireEnemy()
{
    local SFXGame G;
    
    G = SFXGame(WorldInfo.Game);
    if (G != None && G.PerceptionManager != None)
    {
        G.PerceptionManager.AutoAcquireEnemies(Self);
    }
}
public event function AutoNotifyEnemy()
{
    local SFXGame G;
    
    G = SFXGame(WorldInfo.Game);
    if (G != None && G.PerceptionManager != None)
    {
        G.PerceptionManager.AutoNotifyEnemies(Self);
    }
}
public final native function bool CanAISeeByPoints(Vector ViewLocation, Vector TestLocation, Rotator ViewRotation, bool bCheckSmoke);

public final native function bool CanFireAt(Actor ChkTarget, Vector ViewPt, optional bool bUseEyeLocation, optional bool bUseRotation);

public event function bool CanHearPawn(Pawn Heard, float Loudness, float DistSq, float DotSourceToRotation, Name NoiseType)
{
    switch (NoiseType)
    {
        case 'NoiseType_PowerRelease':
        case 'NoiseType_PowerImpact':
        case 'NoiseType_WeaponFire':
        case 'NoiseType_Explosion':
        case 'NoiseType_Death':
            return TRUE;
        case 'NoiseType_Footstep':
            if (DistSq <= EnemyDistance_Short ** float(2))
            {
                if (bUnaware)
                {
                    if (DotSourceToRotation < 0.0)
                    {
                        if (Loudness > 0.100000001 || DistSq < 150.0 ** float(2))
                        {
                            return TRUE;
                        }
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
            else if (MyBP.bSleeping && DistSq <= MyBP.fSleepPerceptionDistance ** float(2))
            {
                return TRUE;
            }
        default:
    }
    return FALSE;
}
public event function Destroyed()
{
    Super.Destroyed();
    if (AILogFile != None)
    {
        AILogFile.Destroy();
    }
    if (CommandList != None)
    {
        AbortCommand(CommandList);
    }
}
public native function bool DirectWalkCheck(const out Vector vTarget, Actor pTarget);

public function FillEnemyList()
{
    local SFXGame G;
    
    G = SFXGame(WorldInfo.Game);
    if (G != None && G.PerceptionManager != None)
    {
        G.PerceptionManager.FillEnemyList(Self);
    }
}
public native function bool FindNearestOpenLocation(Vector vStartLocation, out Vector vFoundLocation, optional Pawn oTarget, optional int nMaxShellsToCheck = 2);

public final latent native function FinishAnimatedTransition();

public final native function bool GetCover(Pawn ChkPawn, out CoverInfo out_Cover);

public final native function int GetEnemyIndex(Pawn TestPawn);

public final native function Vector GetEnemyLocation(optional Pawn TestPawn, optional ELocationType LT);

public final native function Vector GetEnemyLocationByIndex(int idx, optional ELocationType LT);

public final native function Vector GetFireTargetLocation(optional ELocationType LT);

public final native function Vector GetLookingDirection();

public final native function bool GetPawnCover(Pawn ChkPawn, out CoverInfo out_Cover, optional bool bOnlyUseCachedCover = FALSE);

public final native function float GetPeripheralVision();

public event simulated function GetPlayerViewPoint(out Vector out_Location, out Rotator out_rotation)
{
    out_Location = Pawn.GetPawnViewLocation();
    out_rotation = Pawn.Rotation;
}
public native function bool GetSteeringVector(out Vector vSteering);

public native function bool HasLOSToTarget(Actor pTarget, out float fTimeOfHit);

public final native function bool HasValidCover();

public final native function bool HasValidTarget(optional Actor TestTarget);

public function Initialize()
{
    SetTimer(0.5, FALSE, 'FillEnemyList', );
}
public final native function bool InRange(Vector TestLocation, float Distance);

public final native function InterpEnemyLocation(int idx);

public event function InvalidateCover()
{
    if (MyBP == None || MyBP.IsInCover() == FALSE)
    {
        return;
    }
    MyBP.LeaveCover();
    MyBP.ShouldCrouch(FALSE);
}
public final native function bool IsCoverExposedToAnEnemy(const out CoverInfo TestCover, out float out_ExposedScale, optional Pawn TestEnemy, optional bool bActualLocation);

public final native function bool IsEnemyVisibleByIndex(int idx);

public final native function bool IsFriendly(Controller Other);

public final native function bool IsHostile(Controller Other);

public final function bool IsReloading()
{
    return MyBP != None && MyBP.IsReloading();
}
public final function bool IsSwitchingWeapons()
{
    return MyBP != None && MyBP.IsSwitchingWeapons();
}
public native function bool IsTargetInFiringArc(BioPawn pPawn, Actor pTarget, float fFiringArcAsDot, optional ELocationType LT = 2);

public final native function bool IsValidCover(const out CoverInfo TestCover);

public native function MapName_Hench_Teleport(float X, float Y);

public final latent native function MoveToSlot(Vector vSlotLocation);

public event function NotifyEnemyVisible(int EnemyIdx, float TimeSinceSeen);

public event function NotifyNewEnemy(Pawn NewEnemy, bool bPerceivedDirectly, bool bFirstEnemy)
{
    NotifyNewEnemyBase(NewEnemy, bPerceivedDirectly, bFirstEnemy);
}
public event function NotifyNewEnemyFromFriendly(Pawn Target)
{
    local SFXGame G;
    local int EnemyIndex;
    
    G = SFXGame(WorldInfo.Game);
    if (G != None && G.PerceptionManager != None)
    {
        EnemyIndex = GetEnemyIndex(Target);
        if (EnemyIndex == -1)
        {
            G.PerceptionManager.NoticeEnemy(Self, Target, 3, FALSE, 'NewEnemyFromFriendly');
        }
        else
        {
            G.PerceptionManager.DelayedNoticeEnemy(Self, Target, 4, 0.5, 'UpdateEnemyFromFriendly');
        }
    }
}
public event function NotifyNoEnemiesPerceived()
{
    if (MyBP != None && MyBP.Squad != None)
    {
        MyBP.Squad.NotifyNoEnemiesPerceived();
    }
}
public event function OnEnteredPlaypen();

public event function OnEnteringStasis();

public event function OnLeavingStasis();

public event function OnLeftPlaypen();

public event function bool PlayerActivate(Actor Target_)
{
    local int i;
    local int J;
    local bool bActivated;
    
    bActivated = FALSE;
    for (i = 0; i < Pawn.GeneratedEvents.Length; i++)
    {
        if (ClassIsChildOf(Pawn.GeneratedEvents[i].Class, Class'BioSeqEvt_OnPlayerActivate') && Pawn.GeneratedEvents[i] != None)
        {
            for (J = 0; J < Pawn.GeneratedEvents[i].OutputLinks.Length; J++)
            {
                if (Pawn.GeneratedEvents[i].OutputLinks[J].Links.Length > 0)
                {
                    if (Pawn.GeneratedEvents[i].CheckActivate(Pawn, Target_))
                    {
                        bActivated = TRUE;
                        Pawn.GeneratedEvents[i].SetObjectVars("Pawn Activated", Pawn);
                    }
                }
            }
        }
    }
    if (bActivated)
    {
        m_fActivateTime = WorldInfo.GameTimeSeconds;
    }
    return bActivated;
}
public event function Possess(Pawn NewPawn, bool bVehicleTransition)
{
    Super(Controller).Possess(NewPawn, bVehicleTransition);
    if (Pawn != None)
    {
        MyBP = BioPawn(NewPawn);
        Initialize();
        NotifyChangedWeapon(None, Pawn.Weapon);
    }
}
public function Reset()
{
    Super(AIController).Reset();
    EnemyList.Length = 0;
    DelayUpdateList.Length = 0;
    SpawnFactory = None;
    FireTarget = None;
    ForcedTarget = None;
    PreferredTarget = None;
    IgnoredTargets.Length = 0;
    IgnoredSquads.Length = 0;
    Cover.Link = None;
    Cover.SlotIdx = -1;
    CoverGoal.Link = None;
    CoverGoal.SlotIdx = -1;
    LastCover.Link = None;
    LastCover.SlotIdx = -1;
    MoveGoal = None;
    MovePoint = vect(0.0, 0.0, 0.0);
}
public final native function SetKnownEnemyInfo(int EnemyIdx, Pawn EnemyPawn, Vector EnemyLoc);

public final latent native function SteeringMovement();

public event function Tick(float DeltaTime);

public event function UnPossess()
{
    Super(Controller).UnPossess();
    MyBP = None;
}
public function DrawDebug(BioHUD HUD)
{
    local int idx;
    local SFXWeapon Weapon;
    local Vector LookDir;
    local Vector VisionEdgeDir;
    local Vector PawnViewLoc;
    local Rotator PeripheralRotation;
    
    if (bDebug_AI)
    {
        if (Enemy != None)
        {
            DrawDebugLine(Pawn.GetPawnViewLocation(), GetEnemyLocation(None, 1), 100, 0, 0);
            DrawDebugLine(Pawn.GetPawnViewLocation() + vect(0.0, 0.0, 10.0), GetEnemyLocation(), 255, 0, 0);
        }
        LookDir = GetLookingDirection();
        PeripheralRotation.Yaw = int(Acos(GetPeripheralVision()) * 10430.3779);
        PawnViewLoc = Pawn.GetPawnViewLocation();
        VisionEdgeDir = PawnViewLoc + (LookDir >> PeripheralRotation) * 300.0;
        DrawDebugLine(PawnViewLoc, VisionEdgeDir, 255, 255, 0);
        PeripheralRotation.Yaw = -PeripheralRotation.Yaw;
        VisionEdgeDir = PawnViewLoc + (LookDir >> PeripheralRotation) * 300.0;
        DrawDebugLine(PawnViewLoc, VisionEdgeDir, 255, 255, 0);
    }
    if (bDebug_AIRange)
    {
        Weapon = SFXWeapon(Pawn.Weapon);
        if (Weapon != None)
        {
            DrawDebugCylinder(Pawn.location, Pawn.location, Weapon.IdealMinRange, 8, 255, 0, 0);
            DrawDebugCylinder(Pawn.location, Pawn.location, Weapon.IdealMaxRange, 8, 0, 255, 0);
        }
    }
    if (bDebug_AIEnemyList)
    {
        for (idx = 0; idx < EnemyList.Length; idx++)
        {
            if (EnemyList[idx].Pawn != Enemy)
            {
                if (IsEnemyVisibleByIndex(idx))
                {
                    DrawDebugLine(Pawn.location, GetEnemyLocationByIndex(idx), 0, 0, 255);
                    continue;
                }
                DrawDebugLine(Pawn.location, GetEnemyLocationByIndex(idx), 255, 0, 0);
            }
        }
    }
    if (bDebug_ThreatRadius && MyBP != None && MyBP.ThreatRadiusSquared > 0.0)
    {
        DrawDebugCylinder(MyBP.location, MyBP.location, Sqrt(MyBP.ThreatRadiusSquared), 8, 255, 255, 255);
    }
}
public function CheckNearMiss(Pawn Shooter, Weapon W, Vector WeapLoc, Vector LineDir, Vector HitLocation)
{
    local SFXGame G;
    local Vector ClosestPoint;
    local float DistToSegment;
    
    Super(Controller).CheckNearMiss(Shooter, W, WeapLoc, LineDir, HitLocation);
    if (MyBP != None && (MyBP.IsHostile(Shooter) || MyBP.bAmbientCreature))
    {
        DistToSegment = PointDistToSegment(Pawn.location, WeapLoc, HitLocation, ClosestPoint);
        if (DistToSegment <= 35.0)
        {
            TestPlayFlinch();
        }
        if (DistToSegment <= float(200))
        {
            G = SFXGame(WorldInfo.Game);
            if (G != None && G.PerceptionManager != None)
            {
                G.PerceptionManager.DelayedNoticeEnemy(Self, Shooter, 1, Response_MinEnemyHearTime, 'NearMiss');
            }
            NotifyNearMiss(HitLocation);
        }
    }
}
public function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    local int FoundIdx;
    
    Super(Controller).NotifyKilled(Killer, Killed, KilledPawn);
    FoundIdx = EnemyList.Find('Pawn', KilledPawn);
    if (FoundIdx != -1)
    {
        EnemyList[FoundIdx].Pawn = None;
    }
    if (FireTarget == KilledPawn)
    {
        FireTarget = None;
    }
    if (ForcedTarget == KilledPawn)
    {
        ForcedTarget = None;
    }
    if (PreferredTarget == KilledPawn)
    {
        PreferredTarget = None;
    }
    FoundIdx = IgnoredTargets.Find(KilledPawn);
    if (FoundIdx != -1)
    {
        IgnoredTargets.Remove(FoundIdx, 1);
    }
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
    local SFXGame G;
    
    if (instigatedBy != None)
    {
        TestPlayFlinch();
        G = SFXGame(WorldInfo.Game);
        if (G != None && G.PerceptionManager != None)
        {
            G.PerceptionManager.NoticeEnemy(Self, instigatedBy.Pawn, 2, TRUE, 'NotifyTakeHit');
        }
    }
}
public function PawnDied(Pawn inPawn)
{
    if (inPawn == Pawn)
    {
        RouteCache_Empty();
        EnemyList.Length = 0;
    }
    Super(Controller).PawnDied(inPawn);
    Destroy();
}
public function AddIgnoredSquad(BioBaseSquad oSquad)
{
    local BioPawn oBioPawn;
    
    if (IgnoredSquads.Find(oSquad) == -1)
    {
        IgnoredSquads.AddItem(oSquad);
    }
    oBioPawn = BioPawn(FireTarget);
    if (oBioPawn != None && oBioPawn.Squad == oSquad)
    {
        FireTarget = None;
    }
    oBioPawn = BioPawn(Enemy);
    if (oBioPawn != None && oBioPawn.Squad == oSquad)
    {
        Enemy = None;
    }
}
public function AddIgnoredTarget(Actor oTarget)
{
    if (IgnoredTargets.Find(oTarget) == -1)
    {
        IgnoredTargets.AddItem(oTarget);
    }
    if (FireTarget == oTarget)
    {
        FireTarget = None;
    }
    if (Enemy == oTarget)
    {
        Enemy = None;
    }
}
public function Actor GetForcedTarget()
{
    return ForcedTarget;
}
public function Actor GetPreferredTarget()
{
    return PreferredTarget;
}
public function bool HasAnyEnemies()
{
    return EnemyList.Length > 0;
}
public final function bool HasValidEnemy(optional Pawn TestEnemy)
{
    if (TestEnemy == None)
    {
        TestEnemy = Enemy;
    }
    if (TestEnemy == None || TestEnemy.IsValidTargetFor(Self) == FALSE)
    {
        return FALSE;
    }
    return TRUE;
}
public final function bool InMeleeRange(Vector TestLocation)
{
    return InRange(TestLocation, EnemyDistance_Melee);
}
public final function bool InShortRange(Vector TestLocation)
{
    return InRange(TestLocation, EnemyDistance_Short);
}
public final function bool IsMediumRange(Vector TestLocation)
{
    return VSizeSq(TestLocation - Pawn.location) <= EnemyDistance_Medium * EnemyDistance_Medium;
}
public final function bool IsShortRange(Vector TestLocation)
{
    return VSizeSq(TestLocation - Pawn.location) <= EnemyDistance_Short * EnemyDistance_Short;
}
public function NotifyCastAt(Pawn Attacker, SFXPowerCustomAction Power)
{
    local SFXGame G;
    local bool AttackPower;
    
    if (Power == None)
    {
        return;
    }
    if (SFXPawn_Henchman(Attacker) != None)
    {
        AttackPower = Power.HenchmanPowerType != EPowerType.PowerType_Buff;
    }
    else
    {
        AttackPower = Power.PowerType != EPowerType.PowerType_Buff;
    }
    if (AttackPower)
    {
        G = SFXGame(WorldInfo.Game);
        if (G != None && G.PerceptionManager != None)
        {
            G.PerceptionManager.NoticeEnemy(Self, Attacker, 2, TRUE, 'NotifyCastAt');
        }
    }
}
public function NotifyNearMiss(Vector HitLocation);

public final function NotifyNewEnemyBase(Pawn NewEnemy, bool bPerceivedDirectly, bool bFirstEnemy)
{
    local BioAiController AI;
    
    if (MyBP != None && MyBP.bSleeping)
    {
        MyBP.TriggerEventClass(Class'SFXSeqEvt_OnStoppedSleeping', NewEnemy);
        MyBP.bSleeping = FALSE;
    }
    if (SpawnFactory != None)
    {
        SpawnFactory.NotifyCombatEntered();
    }
    if (bPerceivedDirectly && MyBP != None && MyBP.Squad != None)
    {
        foreach MyBP.Squad.SquadMembers(AI)
        {
            if (AI != Self)
            {
                AI.NotifyNewEnemyFromFriendly(NewEnemy);
            }
        }
    }
    if (bPerceivedDirectly)
    {
        SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(17, BioPawn(Pawn), BioPawn(NewEnemy), , , TRUE);
    }
    if (bFirstEnemy && MyBP != None && MyBP.Squad != None)
    {
        MyBP.Squad.NotifyEnemyPerceived();
    }
}
public function OnLastManStanding();

protected function RecordDemoAILog(coerce string LogText);

public function RemoveIgnoredSquad(BioBaseSquad oSquad)
{
    IgnoredSquads.RemoveItem(oSquad);
}
public function RemoveIgnoredTarget(Actor oTarget)
{
    IgnoredTargets.RemoveItem(oTarget);
}
public function SetForcedTarget(Actor oTarget)
{
    ForcedTarget = oTarget;
}
public function SetPreferredTarget(Actor oTarget)
{
    PreferredTarget = oTarget;
}
public function TestPlayFlinch()
{
    if (MyBP.IsReloading(TRUE) == FALSE && MyBP.IsUsingPower() == FALSE && MyBP.IsInAnimatedTransition() == FALSE && MyBP.IsInCover() && MyBP.IsPerformingBlockingAction() == FALSE && MyBP.IsUsingPower() == FALSE && MyBP.DrivenVehicle != None && !MyBP.IsFiring())
    {
        MyBP.StartCustomAction(101);
    }
}
public final function float TimeSinceEnemyLocationUpdate(int idx)
{
    if (idx >= 0 && idx < EnemyList.Length)
    {
        return WorldInfo.GameTimeSeconds - EnemyList[idx].LastKnownLocUpdateTime;
    }
    return 0.0;
}
public final function float TimeSinceEnemyVisible(int idx)
{
    if (idx >= 0 && idx < EnemyList.Length)
    {
        if (EnemyList[idx].bVisible == FALSE)
        {
            return WorldInfo.GameTimeSeconds - EnemyList[idx].LastSeenTime;
        }
    }
    return 0.0;
}
public final function float TimeSinceHurtByEnemy(int idx)
{
    if (idx >= 0 && idx < EnemyList.Length)
    {
        return WorldInfo.GameTimeSeconds - EnemyList[idx].LastHurtByTime;
    }
    return 0.0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InterpEnemyLocSpeed = 20.0
    Response_MinEnemySeenTime = 1.0
    Response_MinEnemyHearTime = 0.25
    EnemyDistance_Short = 600.0
    EnemyDistance_Medium = 1800.0
    EnemyDistance_Long = 3600.0
    EnemyDistance_Melee = 300.0
    bDebug_AI = TRUE
    bAILogToWindow = TRUE
    bUseIterativePathFinding = TRUE
}