Class ParticleModuleKillBox extends ParticleModuleKillBase
    native
    editinlinenew;

var(Kill) editinline BioRawDistributionRwVector3 LowerLeftCornerRw;
var(Kill) editinline BioRawDistributionRwVector3 UpperRightCornerRw;
var(Kill) bool bAbsolute;
var(Kill) bool bKillInside;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorConstant Name=DistributionLowerLeftCorner
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionLowerLeftCornerRw
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionUpperRightCorner
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionUpperRightCornerRw
    End Object
    LowerLeftCornerRw = {
                         Distribution = DistributionLowerLeftCornerRw, 
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
    UpperRightCornerRw = {
                          Distribution = DistributionUpperRightCornerRw, 
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
    bSupported3DDrawMode = TRUE
}