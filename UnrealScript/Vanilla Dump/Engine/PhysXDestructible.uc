Class PhysXDestructible
    native;

struct native PhysXDestructibleParameters 
{
    var(PhysXDestructibleParameters) editfixedsize array<PhysXDestructibleDepthParameters> DepthParameters;
    var(PhysXDestructibleParameters) float DamageThreshold;
    var(PhysXDestructibleParameters) float DamageToRadius;
    var(PhysXDestructibleParameters) float DamageCap;
    var(PhysXDestructibleParameters) float ForceToDamage;
    var(PhysXDestructibleParameters) SoundCue FractureSound;
    var(PhysXDestructibleParameters) ParticleSystem CrumbleParticleSystem;
    var(PhysXDestructibleParameters) float CrumbleParticleSize;
    var float ScaledDamageToRadius;
    var(PhysXDestructibleParameters) bool bAccumulateDamage;
    
    structdefaultproperties
    {
        DamageThreshold = 5.0
        DamageToRadius = 0.100000001
        CrumbleParticleSize = 10.0
        bAccumulateDamage = TRUE
    }
};
struct native PhysXDestructibleDepthParameters 
{
    var(PhysXDestructibleDepthParameters) bool bTakeImpactDamage;
    var(PhysXDestructibleDepthParameters) bool bPlaySoundEffect;
    var(PhysXDestructibleDepthParameters) bool bPlayParticleEffect;
    var(PhysXDestructibleDepthParameters) bool bDoNotTimeOut;
    var bool bNoKillDummy;
    
    structdefaultproperties
    {
        bNoKillDummy = TRUE
    }
};

var(PhysXDestructible) PhysXDestructibleParameters DestructibleParameters;
var array<PhysXDestructibleAsset> DestructibleAssets;
var(PhysXDestructible) array<Vector> CookingScales;
var FracturedStaticMesh FracturedStaticMesh;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DestructibleParameters = {
                              DepthParameters = (), 
                              DamageThreshold = 5.0, 
                              DamageToRadius = 0.100000001, 
                              DamageCap = 0.0, 
                              ForceToDamage = 0.0, 
                              FractureSound = None, 
                              CrumbleParticleSystem = None, 
                              CrumbleParticleSize = 10.0, 
                              ScaledDamageToRadius = 0.0, 
                              bAccumulateDamage = TRUE
                             }
    CookingScales = ({X = 1.0, Y = 1.0, Z = 1.0}
                    )
}