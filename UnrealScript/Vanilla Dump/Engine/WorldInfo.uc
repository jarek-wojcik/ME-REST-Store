Class WorldInfo extends ZoneInfo
    native
    nativereplication
    config(Game);

struct native NavMeshPathGoalEvaluatorCacheDatum 
{
    var NavMeshPathGoalEvaluator List[5];
    var int ListIdx;
};
struct native NavMeshPathConstraintCacheDatum 
{
    var NavMeshPathConstraint List[5];
    var int ListIdx;
};
const MAX_INSTANCES_PER_CLASS = 5;
struct native LightmassWorldInfoSettings 
{
    var float OcclusionCurveLookupTable[256];
    var(General) float StaticLightingLevelScale;
    var(General) int NumIndirectLightingBounces;
    var(General) Color EnvironmentColor;
    var(General) float EnvironmentIntensity;
    var(General) float EmissiveBoost;
    var(General) float DiffuseBoost;
    var float SpecularBoost;
    var(General) float IndirectNormalInfluenceBoost;
    var(General) float LightEnvironmentIndirectContrastFactor;
    var(Occlusion) float DirectIlluminationOcclusionFraction;
    var(Occlusion) float IndirectIlluminationOcclusionFraction;
    var(Occlusion) float OcclusionExponent;
    var(Occlusion) float FullyOccludedSamplesFraction;
    var(Occlusion) float MaxOcclusionDistance;
    var(Occlusion) bool bUseAmbientOcclusion;
    var(Debug) bool bVisualizeMaterialDiffuse;
    var(Debug) bool bVisualizeAmbientOcclusion;
    
    structdefaultproperties
    {
        StaticLightingLevelScale = 1.0
        NumIndirectLightingBounces = 3
        EnvironmentIntensity = 1.0
        EmissiveBoost = 1.0
        DiffuseBoost = 5.0
        SpecularBoost = 1.0
        IndirectNormalInfluenceBoost = 0.300000012
        LightEnvironmentIndirectContrastFactor = 4.0
        DirectIlluminationOcclusionFraction = 0.5
        IndirectIlluminationOcclusionFraction = 1.0
        OcclusionExponent = 1.0
        FullyOccludedSamplesFraction = 1.0
        MaxOcclusionDistance = 200.0
    }
};
const OcclusionCurveLookupTableSize = 256;
struct native transient ScreenMessageString 
{
    var transient init QWord Key;
    var transient init string ScreenMessage;
    var transient init Color DisplayColor;
    var transient init float TimeToDisplay;
    var transient init float CurrentTimeDisplayed;
};
struct native WorldFractureSettings 
{
    var float ChanceOfPhysicsChunkOverride;
    var float MaxExplosionChunkSize;
    var float MaxDamageChunkSize;
    var int MaxNumFacturedChunksToSpawnInAFrame;
    var float FractureExplosionVelScale;
    var bool bEnableChanceOfPhysicsChunkOverride;
    var bool bLimitExplosionChunkSize;
    var bool bLimitDamageChunkSize;
};
enum EConsoleType
{
    CONSOLE_Any,
    CONSOLE_Xbox360,
    CONSOLE_PS3,
    CONSOLE_Mobile,
    CONSOLE_IPhone,
    CONSOLE_Tegra,
};
struct native PhysXVerticalProperties 
{
    var(PhysXVerticalProperties) PhysXEmitterVerticalProperties Emitters;
};
struct native PhysXEmitterVerticalProperties 
{
    var(PhysXEmitterVerticalProperties) int ParticlesLodMin;
    var(PhysXEmitterVerticalProperties) int ParticlesLodMax;
    var(PhysXEmitterVerticalProperties) int PacketsPerPhysXParticleSystemMax;
    var(PhysXEmitterVerticalProperties) float SpawnLodVsFifoBias;
    var(PhysXEmitterVerticalProperties) bool bDisableLod;
    var(PhysXEmitterVerticalProperties) bool bApplyCylindricalPacketCulling;
    
