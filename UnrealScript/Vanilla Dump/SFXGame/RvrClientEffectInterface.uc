Class RvrClientEffectInterface
    native
    abstract;

struct native RvrEffectTargetSelection 
{
};
struct native RvrClientEffectTarget 
{
    var Guid Id;
    var(RvrClientEffectTarget) Vector HitLocation;
    var Vector RefinedHitLocation;
    var Vector RefinedRayDir;
    var(RvrClientEffectTarget) Vector HitNormal;
    var(RvrClientEffectTarget) Vector RayDir;
    var(RvrClientEffectTarget) Vector SpawnValue;
    var(RvrClientEffectTarget) Name HitBone;
    var Actor Instigator;
    var Actor HitActor;
    var PhysicalMaterial HitMaterial;
    var bool bHasRefinedHitLocation;
    
    structdefaultproperties
    {
        RefinedRayDir = {X = -1.0, Y = 0.0, Z = 0.0}
        HitNormal = {X = 1.0, Y = 0.0, Z = 0.0}
        RayDir = {X = -1.0, Y = 0.0, Z = 0.0}
    }
};
struct native RvrClientEffectParameter 
{
    var(RvrClientEffectParameter) Vector ValueVector;
    var(RvrClientEffectParameter) Name Module;
    var(RvrClientEffectParameter) Name Variable;
    var(RvrClientEffectParameter) float ValueFloat;
    var(RvrClientEffectParameter) EParameterType Type;
    var(RvrClientEffectParameter) EParameterDataType DataType;
};
enum EValueModifierOperation
{
    VMO_None,
    VMO_Add,
    VMO_Subtract,
    VMO_Multiply,
    VMO_Divide,
    VMO_Power,
    VMO_DotProduct,
    VMO_CrossProduct,
    VMO_Greater,
    VMO_Less,
    VMO_NearlyEqual,
    VMO_NotNearlyEqual,
};
enum EValueModifierSelection
{
    VMS_Spawn_Value_X,
    VMS_Spawn_Value_Y,
    VMS_Spawn_Value_Z,
    VMS_Spawn_Value_Vector,
    VMS_Parameter_X,
    VMS_Parameter_Y,
    VMS_Parameter_Z,
    VMS_Parameter_Vector,
    VMS_Blood_Color,
};
enum EEffectLocationTarget
{
    ELT_None,
    ELT_Effect,
    ELT_Instigator,
    ELT_HitActor,
    ELT_Tool,
    ELT_HitLocation,
    ELT_HitCharacter,
    ELT_LocalPlayer,
    ELT_Camera,
};
enum EParameterDataType
{
    ParamDataType_Ambiguous,
    ParamDataType_Float,
    ParamDataType_Vector,
    ParamDataType_ColorWithAlpha,
};
enum EParameterType
{
    ParamType_FaceValue,
    ParamType_Location,
    ParamType_Normal,
    ParamType_ScreenLocation,
    ParamType_ScreenNormal,
};

var(RvrClientEffectInterface) int m_nPriority;
var(RvrClientEffectInterface) bool m_bIgnoreAttachedActorHiddenState;

public native function ApplyParameters(RvrClientEffectComponent pComponent, RvrClientEffectModuleInstance pInstance, int nIndex);

public native function array<RvrClientEffectModule> GetModuleArray(RvrClientEffectComponent pComponent);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}