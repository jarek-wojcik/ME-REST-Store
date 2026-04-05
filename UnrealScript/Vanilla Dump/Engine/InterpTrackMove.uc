Class InterpTrackMove extends InterpTrack
    native
    collapsecategories;

enum EInterpTrackMoveRotMode
{
    IMR_Keyframed,
    IMR_LookAtGroup,
};
enum EInterpTrackMoveFrame
{
    IMF_World,
    IMF_RelativeToInitial,
    IMF_AnchorObject,
};
struct native InterpLookupTrack 
{
    var array<InterpLookupPoint> Points;
};
struct native InterpLookupPoint 
{
    var Name GroupName;
    var float Time;
};

var InterpCurveVector PosTrack;
var InterpCurveVector EulerTrack;
var InterpLookupTrack LookupTrack;
var(InterpTrackMove) Name LookAtGroupName;
var(InterpTrackMove) float LinCurveTension;
var(InterpTrackMove) float AngCurveTension;
var(InterpTrackMove) bool bUseQuatInterpolation;
var(InterpTrackMove) bool bShowArrowAtKeys;
var(InterpTrackMove) bool bDisableMovement;
var(InterpTrackMove) bool bShowTranslationOnCurveEd;
var(InterpTrackMove) bool bShowRotationOnCurveEd;
var(InterpTrackMove) bool bHide3DTrack;
var bool SFXCreatedBeforeStuntActorLocationChange;
var(InterpTrackMove) editconst EInterpTrackMoveFrame MoveFrame;
var(InterpTrackMove) EInterpTrackMoveRotMode RotMode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bShowTranslationOnCurveEd = TRUE
    TrackInstClass = Class'InterpTrackInstMove'
    TrackTitle = "Movement"
    bOnePerGroup = TRUE
}