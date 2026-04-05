Class SeqAct_WaitForLevelsVisible extends SeqAct_Latent
    native;

var(SeqAct_WaitForLevelsVisible) array<Name> LevelNames;
var(SeqAct_WaitForLevelsVisible) bool bShouldBlockOnLoad;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bShouldBlockOnLoad = TRUE
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