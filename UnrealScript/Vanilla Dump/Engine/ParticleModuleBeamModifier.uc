Class ParticleModuleBeamModifier extends ParticleModuleBeamBase
    native
    editinlinenew;

struct native BeamModifierOptions 
{
    var(BeamModifierOptions) bool bModify;
    var(BeamModifierOptions) bool bScale;
    var(BeamModifierOptions) bool bLock;
};
enum BeamModifierType
{
    PEB2MT_Source,
    PEB2MT_Target,
};

var(Position) editinline BioRawDistributionRwVector3 PositionRw;
var(Tangent) editinline BioRawDistributionRwVector3 TangentRw;
var(Strength) editinline RawDistributionFloat Strength;
var(Position) BeamModifierOptions PositionOptions;
var(Tangent) BeamModifierOptions TangentOptions;
var(Strength) BeamModifierOptions StrengthOptions;
var(Tangent) bool bAbsoluteTangent;
var(Modifier) BeamModifierType ModifierType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionStrength
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionPosition
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionPositionRw
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionTangent
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionTangentRw
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
    TangentRw = {
                 Distribution = DistributionTangentRw, 
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
}