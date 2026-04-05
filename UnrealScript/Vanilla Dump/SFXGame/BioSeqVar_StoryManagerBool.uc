Class BioSeqVar_StoryManagerBool extends SeqVar_Bool
    native;

var string m_sRefName;
var int m_nIndex;
var(BioSeqVar_StoryManagerBool) EBioRegionAutoSet Region;
var(BioSeqVar_StoryManagerBool) EBioPlotAutoSet Plot;
var(BioSeqVar_StoryManagerBool) EBioAutoSet State;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sRefName = "Unset"
    m_nIndex = -1
}