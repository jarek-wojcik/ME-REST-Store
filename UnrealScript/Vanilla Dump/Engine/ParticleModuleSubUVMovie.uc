Class ParticleModuleSubUVMovie extends ParticleModuleSubUV
    native
    editinlinenew;

var(FlipBook) editinline RawDistributionFloat FrameRate;
var(FlipBook) int StartingFrame;
var(FlipBook) bool bUseEmitterTime;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionFrameRate
        Constant = 30.0
    End Object
    Begin Template Class=DistributionFloatConstant Name=DistributionSubImage
    End Template
    FrameRate = {
                 Distribution = DistributionFrameRate, 
                 Type = 0, 
                 Op = 1, 
                 LookupTableNumElements = 1, 
                 LookupTableChunkSize = 1, 
                 LookupTable = (30.0, 30.0, 30.0, 30.0), 
                 LookupTableTimeScale = 0.0, 
                 LookupTableStartTime = 0.0
                }
    StartingFrame = 1
    SubImageIndex = {Distribution = DistributionSubImage}
}