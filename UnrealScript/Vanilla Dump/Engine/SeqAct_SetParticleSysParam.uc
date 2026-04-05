Class SeqAct_SetParticleSysParam extends SequenceAction;

var(SeqAct_SetParticleSysParam) editinline export array<ParticleSysParam> InstanceParameters;
var(SeqAct_SetParticleSysParam) float ScalarValue;
var(SeqAct_SetParticleSysParam) bool bOverrideScalar;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bOverrideScalar = TRUE
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
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Scalar Value", 
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