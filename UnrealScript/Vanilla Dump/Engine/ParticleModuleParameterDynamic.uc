Class ParticleModuleParameterDynamic extends ParticleModuleParameterBase
    native
    editinlinenew;

struct native EmitterDynamicParameter 
{
    var(EmitterDynamicParameter) editinline RawDistributionFloat ParamValue;
    var(EmitterDynamicParameter) editconst Name ParamName;
    var(EmitterDynamicParameter) bool bUseEmitterTime;
    var(EmitterDynamicParameter) bool bSpawnTimeOnly;
    var(EmitterDynamicParameter) bool bScaleVelocityByParamValue;
    var(EmitterDynamicParameter) EEmitterDynamicParameterValue ValueMethod;
};
enum EEmitterDynamicParameterValue
{
    EDPV_UserSet,
    EDPV_VelocityX,
    EDPV_VelocityY,
    EDPV_VelocityZ,
    EDPV_VelocityMag,
};

var(ParticleModuleParameterDynamic) editinline editfixedsize array<EmitterDynamicParameter> DynamicParams;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionParam1
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionParam2
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionParam3
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionParam4
    End Object
    DynamicParams = ({
                      ParamValue = {
                                    Distribution = DistributionParam1, 
                                    Type = 0, 
                                    Op = 1, 
                                    LookupTableNumElements = 1, 
                                    LookupTableChunkSize = 1, 
                                    LookupTable = (0.0, 0.0, 0.0, 0.0), 
                                    LookupTableTimeScale = 0.0, 
                                    LookupTableStartTime = 0.0
                                   }, 
                      ParamName = 'None', 
                      bUseEmitterTime = FALSE, 
                      bSpawnTimeOnly = FALSE, 
                      bScaleVelocityByParamValue = FALSE, 
                      ValueMethod = EEmitterDynamicParameterValue.EDPV_UserSet
                     }, 
                     {
                      ParamValue = {
                                    Distribution = DistributionParam2, 
                                    Type = 0, 
                                    Op = 1, 
                                    LookupTableNumElements = 1, 
                                    LookupTableChunkSize = 1, 
                                    LookupTable = (0.0, 0.0, 0.0, 0.0), 
                                    LookupTableTimeScale = 0.0, 
                                    LookupTableStartTime = 0.0
                                   }, 
                      ParamName = 'None', 
                      bUseEmitterTime = FALSE, 
                      bSpawnTimeOnly = FALSE, 
                      bScaleVelocityByParamValue = FALSE, 
                      ValueMethod = EEmitterDynamicParameterValue.EDPV_UserSet
                     }, 
                     {
                      ParamValue = {
                                    Distribution = DistributionParam3, 
                                    Type = 0, 
                                    Op = 1, 
                                    LookupTableNumElements = 1, 
                                    LookupTableChunkSize = 1, 
                                    LookupTable = (0.0, 0.0, 0.0, 0.0), 
                                    LookupTableTimeScale = 0.0, 
                                    LookupTableStartTime = 0.0
                                   }, 
                      ParamName = 'None', 
                      bUseEmitterTime = FALSE, 
                      bSpawnTimeOnly = FALSE, 
                      bScaleVelocityByParamValue = FALSE, 
                      ValueMethod = EEmitterDynamicParameterValue.EDPV_UserSet
                     }, 
                     {
                      ParamValue = {
                                    Distribution = DistributionParam4, 
                                    Type = 0, 
                                    Op = 1, 
                                    LookupTableNumElements = 1, 
                                    LookupTableChunkSize = 1, 
                                    LookupTable = (0.0, 0.0, 0.0, 0.0), 
                                    LookupTableTimeScale = 0.0, 
                                    LookupTableStartTime = 0.0
                                   }, 
                      ParamName = 'None', 
                      bUseEmitterTime = FALSE, 
                      bSpawnTimeOnly = FALSE, 
                      bScaleVelocityByParamValue = FALSE, 
                      ValueMethod = EEmitterDynamicParameterValue.EDPV_UserSet
                     }
                    )
    bSpawnModule = TRUE
    bUpdateModule = TRUE
}