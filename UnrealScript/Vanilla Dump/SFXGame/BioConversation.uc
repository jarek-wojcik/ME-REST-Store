Class BioConversation
    native;

struct native BioStageDirection 
{
    var(BioStageDirection) string sText;
    var(BioStageDirection) stringref srStrRef;
};
struct native BioDialogScript 
{
    var(BioDialogScript) Name sScriptTag;
};
struct native BioDialogSpeaker 
{
    var(BioDialogSpeaker) Name sSpeakerTag;
    var transient Actor aSpeaker;
};
struct native BioDialogReplyNode extends BioDialogNode 
{
    var(BioDialogReplyNode) array<int> EntryList;
    var(BioDialogReplyNode) int nListenerIndex;
    var(BioDialogReplyNode) bool bUnskippable;
    var transient bool bIllegal;
    var(BioDialogReplyNode) bool bIsDefaultAction;
    var(BioDialogReplyNode) bool bIsMajorDecision;
    var(BioDialogReplyNode) EReplyTypes ReplyType;
    
    structdefaultproperties
    {
        nListenerIndex = -3
    }
};
struct native BioDialogEntryNode extends BioDialogNode 
{
    var(BioDialogEntryNode) array<BioDialogReplyListDetails> ReplyListNew;
    var(BioDialogEntryNode) array<int> aSpeakerList;
    var(BioDialogEntryNode) int nSpeakerIndex;
    var(BioDialogEntryNode) int nListenerIndex;
    var(BioDialogEntryNode) bool bSkippable;
};
struct native BioDialogNode 
{
    var(BioDialogNode) string sText;
    var(BioDialogNode) stringref srText;
    var(BioDialogNode) int nConditionalFunc;
    var(BioDialogNode) int nConditionalParam;
    var(BioDialogNode) int nStateTransition;
    var(BioDialogNode) int nStateTransitionParam;
    var(BioDialogNode) editconst int nExportID;
    var(BioDialogNode) int nScriptIndex;
    var transient WwiseBaseSoundObject pCue;
    var(BioDialogNode) int nCameraIntimacy;
    var(BioDialogNode) bool bFireConditional;
    var(BioDialogNode) bool bAmbient;
    var(BioDialogNode) bool bNonTextLine;
    var transient bool bSoundLoaded;
    var(BioDialogNode) bool bIgnoreBodyGestures;
    var(BioDialogNode) bool bAlwaysHideSubtitle;
    var(BioDialogNode) EConvGUIStyles eGUIStyle;
};
struct native BioDialogReplyListDetails 
{
    var(BioDialogReplyListDetails) string sParaphrase;
    var(BioDialogReplyListDetails) int nIndex;
    var(BioDialogReplyListDetails) stringref srParaphrase;
    var(BioDialogReplyListDetails) EReplyCategory Category;
};
enum EInterruptionType
{
    INTERRUPTION_RENEGADE,
    INTERRUPTION_PARAGON,
};
enum EConvGUIStyles
{
    GUI_STYLE_NONE,
    GUI_STYLE_CHARM,
    GUI_STYLE_INTIMIDATE,
    GUI_STYLE_PLAYER_ALERT,
    GUI_STYLE_ILLEGAL,
};
enum EReplyCategory
{
    REPLY_CATEGORY_DEFAULT,
    REPLY_CATEGORY_AGREE,
    REPLY_CATEGORY_DISAGREE,
    REPLY_CATEGORY_FRIENDLY,
    REPLY_CATEGORY_HOSTILE,
    REPLY_CATEGORY_INVESTIGATE,
    REPLY_CATEGORY_RENEGADE_INTERRUPT,
    REPLY_CATEGORY_PARAGON_INTERRUPT,
};
enum EReplyTypes
{
    REPLY_STANDARD,
    REPLY_AUTOCONTINUE,
    REPLY_DIALOGEND,
};

var native MultiMap_Mirror m_mapStrRefToAnimData;
var(BioConversation) editconst array<int> m_StartingList;
var(BioConversation) editconst array<BioDialogEntryNode> m_EntryList;
var(BioConversation) editconst array<BioDialogReplyNode> m_ReplyList;
var(BioConversation) editconst array<Name> m_aSpeakerList;
var(BioConversation) editconst array<Name> m_aScriptList;
var(BioConversation) editconst biononship array<BioStageDirection> m_aStageDirections;
var const array<FaceFXAnimSet> m_aMaleFaceSets;
var const array<FaceFXAnimSet> m_aFemaleFaceSets;
var array<WwiseBaseSoundObject> m_aMaleSoundObjects;
var array<WwiseBaseSoundObject> m_aFemaleSoundObjects;
var(BioConversation) editconst int m_nResRefID;
var(BioConversation) const editconst Sequence MatineeSequence;
var(BioConversation) const editconst FaceFXAnimSet FaceFXSet;
var FaceFXAnimSet m_pNonSpeakerFaceFXSet;
var FaceFXAnimSet m_pRubberMouthAnimSet;
var(BioConversation) editconst bool m_bOneLinerConversation;
var transient bool m_bPlayerSexIsValid;
var transient bool m_bPlayerIsFemale;
var bool m_bHasSpeechGrammar;
var bool m_bUsesRubberMouth;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}