    structdefaultproperties
    {
        ParticlesLodMax = 15000
        PacketsPerPhysXParticleSystemMax = 500
        SpawnLodVsFifoBias = 1.0
        bApplyCylindricalPacketCulling = TRUE
    }
};
struct native ApexModuleDestructibleSettings 
{
    var(ApexModuleDestructibleSettings) int MaxChunkIslandCount;
    var(ApexModuleDestructibleSettings) int MaxRrbActorCount;
    var(ApexModuleDestructibleSettings) float MaxChunkSeparationLOD;
    
    structdefaultproperties
    {
        MaxChunkIslandCount = 500
        MaxRrbActorCount = 10000
        MaxChunkSeparationLOD = 0.5
    }
};
struct native PhysXSceneProperties 
{
    var(PhysXSceneProperties) PhysXSimulationProperties PrimaryScene;
    var(PhysXSceneProperties) PhysXSimulationProperties CompartmentRigidBody;
    var(PhysXSceneProperties) PhysXSimulationProperties CompartmentFluid;
    var(PhysXSceneProperties) PhysXSimulationProperties CompartmentCloth;
    var(PhysXSceneProperties) PhysXSimulationProperties CompartmentSoftBody;
    
    structdefaultproperties
    {
        CompartmentRigidBody = {TimeStep = 0.0199999996, MaxSubSteps = 2, bUseHardware = FALSE, bFixedTimeStep = FALSE}
        CompartmentFluid = {TimeStep = 0.0199999996, MaxSubSteps = 1, bUseHardware = TRUE, bFixedTimeStep = FALSE}
        CompartmentCloth = {TimeStep = 0.0199999996, MaxSubSteps = 2, bUseHardware = TRUE, bFixedTimeStep = TRUE}
        CompartmentSoftBody = {TimeStep = 0.0199999996, MaxSubSteps = 2, bUseHardware = TRUE, bFixedTimeStep = TRUE}
    }
};
struct native PhysXSimulationProperties 
{
    var(PhysXSimulationProperties) float TimeStep;
    var(PhysXSimulationProperties) int MaxSubSteps;
    var(PhysXSimulationProperties) bool bUseHardware;
    var(PhysXSimulationProperties) bool bFixedTimeStep;
    
    structdefaultproperties
    {
        TimeStep = 0.0199999996
        MaxSubSteps = 5
    }
};
struct native CompartmentRunList 
{
    var(CompartmentRunList) bool RigidBody;
    var(CompartmentRunList) bool Fluid;
    var(CompartmentRunList) bool Cloth;
    var(CompartmentRunList) bool SoftBody;
    
    structdefaultproperties
    {
        RigidBody = TRUE
        Fluid = TRUE
        Cloth = TRUE
        SoftBody = TRUE
    }
};
struct native NetViewer 
{
    var Vector ViewLocation;
    var Vector ViewDir;
    var PlayerController InViewer;
    var Actor Viewer;
};
enum ENetMode
{
    NM_Standalone,
    NM_DedicatedServer,
    NM_ListenServer,
    NM_Client,
};

