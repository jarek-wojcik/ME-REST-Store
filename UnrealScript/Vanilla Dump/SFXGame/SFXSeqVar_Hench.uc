Class SFXSeqVar_Hench extends SeqVar_Object
    native;

enum ESFXVarHenchTag
{
    VarHenchTag_Unset,
};

var array<Name> m_aRealPriorities;
var transient array<SFXSeqVar_Hench> m_aLinkedHenchVars;
var transient Name m_nmObjValueTag;
var(SFXSeqVar_Hench) bool m_bBiggest;
var(SFXSeqVar_Hench) bool m_bSmallest;
var(SFXSeqVar_Hench) bool m_bFirst;
var(SFXSeqVar_Hench) bool m_bSecond;
var(SFXSeqVar_Hench) bool m_bPriorityMatchRequired;
var transient bool m_bLinkedDataBuilt;
var transient bool m_bCalculatedValue;
var transient bool m_bCalculatedTag;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}