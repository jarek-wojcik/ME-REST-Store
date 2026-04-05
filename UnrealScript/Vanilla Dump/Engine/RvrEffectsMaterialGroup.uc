Class RvrEffectsMaterialGroup
    native;

struct native EMG_Entry 
{
    var(EMG_Entry) Name m_nmEffect;
    var(EMG_Entry) MaterialInterface m_pMaterial;
};

var(RvrEffectsMaterialGroup) array<EMG_Entry> m_lstEffects;
var const Guid m_Guid;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}