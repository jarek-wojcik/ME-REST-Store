Class ParticleModuleUberRainSplashB extends ParticleModuleUberBase
    native
    editinlinenew
    collapsecategories;

var(Lifetime) editinline RawDistributionFloat Lifetime;
var(Size) editinline RawDistributionVector StartSize;
var(Color) editinline RawDistributionVector ColorOverLife;
var(Color) editinline RawDistributionFloat AlphaOverLife;
var(Size) editinline RawDistributionVector LifeMultiplier;
var(Rotation) editinline RawDistributionFloat StartRotationRate;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionAlphaOverLife
        Constant = 255.899994
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionStartRotationRate
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionLifetime
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionLifeMultiplier
    End Object
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionColorOverLife
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionStartSize
        Max = {X = 1.0, Y = 1.0, Z = 1.0}
        Min = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Lifetime = {
                Distribution = DistributionLifetime, 
                Type = 0, 
                Op = 1, 
                LookupTableNumElements = 1, 
                LookupTableChunkSize = 1, 
                LookupTable = (0.0, 0.0, 0.0, 0.0), 
                LookupTableTimeScale = 0.0, 
                LookupTableStartTime = 0.0
               }
    StartSize = {
                 Distribution = DistributionStartSize, 
                 Type = 0, 
                 Op = 1, 
                 LookupTableNumElements = 1, 
                 LookupTableChunkSize = 3, 
                 LookupTable = (1.0, 
                                1.0, 
                                1.0, 
                                1.0, 
                                1.0, 
                                1.0, 
                                1.0, 
                                1.0
                               ), 
                 LookupTableTimeScale = 0.0, 
                 LookupTableStartTime = 0.0
                }
    ColorOverLife = {
                     Distribution = DistributionColorOverLife, 
                     Type = 0, 
                     Op = 1, 
                     LookupTableNumElements = 1, 
                     LookupTableChunkSize = 3, 
                     LookupTable = (0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    0.0
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
                     LookupTable = (255.899994, 255.899994, 255.899994, 255.899994), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    LifeMultiplier = {
                      Distribution = DistributionLifeMultiplier, 
                      Type = 0, 
                      Op = 1, 
                      LookupTableNumElements = 1, 
                      LookupTableChunkSize = 3, 
                      LookupTable = (0.0, 
                                     0.0, 
                                     0.0, 
                                     0.0, 
                                     0.0, 
                                     0.0, 
                                     0.0, 
                                     0.0
                                    ), 
                      LookupTableTimeScale = 0.0, 
                      LookupTableStartTime = 0.0
                     }
    StartRotationRate = {
                         Distribution = DistributionStartRotationRate, 
                         Type = 0, 
                         Op = 1, 
                         LookupTableNumElements = 1, 
                         LookupTableChunkSize = 1, 
                         LookupTable = (0.0, 0.0, 0.0, 0.0), 
                         LookupTableTimeScale = 0.0, 
                         LookupTableStartTime = 0.0
                        }
    MultiplyX = TRUE
    MultiplyY = TRUE
    MultiplyZ = TRUE
    bSpawnModule = TRUE
    bUpdateModule = TRUE
    bSupported3DDrawMode = TRUE
}