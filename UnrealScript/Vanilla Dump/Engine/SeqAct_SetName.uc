Class SeqAct_SetName extends SeqAct_SetSequenceVariable;

var Name Target;
var(SeqAct_SetName) Name Value;

public function Activated()
{
    Target = Value;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Name', 
                      LinkVar = 'None', 
                      PropertyName = 'Target', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Value", 
                      ExpectedType = Class'SeqVar_Name', 
                      LinkVar = 'None', 
                      PropertyName = 'Value', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}