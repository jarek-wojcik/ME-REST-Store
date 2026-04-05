Class BioSeqAct_InterruptAmbientConversation extends SequenceAction;

var(BioSeqAct_InterruptAmbientConversation) BioConversation IgnoreConversation;
var(BioSeqAct_InterruptAmbientConversation) BioConversation OnlyInterruptThisConv;
var(BioSeqAct_InterruptAmbientConversation) bool m_bInterruptFovoToo;

public function Activated()
{
    local BioWorldInfo pBWI;
    local string sReason;
    
    pBWI = BioWorldInfo(GetWorldInfo());
    if (pBWI != None)
    {
        if (m_bInterruptFovoToo)
        {
            pBWI.EndAllFOVOs(FALSE);
        }
        if (pBWI.GetConversationManager() != None)
        {
            sReason = "Interrupt kismet action called";
            pBWI.GetConversationManager().InterruptAmbientConversations(sReason, IgnoreConversation, OnlyInterruptThisConv);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ()
}