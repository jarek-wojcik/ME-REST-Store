Class ParticleModuleBeamTarget extends ParticleModuleBeamBase
    native
    editinlinenew;

var(Target) editinline BioRawDistributionRwVector3 TargetRw;
var(Target) editinline BioRawDistributionRwVector3 TargetTangentRw;
var(Target) editinline RawDistributionFloat TargetStrength;
var(Target) Name TargetName;
var(Target) float LockRadius;
var(Target) bool bTargetAbsolute;
var(Target) bool bLockTarget;
var(Target) bool bLockTargetTangent;
var(Target) bool bLockTargetStength;
var(Target) Beam2SourceTargetMethod TargetMethod;
var(Target) Beam2SourceTargetTangentMethod TargetTangentMethod;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionTargetStrength
        Constant = 25.0
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionTarget
        Constant = {X = 50.0, Y = 50.0, Z = 50.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionTargetRw
        Constant = {X = 50.0, Y = 50.0, Z = 50.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionTargetTangent
        Constant = {X = 1.0, Y = 0.0, Z = 0.0}
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionTargetTangentRw
        Constant = {X = 1.0, Y = 0.0, Z = 0.0}
    End Object
    TargetRw = {
                Distribution = DistributionTargetRw, 
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
    TargetTangentRw = {
                       Distribution = DistributionTargetTangentRw, 
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
    TargetStrength = {
                      Distribution = DistributionTargetStrength, 
                      Type = 0, 
                      Op = 1, 
                      LookupTableNumElements = 1, 
                      LookupTableChunkSize = 1, 
                      LookupTable = (25.0, 25.0, 25.0, 25.0), 
                      LookupTableTimeScale = 0.0, 
                      LookupTableStartTime = 0.0
                     }
    LockRadius = 10.0
}