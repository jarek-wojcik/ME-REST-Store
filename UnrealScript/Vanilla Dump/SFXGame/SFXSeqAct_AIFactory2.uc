Class SFXSeqAct_AIFactory2 extends SequenceAction
    native;

enum ESpawnSortType
{
    SST_Shuffle,
    SST_Linear,
};
struct native AISpawnInfo 
{
    var(AISpawnInfo) array<Pawn> Types;
    var transient array<AISpawnClusterTracker> WatchList;
    var array<Actor> SpawnPoints;
    var array<string> VarLinkDescs;
    var(AISpawnInfo) string AutoDebugText;
    var(AISpawnInfo) Class<SFXProjectile> ObscuredSpawnProjectileClass;
    var(AISpawnInfo) Vector ObscuredSpawnOffset;
    var(AISpawnInfo) Name ActorTag;
    var(AISpawnInfo) float ClusterVisibilityDelay;
    var transient int CurrentCluster;
    var(AISpawnInfo) int SpawnTotal;
    var(AISpawnInfo) int MaxAlive;
    var int SpawnedCount;
    var int SpawnPointIdx;
    var(AISpawnInfo) float MaxSpawnDelay;
    var(AISpawnInfo) float MinSpawnDelay;
    var float CurrentDelay;
    var(AISpawnInfo) int TeamIdx;
    var(AISpawnInfo) BioBaseSquad Squad;
    var(AISpawnInfo) bool bAutoAcquireEnemy;
    var(AISpawnInfo) bool bAutoNotifyEnemy;
    var(AISpawnInfo) bool bDisableFriendlyNotifications;
    var(AISpawnInfo) bool bDisableAI;
    var(AISpawnInfo) bool bCanDropAmmo;
    var(AISpawnInfo) bool bDisableShadowCasting;
    var(AISpawnInfo) ELightShadowMode ShadowMode;
    
    structdefaultproperties
    {
        ObscuredSpawnOffset = {X = 0.0, Y = 0.0, Z = 2000.0}
        SpawnTotal = 1
        MaxAlive = 1
        MaxSpawnDelay = 0.100000001
        MinSpawnDelay = 0.100000001
        TeamIdx = 1
        bCanDropAmmo = TRUE
        ShadowMode = ELightShadowMode.LightShadow_Modulate
    }
};
struct native AISpawnClusterTracker 
{
    var transient array<Pawn> ClusterPawns;
    var transient int CurrentType;
    var transient float VisibilityTimer;
    var transient SFXProjectile ObscuredSpawnProjectile;
    var transient bool bVisible;
};

var array<Vector> ClusterOffsets;
var(SFXSeqAct_AIFactory2) array<AISpawnInfo> SpawnSets;
var(SFXSeqAct_AIFactory2) array<Actor> SpawnPoints;
var transient array<Pawn> SubSpawns;
var array<Pawn> PendingSpawnedPawns;
var(SFXSeqAct_AIFactory2) Actor SpawnerActor;
var(SFXSeqAct_AIFactory2) Actor ProjectileStartLocation;
var(SFXSeqAct_AIFactory2) int NumDeadThreshold;
var int DeadCount;
var BioBaseSquad DefaultSquad;
var bool bAllSpawned;
var bool bAllDead;
var bool bAbortSpawns;
var bool bEnteredCombat;
var(SFXSeqAct_AIFactory2) bool bResetDeadLinkCount;
var bool bActivatedDeadLink;
var(SFXSeqAct_AIFactory2) bool bPreventSave;
var(SFXSeqAct_AIFactory2) ESpawnSortType SpawnSelectionType;

public event function AddSpawnedPawnToCustomAction(BioPawn NewPawn);

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 8;
}
public event function PlaySpawnedAnimation();

private final event simulated function Projectile SpawnObscuringEffect(AISpawnInfo Set)
{
    local BioPawn FirstPawn;
    local Vector ProjLoc;
    local Vector InitialDirection;
    local AISpawnClusterTracker Cluster;
    local Projectile SpawnProjectile;
    
    Cluster = Set.WatchList[Set.CurrentCluster];
    FirstPawn = BioPawn(Cluster.ClusterPawns[0]);
    if (ProjectileStartLocation != None)
    {
        ProjLoc = ProjectileStartLocation.location;
        InitialDirection = Vector(ProjectileStartLocation.Rotation);
    }
    else
    {
        ProjLoc = FirstPawn.location + Set.ObscuredSpawnOffset;
        InitialDirection = -Set.ObscuredSpawnOffset;
        InitialDirection.Z *= 0.75;
        InitialDirection = Normal(InitialDirection);
    }
    SpawnProjectile = SFXGRI(FirstPawn.WorldInfo.GRI).ObjectPool.GetProjectile(Set.ObscuredSpawnProjectileClass, FirstPawn, FirstPawn, ProjLoc, Rotator(InitialDirection));
    if (SpawnProjectile != None && !SpawnProjectile.bDeleteMe)
    {
        SpawnProjectile.Init(InitialDirection);
    }
    return SpawnProjectile;
}
public function NotifyCombatEntered()
{
    if (!bEnteredCombat)
    {
        bEnteredCombat = TRUE;
        OutputLinks[4].bHasImpulse = TRUE;
    }
}
public function RemoveFromWatchList(Pawn TargetPawn)
{
    local int idx;
    local int WatchIdx;
    local int ClusterIdx;
    
    for (idx = 0; idx < SpawnSets.Length; idx++)
    {
        for (ClusterIdx = 0; ClusterIdx < SpawnSets[idx].WatchList.Length; ClusterIdx++)
        {
            WatchIdx = SpawnSets[idx].WatchList[ClusterIdx].ClusterPawns.Find(TargetPawn);
            if (WatchIdx != -1)
            {
                SpawnSets[idx].WatchList[ClusterIdx].ClusterPawns[WatchIdx] = None;
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ClusterOffsets = ({X = 0.0, Y = 0.0, Z = 0.0}, 
                      {X = 1.0, Y = 0.0, Z = 0.0}, 
                      {X = -1.0, Y = 0.0, Z = 0.0}, 
                      {X = 0.0, Y = 1.0, Z = 0.0}, 
                      {X = 0.0, Y = -1.0, Z = 0.0}
                     )
    NumDeadThreshold = 1
    InputLinks = ({
                   LinkDesc = "Spawn", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop Spawning", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Kill All", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Update Inputs", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "All Spawned", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "All Dead", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Spawned", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "# Dead", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Entered Combat", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Spawn Points", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'SpawnPoints', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Default Squad", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'DefaultSquad', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Last Spawned", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Spawned", 
                      ExpectedType = Class'SeqVar_ObjectList', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Num Dead", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Spawner Actor (DO NOT USE)", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'SpawnerActor', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Projectile Start", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'ProjectileStartLocation', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bLatentExecution = TRUE
    bAutoActivateOutputLinks = FALSE
}