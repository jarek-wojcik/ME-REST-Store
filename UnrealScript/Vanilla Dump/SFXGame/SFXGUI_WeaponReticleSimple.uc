Class SFXGUI_WeaponReticleSimple extends SFXGUI_WeaponReticleBase within SFXSFHandler_Reticle
    config(UI);

var GFxValue m_oActualReticle;
var GFxValue m_oPipRight;
var GFxValue m_oPipLeft;

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
public event function ResetReticle(optional bool bUnsubscribe = FALSE)
{
    Super.ResetReticle(bUnsubscribe);
    m_oPipRight.SetPosition(m_oWeapon.MinCrosshairRange.X, 0.0);
    m_oPipLeft.SetPosition(-m_oWeapon.MinCrosshairRange.X, 0.0);
}
public event function TargetCanHitChanged(bool bInSights)
{
    local int nFrame;
    
    nFrame = bInSights ? 2 : 1;
    m_oPipRight.GotoAndStopI(nFrame);
    m_oPipLeft.GotoAndStopI(nFrame);
}
public function OnReticleLoaded()
{
    m_oActualReticle = GetObject("Crosshairs");
    if (m_oActualReticle != None)
    {
        m_oPipRight = m_oActualReticle.GetObject("rightLine");
        m_oPipLeft = m_oActualReticle.GetObject("leftLine");
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_oMovieResource = GFxMovieInfo'GUI_SF_WpnReticleSimple.WpnReticleSimple'
    m_bMonitorCanHitTarget = TRUE
}