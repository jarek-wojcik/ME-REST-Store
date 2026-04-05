Class BioConversationManager
    native;

var transient native Map_Mirror m_mapKismetToConversation;
var transient array<BioConversationController> m_aPreloadingConversations;
var transient array<BioConversationController> m_aReadyConversations;
var transient array<BioConversationController> m_aActiveConversations;
var transient bool m_bActivatingConversation;

public native function bool AnyConversationsActive(optional EBioConversationType eConvType = 0, optional bool bIncludeFull = TRUE, optional bool bIncludeAmbient = TRUE);

public native function BioConversationController GetConversationControllerByResourceID(int nResourceID);

public native function BioConversationController GetFullConversation();

public native function InterruptAmbientConversations(const out string sReason, BioConversation pIgnoreConv, BioConversation pOnlyThis);

public native function bool IsAnyControllerActiveForResourceID(int nResourceID, optional BioConversationController pIgnoreController, optional bool bIncludeFull = TRUE, optional bool bIncludeAmbient = TRUE);

public native function RemoveConversation(BioConversationController pController, const out string sReason);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}