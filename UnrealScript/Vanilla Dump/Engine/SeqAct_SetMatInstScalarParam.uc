Class SeqAct_SetMatInstScalarParam extends SequenceAction
    native;

var(SeqAct_SetMatInstScalarParam) Name ParamName;
var(SeqAct_SetMatInstScalarParam) MaterialInstanceConstant MatInst;
var(SeqAct_SetMatInstScalarParam) float ScalarValue;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "ScalarValue", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'ScalarValue', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}