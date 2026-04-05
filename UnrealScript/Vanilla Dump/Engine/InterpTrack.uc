Class InterpTrack
    native
    noexport
    abstract
    collapsecategories;

enum ETrackActiveCondition
{
    ETAC_Always,
    ETAC_GoreEnabled,
    ETAC_GoreDisabled,
    ETAC_BioFemalePlayer,
    ETAC_BioMalePlayer,
    ETAC_BioSingleHandWeapon,
    ETAC_BioDualHandWeapon,
};

var const native noexport Pointer VfTable_FInterpEdInputInterface;
var native noexport Pointer CurveEdVTable;
var Class<InterpTrackInst> TrackInstClass;
var(InterpTrack) ETrackActiveCondition ActiveCondition;
var string TrackTitle;
var bool bOnePerGroup;
var bool bDirGroupOnly;
var bool bDisableTrack;
var bool bIsAnimControlTrack;
var bool bImportedTrack;

public static event function string GetNewTrackSubMenuName()
{
    return "";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'InterpTrackInst'
    TrackTitle = "Track"
}