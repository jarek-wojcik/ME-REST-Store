Class SeqAct_LevelVisibility extends SeqAct_Latent
    native;

var(SeqAct_LevelVisibility) Name LevelName;
var(SeqAct_LevelVisibility) LevelStreaming Level;
var transient bool bStatusIsOk;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InputLinks = ({
                   LinkDesc = "Make Visible", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Hide", 
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