var transient Double LastTimeUnbuiltLightingWasEncountered;
var(WorldInfo) config PostProcessSettings DefaultPostProcessSettings;
var transient native Map_Mirror ScreenMessages;
var transient native array<ScreenMessageString> PriorityScreenMessages;
var const transient noimport array<PortalVolume> PortalVolumes;
var const transient noimport array<EnvironmentVolume> EnvironmentVolumes;
var(WorldInfo) const editconst array<LevelStreaming> StreamingLevels;
var array<string> DeferredExecs;
var string ComputerName;
var string EngineVersion;
var string MinNetVersion;
var const array<NetViewer> ReplicationViewers;
var string NextURL;
var(WorldInfo) array<Class<GameInfo>> GameTypesSupportedOnThisMap;
var const editconst array<Object> ClientDestroyedActorContent;
var const transient array<Name> PreparingLevelNames;
var(WorldInfo) const localized string Title;
var(WorldInfo) string Author;
var globalconfig string EmitterPoolClassPath;
var globalconfig string DecalManagerClassPath;
var globalconfig string FractureManagerClassPath;
var globalconfig string ParticleEventManagerClassPath;
var(Physics) array<CompartmentRunList> CompartmentRunFrames;
var native Object NavMeshPathConstraintCache;
var native Object NavMeshPathGoalEvaluatorCache;
var(Physics) PhysXSceneProperties PhysicsProperties;
var(WorldInfo) config InteriorSettings DefaultAmbientZoneSettings;
var transient MusicTrackStruct CurrentMusicTrack;
var transient repnotify MusicTrackStruct ReplicatedMusicTrack;
var(Physics) PhysXVerticalProperties VerticalProperties;
var(WorldInfo) config ReverbSettings DefaultReverbSettings;
var(WorldInfo) Vector DefaultColorScale;
var(APEX) ApexModuleDestructibleSettings DestructibleSettings;
var Name WaitForStartKey;
var const transient Name CommittedPersistentLevelName;
var(WorldInfo) config float SquintModeKernelSize;
var const transient noimport PostProcessVolume HighestPriorityPostProcessVolume;
var const transient noimport ReverbVolume HighestPriorityReverbVolume;
var float TimeDilation;
var float DemoPlayTimeDilation;
var float TimeSeconds;
var float GameTimeSeconds;
var float RealTimeSeconds;
var float AudioTimeSeconds;
var const transient float DeltaSeconds;
var transient float PauseDelay;
var transient float RealTimeToUnPause;
var PlayerReplicationInfo Pauser;
var Texture2D DefaultTexture;
var Texture2D WireframeTexture;
var Texture2D WhiteSquareTexture;
var Texture2D LargeVertex;
var Texture2D BSPVertex;
var transient GameReplicationInfo GRI;
var GameInfo Game;
var(WorldInfo) float StallZ;
var transient float WorldGravityZ;
var const globalconfig float DefaultGravityZ;
var(WorldInfo) float GlobalGravityZ;
var globalconfig float RBPhysicsGravityScaling;
var const transient NavigationPoint NavigationPointList;
var const Controller ControllerList;
var const Pawn PawnList;
var const transient CoverLink CoverList;
var const transient Pylon PylonList;
var transient Projectile ProjectileList;
var float MoveRepSize;
var float NextSwitchCountdown;
var(WorldInfo) int PackedLightAndShadowMapTextureSize;
var ObjectReferencer PersistentMapForcedObjects;
var editinline transient export AudioComponent MusicComp;
var transient EmitterPool MyEmitterPool;
var transient DecalManager MyDecalManager;
var transient FractureManager MyFractureManager;
var transient ParticleEventManager MyParticleEventManager;
var(Physics) float MaxPhysicsDeltaTime;
var config int MaxPhysicsSubsteps;
var(Physics) float DefaultSkinWidth;
var(Physics) float ApexLODResourceBudget;
var PhysicsLODVerticalEmitter EmitterVertical;
var PhysicsLODVerticalDestructible DestructibleVertical;
var transient float m_fInputLockTimer;
var config float ParticleLODDistanceMultiplayerBias;
var(Fracture) config float ChanceOfPhysicsChunkOverride;
var(Fracture) config float MaxExplosionChunkSize;
var(Fracture) config float MaxDamageChunkSize;
var(Fracture) config float FractureExplosionVelScale;
var(Fracture) int MaxNumFacturedChunksToSpawnInAFrame;
var transient int NumFacturedChunksSpawnedThisFrame;
var config float FracturedMeshWeaponDamage;
var(Rendering) float CharacterLightingContrastFactor;
var CrowdPopulationManagerBase PopulationManager;
var(WorldInfo) export MapInfo MyMapInfo;
var(WorldInfo) config bool bPersistPostProcessToNextLevel;
var transient bool bStreamingLevelsModified;
var transient bool bWaitingForStreamingLoadIdle;
var transient bool bWaitingForStreamingLoadVisibleComplete;
var bool bMapNeedsLightingFullyRebuilt;
var bool bMapHasDLEsOutsideOfImportanceVolume;
var bool bMapHasMultipleDominantLightsAffectingOnePrimitive;
var bool bMapHasPathingErrors;
var bool bRequestedBlockOnAsyncLoading;
var bool bBegunPlay;
var bool bPlayersOnly;
var bool bPlayersOnlyPending;
var transient bool bDropDetail;
var transient bool bAggressiveLOD;
var bool bStartup;
var bool bPathsRebuilt;
var bool bHasPathNodes;
var(WorldInfo) const bool bIsMenuLevel;
var const transient bool bIsLobbyLevel;
var const transient bool bIsUIWorld;
var transient bool bUseConsoleInput;
var(WorldInfo) bool bNoDefaultInventoryForPlayer;
var(WorldInfo) bool bNoPathWarnings;
var bool bHighPriorityLoading;
var bool bHighPriorityLoadingLocal;
var(ProcBuildings) bool bUseProcBuildingRulesetOverride;
var(Physics) bool bSupportDoubleBufferedPhysics;
var config transient bool bShowDebugText;
var(Fracture) config bool bEnableChanceOfPhysicsChunkOverride;
var(Fracture) config bool bLimitExplosionChunkSize;
var(Fracture) config bool bLimitDamageChunkSize;
var(Rendering) bool bAllowModulateBetterShadows;
var(Rendering) bool bAllowLightEnvSphericalHarmonicLights;
var(Rendering) bool bIncreaseFogNearPrecision;
var ENetMode NetMode;
var ETravelType NextTravelType;

