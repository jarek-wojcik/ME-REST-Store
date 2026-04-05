Class BioSeqEvt_Conversation extends SequenceEvent
    native;

enum EConversationScriptType
{
    NodeEnd,
    NodeStart,
    StartConversationScript,
    EndConversationScript,
    SwitchFromFullToAmbient,
};

var(BioSeqEvt_Conversation) Name sScriptName;
var(BioSeqEvt_Conversation) BioConversation Conv;
var(BioSeqEvt_Conversation) bool bFireForFull;
var(BioSeqEvt_Conversation) bool bFireForAmbient;
var(BioSeqEvt_Conversation) EConversationScriptType eScriptType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bFireForFull = TRUE
    bFireForAmbient = TRUE
    WhoTriggers = EWhoTriggers.WT_Everyone
    VariableLinks = ()
}