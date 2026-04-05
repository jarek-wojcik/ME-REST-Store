Class RvrCEffectModuleRadialBlur extends RvrClientEffectModule
    native
    editinlinenew;

var(RvrCEffectModuleRadialBlur) MaterialInterface m_pMaterial;
var(RvrCEffectModuleRadialBlur) float m_fBlurFalloffExponent;
var(RvrCEffectModuleRadialBlur) float m_fBlurOpacity;
var(RvrCEffectModuleRadialBlur) float m_fMaxCullDistance;
var(RvrCEffectModuleRadialBlur) float m_fDistanceFalloffExponent;
var(RvrCEffectModuleRadialBlur) bool m_bRenderAsVelocity;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fBlurFalloffExponent = 1.5
    m_fBlurOpacity = 1.0
    m_fMaxCullDistance = 2000.0
    m_fDistanceFalloffExponent = 1.5
    m_pInstanceClass = Class'RvrCEffectModuleRadialBlurInstance'
    m_bSoftStopsAreHard = TRUE
}