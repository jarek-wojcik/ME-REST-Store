Class ParticleModuleSubUV extends ParticleModuleSubUVBase
    native
    editinlinenew;

var(SubUV) editinline RawDistributionFloat SubImageIndex;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionSubImage
    End Object
    SubImageIndex = {
                     Distribution = DistributionSubImage, 
                     Type = 0, 
                     Op = 1, 
                     LookupTableNumElements = 1, 
                     LookupTableChunkSize = 1, 
                     LookupTable = (0.0, 0.0, 0.0, 0.0), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}