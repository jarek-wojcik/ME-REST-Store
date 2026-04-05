Class SeqAct_WwiseSetState extends SequenceAction
    native;

var(SeqAct_WwiseSetState) string StateGroup;
var(SeqAct_WwiseSetState) string State;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InputLinks = ({
                   LinkDesc = "Set", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    VariableLinks = ()
}