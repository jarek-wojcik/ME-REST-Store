Class RvrClientEffectMulti extends RvrClientEffectInterface
    native;

var(RvrClientEffectMulti) array<RvrClientEffectInterface> m_aEffects;

public native function ApplyParameters(RvrClientEffectComponent pComponent, RvrClientEffectModuleInstance pInstance, int nIndex);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}