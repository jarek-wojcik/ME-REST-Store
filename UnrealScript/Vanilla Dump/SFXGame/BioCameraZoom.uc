Class BioCameraZoom
    native
    config(Game);

struct native BioZoomMagnificationConfig 
{
    var float m_fCamSpeedFactor;
    var float m_fFOVFactor;
    var int m_nLevelCount;
    var float m_fTransitionDuration;
    
    structdefaultproperties
    {
        m_fCamSpeedFactor = 0.5
        m_fFOVFactor = 0.5
        m_nLevelCount = 2
        m_fTransitionDuration = 0.5
    }
};
struct native BioZoomFocusConfig 
{
    var float m_fMaxFocusDistance;
    var float m_fNearClipFactor;
    var float m_fNearClipMax;
    var float m_fMinRate;
    var float m_fFocusFraction;
    var float m_fInnerRadiusFactor;
    var float m_fFalloffExponent;
    var float m_fBlurKernelSize;
    var float m_fMaxNearBlurAmount;
    var float m_fMaxFarBlurAmount;
    var Color m_clrModulateBlur;
    
    structdefaultproperties
    {
        m_fMaxFocusDistance = 10000.0
        m_fNearClipFactor = 0.00100000005
        m_fMinRate = 10000.0
        m_fFocusFraction = 0.541199982
        m_fInnerRadiusFactor = 0.5
        m_fFalloffExponent = 2.0
        m_fBlurKernelSize = 2.0
        m_fMaxNearBlurAmount = 1.0
        m_fMaxFarBlurAmount = 1.0
        m_clrModulateBlur = {B = 255, G = 255, R = 255, A = 255}
    }
};

var const config BioZoomFocusConfig m_focusConfig;
var const config BioZoomMagnificationConfig m_magnificationConfig;
var int m_nCurrentMagnificationLevel;
var float m_fFOVTarget;
var float m_fFOVRate;
var float m_fFOVMin;
var float m_fFOVMax;
var float m_fCamStickScalarTarget;
var float m_fCamStickScalarRate;
var float m_fCamStickScalarMin;
var float m_fFocusDistance;
var float m_fFocusDistanceTarget;

public final native function Focus(float fDistance, BioWorldInfo pWorldInfo);

public final native function int GetCurrentMagnificationLevel();

public native function ModifyPostProcessSettings(out PostProcessSettings PPSettings);

public final native function Tick(float TimeDelta, float FOV, float CamStickScalar);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_focusConfig = {
                     m_fMaxFocusDistance = 50000.0, 
                     m_fNearClipFactor = 0.0350000001, 
                     m_fNearClipMax = 100.0, 
                     m_fMinRate = 10000.0, 
                     m_fFocusFraction = 0.541199982, 
                     m_fInnerRadiusFactor = 0.5, 
                     m_fFalloffExponent = 2.0, 
                     m_fBlurKernelSize = 2.0, 
                     m_fMaxNearBlurAmount = 1.0, 
                     m_fMaxFarBlurAmount = 1.0, 
                     m_clrModulateBlur = {B = 255, G = 255, R = 255, A = 255}
                    }
    m_magnificationConfig = {m_fCamSpeedFactor = 0.5, m_fFOVFactor = 0.5, m_nLevelCount = 2, m_fTransitionDuration = 0.5}
}