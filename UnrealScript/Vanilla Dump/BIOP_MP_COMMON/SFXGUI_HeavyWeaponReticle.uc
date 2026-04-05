Class SFXGUI_HeavyWeaponReticle extends SFXGUI_WeaponReticleBase within SFXSFHandler_Reticle
    config(UI);

var GFxValue m_oActualReticle;
var GFxValue m_oAmmoText;
var GFxValue m_oReticleBG;

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
public event function TargetCanHitChanged(bool bCanHit)
{
    m_oReticleBG.GotoAndStopI(bCanHit ? 2 : 1);
}
public event function WeaponAmmoChanged(int nAmmo)
{
    if (nAmmo >= 0)
    {
        if (m_oWeapon.AmmoPerShot > float(1))
        {
            nAmmo = int(float(nAmmo * 100) / m_oWeapon.AmmoPerShot);
            m_oAmmoText.SetText(nAmmo $ "%");
        }
        else
        {
            m_oAmmoText.SetText(string(nAmmo));
        }
    }
    else
    {
        m_oAmmoText.SetText("");
    }
}
public function OnReticleLoaded()
{
    m_oActualReticle = GetObject("HeavyWeapon");
    if (m_oActualReticle != None)
    {
        m_oAmmoText = m_oActualReticle.GetObject("txtAmmo");
        m_oReticleBG = m_oActualReticle.GetObject("ReticleBg");
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_oMovieResource = GFxMovieInfo'GUI_SF_WpnReticleHeavy.WpnReticleHeavy'
    m_bMonitorAmmo = TRUE
    m_bMonitorCanHitTarget = TRUE
}