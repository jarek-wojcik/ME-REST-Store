Class BioDecalComponent extends DecalComponent
    native
    editinlinenew;

var(DecalParameters) editinline export RawDistributionFloat FadeInTime;
var(DecalParameters) editinline export RawDistributionFloat FadeOutTime;
var(DecalParameters) editinline export RawDistributionFloat DecalLifetime;
var(DecalParameters) editinline export RawDistributionFloat DecalSize;
var(DecalParameters) editinline export RawDistributionFloat DecalRoll;
var(DecalParameters) editinline export RawDistributionFloat DecalYaw;
var(DecalParameters) editinline export RawDistributionFloat DecalPitch;
var(DecalParametersXMOD) editinline export RawDistributionFloat SizeScale;
var(DecalParameters) array<BioCurveDrivenParameter> aDecalMaterialParameters;
var transient MaterialInstanceConstant m_MaterialInstance;
var editinline transient export SpotLightComponent m_SkeletalDecal;
var editinline transient export SkeletalMeshComponent m_SkeletalReceiver;
var(DecalParameters) bool bScaleByDistance;
var(DecalFilter) bool bProjectOnShields;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatParticleParameter Name=Scale
        ParameterName = 'Level'
        Constant = 1.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=FadeIn
        Min = 0.5
        Max = 1.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=FadeOut
        Min = 0.5
        Max = 1.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=Life
        Min = 5.0
        Max = 10.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=Pitch
    End Object
    Begin Object Class=DistributionFloatUniform Name=Roll
        Max = 360.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=Size
        Min = 100.0
        Max = 200.0
    End Object
    Begin Object Class=DistributionFloatUniform Name=Yaw
    End Object
    FadeInTime = {
                  Distribution = FadeIn, 
                  Type = 0, 
                  Op = 2, 
                  LookupTableNumElements = 2, 
                  LookupTableChunkSize = 2, 
                  LookupTable = (0.5, 1.0, 0.5, 1.0, 0.5, 1.0), 
                  LookupTableTimeScale = 0.0, 
                  LookupTableStartTime = 0.0
                 }
    FadeOutTime = {
                   Distribution = FadeOut, 
                   Type = 0, 
                   Op = 2, 
                   LookupTableNumElements = 2, 
                   LookupTableChunkSize = 2, 
                   LookupTable = (0.5, 1.0, 0.5, 1.0, 0.5, 1.0), 
                   LookupTableTimeScale = 0.0, 
                   LookupTableStartTime = 0.0
                  }
    DecalLifetime = {
                     Distribution = Life, 
                     Type = 0, 
                     Op = 2, 
                     LookupTableNumElements = 2, 
                     LookupTableChunkSize = 2, 
                     LookupTable = (5.0, 10.0, 5.0, 10.0, 5.0, 10.0), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    DecalSize = {
                 Distribution = Size, 
                 Type = 0, 
                 Op = 2, 
                 LookupTableNumElements = 2, 
                 LookupTableChunkSize = 2, 
                 LookupTable = (100.0, 200.0, 100.0, 200.0, 100.0, 200.0), 
                 LookupTableTimeScale = 0.0, 
                 LookupTableStartTime = 0.0
                }
    DecalRoll = {
                 Distribution = Roll, 
                 Type = 0, 
                 Op = 2, 
                 LookupTableNumElements = 2, 
                 LookupTableChunkSize = 2, 
                 LookupTable = (0.0, 360.0, 0.0, 360.0, 0.0, 360.0), 
                 LookupTableTimeScale = 0.0, 
                 LookupTableStartTime = 0.0
                }
    DecalYaw = {
                Distribution = Yaw, 
                Type = 0, 
                Op = 1, 
                LookupTableNumElements = 1, 
                LookupTableChunkSize = 1, 
                LookupTable = (0.0, 0.0, 0.0, 0.0), 
                LookupTableTimeScale = 0.0, 
                LookupTableStartTime = 0.0
               }
    DecalPitch = {
                  Distribution = Pitch, 
                  Type = 0, 
                  Op = 1, 
                  LookupTableNumElements = 1, 
                  LookupTableChunkSize = 1, 
                  LookupTable = (0.0, 0.0, 0.0, 0.0), 
                  LookupTableTimeScale = 0.0, 
                  LookupTableStartTime = 0.0
                 }
    SizeScale = {
                 Distribution = Scale, 
                 Type = 0, 
                 Op = 0, 
                 LookupTableNumElements = 0, 
                 LookupTableChunkSize = 0, 
                 LookupTable = (), 
                 LookupTableTimeScale = 0.0, 
                 LookupTableStartTime = 0.0
                }
    ReplacementPrimitive = None
}