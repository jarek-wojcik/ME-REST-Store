Class ParticleModuleMeshRotation extends ParticleModuleRotationBase
    native
    editinlinenew;

var(Rotation) editinline BioRawDistributionRwVector3 StartRotationRw;
var(Rotation) bool bInheritParent;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorUniform Name=DistributionStartRotation
        Max = {X = 360.0, Y = 360.0, Z = 360.0}
    End Object
    Begin Object Class=DistributionVectorUniform Name=DistributionStartRotationRw
        Max = {X = 360.0, Y = 360.0, Z = 360.0}
    End Object
    StartRotationRw = {
                       Distribution = DistributionStartRotationRw, 
                       Type = 0, 
                       Op = 2, 
                       LookupTableNumElements = 2, 
                       LookupTableChunkSize = 2, 
                       LookupTableMinOut = 0.0, 
                       LookupTableMaxOut = 360.0, 
                       LookupTable = ({X = 0.0, Y = 0.0, Z = 0.0}, 
                                      {X = 360.0, Y = 360.0, Z = 360.0}, 
                                      {X = 0.0, Y = 0.0, Z = 0.0}, 
                                      {X = 360.0, Y = 360.0, Z = 360.0}
                                     ), 
                       LookupTableTimeScale = 0.0, 
                       LookupTableStartTime = 0.0
                      }
    bSpawnModule = TRUE
}