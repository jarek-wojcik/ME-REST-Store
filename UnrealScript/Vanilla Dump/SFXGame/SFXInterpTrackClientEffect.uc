Class SFXInterpTrackClientEffect extends InterpTrackToggle
    native
    collapsecategories;

var(SFXInterpTrackClientEffect) Vector m_vSpawnParameters;
var(SFXInterpTrackClientEffect) RvrClientEffectInterface m_pEffect;
var(SFXInterpTrackClientEffect) bool m_bAllowCooldown;
var(SFXInterpTrackClientEffect) bool m_bStopAllMatchingEffects;

public static event function string GetNewTrackSubMenuName()
{
    return "SFX Cinematics";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bAllowCooldown = TRUE
    m_bStopAllMatchingEffects = TRUE
    TrackInstClass = Class'SFXInterpTrackInstClientEffect'
    TrackTitle = "ClientEffect"
}