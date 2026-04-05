Class RvrClientEffectModuleInstance
    native
    abstract
    transient;

var transient Vector m_vModifierParameter;
var const transient RvrClientEffectModule m_pModule;
var const editinline transient export RvrClientEffectComponent m_pComponent;
var transient float m_fDuration;
var transient float m_fDrawScale;
var transient float m_fTimeScale;
var transient float m_fDelay;
var transient float m_fMaxDistance;
var transient float m_fActivationValue;
var transient float m_fAccumulatedTime;
var transient int m_nLoopsSoFar;
var bool m_bActive;
var bool m_bPrimed;
var bool m_bFinished;
var bool m_bTick;
var bool m_bStopRequested;
var bool m_bHasBeenActivated;
var bool m_bHidInstigator;
var transient bool m_bCounted;
var transient bool m_bHiddenDueToCapsFail;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bFinished = TRUE
}