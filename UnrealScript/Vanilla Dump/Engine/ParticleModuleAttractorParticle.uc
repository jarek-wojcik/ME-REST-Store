Class ParticleModuleAttractorParticle extends ParticleModuleAttractorBase
    native
    editinlinenew;

enum EAttractorParticleSelectionMethod
{
    EAPSM_Random,
    EAPSM_Sequential,
};

var(Attractor) editinline RawDistributionFloat Range;
var(Attractor) editinline RawDistributionFloat Strength;
var(Attractor) export noclear Name EmitterName;
var int LastSelIndex;
var(Attractor) bool bStrengthByDistance;
var(Attractor) bool bAffectBaseVelocity;
var(Attractor) bool bRenewSource;
var(Attractor) bool bInheritSourceVel;
var(location) EAttractorParticleSelectionMethod SelectionMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionRange
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionStrength
    End Object
    Range = {
             Distribution = DistributionRange, 
             Type = 0, 
             Op = 1, 
             LookupTableNumElements = 1, 
             LookupTableChunkSize = 1, 
             LookupTable = (0.0, 0.0, 0.0, 0.0), 
             LookupTableTimeScale = 0.0, 
             LookupTableStartTime = 0.0
            }
    Strength = {
                Distribution = DistributionStrength, 
                Type = 0, 
                Op = 1, 
                LookupTableNumElements = 1, 
                LookupTableChunkSize = 1, 
                LookupTable = (0.0, 0.0, 0.0, 0.0), 
                LookupTableTimeScale = 0.0, 
                LookupTableStartTime = 0.0
               }
    bStrengthByDistance = TRUE
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}