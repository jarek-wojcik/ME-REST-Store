Class FoliageComponent extends PrimitiveComponent
    native;

struct native StoredFoliageInstance extends FoliageInstanceBase 
{
    var Color StaticLighting[3];
};
struct native FoliageInstanceBase 
{
    var Vector location;
    var Vector XAxis;
    var Vector YAxis;
    var Vector ZAxis;
    var float DistanceFactorSquared;
};

var const array<StoredFoliageInstance> LitInstances;
var const array<Guid> StaticallyRelevantLights;
var const array<Guid> StaticallyIrrelevantLights;
var LightmassPrimitiveSettings LightmassSettings;
var const float DirectionalStaticLightingScale[3];
var const float SimpleStaticLightingScale[3];
var Vector MinScale;
var Vector MaxScale;
var const StaticMesh InstanceStaticMesh;
var const MaterialInterface Material;
var float MaxDrawRadius;
var float MinTransitionRadius;
var float MinThinningRadius;
var float SwayScale;

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
    ReplacementPrimitive = None
    bForceDirectLightMap = TRUE
    bAcceptsLights = TRUE
    bUsePrecomputedShadows = TRUE
}