Class BioGestureRulesData
    native;

struct native BioAmbientPerformance extends BioAmbPerfBaseData 
{
    var Name nmGroup;
    var Name nmPropName;
    var Name nmOriginalName;
    var bool bValidForDLCOnly;
    var bool bSuppressDamage;
};
struct native BioAmbPerfPose extends BioAmbPerfBaseData 
{
    var init array<BioAmbPerfPoseTransData> aTransData;
    var Name nmStartTrans;
    var int nPoseChangeChance;
    var int nPlayGestureChance;
    var float fChoiceTimeDelay;
    var bool bStartHere;
    var bool bEnterTransDoneEvent;
    
    structdefaultproperties
    {
        fChoiceTimeDelay = 2.0
    }
};
struct native BioAmbPerfPoseTransData 
{
    var Name nmPoseName;
    var int nWeighting;
};
struct native BioAmbPerfGesture extends BioAmbPerfBaseData 
{
    var Name nmGestureName;
    var float fPlayRate;
    var float fPlayWeight;
    var int nWeighting;
    var float fRetriggerDelay;
};
struct native BioAmbPerfBaseData extends BioAmbPerfGestKey 
{
    var IntPoint tPosition;
    var Name nmPropAction;
    var float fPropActionTimeDelay;
    var bool bEnterEvent;
    var bool bExitEvent;
};
struct native BioAmbPerfGestKey 
{
    var Name nmPerfName;
    var Name nmPoseName;
};
struct native BioGestTransition extends BioGestPose 
{
    var Name nmDestPose;
    var float fTransBlendTime;
    var bool bNoTransAnim;
};
struct native BioGestGesture extends BioGestPose 
{
    var Name nmGesture;
    var bool bOneShotAnim;
};
struct native BioGestPose 
{
    var Name nmPose;
    var Name nmAnimSet;
    var Name nmAnimSeq;
    var IntPoint tPosition;
    var Name nmGroup;
    var Name nmFemaleNodeName;
};
struct native BioARPUBodyConfig 
{
    var Name nmCurveName;
    var Name nmAnimSet;
    var Name nmAnimSeq;
    var float fStartBlendDuration;
    var float fEndBlendDuration;
    var bool bUsesSingleKeyframe;
};

var native MultiMap_Mirror m_mapARPUCurves;
var native Map_Mirror m_mapPoses;
var native MultiMap_Mirror m_mapTransitions;
var native MultiMap_Mirror m_mapGestures;
var native Map_Mirror m_mapPerformances;
var native MultiMap_Mirror m_mapPerfPoses;
var native MultiMap_Mirror m_mapPerfGestures;
var array<BioARPUBodyConfig> m_aARPUItems;
var array<BioGestPose> m_aPosesTemp;
var array<BioGestTransition> m_aTransTemp;
var array<BioGestGesture> m_aGestTemp;
var array<Name> m_aGestureGroups;
var array<Name> m_aPoseGroups;
var array<Name> m_aPerfGroups;
var array<BioAmbientPerformance> m_aPerfTemp;
var array<BioAmbPerfPose> m_aPerfPoseTemp;
var array<BioAmbPerfGesture> m_aPerfGestTemp;
var array<Name> m_aDeletedPerfs;
var Name m_nmDefaultGestGroup;
var Name m_nmDefaultPoseGroup;
var Name m_nmDefaultPerfGroup;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aGestureGroups = ('Gesture', 'Twitches', 'Dynamic')
    m_aPoseGroups = ('Standing', 'Combat', 'Sitting')
    m_aPerfGroups = ('Default')
    m_nmDefaultGestGroup = 'Gesture'
    m_nmDefaultPoseGroup = 'Standing'
    m_nmDefaultPerfGroup = 'Default'
}