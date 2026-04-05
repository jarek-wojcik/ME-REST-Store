Class SeqAct_ConvertToString extends SequenceAction
    native;

var(SeqAct_ConvertToString) string VarSeparator;
var(SeqAct_ConvertToString) int NumberOfInputs;
var(SeqAct_ConvertToString) bool bIncludeVarComment;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VarSeparator = ", "
    NumberOfInputs = 1
    bIncludeVarComment = TRUE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Inputs", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = TRUE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Output", 
                      ExpectedType = Class'SeqVar_String', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}