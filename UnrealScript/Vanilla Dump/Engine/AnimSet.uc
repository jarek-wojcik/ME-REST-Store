Class AnimSet
    native;

struct native AnimSetMeshLinkup 
{
    var QWord SkelMeshLinkupRUID;
    var array<int> BoneToTrackTable;
    var array<byte> BoneUseAnimTranslation;
    var array<byte> ForceUseMeshTranslation;
    
    structdefaultproperties
    {
        BoneUseAnimTranslation = ""
        ForceUseMeshTranslation = ""
    }
};

var array<AnimSequence> Sequences;
var Name PreviewSkelMeshName;
var(AnimSet) editconst BioAnimSetData m_pBioAnimSetData;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}