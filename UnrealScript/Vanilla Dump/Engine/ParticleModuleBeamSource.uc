Class ParticleModuleBeamSource extends ParticleModuleBeamBase
    native
    editinlinenew;

var(Source) editinline BioRawDistributionRwVector3 SourceRw;
var(Source) editinline BioRawDistributionRwVector3 SourceTangentRw;
var(Source) editinline RawDistributionFloat SourceStrength;
var(Source) Name SourceName;
var(Source) bool bSourceAbsolute;
var(Source) bool bLockSource;
var(Source) bool bLockSourceTangent;
var(Source) bool bLockSourceStength;
var(Source) Beam2SourceTargetMethod SourceMethod;
var(Source) Beam2SourceTargetTangentMethod SourceTangentMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionSourceStrength
        Constant = 25.0
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionSource
        Constant = {X = 50.0, Y = 50.0, Z = 50.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionSourceRw
        Constant = {X = 50.0, Y = 50.0, Z = 50.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionSourceTangent
        Constant = {X = 1.0, Y = 0.0, Z = 0.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionSourceTangentRw
        Constant = {X = 1.0, Y = 0.0, Z = 0.0}
    End Object
    SourceRw = {
                Distribution = DistributionSourceRw, 
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
    SourceTangentRw = {
                       Distribution = DistributionSourceTangentRw, 
                       Type = 0, 
                       Op = 1, 
                       LookupTableNumElements = 1, 
                       LookupTableChunkSize = 1, 
                       LookupTableMinOut = 0.0, 
                       LookupTableMaxOut = 1.0, 
                       LookupTable = ({X = 1.0, Y = 0.0, Z = 0.0}
                                     ), 
                       LookupTableTimeScale = 0.0, 
                       LookupTableStartTime = 0.0
                      }
    SourceStrength = {
                      Distribution = DistributionSourceStrength, 
                      Type = 0, 
                      Op = 1, 
                      LookupTableNumElements = 1, 
                      LookupTableChunkSize = 1, 
                      LookupTable = (25.0, 25.0, 25.0, 25.0), 
                      LookupTableTimeScale = 0.0, 
                      LookupTableStartTime = 0.0
                     }
}