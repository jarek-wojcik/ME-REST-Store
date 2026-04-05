Class Engine extends Subsystem
    native
    abstract
    transient
    config(Engine);

struct native DropNoteInfo 
{
    var string Comment;
    var Vector location;
    var Rotator Rotation;
};
enum ETransitionType
{
    TT_None,
    TT_Paused,
    TT_Loading,
    TT_Saving,
    TT_Connecting,
    TT_Precaching,
};
struct native BioLayerDetails 
{
    var string Prefix;
    var string Description;
    var Color Color;
};
struct native StatColorMapping 
{
    var globalconfig string StatName;
    var globalconfig array<StatColorMapEntry> ColorMap;
    var globalconfig bool DisableBlend;
};
struct native StatColorMapEntry 
{
    var globalconfig float In;
    var globalconfig Color Out;
};
enum EBioUnTexCompressSetting
{
    BioTCS_NvTT_NoCuda,
    BioTCS_NvTT_Cuda,
};

var globalconfig string TinyFontName;
var globalconfig string SmallFontName;
var globalconfig string MediumFontName;
var globalconfig string LargeFontName;
var globalconfig string SubtitleFontName;
var array<Font> AdditionalFonts;
var globalconfig array<string> AdditionalFontNames;
var globalconfig string ConsoleClassName;
var globalconfig string GameViewportClientClassName;
var globalconfig string DataStoreClientClassName;
var config string LocalPlayerClassName;
var globalconfig string DefaultMaterialName;
var globalconfig string DefaultDecalMaterialName;
var globalconfig string DefaultTextureName;
var globalconfig string WireframeMaterialName;
var globalconfig string EmissiveTexturedMaterialName;
var globalconfig string GeomMaterialName;
var globalconfig string DefaultFogVolumeMaterialName;
var globalconfig string TickMaterialName;
var globalconfig string CrossMaterialName;
var globalconfig string VisColorationMaterialInChunkName;
var globalconfig string VisColorationMaterialLoadChunkName;
var globalconfig string VisColorationMaterialVisibleChunkName;
var globalconfig string VisColorationMaterialMasterMapName;
var globalconfig string VisColorationMaterialUnloadedName;
var globalconfig string BioColorChunkMaterialName;
var globalconfig string BioTranslucentVolumeMaterialName;
var globalconfig string LevelColorationLitMaterialName;
var globalconfig string LevelColorationUnlitMaterialName;
var globalconfig string LightingTexelDensityName;
var globalconfig string ShadedLevelColorationLitMaterialName;
var globalconfig string ShadedLevelColorationUnlitMaterialName;
var globalconfig string RemoveSurfaceMaterialName;
var globalconfig string VertexColorMaterialName;
var globalconfig string VertexColorViewModeMaterialName_ColorOnly;
var globalconfig string VertexColorViewModeMaterialName_AlphaAsColor;
var globalconfig string VertexColorViewModeMaterialName_RedOnly;
var globalconfig string VertexColorViewModeMaterialName_GreenOnly;
var globalconfig string VertexColorViewModeMaterialName_BlueOnly;
var globalconfig string HeatmapMaterialName;
var globalconfig string BoneWeightMaterialName;
var globalconfig string TangentColorMaterialName;
var globalconfig string ProcBuildingSimpleMaterialName;
var globalconfig string BuildingQuadStaticMeshName;
var globalconfig array<Color> LightComplexityColors;
var globalconfig array<LinearColor> ShaderComplexityColors;
var globalconfig array<StatColorMapping> StatColorMappings;
var globalconfig string EditorBrushMaterialName;
var globalconfig string DefaultPhysMaterialName;
var globalconfig string TerrainErrorMaterialName;
var globalconfig string DefaultOnlineSubsystemName;
var config string DefaultPostProcessName;
var config string ThumbnailSkeletalMeshPostProcessName;
var config string ThumbnailParticleSystemPostProcessName;
var config string ThumbnailMaterialPostProcessName;
var config string DefaultUIScenePostProcessName;
var globalconfig string DefaultUICaretMaterialName;
var globalconfig string SceneCaptureReflectActorMaterialName;
var globalconfig string SceneCaptureCubeActorMaterialName;
var globalconfig string ScreenDoorNoiseTextureName;
var globalconfig string RandomAngleTextureName;
var globalconfig string RandomNormalTextureName;
var globalconfig string RandomNormalTextureName2;
var globalconfig string WeightMapPlaceholderTextureName;
var globalconfig string LightMapDensityTextureName;
var globalconfig string LightMapDensityNormalName;
var globalconfig string DefaultSoundName;
var init array<LocalPlayer> GamePlayers;
var init array<string> DeferredCommands;
var init array<string> NextFrameDeferredCommands;
var const config string ScoutClassName;
var config array<BioLayerDetails> m_BioLayerDetails;
var string TransitionDescription;
var string TransitionGameType;
var transient array<DropNoteInfo> PendingDroppedNotes;
var globalconfig string DynamicCoverMeshComponentName;
var globalconfig array<Name> IgnoreSimulatedFuncWarnings;
var Class<Console> ConsoleClass;
var Class<GameViewportClient> GameViewportClientClass;
var Class<DataStoreClient> DataStoreClientClass;
var Class<LocalPlayer> LocalPlayerClass;
var Class<OnlineSubsystem> OnlineSubsystemClass;
var native Pointer RemoteControlExec;
var native Pointer MobileMaterialEmulator;
var globalconfig LinearColor LightingOnlyBrightness;
var globalconfig LinearColor LightMapDensityVertexMappedColor;
var globalconfig LinearColor LightMapDensitySelectedColor;
var globalconfig LinearColor DefaultSelectedMaterialColor;
var transient LinearColor SelectedMaterialColor;
var transient LinearColor UnselectedMaterialColor;
var Font TinyFont;
var Font SmallFont;
var Font MediumFont;
var Font LargeFont;
var Font SubtitleFont;
var Material DefaultMaterial;
var Material DefaultDecalMaterial;
var Texture DefaultTexture;
var Material WireframeMaterial;
var Material EmissiveTexturedMaterial;
var Material GeomMaterial;
var Material DefaultFogVolumeMaterial;
var Material TickMaterial;
var Material CrossMaterial;
var Material VisColorationMaterialInChunk;
var Material VisColorationMaterialLoadChunk;
var Material VisColorationMaterialVisibleChunk;
var Material VisColorationMaterialMasterMap;
var Material VisColorationMaterialUnloaded;
var Material BioColorChunkMaterial;
var Material BioTranslucentVolumeMaterial;
var Material LevelColorationLitMaterial;
var Material LevelColorationUnlitMaterial;
var Material LightingTexelDensityMaterial;
var Material ShadedLevelColorationLitMaterial;
var Material ShadedLevelColorationUnlitMaterial;
var Material RemoveSurfaceMaterial;
var Material VertexColorMaterial;
var Material VertexColorViewModeMaterial_ColorOnly;
var Material VertexColorViewModeMaterial_AlphaAsColor;
var Material VertexColorViewModeMaterial_RedOnly;
var Material VertexColorViewModeMaterial_GreenOnly;
var Material VertexColorViewModeMaterial_BlueOnly;
var Material HeatmapMaterial;
var Material BoneWeightMaterial;
var Material TangentColorMaterial;
var Material ProcBuildingSimpleMaterial;
var StaticMesh BuildingQuadStaticMesh;
var globalconfig float ProcBuildingLODColorTexelsPerWorldUnit;
var globalconfig float ProcBuildingLODLightingTexelsPerWorldUnit;
var globalconfig int MaxProcBuildingLODColorTextureSize;
var globalconfig int MaxProcBuildingLODLightingTextureSize;
var globalconfig float MaxRMSDForCombiningMappings;
var globalconfig float MaxPixelShaderAdditiveComplexityCount;
var globalconfig float MinTextureDensity;
var globalconfig float IdealTextureDensity;
var globalconfig float MaxTextureDensity;
var globalconfig float MinLightMapDensity;
var globalconfig float IdealLightMapDensity;
var globalconfig float MaxLightMapDensity;
var globalconfig float RenderLightMapDensityGrayscaleScale;
var globalconfig float RenderLightMapDensityColorScale;
var Material EditorBrushMaterial;
var PhysicalMaterial DefaultPhysMaterial;
var Material TerrainErrorMaterial;
var globalconfig int TerrainMaterialMaxTextureCount;
var globalconfig int TerrainTessellationCheckCount;
var globalconfig float TerrainTessellationCheckDistance;
var PostProcessChain DefaultPostProcess;
var PostProcessChain ThumbnailSkeletalMeshPostProcess;
var PostProcessChain ThumbnailParticleSystemPostProcess;
var PostProcessChain ThumbnailMaterialPostProcess;
var PostProcessChain DefaultUIScenePostProcess;
var Material DefaultUICaretMaterial;
var Material SceneCaptureReflectActorMaterial;
var Material SceneCaptureCubeActorMaterial;
var Texture2D ScreenDoorNoiseTexture;
var Texture2D RandomAngleTexture;
var Texture2D RandomNormalTexture;
var Texture2D RandomNormalTexture2;
var Texture WeightMapPlaceholderTexture;
var Texture2D LightMapDensityTexture;
var Texture2D LightMapDensityNormal;
var SoundNodeWave DefaultSound;
var(Settings) config float TimeBetweenPurgingPendingKillObjects;
var const Client Client;
var const GameViewportClient GameViewport;
var int TickCycles;
var int GameCycles;
var int ClientCycles;
var config float MaxSmoothedFrameRate;
var config float MinSmoothedFrameRate;
var const DebugManager DebugManager;
var(Colors) Color C_WorldBox;
var(Colors) Color C_BrushWire;
var(Colors) Color C_AddWire;
var(Colors) Color C_SubtractWire;
var(Colors) Color C_SemiSolidWire;
var(Colors) Color C_NonSolidWire;
var(Colors) Color C_WireBackground;
var(Colors) Color C_ScaleBoxHi;
var(Colors) Color C_VolumeCollision;
var(Colors) Color C_BSPCollision;
var(Colors) Color C_OrthoBackground;
var(Colors) Color C_Volume;
var(Colors) Color C_BrushShape;
var(Settings) float StreamingDistanceFactor;
var config float MeshLODRange;
var config float CameraRotationThreshold;
var config float CameraTranslationThreshold;
var config float PrimitiveProbablyVisibleTime;
var config float PercentUnoccludedRequeries;
var config float MaxOcclusionPixelsFraction;
var config int MaxFluidNumVerts;
var config float FluidSimulationTimeLimit;
var config int MaxParticleResize;
var config int MaxParticleResizeWarn;
var config int MaxParticleVertexMemory;
var transient int MaxParticleSpriteCount;
var transient int MaxParticleSubUVCount;
var config int BeginUPTryCount;
var globalconfig float NetClientTicksPerSecond;
var globalconfig float MaxTrackedOcclusionIncrement;
var globalconfig float TrackedOcclusionStepSize;
var BioTestFramework m_pUnitTestFramework;
var config bool bEnableTranslucentHairPass;
var globalconfig bool UseProcBuildingLODTextureCropping;
var globalconfig bool ForcePowerOfTwoProcBuildingLODTextures;
var globalconfig bool bCombineSimilarMappings;
var globalconfig bool bRenderLightMapDensityGrayscale;
var transient bool bUseSound;
var(Settings) config bool bUseTextureStreaming;
var(Settings) config bool bUseBackgroundLevelStreaming;
var(Settings) config bool bSubtitlesEnabled;
var(Settings) config bool bSubtitlesForcedOff;
var config bool bSmoothFrameRate;
var globalconfig bool HACK_UseTickFrequency;
var globalconfig bool bShouldGenerateSimpleLightmaps;
var(Settings) config bool bForceStaticTerrain;
var config bool DisplayLazyLoadErrors;
var bool m_bSaveInitialized;
var config bool bForceCPUSkinning;
var config bool bUsePostProcessEffects;
var config bool bOnScreenKismetWarnings;
var config bool bEnableKismetLogging;
var config bool bAllowMatureLanguage;
var config bool bRenderTerrainCollisionAsOverlay;
var config bool bDisablePhysXHardwareSupport;
var config bool bPauseOnLossOfFocus;
var globalconfig bool bCheckParticleRenderSize;
var const globalconfig bool bEnableColorClear;
var transient bool bAreConstraintsDirty;
var transient bool bHasPendingGlobalReattach;
var transient bool bUseMobileEmulation;
var globalconfig bool bEnableOnScreenDebugMessages;
var transient bool bEnableOnScreenDebugMessagesDisplay;
var globalconfig bool bSuppressMapWarnings;
var globalconfig bool bCookSeparateSharedMPGameContent;
var globalconfig EBioUnTexCompressSetting BioUnTexCompressSetting;
var ETransitionType TransitionType;

