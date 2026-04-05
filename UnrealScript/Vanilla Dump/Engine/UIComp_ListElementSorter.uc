Class UIComp_ListElementSorter extends UIComp_ListComponentBase within UIList
    native
    editinlinenew;

struct native transient UIListSortingParameters 
{
    var init int PrimaryIndex;
    var init int SecondaryIndex;
    var init bool bReversePrimarySorting;
    var init bool bReverseSecondarySorting;
    var init bool bCaseSensitive;
    var init bool bIntSortPrimary;
    var init bool bIntSortSecondary;
    var init bool bFloatSortPrimary;
    var init bool bFloatSortSecondary;
};

var delegate<OverrideListSort> __OverrideListSort__Delegate;
var(Interaction) int InitialSortColumn;
var(Interaction) int InitialSecondarySortColumn;
var(Interaction) const editconst transient int PrimarySortColumn;
var(Interaction) const editconst transient int SecondarySortColumn;
var(Interaction) bool bAllowCompoundSorting;
var(Interaction) bool bReversePrimarySorting;
var(Interaction) bool bReverseSecondarySorting;

public delegate function bool OverrideListSort(UIList Sender, Name CollectionFieldName, const out UIListSortingParameters SortParameters, out array<int> OrderedIndices);

public final native function ResetSortColumns(optional bool bResort = TRUE);

public final native function bool ResortItems(optional bool bCaseSensitive);

public final native function bool SortItems(int ColumnIndex, optional bool bSecondarySort, optional bool bCaseSensitive);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InitialSortColumn = -1
    InitialSecondarySortColumn = -1
    PrimarySortColumn = -1
    SecondarySortColumn = -1
    bAllowCompoundSorting = TRUE
}