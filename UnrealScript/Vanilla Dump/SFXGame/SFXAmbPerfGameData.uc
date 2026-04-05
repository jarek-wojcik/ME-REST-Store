Class SFXAmbPerfGameData
    native;

struct native SFXAFGDPropActionData 
{
    var Name nmActionName;
    var float fTimeDelay;
    var ParticleSystem pPartSys;
    var RvrClientEffectInterface pClientEffect;
};
struct native SFXAPGDPose extends SFXAPGDAnimData 
{
    var array<SFXAPGDTransition> aTrans;
    var array<SFXAPGDGesture> aGests;
    var int nPoseChangeChance;
    var int nPlayGestureChance;
    var float fChoiceTimeDelay;
    var bool bEnterEvent;
    var bool bExitEvent;
    var bool bEnterTransDoneEvent;
    
    structdefaultproperties
    {
        fChoiceTimeDelay = 2.0
        nPropActionIndex = 0
    }
};
struct native SFXAPGDGesture extends SFXAPGDAnimData 
{
    var float fPlayRate;
    var float fPlayWeight;
    var int nPlayChance;
    var float fRetriggerDelay;
    var bool bOneShot;
    var bool bEnterEvent;
    var bool bExitEvent;
    
    structdefaultproperties
    {
        nPropActionIndex = 0
    }
};
struct native SFXAPGDTransition extends SFXAPGDAnimData 
{
    var float fBlendTime;
    var int nPlayChance;
    var int nDestPoseIndex;
    
    structdefaultproperties
    {
        nPropActionIndex = 0
    }
};
struct native SFXAPGDAnimData 
{
    var Name nmAnimSet;
    var Name nmAnimSeq;
    var int nPropActionIndex;
    
    structdefaultproperties
    {
        nPropActionIndex = -1
    }
};

var array<SFXAFGDPropActionData> m_aPropActions;
var array<SFXAPGDPose> m_aPoses;
var array<AnimSet> m_aAnimsets;
var string m_sWepPropClass;
var Name m_nmPropName;
var int m_nStartPoseIndex;
var Object m_pPropResource;
var int m_nPropActionIndex;
var bool m_bEnterEvent;
var bool m_bExitEvent;
var bool m_bUseDynamicAnimsets;
var bool m_bSuppressDamage;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nPropActionIndex = -1
}