public final native function AddOnScreenDebugMessage(int Key, float TimeToDisplay, Color DisplayColor, string DebugMessage);

public final iterator native function AllControllers(Class<Controller> BaseClass, out Controller C);

public final iterator native function AllNavigationPoints(Class<NavigationPoint> BaseClass, out NavigationPoint N);

public final iterator native function AllPawns(Class<Pawn> BaseClass, out Pawn P, optional Vector TestLocation, optional float TestRadius);

public final native function CancelPendingMapChange();

public final native function CommitMapChange();

public final simulated native function DelayGarbageCollection();

public final native function DoMemoryTracking();

public final native function EnvironmentVolume FindEnvironmentVolume(Vector TestLocation);

public final simulated native function ForceGarbageCollection(optional bool bFullPurge);

public simulated native function string GetAddressURL();

public final simulated native function array<Sequence> GetAllRootSequences();

public final native function GetDemoFrameInfo(optional out int CurrentFrame, optional out int TotalFrames);

public final native function bool GetDemoRewindPoints(out array<int> OutRewindPoints);

public final native function EDetailMode GetDetailMode();

public final simulated native function Sequence GetGameSequence();

public native function float GetGravityZ();

public final native function bool GetInputLock(float fDuration);

public simulated native function string GetLocalURL();

public final native function MapInfo GetMapInfo();

public final native function string GetMapName(optional bool bIncludePrefix);

public native function NavMeshPathConstraint GetNavMeshPathConstraintFromCache(Class<NavMeshPathConstraint> ConstraintClass, NavigationHandle Requestor);

public native function NavMeshPathGoalEvaluator GetNavMeshPathGoalEvaluatorFromCache(Class<NavMeshPathGoalEvaluator> GoalEvalClass, NavigationHandle Requestor);

public final native function WorldFractureSettings GetWorldFractureSettings();

public static final native function WorldInfo GetWorldInfo();

public static final simulated native function bool IsConsoleBuild(optional EConsoleType ConsoleType);

public static final simulated native function bool IsDemoBuild();

public static final simulated native function bool IsFinalReleaseDebugConsoleBuild();

public final native function bool IsInSeamlessTravel();

public final native function bool IsMapChangeReady();

public static final native function bool IsMenuLevel(optional string MapName);

