Class SeqAct_WwiseSetSwitch extends SequenceAction
    native;

var(SeqAct_WwiseSetSwitch) string SwitchGroup;
var(SeqAct_WwiseSetSwitch) string Switch;

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
}