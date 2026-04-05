Class ParticleModuleAttractorLine extends ParticleModuleAttractorBase
    native
    editinlinenew;

var(Attractor) editinline RawDistributionFloat Range;
var(Attractor) editinline RawDistributionFloat Strength;
var(Attractor) Vector EndPoint0;
var(Attractor) Vector EndPoint1;

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
    bUpdateModule = TRUE
    bSupported3DDrawMode = TRUE
}