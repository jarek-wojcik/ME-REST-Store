Class SFXSeqAct_WaitForStreamingComplete extends SeqAct_Latent
    native;

var(SFXSeqAct_WaitForStreamingComplete) bool bWaitForVisibleOnly;
var(SFXSeqAct_WaitForStreamingComplete) bool bBlocking;
var(SFXSeqAct_WaitForStreamingComplete) bool bWaitForUnvisibleAndUnloaded;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bWaitForVisibleOnly = TRUE
    InputLinks = ({
                   LinkDesc = "Wait", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Finished", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ()
}