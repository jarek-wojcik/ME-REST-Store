Class SeqAct_Delay extends SeqAct_Latent
    native;

var const float DefaultDuration;
var(SeqAct_Delay) float Duration;
var const float LastUpdateTime;
var const float RemainingTime;
var const bool bDelayActive;
var(SeqAct_Delay) bool bStartWillRestart;

public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return TRUE;
}
public function Reset()
{
    ResetDelayActive();
}
public native function ResetDelayActive();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultDuration = 1.0
    Duration = 1.0
    InputLinks = ({
                   LinkDesc = "Start", 
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
                   LinkDesc = "Pause", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Duration", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'Duration', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}