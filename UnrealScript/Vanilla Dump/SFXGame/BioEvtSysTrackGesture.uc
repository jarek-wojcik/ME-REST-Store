Class BioEvtSysTrackGesture extends SFXGameActorInterpTrack
    native
    collapsecategories;

struct native BioGestureScrubData extends BioGestureData 
{
    var array<BioGesturePinScrubData> aGestPins;
    var Name nmNextPoseSet;
    var Name nmNextPoseAnim;
    var float fCurPoseTime;
    var float fNextPoseTime;
    var float fTransitionTime;
    var float fCurPoseWeight;
    var float fTransitionWeight;
    var float fNextPoseWeight;
    
    structdefaultproperties
    {
        fPlayRate = 0.0
        fStartBlendDuration = 0.0
        fEndBlendDuration = 0.0
        fWeight = 0.0
    }
};
struct native BioGesturePinScrubData 
{
    var Name nmAnimSet;
    var Name nmAnimSeq;
    var float fTime;
    var float fWeight;
};
struct native BioGestureData 
{
    var array<int> aChainedGestures;
    var Name nmPoseSet;
    var Name nmPoseAnim;
    var Name nmGestureSet;
    var Name nmGestureAnim;
    var Name nmTransitionSet;
    var Name nmTransitionAnim;
    var(BioGestureData) float fPlayRate;
    var(BioGestureData) float fStartOffset;
    var(BioGestureData) float fEndOffset;
    var(BioGestureData) float fStartBlendDuration;
    var(BioGestureData) float fEndBlendDuration;
    var(BioGestureData) float fWeight;
    var(BioGestureData) float fTransBlendTime;
    var bool bInvalidData;
    var bool bOneShotAnim;
    var(BioGestureData) bool bChainToPrevious;
    var(BioGestureData) bool bPlayUntilNext;
    var(BioGestureData) bool bTerminateAllGestures;
    var bool bUseDynAnimSets;
    var(BioGestureData) bool bSnapToPose;
    var(BioGestureData) EBioValidPoseGroups ePoseFilter;
    var(BioGestureData) EBioGestureValidPoses ePose;
    var(BioGestureData) EBioGestureGroups eGestureFilter;
    var(BioGestureData) EBioGestureValidGestures eGesture;
    
    structdefaultproperties
    {
        fPlayRate = 1.0
        fStartBlendDuration = 0.100000001
        fEndBlendDuration = 0.100000001
        fWeight = 1.0
    }
};
enum EBioTrackAllPoseGroups
{
    AllPoseGroups_Unset,
};
enum EBioValidPoseGroups
{
    ValidPoseGroups_Unset,
};
enum EBioGestureGroups
{
    GestGroups_Unset,
};
enum EBioGestureValidGestures
{
    GestValidGest_Unset,
};
enum EBioGestureValidPoses
{
    GestValidPoses_Unset,
};
struct native BioGestureRenameData 
{
    var Name nmOldAnim;
    var Name nmNewSet;
    var Name nmNewAnim;
};
struct native BioGestTrackPriority 
{
    var int nTrackIndex;
    var int nPriority;
};
enum EBioGestureOverrideType
{
    DEFAULT_TRACK,
    FEMALE_PLAYER_TRACK,
};
enum EBioGestureAllPoses
{
    GestPose_Unset,
};
const GESTURES_DEFAULT_WEIGHT = 1.f;
const GESTURES_DEFAULT_BLEND_TIME = 0.1f;

var(BioEvtSysTrackGesture) array<BioGestureData> m_aGestures;
var Name nmStartingPoseSet;
var Name nmStartingPoseAnim;
var(BioEvtSysTrackGesture) float m_fStartPoseOffset;
var bool m_bARPUGenerated;
var bool m_bAutoGenFemaleTrack;
var bool m_bUseDynamicAnimsets;
var(BioEvtSysTrackGesture) EBioTrackAllPoseGroups ePoseFilter;
var(BioEvtSysTrackGesture) EBioGestureAllPoses eStartingPose;

public static event function bool AllowKeyNaming()
{
    return FALSE;
}
public static event function string GetNewTrackSubMenuName()
{
    return "Bio Conversation";
}
public static event function string KeyDataArrayName()
{
    return "m_aGestures";
}
public static event function string KeyDataDisplayName()
{
    return "Gesture Data";
}
public static event function string NewKeyDefaultName()
{
    return "Gesture";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fStartPoseOffset = -1.0
    TrackInstClass = Class'BioEvtSysTrackGestureInst'
    TrackTitle = "Gesture"
}