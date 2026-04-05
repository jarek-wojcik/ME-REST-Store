Class ParticleModuleColor extends ParticleModuleColorBase
    native
    editinlinenew;

var(Color) editinline BioRawDistributionRwVector3 StartColorRw;
var(Color) editinline RawDistributionFloat StartAlpha;
var(Color) bool bClampAlpha;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionStartAlpha
        Constant = 1.0
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionStartColor
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionStartColorRw
    End Object
    StartColorRw = {
                    Distribution = DistributionStartColorRw, 
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
    StartAlpha = {
                  Distribution = DistributionStartAlpha, 
                  Type = 0, 
                  Op = 1, 
                  LookupTableNumElements = 1, 
                  LookupTableChunkSize = 1, 
                  LookupTable = (1.0, 1.0, 1.0, 1.0), 
                  LookupTableTimeScale = 0.0, 
                  LookupTableStartTime = 0.0
                 }
    bClampAlpha = TRUE
    bSpawnModule = TRUE
    bCurvesAsColor = TRUE
}