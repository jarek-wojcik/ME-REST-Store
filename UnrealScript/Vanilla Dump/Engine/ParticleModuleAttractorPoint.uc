Class ParticleModuleAttractorPoint extends ParticleModuleAttractorBase
    native
    editinlinenew;

var(Attractor) editinline BioRawDistributionRwVector3 PositionRw;
var(Attractor) editinline RawDistributionFloat Range;
var(Attractor) editinline RawDistributionFloat Strength;
var(Attractor) bool StrengthByDistance;
var(Attractor) bool bAffectBaseVelocity;
var(Attractor) bool bOverrideVelocity;
var(Attractor) bool bUseWorldSpacePosition;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionRange
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionStrength
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionPosition
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionPositionRw
    End Object
    PositionRw = {
                  Distribution = DistributionPositionRw, 
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
    Range = {
             Distribution = DistributionRange, 
             Type = 0, 
             Op = 1, 
             LookupTableNumElements = 1, 
             LookupTableChunkSize = 1, 
             LookupTable = (0.0, 0.0, 0.0, 0.0), 
             LookupTableTimeScale = 0.0, 
             LookupTableStartTime = 0.0
            }
    Strength = {
                Distribution = DistributionStrength, 
                Type = 0, 
                Op = 1, 
                LookupTableNumElements = 1, 
                LookupTableChunkSize = 1, 
                LookupTable = (0.0, 0.0, 0.0, 0.0), 
                LookupTableTimeScale = 0.0, 
                LookupTableStartTime = 0.0
               }
    StrengthByDistance = TRUE
    bUpdateModule = TRUE
    bSupported3DDrawMode = TRUE
}