Class SeqAct_ToggleInput extends SeqAct_Toggle;

var(SeqAct_ToggleInput) bool bToggleMovement;
var(SeqAct_ToggleInput) bool bToggleTurning;

public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bToggleMovement = TRUE
    bToggleTurning = TRUE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = TRUE, 
                      bAllowAnyType = FALSE
                     }
                    )
}