Class SFXGUI_ShotgunReticle extends SFXGUI_WeaponReticleBase within SFXSFHandler_Reticle
    config(UI);

const SHOTGUN_SMOOTHING_BUFFER = 3;

var float m_aRawBuffer[3];
var int m_nCurrentBufferIndex;
var GFxValue CircleReticle;
var float ReticleOpacity;
var config float RadiusModifier;

public event function PerformReticleHide(bool bInstant)
{
    CircleReticle.SetVisible(FALSE);
    Super.PerformReticleHide(bInstant);
}
public event function PerformReticleShow(bool bInstant)
{
    Super.PerformReticleShow(bInstant);
    CircleReticle.SetVisible(TRUE);
}
public event function ResetReticle(optional bool bUnsubscribe = FALSE)
{
    local ASDisplayInfo disp;
    
    Super.ResetReticle(bUnsubscribe);
    disp = CircleReticle.GetDisplayInfo();
    disp.Alpha = ReticleOpacity;
    CircleReticle.SetDisplayInfo(disp);
}
public event function TargetCanHitChanged(bool bInSights)
{
    if (CircleReticle != None)
    {
        CircleReticle.GotoAndStop(bInSights ? "red" : "blue");
    }
}
public event function Update(float fDeltaT)
{
    local float fRadiiSum;
    local int nSumCount;
    local int nIndex;
    local float fCurrentRadius;
    local SFXPlayerInventoryManager pInvManager;
    
    pInvManager = SFXPlayerInventoryManager(BioPlayerController(Outer.GetPC()).GetBioPawn().InvManager);
    if (pInvManager != None)
    {
        fCurrentRadius = pInvManager.GetPlayerCrosshairValue();
    }
    m_aRawBuffer[m_nCurrentBufferIndex] = fCurrentRadius;
    ++m_nCurrentBufferIndex;
    if (m_nCurrentBufferIndex >= 3)
    {
        m_nCurrentBufferIndex = 0;
    }
    for (nIndex = 0; nIndex < 3; ++nIndex)
    {
        if (m_aRawBuffer[nIndex] >= 0.0)
        {
            fRadiiSum += m_aRawBuffer[nIndex];
            ++nSumCount;
        }
    }
    fCurrentRadius = fRadiiSum / float(nSumCount) * RadiusModifier;
    if (fCurrentRadius > float(0))
    {
        CircleReticle.SetNumber("_width", fCurrentRadius * float(2));
        CircleReticle.SetNumber("_height", fCurrentRadius * float(2));
    }
}
public function OnReticleLoaded()
{
    CircleReticle = GetObject("ShotgunReticule");
    if (CircleReticle == None)
    {
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReticleOpacity = 75.0
    RadiusModifier = 1.0
    m_oMovieResource = GFxMovieInfo'GUI_SF_WpnReticleShotgun.WpnReticleShotgun'
    m_bMonitorCanHitTarget = TRUE
    m_bScriptUpdate = TRUE
}