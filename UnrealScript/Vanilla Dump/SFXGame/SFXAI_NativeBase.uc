Class SFXAI_NativeBase extends BioAiController
    native
    placeable
    hidedropdown
    config(AI);

const ENABLE_AI_REQUESTED_BY_HENCHMAN_INTERACTION = 32;
const ENABLE_AI_REQUESTED_BY_DEATH = 16;
const ENABLE_AI_REQUESTED_BY_GAME_EFFECT = 8;
const ENABLE_AI_REQUESTED_BY_KISMET = 4;
const ENABLE_AI_REQUESTED_BY_CONVERSATION = 2;
const ENABLE_AI_REQUESTED_BY_UNKNOWN = 1;
enum EAICombatMood
{
    AI_NoMood,
    AI_Unaware,
    AI_Fallback,
    AI_Normal,
    AI_Aggressive,
    AI_Berserk,
};
enum EAICombatRange
{
    AI_Range_Melee,
    AI_Range_Short,
    AI_Range_Medium,
    AI_Range_Long,
};

var transient int m_nMantleCostModifier;
var transient float LastShotAtTime;
var SFXPathWeightLog PathWeightLog;
var transient int m_nEnabledFlags;
var SFXNav_InteractionPoint CombatIdleNode;
var transient float m_fNextTimeForReachableCheck;
var transient float NextTimeForBlockedReachSpecCheck;
var transient bool m_bCanSkipNodes;
var transient bool m_bInitiallyDisabled;
var transient bool CustomReachSpecBlocked;
var EAICombatMood CombatMood;

public native function bool AdjustSteeringMoveSpeed(Vector vSteering);

public event function BioClearCrossLevelReferences(Level oLevel);

public event function bool CanInterruptCurrentState()
{
    local SFXAICommand Cmd;
    
    Cmd = SFXAICommand(CommandList);
    if (Cmd != None)
    {
        return Cmd.CanInterruptCurrentCommand();
    }
    return TRUE;
}
public final native function bool CanNavFireIntoSector(NavigationPoint Nav, int Sector, float Distance);

private final native function bool CanSkipCurrentPathNode();

public final native function CheckLeaveCover();

public event function bool EnableAI(bool bEnable, int nRequestedBy)
{
    return TRUE;
}
public event function GetActorToFollow(out Actor oActor, out Vector vLocation);

public event function Vector GetAimLocation(optional Actor oAimTarget);

public final native function float GetRouteCacheDistance();

public final native function int GetSectorForLine(const out Vector SectorLine);

public native function bool GetSteeringVector(out Vector vSteering);

public final native function bool HasApproximateSightBetweenNodes(NavigationPoint OriginNav, NavigationPoint TargetNav);

public final native function bool HasEnemyWithinDistance(float Distance, optional out Pawn out_EnemyPawn, optional bool bExact);

public native function bool IsActorInLevel(Actor oActor, Level oLevel);

public event function bool IsCustomReachSpecBlocked(SFXCustomReachSpec ReachSpec)
{
    local Vector CollisionLocation;
    local float CollisionRadius;
    local Pawn BlockingPawn;
    
    if (Pawn == None || ReachSpec == None || ReachSpec.End.Actor == None)
    {
        return TRUE;
    }
    if (ReachSpec.BlockingPawn != None && ReachSpec.BlockingPawn != Pawn)
    {
        return TRUE;
    }
    CollisionLocation = ReachSpec.End.Actor.location;
    CollisionRadius = Pawn.GetCollisionRadius();
    CollisionRadius *= 1.25;
    foreach Pawn.CollidingActors(Class'Pawn', BlockingPawn, CollisionRadius, CollisionLocation, TRUE, , )
    {
        if (BlockingPawn != Pawn && BlockingPawn.IsDead() == FALSE)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public event function bool IsEnabled()
{
    return m_nEnabledFlags == 0;
}
private final native function bool IsSpecialMoveAfterMoveTarget();

public native function MoveTowardLocation(Vector vLocation, optional float fOffset);

public event function NotifyPlayerFocus();

public final native function ReachedMoveTarget();

public final native function bool RequiresCover(ReachSpec ReachSpec);

public event function ResetToIdle(optional bool bTeleport = FALSE);

public native function SetMoveTimer(out Vector vMove);

public event function SetSpawnPoint(PathNode SpawnPoint)
{
    local SFXNav_InteractionPoint InteractionNode;
    
    InteractionNode = SFXNav_InteractionPoint(SpawnPoint);
    if (InteractionNode != None)
    {
        CombatIdleNode = InteractionNode;
    }
}
public final latent native function SmoothPathMovement();

public event function StartedSpawning();

public event function StoppedSpawning();

public event function UpdateMovementActions();

public final native function ValidateFireTargetLocation();

public function float GetCombatRange(EAICombatRange CombatRange)
{
    local float fRangeModifier;
    local float fRange;
    
    switch (CombatMood)
    {
        case EAICombatMood.AI_Fallback:
            fRangeModifier = 2.0;
            break;
        case EAICombatMood.AI_Aggressive:
            fRangeModifier = 0.75;
            break;
        default:
            fRangeModifier = 1.0;
            break;
    }
    switch (CombatRange)
    {
        case EAICombatRange.AI_Range_Melee:
            fRange = MyBP.GetWeaponRange(1);
            break;
        case EAICombatRange.AI_Range_Short:
            fRange = MyBP.GetWeaponRange(2);
            break;
        case EAICombatRange.AI_Range_Medium:
            fRange = MyBP.GetWeaponRange(3);
            break;
        case EAICombatRange.AI_Range_Long:
            fRange = MyBP.GetWeaponRange(4);
            break;
        default:
    }
    return fRange * fRangeModifier;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nMantleCostModifier = 3
    LastShotAtTime = -9999.0
    m_bCanSkipNodes = TRUE
    CombatMood = EAICombatMood.AI_Normal
}