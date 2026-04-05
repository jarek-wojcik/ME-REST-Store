Class SeqAct_SetMatInstVectorParam extends SequenceAction
    deprecated;

var(SeqAct_SetMatInstVectorParam) LinearColor VectorValue;
var(SeqAct_SetMatInstVectorParam) Name ParamName;
var(SeqAct_SetMatInstVectorParam) MaterialInstanceConstant MatInst;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VectorValue = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "VectorValue", 
                      ExpectedType = Class'SeqVar_Vector', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}