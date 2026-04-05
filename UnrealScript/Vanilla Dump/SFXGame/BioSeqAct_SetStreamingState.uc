Class BioSeqAct_SetStreamingState extends SequenceAction
    native;

var(BioSeqAct_SetStreamingState) Name StateName;
var(BioSeqAct_SetStreamingState) bool NewValue;

public function Activated()
{
    SetState();
    RetouchTriggers();
}
public native function RetouchTriggers();

public native function SetState();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "State Name", 
                      ExpectedType = Class'SeqVar_Name', 
                      LinkVar = 'None', 
                      PropertyName = 'StateName', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "New Value", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'NewValue', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}