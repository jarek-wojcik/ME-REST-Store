Class SFXGUI_WeaponReticleSimpleAlpha extends SFXGUI_WeaponReticleSimple within SFXSFHandler_Reticle
    config(UI);

var float ReticleOpacity;

public event function ResetReticle(optional bool bUnsubscribe = FALSE)
{
    local ASDisplayInfo disp;
    
    Super.ResetReticle(bUnsubscribe);
    disp = m_oActualReticle.GetDisplayInfo();
    disp.Alpha = ReticleOpacity;
    m_oActualReticle.SetDisplayInfo(disp);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReticleOpacity = 32.0
}