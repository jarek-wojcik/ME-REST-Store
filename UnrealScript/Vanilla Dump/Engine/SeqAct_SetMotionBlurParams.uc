Class SeqAct_SetMotionBlurParams extends SeqAct_Latent
    native;

var(SeqAct_SetMotionBlurParams) float MotionBlurAmount;
var(SeqAct_SetMotionBlurParams) float InterpolateSeconds;
var float InterpolateElapsed;
var float OldMotionBlurAmount;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MotionBlurAmount = 0.100000001
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