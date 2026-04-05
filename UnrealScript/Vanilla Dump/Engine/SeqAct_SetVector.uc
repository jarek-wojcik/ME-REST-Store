Class SeqAct_SetVector extends SeqAct_SetSequenceVariable;

var(SeqAct_SetVector) Vector DefaultValue;

public event function Activated()
{
    local bool bIgnoreDefault;
    local SeqVar_Vector VectVar;
    local Vector Value;
    
    foreach LinkedVariables(Class'SeqVar_Vector', VectVar, "Value")
    {
        bIgnoreDefault = TRUE;
        Value += VectVar.VectValue;
    }
    if (!bIgnoreDefault)
    {
        Value = DefaultValue;
    }
    foreach LinkedVariables(Class'SeqVar_Vector', VectVar, "Target")
    {
        VectVar.VectValue = Value;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Vector', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
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