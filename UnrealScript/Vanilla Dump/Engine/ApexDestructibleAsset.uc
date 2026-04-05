Class ApexDestructibleAsset extends ApexAsset
    native;

struct native NxDestructibleParameters 
{
    var(NxDestructibleParameters) editfixedsize array<NxDestructibleDepthParameters> DepthParameters;
    var(NxDestructibleParameters) Box ValidBounds;
    var(NxDestructibleParameters) float DamageThreshold;
    var(NxDestructibleParameters) float DamageToRadius;
    var(NxDestructibleParameters) float DamageCap;
    var(NxDestructibleParameters) float ForceToDamage;
    var(NxDestructibleParameters) float ImpactVelocityThreshold;
    var(NxDestructibleParameters) float DamageToPercentDeformation;
    var(NxDestructibleParameters) float DeformationPercentLimit;
    var(NxDestructibleParameters) int SupportDepth;
    var(NxDestructibleParameters) int DebrisDepth;
    var(NxDestructibleParameters) int EssentialDepth;
    var(NxDestructibleParameters) float DebrisLifetimeMin;
    var(NxDestructibleParameters) float DebrisLifetimeMax;
    var(NxDestructibleParameters) float DebrisMaxSeparationMin;
    var(NxDestructibleParameters) float DebrisMaxSeparationMax;
    var(NxDestructibleParameters) float MaxChunkSpeed;
    var(NxDestructibleParameters) float MassScaleExponent;
    var(NxDestructibleParameters) NxDestructibleParametersFlag Flags;
    var(NxDestructibleParameters) float GrbVolumeLimit;
    var(NxDestructibleParameters) float GrbParticleSpacing;
    var(NxDestructibleParameters) float FractureImpulseScale;
    var(NxDestructibleParameters) bool bFormExtendedStructures;
    
    structdefaultproperties
    {
        ValidBounds = {
                       Min = {X = -500000.0, Y = -500000.0, Z = -500000.0}, 
                       Max = {X = 500000.0, Y = 500000.0, Z = 500000.0}, 
                       IsValid = 0
                      }
    }
};
struct native NxDestructibleParametersFlag 
{
    var(NxDestructibleParametersFlag) bool ACCUMULATE_DAMAGE;
    var(NxDestructibleParametersFlag) bool ASSET_DEFINED_SUPPORT;
    var(NxDestructibleParametersFlag) bool WORLD_SUPPORT;
    var(NxDestructibleParametersFlag) bool DEBRIS_TIMEOUT;
    var(NxDestructibleParametersFlag) bool DEBRIS_MAX_SEPARATION;
    var(NxDestructibleParametersFlag) bool CRUMBLE_SMALLEST_CHUNKS;
    var(NxDestructibleParametersFlag) bool ACCURATE_RAYCASTS;
    var(NxDestructibleParametersFlag) bool USE_VALID_BOUNDS;
};
struct native NxDestructibleDepthParameters 
{
    var(NxDestructibleDepthParameters) bool TAKE_IMPACT_DAMAGE;
    var(NxDestructibleDepthParameters) bool IGNORE_POSE_UPDATES;
    var(NxDestructibleDepthParameters) bool IGNORE_RAYCAST_CALLBACKS;
    var(NxDestructibleDepthParameters) bool IGNORE_CONTACT_CALLBACKS;
    var(NxDestructibleDepthParameters) bool USER_FLAG_0;
    var(NxDestructibleDepthParameters) bool USER_FLAG_1;
    var(NxDestructibleDepthParameters) bool USER_FLAG_2;
    var(NxDestructibleDepthParameters) bool USER_FLAG_3;
};

var(ApexDestructibleAsset) NxDestructibleParameters DestructibleParameters;
var(ApexDestructibleAsset) const editfixedsize array<MaterialInterface> Materials;
var(ApexDestructibleAsset) string CrumbleEmitterName;
var(ApexDestructibleAsset) string DustEmitterName;
var native Pointer MApexAsset;
var(ApexDestructibleAsset) bool bDynamic;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DestructibleParameters = {
                              DepthParameters = (), 
                              ValidBounds = {
                                             Min = {X = -500000.0, Y = -500000.0, Z = -500000.0}, 
                                             Max = {X = 500000.0, Y = 500000.0, Z = 500000.0}, 
                                             IsValid = 0
                                            }, 
                              DamageThreshold = 0.0, 
                              DamageToRadius = 0.0, 
                              DamageCap = 0.0, 
                              ForceToDamage = 0.0, 
                              ImpactVelocityThreshold = 0.0, 
                              DamageToPercentDeformation = 0.0, 
                              DeformationPercentLimit = 0.0, 
                              SupportDepth = 0, 
                              DebrisDepth = 0, 
                              EssentialDepth = 0, 
                              DebrisLifetimeMin = 0.0, 
                              DebrisLifetimeMax = 0.0, 
                              DebrisMaxSeparationMin = 0.0, 
                              DebrisMaxSeparationMax = 0.0, 
                              MaxChunkSpeed = 0.0, 
                              MassScaleExponent = 0.0, 
                              Flags = {
                                       ACCUMULATE_DAMAGE = FALSE, 
                                       ASSET_DEFINED_SUPPORT = FALSE, 
                                       WORLD_SUPPORT = FALSE, 
                                       DEBRIS_TIMEOUT = FALSE, 
                                       DEBRIS_MAX_SEPARATION = FALSE, 
                                       CRUMBLE_SMALLEST_CHUNKS = FALSE, 
                                       ACCURATE_RAYCASTS = FALSE, 
                                       USE_VALID_BOUNDS = FALSE
                                      }, 
                              GrbVolumeLimit = 0.0, 
                              GrbParticleSpacing = 0.0, 
                              FractureImpulseScale = 0.0, 
                              bFormExtendedStructures = FALSE
                             }
}