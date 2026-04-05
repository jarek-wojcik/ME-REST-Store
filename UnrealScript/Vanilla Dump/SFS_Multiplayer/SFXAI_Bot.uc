Class SFXAI_Bot extends SFXAI_Cover
    placeable
    config(AI);

var float TetherDistanceInCombat;
var Vector HoldLocation;
var bool FollowPlayer;
var bool HoldingObjective;
var bool KeepCloseToObjectiveActor;
var SFXPawn PlayerPawn;
var bool bMovingToDownedTarget;
var transient float DefaultOffset;
var transient float GoalOffset;
var float currentOffset;
var string Goal;
var int botId;
var bool bDebugLoggingEnabled;
var float DebugLoggingInterval;

public function PostBeginPlay()
{
    Super(SFXAI_Core).PostBeginPlay();
    StartCommandWatchdog();
}
public function bool WantsToRun(float fDistance)
{
    if (bMovingToDownedTarget)
    {
        return TRUE;
    }
    else
    {
        return Super(SFXAI_Core).WantsToRun(fDistance);
    }
}
public function DebugLogging(optional string Context)
{
    local string LogPrefix;
    local string StateInfo;
    local string MovementInfo;
    local string NavInfo;
    local string CmdInfo;
    local SFXAICommand CurrentCmd;
    local float DistToPlayer;
    local float DistToObjective;
    
    if (MyBP == None)
    {
        return;
    }
    // === BUILD LOG PREFIX ===
    LogPrefix = "Bot[" $ botId $ "]";
    if (Context != "")
    {
        LogPrefix = LogPrefix $ " (" $ Context $ ")";
    }
    // === GATHER STATE & TARGET DATA ===
    StateInfo = "Mood: " $ CombatMood;
    StateInfo = StateInfo $ " | bStuck: " $ bStuck;
    StateInfo = StateInfo $ " | InCombat: " $ IsInCombat();
    if (FireTarget != None)
    {
        StateInfo = StateInfo $ " | FireTarget: " $ FireTarget.Name;
    }
    // === GATHER MOVEMENT DATA ===
    MovementInfo = "";
    if (PlayerPawn != None)
    {
        DistToPlayer = VSize(PlayerPawn.location - MyBP.location);
        MovementInfo = "DistToPlayer: " $ DistToPlayer;
    }
    if (ObjectiveGoalActor != None)
    {
        DistToObjective = VSize(ObjectiveGoalActor.location - MyBP.location);
        if (MovementInfo != "")
        {
            MovementInfo = MovementInfo $ " | ";
        }
        MovementInfo = MovementInfo $ "DistToObjective: " $ DistToObjective;
    }
    if (MovementInfo != "")
    {
        MovementInfo = MovementInfo $ " | ";
    }
    MovementInfo = MovementInfo $ "currentOffset: " $ currentOffset;
    // === GATHER NAVIGATION DATA ===
    NavInfo = "MoveGoal: " $ MoveGoal;
    NavInfo = NavInfo $ " | m_ActorToFollow: " $ m_ActorToFollow;
    NavInfo = NavInfo $ " | bReachedMoveGoal: " $ bReachedMoveGoal;
    NavInfo = NavInfo $ " | bGetFirstMoveTargetFailed: " $ bGetFirstMoveTargetFailed;
    NavInfo = NavInfo $ " | m_nMoveAttemptCounter: " $ m_nMoveAttemptCounter;
    NavInfo = NavInfo $ " | LastFailedPathTime: " $ LastFailedPathTime;
    NavInfo = NavInfo $ " | LastSuccessfulPathTime: " $ LastSuccessfulPathTime;
    NavInfo = NavInfo $ " | m_bFollowingActor: " $ m_bFollowingActor;
    NavInfo = NavInfo $ " | m_bAllowedToLeavePlaypen: " $ m_bAllowedToLeavePlaypen;
    NavInfo = NavInfo $ " | ObjectiveGoalActor: " $ ObjectiveGoalActor.Name;
    if (MyBP.Anchor != None)
    {
        NavInfo = NavInfo $ " | Anchor: " $ MyBP.Anchor.Name;
    }
    else
    {
        NavInfo = NavInfo $ " | Anchor: NONE";
    }
    // === GATHER COMMAND DATA ===
    CurrentCmd = SFXAICommand(CommandList);
    if (CurrentCmd != None)
    {
        CmdInfo = "Cmd: " $ CurrentCmd.Class.Name;
    }
    else
    {
        CmdInfo = "Cmd: NONE";
    }
    // === PRINT LOG LINES ===
    Class'SFSCore'.static.log(Self.Name, LogPrefix $ " STATE: " $ StateInfo, MyBP);
    Class'SFSCore'.static.log(Self.Name, LogPrefix $ " MOVE: " $ MovementInfo, MyBP);
    Class'SFSCore'.static.log(Self.Name, LogPrefix $ " NAV: " $ NavInfo, MyBP);
    Class'SFSCore'.static.log(Self.Name, LogPrefix $ " " $ CmdInfo, MyBP);
}
public function DebugLoggingTick()
{
    DebugLogging("Timer");
}
public function StartDebugLogging(optional float Interval)
{
    if (!bDebugLoggingEnabled)
    {
        return;
    }
    if (Interval <= 0.0)
    {
        Interval = DebugLoggingInterval;
    }
    if (Interval <= 0.0)
    {
        Interval = 2.0;
        // Default 2 seconds
    }
    DebugLoggingInterval = Interval;
    SetTimer(Interval, TRUE, 'DebugLoggingTick', );
    Class'SFSCore'.static.log(Self.Name, "DebugLogging: Started periodic logging every " $ Interval $ " seconds", MyBP);
    DebugLogging("Initial");
}
public function StopDebugLogging()
{
    ClearTimer('DebugLoggingTick');
    Class'SFSCore'.static.log(Self.Name, "DebugLogging: Stopped periodic logging", MyBP);
}
public function StartCommandWatchdog()
{
    SetTimer(0.5, TRUE, 'CheckCommandList', );
}
public function StopCommandWatchdog()
{
    ClearTimer('CheckCommandList');
}
public function CheckCommandList()
{
    // Don't do anything if dying or AI is disabled
    if (bDying || m_nEnabledFlags != 0)
    {
        return;
    }
    // Don't do anything if we don't have a valid pawn
    if (MyBP == None || MyBP.Health <= 0)
    {
        return;
    }
    // Clear stale fire target pointing to dead pawn
    if (FireTarget != None)
    {
        if (Pawn(FireTarget) != None && Pawn(FireTarget).Health <= 0)
        {
            ReleaseTicket(FireTarget, 1);
            ReleaseTicket(FireTarget, 2, TRUE);
            FireTarget = None;
        }
        else if (FireTarget.bDeleteMe)
        {
            ReleaseTicket(FireTarget, 1);
            ReleaseTicket(FireTarget, 2, TRUE);
            FireTarget = None;
        }
    }
    // If no command is running, restart the default command
    if (CommandList == None)
    {
        Class'SFSCore'.static.log(Self.Name, "Watchdog: No active command, restarting DefaultCommand", MyBP);
        BeginDefaultCommand("Watchdog - No active command", TRUE);
    }
}
public function bool ShouldFollowPlayer()
{
    local float fDistance;
    local SFXPawn Player;
    
    if (MyBP == None)
    {
        return FALSE;
    }
    if (Player == None)
    {
        return FALSE;
    }
    fDistance = VSize(Player.location - MyBP.location);
    if (fDistance > TetherDistanceInCombat)
    {
        return TRUE;
    }
    if (FollowPlayer && fDistance >= TetherDistanceInCombat + Player.FollowDistanceModifier)
    {
        return TRUE;
    }
    if (IsInCombat() == FALSE)
    {
        return TRUE;
    }
    if (FireTarget == None && SelectTarget() == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool ChooseAttack(Actor oTarget, out Name nmPowerName)
{
    local SFXWeapon oWeapon;
    local int nRequiresAttackTicket;
    local Vector AttackOrigin;
    local ECoverAction AttackerCoverAction;
    local ECoverAction TargetCoverAction;
    local BioWorldInfo BWI;
    
    BWI = BioWorldInfo(WorldInfo);
    if (MyBP == None)
    {
        return FALSE;
    }
    if (BWI != None && FRand() <= BWI.m_fAutoBotDefensePowerPercent)
    {
        if (ChooseDefensivePower(nmPowerName))
        {
            return TRUE;
        }
    }
    if (oTarget == None)
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
    if (m_bCheckLOS && CanAttack(oTarget) == FALSE)
    {
        m_AttackResult = AttackResult.ATTACK_FAIL_NO_LOS;
        if (nmPowerName != 'None')
        {
            ClearPowerReservation(nmPowerName);
        }
        return FALSE;
    }
    return TRUE;
}
public function float GetCoverDelayTime()
{
    if (FireTarget == None)
    {
        return 1.0;
    }
    return RandRange(FarCoverDelayTime.X, FarCoverDelayTime.Y);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
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
        Begin Template Class=CovGoal_CombatZones Name=CovGoal_CombatZones0
        End Template
        Begin Template Class=CovGoal_Enemies Name=CovGoal_Enemies0
        End Template
        Begin Template Class=CovGoal_MovementDistance Name=CovGoal_MovDistWeapon
        End Template
        Begin Template Class=CovGoal_TeammateProximity Name=CovGoal_TeamProx0
        End Template
        Begin Template Class=CovGoal_WeaponRange Name=CovGoal_WeaponRange0
        End Template
        CoverGoalConstraints = (CovGoal_WeaponRange0, CovGoal_Enemies0, CovGoal_TeamProx0, CovGoal_MovDistWeapon, CovGoal_CombatZones0)
    End Template
    AtCover_WeaponRange = AtCov_EvalWeaponRange
    AtCover_Defensive = AtCov_EvalDefensive
    AtCover_Aggressive = AtCov_EvalAggressive
    AtCover_NearMoveGoal = AtCov_EvalNearGoal
    DefaultCommand = Class'SFXAICmd_Bot_Base'
    TetherDistanceInCombat = 10000.0
    EvadeResetDuration = 9999.0
    EvadeHealthThreshold = 100.0
    EvadeFrequency = 5.0
    PartialLeanPct = 0.5
    CancelFirePct = 0.349999994
    MeleeAttackInterval = 2.0
    GoalOffset = 50.0
    DefaultOffset = 300.0
    m_fRunThreshold = 100.0
    ActionDelayTime_Normal = {X = 0.200000003, Y = 0.5}
    MoveFireDelayTime = {X = 0.200000003, Y = 0.5}
    DesiredBurstsToFire = 20
    WeaponAimDelay = 0.200000003
    m_fNearbyEnemyDistance = 5000.0
    m_bAvoidDangerLinks = TRUE
    bIsAutoBot = TRUE
    m_bCheckLOS = TRUE
    bDebugLoggingEnabled = FALSE
    DebugLoggingInterval = 2.0
}