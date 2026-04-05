Class BioSeqEvt_ConvNode extends SequenceEvent
    native;

var(BioSeqEvt_ConvNode) int m_nNodeID;
var(BioSeqEvt_ConvNode) int m_nConvResRefID;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nNodeID = -1
    m_nConvResRefID = -1
    WhoTriggers = EWhoTriggers.WT_Everyone
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Started", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ()
}