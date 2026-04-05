Class BioEmissionAreaListBoneList extends BioEmissionAreaList
    native;

struct native BoneListEmissionArea 
{
    var(BoneListEmissionArea) array<BoneAndWeight> Bones;
    var(BoneListEmissionArea) Name AreaTag;
    var(BoneListEmissionArea) bool UseNumVertsAsWeights;
    
    structdefaultproperties
    {
        UseNumVertsAsWeights = TRUE
    }
};
struct native BoneAndWeight 
{
    var(BoneAndWeight) Name BoneName;
    var(BoneAndWeight) float BoneWeight;
    
    structdefaultproperties
    {
        BoneWeight = 1.0
    }
};

var(BioEmissionAreaListBoneList) array<BoneListEmissionArea> m_EmissionAreas;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}