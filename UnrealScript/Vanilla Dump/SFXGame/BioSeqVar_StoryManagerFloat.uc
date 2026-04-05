Class BioSeqVar_StoryManagerFloat extends SeqVar_Float
    native;

var string m_sRefName;
var int m_nIndex;
var(BioSeqVar_StoryManagerFloat) EBioRegionAutoSet Region;
var(BioSeqVar_StoryManagerFloat) EBioPlotAutoSet Plot;
var(BioSeqVar_StoryManagerFloat) EBioAutoSet Float;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sRefName = "Unset"
    m_nIndex = -1
}