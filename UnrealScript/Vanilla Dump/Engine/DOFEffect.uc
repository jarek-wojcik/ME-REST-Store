Class DOFEffect extends PostProcessEffect
    native
    abstract;

enum EFocusType
{
    FOCUS_Distance,
    FOCUS_Position,
};

var(DOFEffect) Vector FocusPosition;
var(DOFEffect) float FalloffExponent;
var(DOFEffect) float BlurKernelSize;
var(DOFEffect) float MaxNearBlurAmount;
var(DOFEffect) float MaxFarBlurAmount;
var(DOFEffect) Color ModulateBlurColor;
var(DOFEffect) float FocusInnerRadius;
var(DOFEffect) float FocusDistance;
var(DOFEffect) EFocusType FocusType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FalloffExponent = 2.0
    BlurKernelSize = 2.0
    MaxNearBlurAmount = 1.0
    MaxFarBlurAmount = 1.0
    ModulateBlurColor = {B = 255, G = 255, R = 255, A = 255}
    FocusInnerRadius = 400.0
    FocusDistance = 800.0
}