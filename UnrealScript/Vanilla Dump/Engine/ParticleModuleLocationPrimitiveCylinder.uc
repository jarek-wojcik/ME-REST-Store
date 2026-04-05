Class ParticleModuleLocationPrimitiveCylinder extends ParticleModuleLocationPrimitiveBase
    native
    editinlinenew;

enum CylinderHeightAxis
{
    PMLPC_HEIGHTAXIS_X,
    PMLPC_HEIGHTAXIS_Y,
    PMLPC_HEIGHTAXIS_Z,
};

var(location) editinline RawDistributionFloat StartRadius;
var(location) editinline RawDistributionFloat StartHeight;
var(location) bool RadialVelocity;
var(location) CylinderHeightAxis HeightAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionStartHeight
        Constant = 50.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionStartRadius
        Constant = 50.0
    End Object
    Begin Template Class=DistributionFloatConstant Name=DistributionVelocityScale
    End Template
    Begin Template Class=DistributionFloatParticleParameter Name=DistributionSeed
    End Template
    Begin Template Class=DistributionVectorConstant Name=DistributionStartLocation
    End Template
    Begin Template Class=DistributionVectorConstant Name=DistributionStartLocationRw
    End Template
    StartRadius = {
                   Distribution = DistributionStartRadius, 
                   Type = 0, 
                   Op = 1, 
                   LookupTableNumElements = 1, 
                   LookupTableChunkSize = 1, 
                   LookupTable = (50.0, 50.0, 50.0, 50.0), 
                   LookupTableTimeScale = 0.0, 
                   LookupTableStartTime = 0.0
                  }
    StartHeight = {
                   Distribution = DistributionStartHeight, 
                   Type = 0, 
                   Op = 1, 
                   LookupTableNumElements = 1, 
                   LookupTableChunkSize = 1, 
                   LookupTable = (50.0, 50.0, 50.0, 50.0), 
                   LookupTableTimeScale = 0.0, 
                   LookupTableStartTime = 0.0
                  }
    RadialVelocity = TRUE
    HeightAxis = CylinderHeightAxis.PMLPC_HEIGHTAXIS_Z
    StartLocationRw = {Distribution = DistributionStartLocationRw}
    VelocityScale = {Distribution = DistributionVelocityScale}
    m_Seed = DistributionSeed
    bSupported3DDrawMode = TRUE
}