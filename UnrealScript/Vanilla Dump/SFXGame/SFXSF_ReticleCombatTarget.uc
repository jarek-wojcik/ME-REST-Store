Class SFXSF_ReticleCombatTarget extends SFXSF_ReticleBase within SFXSFHandler_Reticle
    native
    transient
    config(UI);

var Vector2D m_vExtents;
var Vector2D m_vExtentShrinkDelta;
var float m_fMinTargetSelectionWidth;
var float m_fMinTargetSelectionHeight;
var float m_fReticleShrinkTime;
var float m_fFlourishLifeTime;
var GFxValue m_oReticleTarget;
var GFxValue m_oReticleTargetBase;
var config float m_fSelectionBoxScalingFactor;
var bool m_bPreviouslyInitialized;
var bool m_bDoingActionFlourish;

public event native function ClearReticle(optional bool bTransition = TRUE);

public event native function SetReticle(string sSFReticlePath);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fReticleShrinkTime = 0.300000012
    m_fSelectionBoxScalingFactor = 0.899999976
    m_sFlashLinkageIdentifier = "CombatTarget"
    m_nFlashLayerModifier = 1000
}