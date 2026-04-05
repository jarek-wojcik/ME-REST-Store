Class BioSeqAct_FaceOnlyVO extends BioSequenceLatentAction
    native
    editinlinenew;

enum EBioFOVOSpeakers
{
    FOVOSpeakers_Unset,
};
enum EBioFOVOLines
{
    FOVOLines_Unset,
};

var transient native Map_Mirror m_mapUsedEnums;
var transient array<stringref> m_aStrRefs;
var transient string m_sSubtitle;
var transient string m_sFaceFXAnim;
var Name m_nmSpeakerTag;
var(BioSeqAct_FaceOnlyVO) BioConversation m_pConversation;
var stringref m_srLineStrRef;
var(BioSeqAct_FaceOnlyVO) stringref m_srActorNameOverride;
var transient int m_nPickedSpeakerIndex;
var transient Actor m_pActor;
var transient WwiseBaseSoundObject m_pAudioObject;
var transient FaceFXAnimSet m_pFaceFXSet;
var transient float m_fPreLoadTimer;
var transient int m_nExportID;
var(BioSeqAct_FaceOnlyVO) bool m_bForceHideSubtitles;
var(BioSeqAct_FaceOnlyVO) bool m_bIgnoreHenchmanSquadCheck;
var(BioSeqAct_FaceOnlyVO) bool m_bPlaySoundOnly;
var(BioSeqAct_FaceOnlyVO) bool m_bDisableDelayUntilPreload;
var(BioSeqAct_FaceOnlyVO) bool m_bHasPriority;
var(BioSeqAct_FaceOnlyVO) bool m_bInterruptAmbients;
var(BioSeqAct_FaceOnlyVO) bool m_bSubtitleHasPriority;
var transient bool m_bErrorInActivation;
var transient bool m_bKilledVO;
var transient bool m_bPreLoadRequested;
var transient bool m_bPlayRequested;
var transient bool m_bAllowInConversation;
var transient bool m_bAlwaysHideSubtitle;
var transient bool m_bHasPlayed;
var transient bool m_bUpdatedMeshSettings;
var transient bool m_bEntryNode;
var transient bool m_bFemalePlayer;
var(BioSeqAct_FaceOnlyVO) EBioFOVOSpeakers m_eSpeakerList;
var(BioSeqAct_FaceOnlyVO) EBioFOVOLines m_eConvLine;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 4;
}
public event function PreVersionUpdated(int OldVersion, int NewVersion)
{
    if (VariableLinks.Length > 0 && VariableLinks[0].LinkDesc == "Pawn")
    {
        VariableLinks[0].LinkDesc = "Actor";
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InputLinks = ({
                   LinkDesc = "Play", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Begin PreLoad", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Done", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Failed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Aborted", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "PreLoad Done", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Actor", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}