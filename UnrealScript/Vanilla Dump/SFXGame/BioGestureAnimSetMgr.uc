Class BioGestureAnimSetMgr
    native;

struct native BioAnimSetReference 
{
    var int nRefCount;
    var AnimSet pAnimSet;
};
struct native BioGestDataKey 
{
    var SFXGestureData tRawData;
    var BioGestChainTree pChainTree;
    var bool bUseDynamicAnimSets;
};
struct native SFXGestureData 
{
    var array<int> aChainedGestures;
    var Name nmPoseSet;
    var Name nmPoseAnim;
    var Name nmGestureSet;
    var Name nmGestureAnim;
    var Name nmTransitionSet;
    var Name nmTransitionAnim;
    var(SFXGestureData) float fPlayRate;
    var(SFXGestureData) float fStartOffset;
    var(SFXGestureData) float fEndOffset;
    var(SFXGestureData) float fStartBlendDuration;
    var(SFXGestureData) float fEndBlendDuration;
    var(SFXGestureData) float fWeight;
    var float fTransBlendTime;
    var bool bInvalidData;
    var bool bOneShotAnim;
    var(SFXGestureData) bool bChainToPrevious;
    var(SFXGestureData) bool bPlayUntilNext;
    var(SFXGestureData) bool bTerminateAllGestures;
    var bool bUseDynAnimSets;
    var(SFXGestureData) bool bSnapToPose;
    
    structdefaultproperties
    {
        fPlayRate = 1.0
        fStartBlendDuration = 0.100000001
        fEndBlendDuration = 0.100000001
        fWeight = 1.0
    }
};

var native Map_Mirror m_mapAnimSetReference;
var array<BioGestDataKey> m_aNewGestureData;
var transient float m_fGestureBlendTime;
var int m_nGestureState;
var transient bool m_bTransitioning;
var transient bool m_bGesturePlaying;

public native function SetPoseRMRotation(bool bEnabled);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nGestureState = 512
}