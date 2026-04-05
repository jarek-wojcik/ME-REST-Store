Class SeqAct_WwiseLockMic extends SequenceAction
    native;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InputLinks = ({
                   LinkDesc = "Lock", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Unlock", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}