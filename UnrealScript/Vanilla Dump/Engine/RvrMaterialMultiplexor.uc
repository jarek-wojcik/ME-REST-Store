Class RvrMaterialMultiplexor extends MaterialInterface
    native;

struct native RvrMultiplexorEntry 
{
    var(RvrMultiplexorEntry) Name m_nmTag;
    var(RvrMultiplexorEntry) MaterialInterface m_pMaterial;
};

var(RvrMaterialMultiplexor) array<RvrMultiplexorEntry> m_lstParents;
var const native duplicatetransient Pointer DefaultMaterialInstances[2];
var(RvrMaterialMultiplexor) Name m_nmParentNameParameter;
var(RvrMaterialMultiplexor) MaterialInterface m_pDefaultMaterial;
var const transient bool ReentrantFlag;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}