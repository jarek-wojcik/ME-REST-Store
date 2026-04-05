Class RvrClientEffectByImpactMaterial extends RvrClientEffectInterface
    native;

struct native CEImpactByMaterial 
{
    var(CEImpactByMaterial) RvrClientEffectInterface ClientEffect;
    var(CEImpactByMaterial) EClientEffectMaterial MaterialType;
};

var(RvrClientEffectByImpactMaterial) array<CEImpactByMaterial> m_lstImpacts;
var(RvrClientEffectByImpactMaterial) RvrClientEffectInterface DefaultEffect;

public native function ApplyParameters(RvrClientEffectComponent pComponent, RvrClientEffectModuleInstance pInstance, int nIndex);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}