public static final simulated native function bool IsPlayInEditor();

public final native function bool IsPlayingDemo();

public final native function bool IsPreparingMapChange();

public final native function bool IsRecordingDemo();

public static final simulated native function bool IsShippingPCBuild();

public final native function NavigationPointCheck(Vector Point, Vector Extent, optional out array<NavigationPoint> Navs, optional out array<ReachSpec> Specs);

public final native function NotifyMatchStarted(optional bool bShouldActivateLevelStartupEvents = TRUE, optional bool bShouldActivateLevelBeginningEvents = TRUE, optional bool bShouldActivateLevelLoadedEvents = FALSE);

public function PauseGame(bool bPause)
{
    bPlayersOnly = bPause;
}
public simulated function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    if (IsConsoleBuild())
    {
        bUseConsoleInput = TRUE;
    }
}
public simulated function PreBeginPlay()
{
    local Class<EmitterPool> PoolClass;
    local Class<DecalManager> DecalManagerClass;
    local Class<FractureManager> FractureManagerClass;
    local Class<ParticleEventManager> ParticleEventManagerClass;
    
    Super(Actor).PreBeginPlay();
    if (WorldInfo.NetMode != ENetMode.NM_DedicatedServer && IsInPersistentLevel())
    {
        if (EmitterPoolClassPath != "")
        {
            PoolClass = Class<EmitterPool>(DynamicLoadObject(EmitterPoolClassPath, Class'Class'));
            if (PoolClass != None)
            {
                MyEmitterPool = Spawn(PoolClass, Self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0));
            }
        }
        if (DecalManagerClassPath != "")
        {
            DecalManagerClass = Class<DecalManager>(DynamicLoadObject(DecalManagerClassPath, Class'Class'));
            if (DecalManagerClass != None)
            {
                MyDecalManager = Spawn(DecalManagerClass, Self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0));
            }
        }
        if (FractureManagerClassPath != "")
        {
            FractureManagerClass = Class<FractureManager>(DynamicLoadObject(FractureManagerClassPath, Class'Class'));
            if (FractureManagerClass != None)
            {
                MyFractureManager = Spawn(FractureManagerClass, Self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0));
            }
        }
        if (ParticleEventManagerClassPath != "")
        {
            ParticleEventManagerClass = Class<ParticleEventManager>(DynamicLoadObject(ParticleEventManagerClassPath, Class'Class'));
            if (ParticleEventManagerClass != None)
            {
                MyParticleEventManager = Spawn(ParticleEventManagerClass, Self, , vect(0.0, 0.0, 0.0), rot(0, 0, 0));
            }
        }
    }
}
public final native function PrepareMapChange(const out array<Name> LevelNames);

public final iterator native function RadiusNavigationPoints(Class<NavigationPoint> BaseClass, out NavigationPoint N, Vector Point, float Radius);

public native function ReleaseCachedConstraintsAndEvaluators();

public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ReplicatedMusicTrack')
    {
        UpdateMusicTrack(ReplicatedMusicTrack);
    }
    Super(Actor).ReplicatedEvent(VarName);
}
public final simulated native function RescheduleGarbageCollectionTimer(float maxdelay);

public function Reset()
{
    Super(Actor).Reset();
}
public final native function SeamlessTravel(string URL, optional bool bAbsolute, optional init Guid MapPackageGuid);

public event simulated function ServerTravel(string URL, optional bool bAbsolute, optional bool bShouldSkipGameNotify)
{
    if (InStr(URL, "%", , , ) >= 0)
    {
        return;
    }
    if (InStr(URL, ":", , , ) >= 0 || InStr(URL, "/", , , ) >= 0 || InStr(URL, "\\", , , ) >= 0)
    {
        return;
    }
    if (Game != None && Game.bHasNetworkError)
    {
        return;
    }
    NextTravelType = bAbsolute ? ETravelType.TRAVEL_Absolute : ETravelType.TRAVEL_Relative;
    if (NextURL == "" && (!IsInSeamlessTravel() || bShouldSkipGameNotify))
    {
        NextURL = URL;
        if (Game != None)
        {
            if (!bShouldSkipGameNotify)
            {
                Game.ProcessServerTravel(URL, bAbsolute);
            }
        }
        else
        {
            NextSwitchCountdown = 0.0;
        }
    }
}
public final native function SetLevelRBGravity(Vector NewGrav);

