Class BioAnimNodeBlendScalar extends BioAnimNodeBlendBase
    native;

struct native BioScalarPrecomputedValues 
{
    var float fRangeLowerRatio;
    var float fRangeUpperRatio;
};
struct native BioScalarBlendParams 
{
    var(BioScalarBlendParams) float Min;
    var(BioScalarBlendParams) float Peak;
    var(BioScalarBlendParams) float Max;
};

var(BioAnimNodeBlendScalar) editconst array<BioScalarBlendParams> m_aChildBlendParams;
var string m_sDescription;
var array<BioScalarPrecomputedValues> m_aChildPrecomputes;
var(BioAnimNodeBlendScalar) float m_fBlendPctPerSecond;
var(BioAnimNodeBlendScalar) float m_fBlendSpanTime;
var float m_fRangeMin;
var float m_fRangeMax;
var float m_fUnitsPerSecond;
var float m_fCurrentScalar;
var float m_fTargetScalar;
var(Behavior) export BioAnimNodeBlendScalarBehavior m_oBehavior;
var(BioAnimNodeBlendScalar) bool m_bBlendInstant;
var(BioAnimNodeBlendScalar) bool m_bUseBlendSpanTime;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bFixNumChildren = TRUE
}