Class SFXSeqAct_WaitForGFxMovieClose extends SeqAct_Latent
    native;

var(SFXGUI) SFXGUIMovieKismet movie;
var(SFXGUI) bool DeferredClose;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DeferredClose = TRUE
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
}