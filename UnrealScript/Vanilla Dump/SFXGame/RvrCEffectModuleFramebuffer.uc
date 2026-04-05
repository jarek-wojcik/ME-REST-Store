Class RvrCEffectModuleFramebuffer extends RvrClientEffectModule
    native
    editinlinenew;

var(RvrCEffectModuleFramebuffer) PostProcessChain m_pPostProcess;
var(RvrCEffectModuleFramebuffer) bool m_bResetTime;
var(RvrCEffectModuleFramebuffer) bool m_bInstantiateMaterials;
var(RvrCEffectModuleFramebuffer) bool m_bSendTimeParam;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bResetTime = TRUE
    m_bInstantiateMaterials = TRUE
    m_pInstanceClass = Class'RvrCEffectModuleFramebufferInstance'
    m_fMaxDistance = 2000.0
    m_bSoftStopsAreHard = TRUE
}