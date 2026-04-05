Class BioAnimNodeFrame extends AnimNode
    native;

var transient array<BoneAtom> m_FrameBoneData;
var transient bool m_bIsFrameDataValid;
var(BioAnimNodeFrame) bool m_bCaptureOnRelevant;

public native function CaptureAnimFrame();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bCaptureOnRelevant = TRUE
}