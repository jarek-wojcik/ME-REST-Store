Class ParticleModuleVelocityOverLifetime extends ParticleModuleVelocityBase
    native
    editinlinenew;

var(Velocity) editinline BioRawDistributionRwVector3 VelOverLifeRw;
var(Velocity) export bool Absolute;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionVelOverLife
    End Object
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionVelOverLifeRw
    End Object
    VelOverLifeRw = {
                     Distribution = DistributionVelOverLifeRw, 
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
    bInWorldSpace = TRUE
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}