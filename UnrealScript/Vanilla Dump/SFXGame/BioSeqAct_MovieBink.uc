Class BioSeqAct_MovieBink extends BioSequenceLatentAction
    native;

var transient BioBinkAsyncPreloader Preloader;
var(BioSeqAct_MovieBink) string m_sMovieName;
var(BioSeqAct_MovieBink) WwiseEvent m_wwiseEvent;
var bool m_bFiredBinkStartEvent;
var transient bool m_bKeepTryingToPlay;
var transient bool IsComplete;

public event function Activated()
{
    local BioPlayerController Controller;
    
    Super(SequenceOp).Activated();
    Controller = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    if (Controller != None)
    {
        Controller.GameModeManager2.EnableMode(10);
    }
    m_bFiredBinkStartEvent = FALSE;
}
public event function Deactivated()
{
    local BioPlayerController Controller;
    local BioWorldInfo BWI;
    
    Super(SequenceOp).Deactivated();
    BWI = BioWorldInfo(GetWorldInfo());
    if (BWI != None)
    {
        Controller = BWI.GetLocalPlayerController();
        if (Controller != None)
        {
            Controller.GameModeManager2.DisableMode(10);
        }
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 3;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InputLinks = ({
                   LinkDesc = "Play", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Prime", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Unprime", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Out", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Complete", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "HasStarted", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Failed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Primed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ()
    bManualHandleOutputs = TRUE
}