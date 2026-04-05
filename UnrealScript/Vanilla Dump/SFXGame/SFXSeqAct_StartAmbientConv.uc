Class SFXSeqAct_StartAmbientConv extends BioSequenceLatentAction
    native;

struct native SFXConvActorVar 
{
    var Name nmPinName;
    var Actor pActor;
    var SeqVar_Object pSeqVar;
};

var transient array<SFXConvActorVar> m_aConnectedActors;
var(SFXSeqAct_StartAmbientConv) BioConversation Conv;
var(SFXSeqAct_StartAmbientConv) float m_fInterruptRange;
var transient BioConversationController m_pConvController;
var transient Actor m_pOwner;
var(SFXSeqAct_StartAmbientConv) bool m_bNoGestures;
var(SFXSeqAct_StartAmbientConv) bool m_bFOVOMode;
var(SFXSeqAct_StartAmbientConv) bool m_bLookAtActive;
var(SFXSeqAct_StartAmbientConv) bool m_bDisableLookAtRangeCheck;
var(SFXSeqAct_StartAmbientConv) bool m_bDisableDelayUntilPreload;
var(SFXSeqAct_StartAmbientConv) bool m_bDisableProceduralFoley;
var(SFXSeqAct_StartAmbientConv) bool m_bAllowStartingIfAlreadyActive;
var(SFXSeqAct_StartAmbientConv) bool m_bSubtitleHasPriority;
var transient bool m_bPreLoading;
var transient bool m_bPlayRequested;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bLookAtActive = TRUE
    m_bAllowStartingIfAlreadyActive = TRUE
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
                    LinkDesc = "Out", 
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
                    LinkDesc = "PreLoad Done", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Owner", 
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
    bManualHandleOutputs = TRUE
}