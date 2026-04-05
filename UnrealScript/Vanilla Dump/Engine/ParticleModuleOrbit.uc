Class ParticleModuleOrbit extends ParticleModuleOrbitBase
    native
    editinlinenew;

struct native OrbitOptions 
{
    var(OrbitOptions) bool bProcessDuringSpawn;
    var(OrbitOptions) bool bProcessDuringUpdate;
    var(OrbitOptions) bool bUseEmitterTime;
    
    structdefaultproperties
    {
        bProcessDuringSpawn = TRUE
    }
};
enum EOrbitChainMode
{
    EOChainMode_Add,
    EOChainMode_Scale,
    EOChainMode_Link,
};

var(Offset) editinline BioRawDistributionRwVector3 OffsetAmountRw;
var(Rotation) editinline BioRawDistributionRwVector3 RotationAmountRw;
var(RotationRate) editinline BioRawDistributionRwVector3 RotationRateAmountRw;
var(Offset) OrbitOptions OffsetOptions;
var(Rotation) OrbitOptions RotationOptions;
var(RotationRate) OrbitOptions RotationRateOptions;
var(Chaining) EOrbitChainMode ChainMode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorUniform Name=DistributionOffsetAmount
        Max = {X = 0.0, Y = 50.0, Z = 0.0}
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionOffsetAmountRw
        Max = {X = 0.0, Y = 50.0, Z = 0.0}
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionRotationAmount
        Max = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionRotationAmountRw
        Max = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionRotationRateAmount
        Max = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionRotationRateAmountRw
        Max = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    OffsetAmountRw = {
                      Distribution = DistributionOffsetAmountRw, 
                      Type = 0, 
                      Op = 2, 
                      LookupTableNumElements = 2, 
                      LookupTableChunkSize = 2, 
                      LookupTableMinOut = 0.0, 
                      LookupTableMaxOut = 50.0, 
                      LookupTable = ({X = 0.0, Y = 0.0, Z = 0.0}, 
                                     {X = 0.0, Y = 50.0, Z = 0.0}, 
                                     {X = 0.0, Y = 0.0, Z = 0.0}, 
                                     {X = 0.0, Y = 50.0, Z = 0.0}
                                    ), 
                      LookupTableTimeScale = 0.0, 
                      LookupTableStartTime = 0.0
                     }
    RotationAmountRw = {
                        Distribution = DistributionRotationAmountRw, 
                        Type = 0, 
                        Op = 2, 
                        LookupTableNumElements = 2, 
                        LookupTableChunkSize = 2, 
                        LookupTableMinOut = 0.0, 
                        LookupTableMaxOut = 1.0, 
                        LookupTable = ({X = 0.0, Y = 0.0, Z = 0.0}, 
                                       {X = 1.0, Y = 1.0, Z = 1.0}, 
                                       {X = 0.0, Y = 0.0, Z = 0.0}, 
                                       {X = 1.0, Y = 1.0, Z = 1.0}
                                      ), 
                        LookupTableTimeScale = 0.0, 
                        LookupTableStartTime = 0.0
                       }
    RotationRateAmountRw = {
                            Distribution = DistributionRotationRateAmountRw, 
                            Type = 0, 
                            Op = 2, 
                            LookupTableNumElements = 2, 
                            LookupTableChunkSize = 2, 
                            LookupTableMinOut = 0.0, 
                            LookupTableMaxOut = 1.0, 
                            LookupTable = ({X = 0.0, Y = 0.0, Z = 0.0}, 
                                           {X = 1.0, Y = 1.0, Z = 1.0}, 
                                           {X = 0.0, Y = 0.0, Z = 0.0}, 
                                           {X = 1.0, Y = 1.0, Z = 1.0}
                                          ), 
                            LookupTableTimeScale = 0.0, 
                            LookupTableStartTime = 0.0
                           }
    OffsetOptions = {bProcessDuringSpawn = TRUE, bProcessDuringUpdate = FALSE, bUseEmitterTime = FALSE}
    RotationOptions = {bProcessDuringSpawn = TRUE, bProcessDuringUpdate = FALSE, bUseEmitterTime = FALSE}
    RotationRateOptions = {bProcessDuringSpawn = TRUE, bProcessDuringUpdate = FALSE, bUseEmitterTime = FALSE}
    ChainMode = EOrbitChainMode.EOChainMode_Link
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}