Class ParticleModuleTrailTaper extends ParticleModuleTrailBase
    native
    editinlinenew
    collapsecategories;

enum ETrailTaperMethod
{
    PETTM_None,
    PETTM_Full,
    PETTM_Partial,
};

var(Taper) editinline RawDistributionFloat TaperFactor;
var(Taper) ETrailTaperMethod TaperMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionTaperFactor
        Constant = 1.0
    End Object
    TaperFactor = {
                   Distribution = DistributionTaperFactor, 
                   Type = 0, 
                   Op = 1, 
                   LookupTableNumElements = 1, 
                   LookupTableChunkSize = 1, 
                   LookupTable = (1.0, 1.0, 1.0, 1.0), 
                   LookupTableTimeScale = 0.0, 
                   LookupTableStartTime = 0.0
                  }
}