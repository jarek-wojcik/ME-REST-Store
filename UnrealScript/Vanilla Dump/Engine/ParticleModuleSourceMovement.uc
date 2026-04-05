Class ParticleModuleSourceMovement extends ParticleModuleLocationBase
    native
    editinlinenew;

var(SourceMOvement) editinline BioRawDistributionRwVector3 SourceMovementScaleRw;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DistributionFloatParticleParameter Name=DistributionSeed
    End Template
    Begin Object Class=DistributionVectorConstant Name=DistributionSourceMovementScale
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionSourceMovementScaleRw
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    SourceMovementScaleRw = {
                             Distribution = DistributionSourceMovementScaleRw, 
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
    m_Seed = DistributionSeed
    bFinalUpdateModule = TRUE
}