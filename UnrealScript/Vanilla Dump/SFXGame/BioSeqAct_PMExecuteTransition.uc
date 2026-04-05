Class BioSeqAct_PMExecuteTransition extends BioSeqAct_PMBase
    native;

var(BioSeqAct_PMExecuteTransition) int Param;
var(BioSeqAct_PMExecuteTransition) EBioAutoSet Transition;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sObjectType = "Execute Transition"
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
                     }
                    )
}