Class SeqAct_LevelStreamingBase extends SeqAct_Latent
    native
    abstract;

var(SeqAct_LevelStreamingBase) bool bMakeVisibleAfterLoad;
var(SeqAct_LevelStreamingBase) bool bShouldBlockOnLoad;
var(SeqAct_LevelStreamingBase) bool bNeverAutoStreamOut;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bMakeVisibleAfterLoad = TRUE
    InputLinks = ({
                   LinkDesc = "Load", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Unload", 
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