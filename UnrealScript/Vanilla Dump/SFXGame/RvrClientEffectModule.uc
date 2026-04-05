Class RvrClientEffectModule
    native
    editinlinenew
    abstract;

const VisibilityPersistenceTime = 1.0;
struct native RvrCEParameterDistribution 
{
    var(RvrCEParameterDistribution) editinline RawDistributionFloat DistributionFloat;
    var(RvrCEParameterDistribution) editinline RawDistributionVector DistributionVector;
    var(RvrCEParameterDistribution) RvrClientEffectParameter Parameter;
    var(RvrCEParameterDistribution) bool bDistanceBased;
    var(RvrCEParameterDistribution) bool bNormalizeTime;
    var(RvrCEParameterDistribution) bool bSuppressDuringRegular;
    var(RvrCEParameterDistribution) bool bSuppressDuringCooldown;
    var(RvrCEParameterDistribution) EValueModifierOperation ValueModifierOperation;
    var(RvrCEParameterDistribution) EValueModifierSelection ValueModifierSelection;
};
enum EModuleTickGroup
{
    MTG_Main,
    MTG_Location,
    MTG_Parameters,
};
enum EEffectLocationReference
{
    ELR_Actor,
    ELR_Bone,
    ELR_Socket,
    ELR_HitBone,
    ELR_TargetSocket,
    ELR_TargetBone,
};

var(Parameters) editinline array<RvrCEParameterDistribution> m_aParameters;
var Class<RvrClientEffectModuleInstance> m_pInstanceClass;
var(Parameters) Name m_nmTag;
var(Module) float m_fDuration;
var(Module) float m_fDrawScale;
var(Module) float m_fTimeScale;
var(Module) int m_nSortBias;
var(Activation) float m_fDelay;
var(Activation) float m_fMaxDistance;
var(Activation) float m_fMaxBehindDistance;
var(Activation) float m_fActivationValue;
var(Looping) int m_nLoops;
var(Module) bool m_bEnabled;
var(Module) bool m_bSoftStopsAreHard;
var(Module) bool m_bIgnoreSoftStops;
var(Module) bool m_bExclusiveOnTarget;
var(Module) bool m_bLocalPlayerOnly;
var(Module) bool m_bEndOnInstigatorDestroy;
var(Module) bool m_bHideInstigatorOnEnd;
var(Module) bool m_bSinglePlayerOnly;
var(Activation) bool m_bOnVisibleInstigatorOnly;
var(Activation) bool m_bIsCoolDownModule;
var(Activation) bool m_bCapsFailKillsEffect;
var(Activation) bool m_bAllowPendingMode;
var(Looping) bool m_bLooping;
var(Looping) bool m_bLoopsAreHard;
var const bool m_bSupportsInfiniteDuration;
var const EModuleTickGroup m_eModuleTickGroup;
var(Activation) EValueModifierOperation m_eActivationOperation;
var(Activation) EValueModifierSelection m_eActivationSelection;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_pInstanceClass = Class'RvrClientEffectModuleInstance'
    m_fDrawScale = 1.0
    m_fTimeScale = 1.0
    m_fActivationValue = 1.0
    m_nLoops = 1
    m_bEnabled = TRUE
    m_bSupportsInfiniteDuration = TRUE
}