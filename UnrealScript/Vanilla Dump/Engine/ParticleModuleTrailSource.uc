Class ParticleModuleTrailSource extends ParticleModuleTrailBase
    native
    editinlinenew;

enum ETrail2SourceMethod
{
    PET2SRCM_Default,
    PET2SRCM_Particle,
    PET2SRCM_Actor,
};

var(Source) editinline RawDistributionFloat SourceStrength;
var(Source) editfixedsize array<RwVector3> SourceOffsetDefaults;
var(Source) Name SourceName;
var(Source) int SourceOffsetCount;
var(Source) bool bLockSourceStength;
var(Source) bool bInheritRotation;
var(Source) ETrail2SourceMethod SourceMethod;
var(Source) EParticleSourceSelectionMethod SelectionMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionSourceStrength
        Constant = 100.0
    End Object
    SourceStrength = {
                      Distribution = DistributionSourceStrength, 
                      Type = 0, 
                      Op = 1, 
                      LookupTableNumElements = 1, 
                      LookupTableChunkSize = 1, 
                      LookupTable = (100.0, 100.0, 100.0, 100.0), 
                      LookupTableTimeScale = 0.0, 
                      LookupTableStartTime = 0.0
                     }
    SelectionMethod = EParticleSourceSelectionMethod.EPSSM_Sequential
}