Class BioAnimNodeSequenceMirror extends AnimNodeSequence
    native;

var(BioAnimNodeSequenceMirror) const Name MirroredAnimSeqName;
var const transient AnimSequence MirroredAnimSeq;
var const transient int MirroredAnimLinkupIndex;
var const transient AnimSequence DefaultAnimSeq;
var const transient int DefaultAnimLinkupIndex;
var(BioAnimNodeSequenceMirror) transient bool bUseMirrored;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MirroredAnimLinkupIndex = -1
    DefaultAnimLinkupIndex = -1
}