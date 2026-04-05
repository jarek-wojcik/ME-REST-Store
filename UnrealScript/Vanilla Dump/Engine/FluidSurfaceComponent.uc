Class FluidSurfaceComponent extends PrimitiveComponent
    native
    editinlinenew;

struct LightMapRef 
{
    var const native Pointer Reference;
};

var const array<byte> ClampMap;
var const array<ShadowMap2D> ShadowMaps;
var const native LightMapRef LightMap;
var const transient native Pointer FluidSimulation;
var(Lightmass) LightmassPrimitiveSettings LightmassSettings;
var transient native Vector SimulationPosition;
var transient native Vector DetailPosition;
var(FluidSurfaceComponent) MaterialInterface FluidMaterial;
var(Lighting) int LightMapResolution;
var(Fluid) int SimulationQuadsX;
var(Fluid) int SimulationQuadsY;
var(Fluid) float GridSpacing;
var(Fluid) float GridSpacingLowRes;
var(Fluid) Actor TargetSimulation;
var(Fluid) float GPUTessellationFactor;
var(Fluid) float FluidDamping;
var(Fluid) float FluidTravelSpeed;
var(Fluid) float FluidHeightScale;
var(Fluid) float FluidUpdateRate;
var(Fluid) float ForceImpact;
var(Fluid) float ForceContinuous;
var(Fluid) float LightingContrast;
var(Fluid) Actor TargetDetail;
var(Fluid) float DeactivationDistance;
var(FluidDetail) int DetailResolution;
var(FluidDetail) float DetailSize;
var(FluidDetail) float DetailDamping;
var(FluidDetail) float DetailTravelSpeed;
var(FluidDetail) float DetailTransfer;
var(FluidDetail) float DetailHeightScale;
var(FluidDetail) float DetailUpdateRate;
var(FluidDebug) float NormalLength;
var(FluidDebug) float TestRippleSpeed;
var(FluidDebug) float TestRippleFrequency;
var(FluidDebug) float TestRippleRadius;
var float FluidWidth;
var float FluidHeight;
var transient native float TestRippleTime;
var transient native float TestRippleAngle;
var transient native float DeactivationTimer;
var transient native float ViewDistance;
var(Fluid) bool EnableSimulation;
var(Fluid) bool EnableDetail;
var(FluidDebug) transient bool bPause;
var(FluidDebug) transient bool bShowSimulationNormals;
var(FluidDebug) bool bShowSimulationPosition;
var(FluidDebug) bool bShowDetailNormals;
var(FluidDebug) bool bShowDetailPosition;
var(FluidDebug) transient bool bShowFluidSimulation;
var(FluidDebug) transient bool bShowFluidDetail;
var(FluidDebug) bool bTestRipple;
var(FluidDebug) bool bTestRippleCenterOnDetail;

public final native function ApplyForce(Vector WorldPos, float Strength, float Radius, optional bool bImpulse);

public final native function SetDetailPosition(Vector WorldPos);

public final native function SetSimulationPosition(Vector WorldPos);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LightmassSettings = {
                         bUseTwoSidedLighting = FALSE, 
                         bShadowIndirectOnly = FALSE, 
                         bUseEmissiveForStaticLighting = FALSE, 
                         EmissiveLightFalloffExponent = 2.0, 
                         EmissiveLightExplicitInfluenceRadius = 0.0, 
                         EmissiveBoost = 1.0, 
                         DiffuseBoost = 1.0, 
                         SpecularBoost = 1.0, 
                         FullyOccludedSamplesFraction = 1.0
                        }
    LightMapResolution = 128
    SimulationQuadsX = 200
    SimulationQuadsY = 200
    GridSpacing = 10.0
    GridSpacingLowRes = 800.0
    GPUTessellationFactor = 1.0
    FluidDamping = 1.0
    FluidTravelSpeed = 1.0
    FluidHeightScale = 1.0
    FluidUpdateRate = 30.0
    ForceImpact = -3.0
    ForceContinuous = -200.0
    LightingContrast = 1.0
    DeactivationDistance = 3000.0
    DetailResolution = 256
    DetailSize = 500.0
    DetailDamping = 1.0
    DetailTravelSpeed = 1.0
    DetailTransfer = 0.5
    DetailHeightScale = 1.0
    DetailUpdateRate = 30.0
    NormalLength = 10.0
    TestRippleSpeed = 1.0
    TestRippleFrequency = 1.0
    TestRippleRadius = 30.0
    FluidWidth = 2000.0
    FluidHeight = 2000.0
    EnableSimulation = TRUE
    EnableDetail = TRUE
    bShowFluidSimulation = TRUE
    bShowFluidDetail = TRUE
    ReplacementPrimitive = None
    bIgnoreNearPlaneIntersection = TRUE
    bForceDirectLightMap = TRUE
    bAcceptsLights = TRUE
    bUsePrecomputedShadows = TRUE
    CollideActors = TRUE
    BlockZeroExtent = TRUE
    BlockNonZeroExtent = TRUE
    bTickInEditor = TRUE
}