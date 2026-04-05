Class InterpTrackFaceFX extends InterpTrack
    native
    collapsecategories;

struct native Override_AnimSet 
{
    var array<FaceFXAnimSet> aBioMaleSets;
    var array<FaceFXAnimSet> aBioFemaleSets;
    var(Override_AnimSet) FaceFXAnimSet fxaAnimSet;
    var(Override_AnimSet) EBioAutoSetFXAnimTrack eAnimSequence;
};
struct native Override_Asset 
{
    var(Override_Asset) FaceFXAsset fxAsset;
    var(Override_Asset) EBioAutoSetFXAnimGroupTrack eAnimGroup;
    var(Override_Asset) EBioAutoSetFXAnimSeqTrack eAnimSeq;
};
enum EBioAutoSetFXAnimSeqTrack
{
    FaceFXAnimSeqTrack_Unset,
};
enum EBioAutoSetFXAnimGroupTrack
{
    FaceFXAnimGroupTrack_Unset,
};
enum EBioAutoSetFXAnimTrack
{
    FaceFXAnimTrack_Unset,
};
struct native FaceFXSoundCueKey 
{
    var const SoundCue FaceFXSoundCue;
};
struct native FaceFXTrackKey 
{
    var string FaceFXGroupName;
    var string FaceFXSeqName;
    var float StartTime;
};

var(Override) Override_AnimSet OverrideAnimSet;
var(InterpTrackFaceFX) array<FaceFXAnimSet> FaceFXAnimSets;
var array<FaceFXAnimSet> m_aBioMaleAnimSets;
var array<FaceFXAnimSet> m_aBioFemaleAnimSets;
var array<FaceFXTrackKey> FaceFXSeqs;
var const array<FaceFXSoundCueKey> FaceFXSoundCueKeys;
var(Override) Override_Asset OverrideAsset;
var(InterpTrackFaceFX) Name m_nmSFXFindActor;
var transient FaceFXAsset CachedActorFXAsset;
var(InterpTrackFaceFX) bool m_bSFXEnableClipToClipBlending;
var(InterpTrackFaceFX) ESFXFindByTagTypes m_eSFXFindActorMode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'InterpTrackInstFaceFX'
    TrackTitle = "FaceFX"
}