Class SFXGUI_CrosshairReticle extends SFXGUI_WeaponReticleBase within SFXSFHandler_Reticle
    native
    config(UI);

const CROSSHAIR_SMOOTHING_BUFFER = 3;

var float m_aCrosshairRawBuffer[3];
var GFxValue m_oActualReticle;
var GFxValue m_oCrosshairTop;
var GFxValue m_oCrosshairRight;
var GFxValue m_oCrosshairBottom;
var GFxValue m_oCrosshairLeft;
var float m_fCacheCrosshairRadius;
var int m_nCrosshairBufferIndex;
var config float m_fCrosshairAccuracyModifier;
var bool m_fCacheTargetInSights;

public final event function float GetCrosshairRadius()
{
    local SFXPlayerInventoryManager pInvManager;
    local BioPlayerController pPC;
    
    pPC = BioPlayerController(Outer.GetPC());
    pInvManager = pPC == None ? None : SFXPlayerInventoryManager(pPC.GetBioPawn().InvManager);
    if (pInvManager != None)
    {
        return pInvManager.GetPlayerCrosshairValue();
    }
    return 0.0;
}
public event function PerformReticleHide(bool bInstant)
{
    m_oActualReticle.SetVisible(FALSE);
    Super.PerformReticleHide(bInstant);
}
public event function PerformReticleShow(bool bInstant)
{
    Super.PerformReticleShow(bInstant);
    m_oActualReticle.SetVisible(TRUE);
}
public event function TargetCanHitChanged(bool bInSights)
{
    local int nFrame;
    
    nFrame = bInSights ? 2 : 1;
    m_oCrosshairTop.GotoAndStopI(nFrame);
    m_oCrosshairBottom.GotoAndStopI(nFrame);
    m_oCrosshairRight.GotoAndStopI(nFrame);
    m_oCrosshairLeft.GotoAndStopI(nFrame);
}
public final function AS_TriggerImpactVisualization()
{
    ActionScriptVoid("TriggerImpactVisualization");
}
public function OnReticleLoaded()
{
    local int nIndex;
    
    m_oActualReticle = GetObject("Crosshairs");
    if (m_oActualReticle != None)
    {
        m_oCrosshairTop = m_oActualReticle.GetObject("topLine");
        m_oCrosshairRight = m_oActualReticle.GetObject("rightLine");
        m_oCrosshairBottom = m_oActualReticle.GetObject("bottomLine");
        m_oCrosshairLeft = m_oActualReticle.GetObject("leftLine");
    }
    for (nIndex = 0; nIndex < 3; ++nIndex)
    {
        m_aCrosshairRawBuffer[nIndex] = -1.0;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fCrosshairAccuracyModifier = -17.0
    m_oMovieResource = GFxMovieInfo'GUI_SF_WpnReticleCrosshair.WpnReticleCrosshair'
    m_bMonitorCanHitTarget = TRUE
}