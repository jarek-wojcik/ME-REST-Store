Class SFXGUI_StandardSniperZoomReticle extends SFXGUI_WeaponReticleBase within SFXSFHandler_Reticle
    config(UI);

var string m_sSniperReticleSubMovie;
var GFxValue m_oActualReticle;
var GFxValue m_oZoomText;
var GFxValue m_oDistanceText;
var GFxValue m_oAmmoText;

public event function DistanceToTargetChanged(float fDistance)
{
    if (m_oDistanceText != None)
    {
        if (fDistance >= 0.0)
        {
            m_oDistanceText.SetText(int(fDistance * 0.00999999978) $ Outer.UIStrRef(m_srWeaponDistanceUnit));
        }
        else
        {
            m_oDistanceText.SetText("");
        }
    }
}
public event function PerformReticleHide(bool bInstant)
{
    if (bInstant)
    {
        m_oActualReticle.GotoAndStop("off");
        m_oActualReticle.SetVisible(FALSE);
    }
    else
    {
        m_oActualReticle.GotoAndPlay("out");
    }
    Super.PerformReticleHide(bInstant);
}
public event function PerformReticleShow(bool bInstant)
{
    Super.PerformReticleShow(bInstant);
    m_oActualReticle.SetVisible(TRUE);
    if (bInstant)
    {
        m_oActualReticle.GotoAndStop("on");
    }
    else
    {
        m_oActualReticle.GotoAndPlay("in");
    }
}
public event function WeaponAmmoChanged(int nAmmo)
{
    if (nAmmo >= 0)
    {
        m_oAmmoText.SetText(string(nAmmo));
    }
    else
    {
        m_oAmmoText.SetText("");
    }
}
public event function ZoomChanged(int nZoom)
{
    if (nZoom > 0)
    {
        m_oZoomText.SetText(nZoom * 10 $ "X");
    }
    else
    {
        m_oZoomText.SetText("");
    }
}
public function OnReticleLoaded()
{
    local GFxValue distanceMC;
    
    m_oActualReticle = GetObject(m_sSniperReticleSubMovie);
    if (m_oActualReticle != None)
    {
        distanceMC = m_oActualReticle.GetObject("distanceMC");
        if (distanceMC != None)
        {
            m_oZoomText = distanceMC.GetObject("txtZoom");
            m_oDistanceText = distanceMC.GetObject("txtDistance");
            m_oAmmoText = distanceMC.GetObject("txtAmmo");
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sSniperReticleSubMovie = "SniperWeapon"
    m_oMovieResource = GFxMovieInfo'GUI_SF_WpnReticleSniper.WpnReticleSniper'
    m_bMonitorDistance = TRUE
    m_bMonitorAmmo = TRUE
    m_bMonitorZoom = TRUE
}