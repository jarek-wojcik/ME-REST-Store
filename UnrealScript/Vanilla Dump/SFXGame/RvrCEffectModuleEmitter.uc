Class RvrCEffectModuleEmitter extends RvrClientEffectModule
    native
    editinlinenew;

var(RvrCEffectModuleEmitter) ParticleSystem m_pParticleSystem;
var(RvrCEffectModuleEmitter) EEffectLocationTarget m_eEmitterTarget;
var(RvrCEffectModuleEmitter) EEffectLocationTarget m_eEmitterInstigator;
var(RvrCEffectModuleEmitter) ESceneDepthPriorityGroup m_eDPG;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_eEmitterTarget = EEffectLocationTarget.ELT_Instigator
    m_eEmitterInstigator = EEffectLocationTarget.ELT_Instigator
    m_eDPG = ESceneDepthPriorityGroup.SDPG_World
    m_pInstanceClass = Class'RvrCEffectModuleEmitterInstance'
}