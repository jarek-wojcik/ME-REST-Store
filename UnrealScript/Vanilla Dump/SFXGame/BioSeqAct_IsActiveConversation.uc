Class BioSeqAct_IsActiveConversation extends SequenceAction;

var(BioSeqAct_IsActiveConversation) BioConversation Conversation;
var(BioSeqAct_IsActiveConversation) bool m_bCheckForFovoToo;
var(BioSeqAct_IsActiveConversation) bool m_bCheckForFull;
var(BioSeqAct_IsActiveConversation) bool m_bCheckForAmbient;

public function Activated()
{
    local BioWorldInfo pBWI;
    local BioConversationManager pConvMan;
    
    OutputLinks[0].bHasImpulse = FALSE;
    OutputLinks[1].bHasImpulse = FALSE;
    pBWI = BioWorldInfo(GetWorldInfo());
    if (pBWI != None)
    {
        if (m_bCheckForFovoToo && pBWI.IsFOVOPlaying(None, TRUE))
        {
            OutputLinks[0].bHasImpulse = TRUE;
            return;
        }
        pConvMan = pBWI.GetConversationManager();
        if (pConvMan != None)
        {
            if (Conversation == None)
            {
                if (pConvMan.AnyConversationsActive(0, m_bCheckForFull, m_bCheckForAmbient))
                {
                    OutputLinks[0].bHasImpulse = TRUE;
                    return;
                }
            }
            else if (pConvMan.IsAnyControllerActiveForResourceID(Conversation.m_nResRefID, None, m_bCheckForFull, m_bCheckForAmbient))
            {
                OutputLinks[0].bHasImpulse = TRUE;
                return;
            }
        }
    }
    OutputLinks[1].bHasImpulse = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bCheckForFull = TRUE
    m_bCheckForAmbient = TRUE
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
    VariableLinks = ()
    bManualHandleOutputs = TRUE
}