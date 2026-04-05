Class ParticleModuleBeamNoise extends ParticleModuleBeamBase
    native
    editinlinenew;

var(LowFreq) editinline BioRawDistributionRwVector3 NoiseRangeRw;
var(LowFreq) editinline BioRawDistributionRwVector3 NoiseSpeedRw;
var(LowFreq) editinline RawDistributionFloat NoiseRangeScale;
var(LowFreq) editinline RawDistributionFloat NoiseTangentStrength;
var(LowFreq) editinline RawDistributionFloat NoiseScale;
var(LowFreq) int Frequency;
var(LowFreq) int Frequency_LowRange;
var(LowFreq) float NoiseLockRadius;
var(LowFreq) float NoiseLockTime;
var(LowFreq) float NoiseTension;
var(LowFreq) int NoiseTessellation;
var(LowFreq) float FrequencyDistance;
var(LowFreq) bool bLowFreq_Enabled;
var(LowFreq) bool bNRScaleEmitterTime;
var(LowFreq) bool bSmooth;
var const bool bNoiseLock;
var(LowFreq) bool bOscillate;
var(LowFreq) bool bUseNoiseTangents;
var(LowFreq) bool bTargetNoise;
var(LowFreq) bool bApplyNoiseScale;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionNoiseRangeScale
        Constant = 1.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionNoiseTangentStrength
        Constant = 250.0
    End Object
    Begin Object Class=DistributionFloatConstantCurve Name=DistributionNoiseScale
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionNoiseRange
        Constant = {X = 50.0, Y = 50.0, Z = 50.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionNoiseRangeRw
        Constant = {X = 50.0, Y = 50.0, Z = 50.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionNoiseSpeed
        Constant = {X = 50.0, Y = 50.0, Z = 50.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionNoiseSpeedRw
        Constant = {X = 50.0, Y = 50.0, Z = 50.0}
    End Object
    NoiseRangeRw = {
                    Distribution = DistributionNoiseRangeRw, 
                    Type = 0, 
                    Op = 1, 
                    LookupTableNumElements = 1, 
                    LookupTableChunkSize = 1, 
                    LookupTableMinOut = 50.0, 
                    LookupTableMaxOut = 50.0, 
                    LookupTable = ({X = 50.0, Y = 50.0, Z = 50.0}
                                  ), 
                    LookupTableTimeScale = 0.0, 
                    LookupTableStartTime = 0.0
                   }
    NoiseSpeedRw = {
                    Distribution = DistributionNoiseSpeedRw, 
                    Type = 0, 
                    Op = 1, 
                    LookupTableNumElements = 1, 
                    LookupTableChunkSize = 1, 
                    LookupTableMinOut = 50.0, 
                    LookupTableMaxOut = 50.0, 
                    LookupTable = ({X = 50.0, Y = 50.0, Z = 50.0}
                                  ), 
                    LookupTableTimeScale = 0.0, 
                    LookupTableStartTime = 0.0
                   }
    NoiseRangeScale = {
                       Distribution = DistributionNoiseRangeScale, 
                       Type = 0, 
                       Op = 1, 
                       LookupTableNumElements = 1, 
                       LookupTableChunkSize = 1, 
                       LookupTable = (1.0, 1.0, 1.0, 1.0), 
                       LookupTableTimeScale = 0.0, 
                       LookupTableStartTime = 0.0
                      }
    NoiseTangentStrength = {
                            Distribution = DistributionNoiseTangentStrength, 
                            Type = 0, 
                            Op = 1, 
                            LookupTableNumElements = 1, 
                            LookupTableChunkSize = 1, 
                            LookupTable = (250.0, 250.0, 250.0, 250.0), 
                            LookupTableTimeScale = 0.0, 
                            LookupTableStartTime = 0.0
                           }
    NoiseScale = {
                  Distribution = DistributionNoiseScale, 
                  Type = 0, 
                  Op = 1, 
                  LookupTableNumElements = 1, 
                  LookupTableChunkSize = 1, 
                  LookupTable = (0.0, 0.0, 0.0, 0.0), 
                  LookupTableTimeScale = 0.0, 
                  LookupTableStartTime = 0.0
                 }
    NoiseLockRadius = 1.0
    NoiseTension = 0.5
    NoiseTessellation = 1
}