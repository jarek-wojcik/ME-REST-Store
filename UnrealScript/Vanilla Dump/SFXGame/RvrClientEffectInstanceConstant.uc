Class RvrClientEffectInstanceConstant extends RvrClientEffectInterface
    native
    editinlinenew
    collapsecategories;

var(RvrClientEffectInstanceConstant) array<RvrClientEffectParameter> m_lstParameters;
var(RvrClientEffectInstanceConstant) RvrClientEffectInterface m_pClientEffect;

public native function ApplyParameters(RvrClientEffectComponent pComponent, RvrClientEffectModuleInstance pInstance, int nIndex);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}