public final native function SetMapInfo(MapInfo NewMapInfo);

public final native function SetSeamlessTravelMidpointPause(bool bNowPaused);

public final native function UpdateMusicTrack(MusicTrackStruct NewMusicTrack);

public final simulated native function VerifyNavList();

public simulated function Class<GameInfo> GetGameClass()
{
    if (WorldInfo.Game != None)
    {
        return WorldInfo.Game.Class;
    }
    if (GRI != None && GRI.GameClass != None)
    {
        return GRI.GameClass;
    }
    return None;
}
public function ThisIsNeverExecuted(DefaultPhysicsVolume P)
{
    P = None;
}

//Replication conditions for this class are native. This block has no effect
replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        ReplicatedMusicTrack, TimeDilation, Pauser, WorldGravityZ, bHighPriorityLoading;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=PhysicsLODVerticalDestructible Name=PhysicsLODVerticalDestructible0
    End Object
    Begin Object Class=PhysicsLODVerticalEmitter Name=PhysicsLODVerticalEmitter0
    End Object
    DefaultPostProcessSettings = {
                                  ColorGradingLUT = {
                                                     LUTTextures = (), 
                                                     LUTWeights = ()
                                                    }, 
                                  RimShader_Color = {R = 0.47044, G = 0.585973024, B = 0.827726007, A = 1.0}, 
                                  DOF_FocusPosition = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                  Scene_HighLights = {X = 1.0, Y = 1.0, Z = 1.0}, 
                                  Scene_MidTones = {X = 1.0, Y = 1.0, Z = 1.0}, 
                                  Scene_Shadows = {X = 0.0, Y = 0.0, Z = 0.0}, 
                                  Bloom_Scale = 1.0, 
                                  Bloom_Threshold = 1.0, 
                                  Bloom_Tint = {B = 255, G = 255, R = 255, A = 0}, 
                                  Bloom_ScreenBlendThreshold = 10.0, 
                                  Bloom_InterpolationDuration = 1.0, 
                                  DOF_FalloffExponent = 4.0, 
                                  DOF_BlurKernelSize = 16.0, 
                                  DOF_BlurBloomKernelSize = 16.0, 
                                  DOF_MaxNearBlurAmount = 1.0, 
                                  DOF_MaxFarBlurAmount = 1.0, 
                                  DOF_ModulateBlurColor = {B = 255, G = 255, R = 255, A = 255}, 
                                  DOF_FocusInnerRadius = 2000.0, 
                                  DOF_FocusDistance = 0.0, 
                                  DOF_InterpolationDuration = 1.0, 
                                  MotionBlur_MaxVelocity = 1.0, 
                                  MotionBlur_Amount = 0.5, 
                                  MotionBlur_CameraRotationThreshold = 45.0, 
                                  MotionBlur_CameraTranslationThreshold = 10000.0, 
                                  MotionBlur_InterpolationDuration = 1.0, 
                                  Scene_Desaturation = 0.0, 
                                  Scene_InterpolationDuration = 1.0, 
                                  RimShader_InterpolationDuration = 1.0, 
                                  ColorGrading_LookupTable = None, 
                                  PP_DesaturationMultiplier = 0.0, 
                                  PP_HighlightsMultiplier = 1.0, 
                                  PP_MidTonesMultiplier = 1.0, 
                                  PP_ShadowsMultiplier = 0.0, 
                                  bOverride_EnableBloom = TRUE, 
                                  bOverride_EnableDOF = TRUE, 
                                  bOverride_EnableMotionBlur = TRUE, 
                                  bOverride_EnableSceneEffect = TRUE, 
                                  bOverride_AllowAmbientOcclusion = TRUE, 
                                  bOverride_OverrideRimShaderColor = TRUE, 
                                  bOverride_Bloom_Scale = TRUE, 
                                  bOverride_Bloom_Threshold = TRUE, 
                                  bOverride_Bloom_Tint = TRUE, 
                                  bOverride_Bloom_ScreenBlendThreshold = TRUE, 
                                  bOverride_Bloom_InterpolationDuration = TRUE, 
                                  bOverride_DOF_FalloffExponent = TRUE, 
                                  bOverride_DOF_BlurKernelSize = TRUE, 
                                  bOverride_DOF_BlurBloomKernelSize = TRUE, 
                                  bOverride_DOF_MaxNearBlurAmount = TRUE, 
                                  bOverride_DOF_MaxFarBlurAmount = TRUE, 
                                  bOverride_DOF_ModulateBlurColor = TRUE, 
                                  bOverride_DOF_FocusType = TRUE, 
                                  bOverride_DOF_FocusInnerRadius = TRUE, 
                                  bOverride_DOF_FocusDistance = TRUE, 
                                  bOverride_DOF_FocusPosition = TRUE, 
                                  bOverride_DOF_InterpolationDuration = TRUE, 
                                  bOverride_MotionBlur_MaxVelocity = TRUE, 
                                  bOverride_MotionBlur_Amount = TRUE, 
                                  bOverride_MotionBlur_FullMotionBlur = TRUE, 
                                  bOverride_MotionBlur_CameraRotationThreshold = TRUE, 
                                  bOverride_MotionBlur_CameraTranslationThreshold = TRUE, 
                                  bOverride_MotionBlur_InterpolationDuration = TRUE, 
                                  bOverride_Scene_Desaturation = TRUE, 
                                  bOverride_Scene_HighLights = TRUE, 
                                  bOverride_Scene_MidTones = TRUE, 
                                  bOverride_Scene_Shadows = TRUE, 
                                  bOverride_Scene_InterpolationDuration = TRUE, 
                                  bOverride_RimShader_Color = TRUE, 
                                  bOverride_RimShader_InterpolationDuration = TRUE, 
                                  bEnableBloom = TRUE, 
                                  bEnableDOF = FALSE, 
                                  bEnableMotionBlur = TRUE, 
                                  bEnableSceneEffect = TRUE, 
                                  bAllowAmbientOcclusion = TRUE, 
                                  bOverrideRimShaderColor = FALSE, 
                                  bOverride_EnableFilmic = TRUE, 
                                  bEnableFilmic = TRUE, 
                                  bOverride_EnableVignette = TRUE, 
                                  bEnableVignette = TRUE, 
                                  bOverride_EnableFilmGrain = TRUE, 
                                  bEnableFilmGrain = TRUE, 
                                  MotionBlur_FullMotionBlur = TRUE, 
                                  DOF_FocusType = EFocusType.FOCUS_Distance
                                 }
    EmitterPoolClassPath = "Engine.EmitterPool"
    DecalManagerClassPath = "Engine.DecalManager"
    FractureManagerClassPath = "Engine.FractureManager"
    PhysicsProperties = {
                         PrimaryScene = {TimeStep = 0.0199999996, MaxSubSteps = 5, bUseHardware = FALSE, bFixedTimeStep = FALSE}, 
                         CompartmentRigidBody = {TimeStep = 0.0199999996, MaxSubSteps = 2, bUseHardware = FALSE, bFixedTimeStep = FALSE}, 
                         CompartmentFluid = {TimeStep = 0.0199999996, MaxSubSteps = 1, bUseHardware = TRUE, bFixedTimeStep = FALSE}, 
                         CompartmentCloth = {TimeStep = 0.0199999996, MaxSubSteps = 2, bUseHardware = TRUE, bFixedTimeStep = TRUE}, 
                         CompartmentSoftBody = {TimeStep = 0.0199999996, MaxSubSteps = 2, bUseHardware = TRUE, bFixedTimeStep = TRUE}
                        }
    DefaultAmbientZoneSettings = {
                                  ExteriorVolume = 1.0, 
                                  ExteriorTime = 0.5, 
                                  ExteriorLPF = 1.0, 
                                  ExteriorLPFTime = 0.5, 
                                  InteriorVolume = 1.0, 
                                  InteriorTime = 0.5, 
                                  InteriorLPF = 1.0, 
                                  InteriorLPFTime = 0.5, 
                                  bIsWorldInfo = TRUE
                                 }
    CurrentMusicTrack = {
                         TheSoundCue = None, 
                         FadeInTime = 5.0, 
                         FadeInVolumeLevel = 1.0, 
                         FadeOutTime = 5.0, 
                         FadeOutVolumeLevel = 0.0, 
                         bAutoPlay = FALSE, 
                         bPersistentAcrossLevels = FALSE
                        }
    ReplicatedMusicTrack = {
                            TheSoundCue = None, 
                            FadeInTime = 5.0, 
                            FadeInVolumeLevel = 1.0, 
                            FadeOutTime = 5.0, 
                            FadeOutVolumeLevel = 0.0, 
                            bAutoPlay = FALSE, 
                            bPersistentAcrossLevels = FALSE
                           }
    VerticalProperties = {
                          Emitters = {
                                      ParticlesLodMin = 0, 
                                      ParticlesLodMax = 15000, 
                                      PacketsPerPhysXParticleSystemMax = 500, 
                                      SpawnLodVsFifoBias = 1.0, 
                                      bDisableLod = FALSE, 
                                      bApplyCylindricalPacketCulling = TRUE
                                     }
                         }
    DefaultReverbSettings = {Volume = 0.5, FadeTime = 2.0, bApplyReverb = TRUE, ReverbType = ReverbPreset.REVERB_Default}
    DefaultColorScale = {X = 1.0, Y = 1.0, Z = 1.0}
    DestructibleSettings = {MaxChunkIslandCount = 500, MaxRrbActorCount = 10000, MaxChunkSeparationLOD = 0.5}
    SquintModeKernelSize = 128.0
    TimeDilation = 1.0
    DemoPlayTimeDilation = 1.0
    DefaultTexture = Texture2D'EngineResources.DefaultTexture'
    WhiteSquareTexture = Texture2D'EngineResources.WhiteSquareTexture'
    StallZ = 1000000.0
    DefaultGravityZ = -981.0
    RBPhysicsGravityScaling = 1.0
    MoveRepSize = 42.0
    PackedLightAndShadowMapTextureSize = 1024
    MaxPhysicsDeltaTime = 0.333333343
    MaxPhysicsSubsteps = 5
    DefaultSkinWidth = 0.0250000004
    ApexLODResourceBudget = 25000.0
    EmitterVertical = PhysicsLODVerticalEmitter0
    DestructibleVertical = PhysicsLODVerticalDestructible0
    ParticleLODDistanceMultiplayerBias = 2000.0
    ChanceOfPhysicsChunkOverride = 1.0
    FractureExplosionVelScale = 1.0
    MaxNumFacturedChunksToSpawnInAFrame = 12
    FracturedMeshWeaponDamage = 1.0
    CharacterLightingContrastFactor = 1.5
    bPersistPostProcessToNextLevel = TRUE
    bWaitingForStreamingLoadIdle = TRUE
    bWaitingForStreamingLoadVisibleComplete = TRUE
    bShowDebugText = TRUE
    bAllowModulateBetterShadows = TRUE
    bAllowLightEnvSphericalHarmonicLights = TRUE
    bIncreaseFogNearPrecision = TRUE
    NextTravelType = ETravelType.TRAVEL_Relative
    Components = ()
    bWorldGeometry = TRUE
    bAlwaysRelevant = TRUE
    bMovable = FALSE
    bBlockActors = TRUE
    bHiddenEd = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}