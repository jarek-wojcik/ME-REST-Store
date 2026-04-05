Class FaceFXAsset
    native;

var const native array<byte> RawFaceFXActorBytes;
var const native array<byte> RawFaceFXSessionBytes;
var transient array<FaceFXAnimSet> MountedFaceFXAnimSets;
var array<WwiseBaseSoundObject> ReferencedSoundCues;
var const native Pointer FaceFXActor;
var transient int NumLoadErrors;

public final native function MountFaceFXAnimSet(FaceFXAnimSet AnimSet);

public final native function UnmountFaceFXAnimSet(FaceFXAnimSet AnimSet);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}