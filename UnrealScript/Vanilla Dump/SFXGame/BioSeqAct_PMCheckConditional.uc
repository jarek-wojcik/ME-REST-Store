Class BioSeqAct_PMCheckConditional extends BioSeqAct_PMBase
    native;

var(BioSeqAct_PMCheckConditional) int Param;
var bool OutValue;
var(BioSeqAct_PMCheckConditional) EBioAutoSet Conditional;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sObjectType = "Check Conditional"
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "True", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "False", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Param", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'Param', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Value", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'OutValue', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}