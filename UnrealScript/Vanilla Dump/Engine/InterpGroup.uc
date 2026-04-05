Class InterpGroup
    native
    collapsecategories;

struct InterpEdSelKey 
{
    var InterpGroup Group;
    var int TrackIndex;
    var int KeyIndex;
    var float UnsnappedPosition;
};
enum ESFXFindByTagTypes
{
    FindActorByTag,
    FindActorByNode,
    UseGroupActor,
};

var const native noexport Pointer VfTable_FInterpEdInputInterface;
var export array<InterpTrack> InterpTracks;
var(InterpGroup) array<AnimSet> GroupAnimSets;
var(InterpGroup) Name m_nmSFXFindActor;
var Name GroupName;
var(InterpGroup) Color GroupColor;
var(InterpGroup) int BioForcedLodModel;
var bool bCollapsed;
var transient bool bVisible;
var(InterpGroup) bool bDontPrime;
var bool bIsFolder;
var bool bIsParented;
var transient bool bIsSelected;
var(InterpGroup) ESFXFindByTagTypes m_eSFXFindActorMode;

public final native function SFXScriptCopyGroupAnimSets(out array<AnimSet> aOutGroupAnimSets);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GroupName = 'InterpGroup'
    GroupColor = {B = 200, G = 80, R = 100, A = 255}
    bVisible = TRUE
}