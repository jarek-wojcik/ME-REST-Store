Class ParticleModuleSubUVDirect extends ParticleModuleSubUVBase
    native
    editinlinenew;

var(SubUV) editinline BioRawDistributionRwVector3 SubUVPositionRw;
var(SubUV) editinline BioRawDistributionRwVector3 SubUVSizeRw;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorConstant Name=DistributionSubImagePosition
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionSubImagePositionRw
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionSubImageSize
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionSubImageSizeRw
    End Object
    SubUVPositionRw = {
                       Distribution = DistributionSubImagePositionRw, 
                       Type = 0, 
                       Op = 1, 
                       LookupTableNumElements = 1, 
                       LookupTableChunkSize = 1, 
                       LookupTableMinOut = 0.0, 
                       LookupTableMaxOut = 0.0, 
                       LookupTable = ({X = 0.0, Y = 0.0, Z = 0.0}
                                     ), 
                       LookupTableTimeScale = 0.0, 
                       LookupTableStartTime = 0.0
                      }
    SubUVSizeRw = {
                   Distribution = DistributionSubImageSizeRw, 
                   Type = 0, 
                   Op = 1, 
                   LookupTableNumElements = 1, 
                   LookupTableChunkSize = 1, 
                   LookupTableMinOut = 0.0, 
                   LookupTableMaxOut = 0.0, 
                   LookupTable = ({X = 0.0, Y = 0.0, Z = 0.0}
                                 ), 
                   LookupTableTimeScale = 0.0, 
                   LookupTableStartTime = 0.0
                  }
    bUpdateModule = TRUE
}