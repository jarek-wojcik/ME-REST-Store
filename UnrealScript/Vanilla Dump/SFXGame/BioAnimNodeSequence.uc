Class BioAnimNodeSequence extends AnimNodeSequence
    native;

var const native Pointer m_pDFCurTimeProp;
var const native Pointer m_pDFRateProp;
var const native Pointer m_pDFSeqLenProp;
var transient Vector m_vTotalTranslation;
var(DataForwarding) Name DF_CurrentTime;
var(DataForwarding) Name DF_Rate;
var(DataForwarding) Name DF_SequenceLength;
var(Random) bool bRandomizeStartTime;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}