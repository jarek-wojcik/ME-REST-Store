Class ParticleModuleLocationPrimitiveBase extends ParticleModuleLocationBase
    native
    editinlinenew;

var(location) editinline BioRawDistributionRwVector3 StartLocationRw;
var(location) editinline RawDistributionFloat VelocityScale;
var(location) bool Positive_X;
var(location) bool Positive_Y;
var(location) bool Positive_Z;
var(location) bool Negative_X;
var(location) bool Negative_Y;
var(location) bool Negative_Z;
var(location) bool SurfaceOnly;
var(location) bool Velocity;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DistributionFloatParticleParameter Name=DistributionSeed
    End Template
    Begin Object Class=DistributionFloatConstant Name=DistributionVelocityScale
        Constant = 1.0
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionStartLocation
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionStartLocationRw
    End Object
    StartLocationRw = {
                       Distribution = DistributionStartLocationRw, 
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
    VelocityScale = {
                     Distribution = DistributionVelocityScale, 
                     Type = 0, 
                     Op = 1, 
                     LookupTableNumElements = 1, 
                     LookupTableChunkSize = 1, 
                     LookupTable = (1.0, 1.0, 1.0, 1.0), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    Positive_X = TRUE
    Positive_Y = TRUE
    Positive_Z = TRUE
    Negative_X = TRUE
    Negative_Y = TRUE
    Negative_Z = TRUE
    m_Seed = DistributionSeed
    bSpawnModule = TRUE
}