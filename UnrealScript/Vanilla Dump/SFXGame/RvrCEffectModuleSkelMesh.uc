Class RvrCEffectModuleSkelMesh extends RvrClientEffectModule
    native
    editinlinenew;

var(RvrCEffectModuleSkelMesh) array<MaterialInterface> m_lstMaterials;
var(RvrCEffectModuleSkelMesh) Name m_nmAnimSeq;
var(RvrCEffectModuleSkelMesh) SkeletalMesh m_pSkeletalMesh;
var(RvrCEffectModuleSkelMesh) AnimSet m_pAnimSet;
var(RvrCEffectModuleSkelMesh) bool m_bParentToPrimary;
var(RvrCEffectModuleSkelMesh) bool m_bInstantiateMaterials;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bParentToPrimary = TRUE
    m_pInstanceClass = Class'RvrCEffectModuleSkelMeshInstance'
    m_bSoftStopsAreHard = TRUE
}