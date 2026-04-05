Class BioAnimSetData
    native;

var array<Name> TrackBoneNames;
var transient array<AnimSetMeshLinkup> LinkupCache;
var(BioAnimSetData) array<Name> UseTranslationBoneNames;
var(BioAnimSetData) array<Name> ForceMeshTranslationBoneNames;
var(BioAnimSetData) bool bAnimRotationOnly;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAnimRotationOnly = TRUE
}