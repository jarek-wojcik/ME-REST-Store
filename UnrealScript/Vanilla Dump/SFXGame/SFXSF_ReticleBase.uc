Class SFXSF_ReticleBase within SFXSFHandler_Reticle
    native
    abstract
    transient;

var string m_sSFPath;
var string m_sFlashLinkageIdentifier;
var Vector2D m_vHUDLocation;
var Actor m_pTarget;
var GFxValue m_oReticle;
var int m_nFlashLayerModifier;
var bool m_bFirstUpdate;
var bool m_bHasInTransition;
var bool m_bHasOutTransition;
var bool m_bVisible;
var bool m_bInTransitionOut;

public event native function ClearReticle(optional bool bTransition = TRUE);

protected event function bool IsUpdateRequired(float fDeltaT)
{
    return FALSE;
}
protected event function PlayVisibleTransition(bool bVisible);

public event native function SetReticle(string sSFReticlePath);

public event native function SetVisible(bool bVisible, optional bool bTransition = FALSE);

protected event function UpdateReticleDisplay();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}