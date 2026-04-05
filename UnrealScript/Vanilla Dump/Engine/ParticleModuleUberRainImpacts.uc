Class ParticleModuleUberRainImpacts extends ParticleModuleUberBase
    native
    editinlinenew
    collapsecategories;

var(Lifetime) editinline RawDistributionFloat Lifetime;
var(Size) editinline RawDistributionVector StartSize;
var(Rotation) editinline RawDistributionVector StartRotation;
var(Size) editinline RawDistributionVector LifeMultiplier;
var(location) editinline RawDistributionFloat PC_VelocityScale;
var(location) editinline RawDistributionVector PC_StartLocation;
var(location) editinline RawDistributionFloat PC_StartRadius;
var(location) editinline RawDistributionFloat PC_StartHeight;
var(Color) editinline RawDistributionVector ColorOverLife;
var(Color) editinline RawDistributionFloat AlphaOverLife;
var(Rotation) bool bInheritParent;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;
var(location) bool bIsUsingCylinder;
var(location) bool bPositive_X;
var(location) bool bPositive_Y;
var(location) bool bPositive_Z;
var(location) bool bNegative_X;
var(location) bool bNegative_Y;
var(location) bool bNegative_Z;
var(location) bool bSurfaceOnly;
var(location) bool bVelocity;
var(location) bool bRadialVelocity;
var(location) CylinderHeightAxis PC_HeightAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionAlphaOverLife
        Constant = 255.899994
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionPC_StartHeight
        Constant = 50.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionPC_StartRadius
        Constant = 50.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionPC_VelocityScale
        Constant = 1.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=DistributionLifetime
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionLifeMultiplier
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionPC_StartLocation
    End Object
    Begin Object Class=DistributionVectorConstantCurve Name=DistributionColorOverLife
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionStartRotation
        Max = {X = 360.0, Y = 360.0, Z = 360.0}
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
    StartRotation = {
                     Distribution = DistributionStartRotation, 
                     Type = 0, 
                     Op = 2, 
                     LookupTableNumElements = 2, 
                     LookupTableChunkSize = 6, 
                     LookupTable = (0.0, 
                                    360.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    360.0, 
                                    360.0, 
                                    360.0, 
                                    0.0, 
                                    0.0, 
                                    0.0, 
                                    360.0, 
                                    360.0, 
                                    360.0
                                   ), 
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
    PC_VelocityScale = {
                        Distribution = DistributionPC_VelocityScale, 
                        Type = 0, 
                        Op = 1, 
                        LookupTableNumElements = 1, 
                        LookupTableChunkSize = 1, 
                        LookupTable = (1.0, 1.0, 1.0, 1.0), 
                        LookupTableTimeScale = 0.0, 
                        LookupTableStartTime = 0.0
                       }
    PC_StartLocation = {
                        Distribution = DistributionPC_StartLocation, 
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
    PC_StartRadius = {
                      Distribution = DistributionPC_StartRadius, 
                      Type = 0, 
                      Op = 1, 
                      LookupTableNumElements = 1, 
                      LookupTableChunkSize = 1, 
                      LookupTable = (50.0, 50.0, 50.0, 50.0), 
                      LookupTableTimeScale = 0.0, 
                      LookupTableStartTime = 0.0
                     }
    PC_StartHeight = {
                      Distribution = DistributionPC_StartHeight, 
                      Type = 0, 
                      Op = 1, 
                      LookupTableNumElements = 1, 
                      LookupTableChunkSize = 1, 
                      LookupTable = (50.0, 50.0, 50.0, 50.0), 
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
    MultiplyX = TRUE
    MultiplyY = TRUE
    MultiplyZ = TRUE
    bIsUsingCylinder = TRUE
    bPositive_X = TRUE
    bPositive_Y = TRUE
    bPositive_Z = TRUE
    bNegative_X = TRUE
    bNegative_Y = TRUE
    bNegative_Z = TRUE
    bRadialVelocity = TRUE
    PC_HeightAxis = CylinderHeightAxis.PMLPC_HEIGHTAXIS_Z
    bSpawnModule = TRUE
    bUpdateModule = TRUE
    bSupported3DDrawMode = TRUE
}