Class RvrCEffectModuleLocation extends RvrClientEffectModule
    native
    editinlinenew;

enum EEffectBoneAxis
{
    EBoneAxis_All,
    EBoneAxis_X,
    EBoneAxis_Y,
    EBoneAxis_Z,
};
enum EEffectRotationTarget
{
    ERotTarget_OppositeRayDir,
    ERotTarget_RayDir,
    ERotTarget_AwayFromImpact,
    ERotTarget_IntoImpact,
    ERotTarget_World,
    ERotTarget_Actor,
    ERotTarget_Bone,
};

var(Adjustment) editinline RawDistributionVector m_LocationAdjust;
var(Adjustment) editinline RawDistributionVector m_RotationAdjust;
var(RvrCEffectModuleLocation) RvrClientEffectParameter m_oLocationParam;
var(RvrCEffectModuleLocation) RvrClientEffectParameter m_oNormalParam;
var(Target) Name m_sAttachment;
var(Adjustment) float m_HitLocationPullback;
var(RvrCEffectModuleLocation) bool m_bSetEffectLocation;
var(RvrCEffectModuleLocation) bool m_bContinuous;
var(RvrCEffectModuleLocation) bool m_bSendLocation;
var(RvrCEffectModuleLocation) bool m_bSendNormal;
var(RvrCEffectModuleLocation) bool m_bAttach;
var(Target) EEffectLocationTarget m_eTarget;
var(Target) EEffectLocationReference m_eReference;
var(Target) EEffectRotationTarget m_eRotationTarget;
var(Target) EEffectBoneAxis m_eBoneAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionVectorConstant Name=DistributionLocationAdjust
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionRotationAdjust
    End Object
    m_LocationAdjust = {
                        Distribution = DistributionLocationAdjust, 
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
    m_RotationAdjust = {
                        Distribution = DistributionRotationAdjust, 
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
    m_oLocationParam = {
                        ValueVector = {X = 0.0, Y = 0.0, Z = 0.0}, 
                        Module = 'None', 
                        Variable = 'None', 
                        ValueFloat = 0.0, 
                        Type = EParameterType.ParamType_Location, 
                        DataType = EParameterDataType.ParamDataType_Vector
                       }
    m_oNormalParam = {
                      ValueVector = {X = 0.0, Y = 0.0, Z = 0.0}, 
                      Module = 'None', 
                      Variable = 'None', 
                      ValueFloat = 0.0, 
                      Type = EParameterType.ParamType_Normal, 
                      DataType = EParameterDataType.ParamDataType_Vector
                     }
    m_eTarget = EEffectLocationTarget.ELT_Instigator
    m_pInstanceClass = Class'RvrCEffectModuleLocationInstance'
    m_eModuleTickGroup = EModuleTickGroup.MTG_Location
}