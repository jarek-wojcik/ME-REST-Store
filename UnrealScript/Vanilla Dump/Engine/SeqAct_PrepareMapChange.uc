Class SeqAct_PrepareMapChange extends SeqAct_Latent
    native;

var(SeqAct_PrepareMapChange) array<Name> InitiallyLoadedSecondaryLevelNames;
var(SeqAct_PrepareMapChange) Name MainLevelName;
var(SeqAct_PrepareMapChange) bool bIsHighPriority;
var transient bool bStatusIsOk;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InputLinks = ({
                   LinkDesc = "PrepareLoad", 
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