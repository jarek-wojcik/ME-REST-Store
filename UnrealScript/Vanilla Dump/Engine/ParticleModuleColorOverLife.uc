Class ParticleModuleColorOverLife extends ParticleModuleColorBase
    native
    editinlinenew;

var(Color) editinline BioRawDistributionRwVector3 ColorOverLifeRw;
var(Color) editinline RawDistributionFloat AlphaOverLife;
var(Color) bool bClampAlpha;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionAlphaOverLife
        Constant = 1.0
    End Object
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionColorOverLife
    End Object
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionColorOverLifeRw
    End Object
    ColorOverLifeRw = {
                       Distribution = DistributionColorOverLifeRw, 
                       Type = 0, 
                       Op = 1, 
                       LookupTableNumElements = 1, 
                       LookupTableChunkSize = 1, 
                       LookupTableMinOut = 0.0, 
                       LookupTableMaxOut = 0.0, 
                       LookupTable = ({X = 0.0, Y = 0.0, Z = 0.0}, 
                                      {X = 0.0, Y = 0.0, Z = 0.0}
                                     ), 
                       LookupTableTimeScale = 0.0, 
                       LookupTableStartTime = 0.0
                      }
    AlphaOverLife = {
                     Distribution = DistributionAlphaOverLife, 
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
    bUpdateModule = TRUE
    bCurvesAsColor = TRUE
}