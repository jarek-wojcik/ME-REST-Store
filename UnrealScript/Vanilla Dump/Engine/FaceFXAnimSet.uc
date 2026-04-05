Class FaceFXAnimSet
    native;

var const native array<byte> RawFaceFXAnimSetBytes;
var const native array<byte> RawFaceFXMiniSessionBytes;
var array<WwiseBaseSoundObject> ReferencedSoundCues;
var const native Pointer InternalFaceFXAnimSet;
var int NumLoadErrors;
var transient bool m_bBioSoundCuesFixedUp;
var(FaceFXAnimSet) bool bLocalizationDisabled;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}