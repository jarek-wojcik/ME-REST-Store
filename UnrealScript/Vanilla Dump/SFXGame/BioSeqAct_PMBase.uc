Class BioSeqAct_PMBase extends SequenceAction
    native
    abstract;

var string m_sObjectType;
var int m_nIndex;
var(BioSeqAct_PMBase) EBioRegionAutoSet Region;
var(BioSeqAct_PMBase) EBioPlotAutoSet Plot;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}