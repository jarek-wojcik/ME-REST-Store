Class SeqAct_ForceFeedback extends SequenceAction;

var(SeqAct_ForceFeedback) Class<WaveFormBase> PredefinedWaveForm;
var(SeqAct_ForceFeedback) ForceFeedbackWaveform FFWaveform;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InputLinks = ({
                   LinkDesc = "Start", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}