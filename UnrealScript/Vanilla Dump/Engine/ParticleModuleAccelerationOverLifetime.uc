Class ParticleModuleAccelerationOverLifetime extends ParticleModuleAccelerationBase
    native
    editinlinenew;

var(Acceleration) editinline BioRawDistributionRwVector3 AccelOverLifeRw;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionAccelOverLife
    End Object
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionAccelOverLifeRw
    End Object
    AccelOverLifeRw = {
                       Distribution = DistributionAccelOverLifeRw, 
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
    bUpdateModule = TRUE
}