Class BioSeqVar_StoryManagerStateId extends SeqVar_Int
    native;

var int m_nIndex;
var(BioSeqVar_StoryManagerStateId) EBioRegionAutoSet Region;
var(BioSeqVar_StoryManagerStateId) EBioPlotAutoSet Plot;
var(BioSeqVar_StoryManagerStateId) EBioAutoSet State;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nIndex = -1
}