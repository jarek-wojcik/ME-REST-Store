Class ParticleModuleColorScaleOverLife extends ParticleModuleColorBase
    native
    editinlinenew;

var(Color) editinline BioRawDistributionRwVector3 ColorScaleOverLifeRw;
var(Color) editinline RawDistributionFloat AlphaScaleOverLife;
var(Color) bool bEmitterTime;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionAlphaScaleOverLife
        Constant = 1.0
    End Object
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionColorScaleOverLife
    End Object
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionColorScaleOverLifeRw
    End Object
    ColorScaleOverLifeRw = {
                            Distribution = DistributionColorScaleOverLifeRw, 
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
    AlphaScaleOverLife = {
                          Distribution = DistributionAlphaScaleOverLife, 
                          Type = 0, 
                          Op = 1, 
                          LookupTableNumElements = 1, 
                          LookupTableChunkSize = 1, 
                          LookupTable = (1.0, 1.0, 1.0, 1.0), 
                          LookupTableTimeScale = 0.0, 
                          LookupTableStartTime = 0.0
                         }
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}