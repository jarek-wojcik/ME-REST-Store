Class ParticleModuleKillHeight extends ParticleModuleKillBase
    native
    editinlinenew;

var(Kill) editinline RawDistributionFloat Height;
var(Kill) bool bAbsolute;
var(Kill) bool bFloor;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionHeight
    End Object
    Height = {
              Distribution = DistributionHeight, 
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