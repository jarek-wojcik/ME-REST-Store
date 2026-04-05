Class BioSeqVar_StoryManagerInt extends SeqVar_Int
    native;

var string m_sRefName;
var int m_nIndex;
var(BioSeqVar_StoryManagerInt) EBioRegionAutoSet Region;
var(BioSeqVar_StoryManagerInt) EBioPlotAutoSet Plot;
var(BioSeqVar_StoryManagerInt) EBioAutoSet Int;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sRefName = "Unset"
    m_nIndex = -1
}