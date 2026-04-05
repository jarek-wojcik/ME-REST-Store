Class RvrCEffectModuleSound extends RvrClientEffectModule
    native
    editinlinenew;

var(RvrCEffectModuleSound) WwiseEvent m_pStartEvent;
var(RvrCEffectModuleSound) WwiseEvent m_pStopEvent;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_pInstanceClass = Class'RvrCEffectModuleSoundInstance'
    m_bSoftStopsAreHard = TRUE
}