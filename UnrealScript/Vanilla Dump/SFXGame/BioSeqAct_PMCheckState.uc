Class BioSeqAct_PMCheckState extends BioSeqAct_PMBase
    native;

var bool OutValue;
var(BioSeqAct_PMCheckState) EBioAutoSet State;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sObjectType = "Check State"
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
    bManualHandleOutputs = TRUE
}