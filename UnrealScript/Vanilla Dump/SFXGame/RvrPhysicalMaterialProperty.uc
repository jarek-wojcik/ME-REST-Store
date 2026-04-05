Class RvrPhysicalMaterialProperty extends PhysicalMaterialPropertyBase
    native
    editinlinenew
    collapsecategories;

enum EClientEffectMaterial
{
    CEM_Dummy,
};

var(ClientEffect) EClientEffectMaterial m_eImpactClientEffect;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}