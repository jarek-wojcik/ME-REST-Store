Class RvrSeqAct_ActivateClientEffect extends SequenceAction
    native;

var(RvrSeqAct_ActivateClientEffect) bool bAllowCooldown;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAllowCooldown = TRUE
    InputLinks = ({
                   LinkDesc = "Activate", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Deactivate", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}