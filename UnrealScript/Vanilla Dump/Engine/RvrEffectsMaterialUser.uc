Class RvrEffectsMaterialUser extends MaterialInterface
    native;

var const native noexport Pointer VfTable_FCallbackEventDevice;
var(RvrEffectsMaterialUser) array<Guid> m_lstParentGuids;
var(RvrEffectsMaterialUser) MaterialInterface m_pBaseMaterial;
var(RvrEffectsMaterialUser) RvrEffectsMaterialGroup m_pEffectsGroup;
var(RvrEffectsMaterialUser) const editconst RvrMaterialMultiplexor m_pMultiplexor;
var(RvrEffectsMaterialUser) const editconst MaterialInterface m_pParentMaterial;
var const transient bool ReentrantFlag;
var(RvrEffectsMaterialUser) bool m_bSupportsStaticMeshes;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}