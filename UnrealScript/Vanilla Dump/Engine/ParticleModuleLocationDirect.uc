Class ParticleModuleLocationDirect extends ParticleModuleLocationBase
    native
    editinlinenew;

var(location) editinline BioRawDistributionRwVector3 LocationRw;
var(location) editinline BioRawDistributionRwVector3 LocationOffsetRw;
var(location) editinline BioRawDistributionRwVector3 ScaleFactorRw;
var(location) editinline BioRawDistributionRwVector3 DirectionRw;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DistributionFloatParticleParameter Name=DistributionSeed
    End Template
    Begin Object Class=DistributionVectorConstant Name=DistributionLocationOffset
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionLocationOffsetRw
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionScaleFactor
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionScaleFactorRw
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionDirection
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionDirectionRw
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionLocation
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionLocationRw
    End Object
    LocationRw = {
                  Distribution = DistributionLocationRw, 
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
    LocationOffsetRw = {
                        Distribution = DistributionLocationOffsetRw, 
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
    ScaleFactorRw = {
                     Distribution = DistributionScaleFactorRw, 
                     Type = 0, 
                     Op = 1, 
                     LookupTableNumElements = 1, 
                     LookupTableChunkSize = 1, 
                     LookupTableMinOut = 1.0, 
                     LookupTableMaxOut = 1.0, 
                     LookupTable = ({X = 1.0, Y = 1.0, Z = 1.0}
                                   ), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    DirectionRw = {
                   Distribution = DistributionDirectionRw, 
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
    m_Seed = DistributionSeed
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}