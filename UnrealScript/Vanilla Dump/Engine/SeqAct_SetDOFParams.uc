Class SeqAct_SetDOFParams extends SeqAct_Latent
    native;

var(SeqAct_SetDOFParams) Vector FocusPosition;
var Vector OldFocusPosition;
var(SeqAct_SetDOFParams) float FalloffExponent;
var(SeqAct_SetDOFParams) float BlurKernelSize;
var(SeqAct_SetDOFParams) float MaxNearBlurAmount;
var(SeqAct_SetDOFParams) float MaxFarBlurAmount;
var(SeqAct_SetDOFParams) Color ModulateBlurColor;
var(SeqAct_SetDOFParams) float FocusInnerRadius;
var(SeqAct_SetDOFParams) float FocusDistance;
var(SeqAct_SetDOFParams) float InterpolateSeconds;
var float InterpolateElapsed;
var float OldFalloffExponent;
var float OldBlurKernelSize;
var float OldMaxNearBlurAmount;
var float OldMaxFarBlurAmount;
var Color OldModulateBlurColor;
var float OldFocusInnerRadius;
var float OldFocusDistance;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FalloffExponent = 4.0
    BlurKernelSize = 5.0
    MaxNearBlurAmount = 1.0
    MaxFarBlurAmount = 1.0
    ModulateBlurColor = {B = 255, G = 255, R = 255, A = 255}
    FocusInnerRadius = 600.0
    FocusDistance = 600.0
    InterpolateSeconds = 2.0
    InputLinks = ({
                   LinkDesc = "Enable", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Disable", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}