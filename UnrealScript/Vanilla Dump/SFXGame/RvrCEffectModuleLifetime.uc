Class RvrCEffectModuleLifetime extends RvrClientEffectModule
    native
    editinlinenew;

var(RvrCEffectModuleLifetime) float m_fMin;
var(RvrCEffectModuleLifetime) float m_fMax;
var(RvrCEffectModuleLifetime) float m_fRequestStop;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_pInstanceClass = Class'RvrCEffectModuleLifetimeInstance'
}