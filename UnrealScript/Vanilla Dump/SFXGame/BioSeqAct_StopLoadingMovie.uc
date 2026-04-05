Class BioSeqAct_StopLoadingMovie extends SeqAct_Latent
    native;

var(BioSeqAct_StopLoadingMovie) bool bDelayStopUntilGameHasRendered;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Done", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ()
    bAutoActivateOutputLinks = FALSE
}