public static final native function AddOverlay(Font Font, string Text, float X, float Y, float ScaleX, float ScaleY, bool bIsCentered);

public static final native function AddOverlayWrapped(Font Font, string Text, float X, float Y, float ScaleX, float ScaleY, float WrapWidth);

public native function BioShowDebugMessageBox(string sMessage);

public static final simulated native function FlushAsyncLoading();

public static final native function Font GetAdditionalFont(int AdditionalFontIndex);

public static final native function AudioDevice GetAudioDevice();

public static final native function string GetBuildDate();

public static final native function WorldInfo GetCurrentWorldInfo();

public static final native function Engine GetEngine();

public static final native function Font GetLargeFont();

public static final native function string GetLastMovieName();

public static final native function Font GetMediumFont();

public static final native function GetMemoryStatus(out int allocated, out int available);

public static final native function Font GetSmallFont();

public static final native function Font GetSubtitleFont();

public static final native function Font GetTinyFont();

public static final native function bool IsEditor();

public static final native function bool IsGame();

public static final native function bool IsShip();

public static final native function bool IsSplitScreen();

public static final native function bool PlayLoadMapMovie();

public static final native function RemoveAllOverlays();

public static final native function StopMovie(bool bDelayStopUntilGameHasRendered, optional bool bSFXForceStop = TRUE);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TinyFontName = "EngineFonts.TinyFont"
    SmallFontName = "EngineFonts.SmallFont"
    MediumFontName = "EngineFonts.MediumFont"
    LargeFontName = "EngineFonts.MediumFont"
    SubtitleFontName = "EngineFonts.SmallFont"
    ConsoleClassName = "SFXGame.SFXConsole"
    GameViewportClientClassName = "SFXGame.SFXGameViewportClient"
    DataStoreClientClassName = "Engine.DataStoreClient"
    LocalPlayerClassName = "SFXGame.SFXLocalPlayer"
    DefaultMaterialName = "EngineMaterials.DefaultMaterial"
    DefaultDecalMaterialName = "EngineMaterials.DefaultDecalMaterial"
    DefaultTextureName = "EngineMaterials.DefaultDiffuse"
    WireframeMaterialName = "EngineDebugMaterials.WireframeMaterial"
    EmissiveTexturedMaterialName = "EngineMaterials.EmissiveTexturedMaterial"
    GeomMaterialName = "EngineDebugMaterials.GeomMaterial"
    DefaultFogVolumeMaterialName = "EngineMaterials.FogVolumeMaterial"
    TickMaterialName = "EditorMaterials.Tick_Mat"
    CrossMaterialName = "EditorMaterials.Cross_Mat"
    VisColorationMaterialInChunkName = "BioEditorMaterials.VisColorationMaterialInChunk"
    VisColorationMaterialLoadChunkName = "BioEditorMaterials.VisColorationMaterialLoadChunk"
    VisColorationMaterialVisibleChunkName = "BioEditorMaterials.VisColorationMaterialVisibleChunk"
    VisColorationMaterialMasterMapName = "BioEditorMaterials.VisColorationMaterialMasterMap"
    VisColorationMaterialUnloadedName = "BioEditorMaterials.VisColorationMaterialUnloaded"
    BioColorChunkMaterialName = "BioEditorMaterials.DisabledChunkMat"
    BioTranslucentVolumeMaterialName = "BioEditorMaterials.BioTranslucentVolumeMaterial"
    LevelColorationLitMaterialName = "EngineDebugMaterials.LevelColorationLitMaterial"
    LevelColorationUnlitMaterialName = "EngineDebugMaterials.LevelColorationUnlitMaterial"
    LightingTexelDensityName = "EngineDebugMaterials.MAT_LevelColorationLitLightmapUVs"
    ShadedLevelColorationLitMaterialName = "EngineDebugMaterials.ShadedLevelColorationLitMaterial"
    ShadedLevelColorationUnlitMaterialName = "EngineDebugMaterials.ShadedLevelColorationUnlitMaterial"
    RemoveSurfaceMaterialName = "EngineMaterials.RemoveSurfaceMaterial"
    VertexColorMaterialName = "EngineDebugMaterials.VertexColorMaterial"
    VertexColorViewModeMaterialName_ColorOnly = "EngineDebugMaterials.VertexColorViewMode_ColorOnly"
    VertexColorViewModeMaterialName_AlphaAsColor = "EngineDebugMaterials.VertexColorViewMode_AlphaAsColor"
    VertexColorViewModeMaterialName_RedOnly = "EngineDebugMaterials.VertexColorViewMode_RedOnly"
    VertexColorViewModeMaterialName_GreenOnly = "EngineDebugMaterials.VertexColorViewMode_GreenOnly"
    VertexColorViewModeMaterialName_BlueOnly = "EngineDebugMaterials.VertexColorViewMode_BlueOnly"
    HeatmapMaterialName = "EngineDebugMaterials.HeatmapMaterial"
    BoneWeightMaterialName = "EngineDebugMaterials.BoneWeightMaterial"
    TangentColorMaterialName = "EngineDebugMaterials.TangentColorMaterial"
    ProcBuildingSimpleMaterialName = "EngineBuildings.ProcBuildingSimpleMaterial"
    BuildingQuadStaticMeshName = "EngineBuildings.BuildingQuadMesh"
    LightComplexityColors = ({B = 0, G = 0, R = 0, A = 1}, 
                             {B = 0, G = 255, R = 0, A = 1}, 
                             {B = 0, G = 191, R = 63, A = 1}, 
                             {B = 0, G = 127, R = 127, A = 1}, 
                             {B = 0, G = 63, R = 191, A = 1}, 
                             {B = 0, G = 0, R = 255, A = 1}
                            )
    ShaderComplexityColors = ({R = 0.0, G = 1.0, B = 0.127000004, A = 1.0}, 
                              {R = 0.0, G = 1.0, B = 0.0, A = 1.0}, 
                              {R = 0.0460000001, G = 0.519999981, B = 0.0, A = 1.0}, 
                              {R = 0.215000004, G = 0.215000004, B = 0.0, A = 1.0}, 
                              {R = 0.519999981, G = 0.0460000001, B = 0.0, A = 1.0}, 
                              {R = 0.699999988, G = 0.0, B = 0.0, A = 1.0}, 
                              {R = 1.0, G = 0.0, B = 0.0, A = 1.0}, 
                              {R = 1.0, G = 0.0, B = 0.5, A = 1.0}, 
                              {R = 1.0, G = 0.899999976, B = 0.899999976, A = 1.0}
                             )
    StatColorMappings = ({
                          StatName = "AverageFPS", 
                          ColorMap = ({
                                       In = 15.0, 
                                       Out = {B = 0, G = 0, R = 255, A = 0}
                                      }, 
                                      {
                                       In = 30.0, 
                                       Out = {B = 0, G = 255, R = 255, A = 0}
                                      }, 
                                      {
                                       In = 45.0, 
                                       Out = {B = 0, G = 255, R = 0, A = 0}
                                      }
                                     ), 
                          DisableBlend = FALSE
                         }, 
                         {
                          StatName = "Frametime", 
                          ColorMap = ({
                                       In = 1.0, 
                                       Out = {B = 0, G = 255, R = 0, A = 0}
                                      }, 
                                      {
                                       In = 25.0, 
                                       Out = {B = 0, G = 255, R = 0, A = 0}
                                      }, 
                                      {
                                       In = 29.0, 
                                       Out = {B = 0, G = 255, R = 255, A = 0}
                                      }, 
                                      {
                                       In = 33.0, 
                                       Out = {B = 0, G = 0, R = 255, A = 0}
                                      }
                                     ), 
                          DisableBlend = FALSE
                         }, 
                         {
                          StatName = "Streaming fudge factor", 
                          ColorMap = ({
                                       In = 0.0, 
                                       Out = {B = 0, G = 255, R = 0, A = 0}
                                      }, 
                                      {
                                       In = 1.0, 
                                       Out = {B = 0, G = 255, R = 0, A = 0}
                                      }, 
                                      {
                                       In = 2.5, 
                                       Out = {B = 0, G = 255, R = 255, A = 0}
                                      }, 
                                      {
                                       In = 5.0, 
                                       Out = {B = 0, G = 0, R = 255, A = 0}
                                      }, 
                                      {
                                       In = 10.0, 
                                       Out = {B = 0, G = 0, R = 255, A = 0}
                                      }
                                     ), 
                          DisableBlend = FALSE
                         }
                        )
    EditorBrushMaterialName = "EngineMaterials.EditorBrushMaterial"
    DefaultPhysMaterialName = "EngineMaterials.DefaultPhysicalMaterial"
    TerrainErrorMaterialName = "EngineDebugMaterials.MaterialError_Mat"
    DefaultOnlineSubsystemName = "SFXOnlineFoundation.SFXOnlineSubsystem"
    DefaultPostProcessName = "BioVFX_FB_RenderSyle.Final_RenderStyle.RenderStylePostProcess"
    ThumbnailSkeletalMeshPostProcessName = "EngineMaterials.DefaultThumbnailPostProcess"
    ThumbnailParticleSystemPostProcessName = "EngineMaterials.DefaultThumbnailPostProcess"
    ThumbnailMaterialPostProcessName = "EngineMaterials.DefaultThumbnailPostProcess"
    DefaultUICaretMaterialName = "EngineMaterials.BlinkingCaret"
    SceneCaptureReflectActorMaterialName = "EngineMaterials.ScreenMaterial"
    SceneCaptureCubeActorMaterialName = "EngineMaterials.CubeMaterial"
    ScreenDoorNoiseTextureName = "EngineMaterials.ScreenDoorNoiseTexture"
    RandomAngleTextureName = "EngineMaterials.RandomAngles"
    RandomNormalTextureName = "EngineMaterials.RandomNormal"
    RandomNormalTextureName2 = "EngineMaterials.RandomNormal2"
    WeightMapPlaceholderTextureName = "EngineMaterials.WeightMapPlaceholderTexture"
    LightMapDensityTextureName = "EngineMaterials.DefaultWhiteGrid"
    LightMapDensityNormalName = "EngineMaterials.DefaultNormal"
    ScoutClassName = "SFXGame.BioScout"
    m_BioLayerDetails = ({
                          Prefix = "", 
                          Description = "Non-layered", 
                          Color = {B = 0, G = 0, R = 0, A = 0}
                         }, 
                         {
                          Prefix = "BioP", 
                          Description = "Persistent", 
                          Color = {B = 192, G = 192, R = 192, A = 0}
                         }, 
                         {
                          Prefix = "BioA", 
                          Description = "Art", 
                          Color = {B = 0, G = 143, R = 192, A = 0}
                         }, 
                         {
                          Prefix = "BioD", 
                          Description = "Design", 
                          Color = {B = 0, G = 221, R = 84, A = 0}
                         }, 
                         {
                          Prefix = "BioS", 
                          Description = "Audio", 
                          Color = {B = 100, G = 50, R = 0, A = 0}
                         }
                        )
    IgnoreSimulatedFuncWarnings = ('Tick')
    LightingOnlyBrightness = {R = 0.5, G = 0.5, B = 0.5, A = 1.0}
    LightMapDensityVertexMappedColor = {R = 0.649999976, G = 0.649999976, B = 0.25, A = 1.0}
    LightMapDensitySelectedColor = {R = 1.0, G = 0.200000003, B = 1.0, A = 1.0}
    DefaultSelectedMaterialColor = {R = 0.0399999991, G = 0.0199999996, B = 0.239999995, A = 1.0}
    SelectedMaterialColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    UnselectedMaterialColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    ProcBuildingLODColorTexelsPerWorldUnit = 0.075000003
    ProcBuildingLODLightingTexelsPerWorldUnit = 0.0149999997
    MaxProcBuildingLODColorTextureSize = 1024
    MaxProcBuildingLODLightingTextureSize = 256
    MaxRMSDForCombiningMappings = 10.0
    MaxPixelShaderAdditiveComplexityCount = 900.0
    IdealTextureDensity = 1.0
    MaxTextureDensity = 2.5
    IdealLightMapDensity = 1.0
    MaxLightMapDensity = 3.0
    RenderLightMapDensityGrayscaleScale = 1.0
    RenderLightMapDensityColorScale = 1.0
    TerrainMaterialMaxTextureCount = 16
    TerrainTessellationCheckCount = 6
    TerrainTessellationCheckDistance = 4096.0
    TimeBetweenPurgingPendingKillObjects = 60.0
    MaxSmoothedFrameRate = 62.0
    MinSmoothedFrameRate = 22.0
    C_WorldBox = {B = 40, G = 0, R = 0, A = 255}
    C_BrushWire = {B = 0, G = 0, R = 192, A = 255}
    C_AddWire = {B = 255, G = 127, R = 127, A = 255}
    C_SubtractWire = {B = 63, G = 192, R = 255, A = 255}
    C_SemiSolidWire = {B = 0, G = 255, R = 127, A = 255}
    C_NonSolidWire = {B = 32, G = 192, R = 63, A = 255}
    C_WireBackground = {B = 0, G = 0, R = 0, A = 255}
    C_ScaleBoxHi = {B = 157, G = 149, R = 223, A = 255}
    C_VolumeCollision = {B = 157, G = 223, R = 149, A = 255}
    C_BSPCollision = {B = 223, G = 157, R = 149, A = 255}
    C_OrthoBackground = {B = 163, G = 163, R = 163, A = 255}
    C_Volume = {B = 255, G = 196, R = 255, A = 255}
    C_BrushShape = {B = 128, G = 255, R = 128, A = 255}
    CameraRotationThreshold = 45.0
    CameraTranslationThreshold = 10000.0
    PrimitiveProbablyVisibleTime = 8.0
    PercentUnoccludedRequeries = 0.125
    MaxOcclusionPixelsFraction = 0.00100000005
    MaxFluidNumVerts = 1048576
    FluidSimulationTimeLimit = 30.0
    MaxParticleVertexMemory = 131972
    BeginUPTryCount = 200000
    NetClientTicksPerSecond = 200.0
    MaxTrackedOcclusionIncrement = 0.100000001
    TrackedOcclusionStepSize = 0.100000001
    UseProcBuildingLODTextureCropping = TRUE
    ForcePowerOfTwoProcBuildingLODTextures = TRUE
    bRenderLightMapDensityGrayscale = TRUE
    bUseSound = TRUE
    bUseTextureStreaming = TRUE
    bUseBackgroundLevelStreaming = TRUE
    bSubtitlesEnabled = TRUE
    bSmoothFrameRate = TRUE
    DisplayLazyLoadErrors = TRUE
    bOnScreenKismetWarnings = TRUE
    bDisablePhysXHardwareSupport = TRUE
    bCheckParticleRenderSize = TRUE
    bEnableOnScreenDebugMessages = TRUE
    bCookSeparateSharedMPGameContent = TRUE
}