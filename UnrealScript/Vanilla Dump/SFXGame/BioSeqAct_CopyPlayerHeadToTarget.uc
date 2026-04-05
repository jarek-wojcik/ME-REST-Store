Class BioSeqAct_CopyPlayerHeadToTarget extends SequenceAction
    native;

var(BioSeqAct_CopyPlayerHeadToTarget) bool m_bCopyHeadGearMesh;
var(BioSeqAct_CopyPlayerHeadToTarget) bool m_bCopyHairMesh;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bCopyHeadGearMesh = TRUE
    m_bCopyHairMesh = TRUE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Done", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}