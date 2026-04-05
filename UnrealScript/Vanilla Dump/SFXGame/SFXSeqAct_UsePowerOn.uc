Class SFXSeqAct_UsePowerOn extends SeqAct_Latent
    native;

var Name nmPower;
var(SFXSeqAct_UsePowerOn) Pawn oPawn;
var(SFXSeqAct_UsePowerOn) Actor oTarget;
var(SFXSeqAct_UsePowerOn) float fTimeOut;
var int nCompletionReason;
var float m_fTotalTimeRunning;
var int m_nReason;
var bool m_bDone;
var(SFXSeqAct_UsePowerOn) EBioAutoSet ePower;

public event function CancelPower()
{
    local SFXAI_Core oAI;
    
    if (oPawn != None)
    {
        oAI = SFXAI_Core(oPawn.Controller);
        if (oAI != None)
        {
            oAI.CancelAction();
        }
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}
public event function UsePower(Actor pTarget)
{
    local SFXAI_Core oAI;
    
    if (oPawn != None)
    {
        oAI = SFXAI_Core(oPawn.Controller);
        if (oAI != None)
        {
            oAI.UsePowerOnTarget(nmPower, pTarget, UsePowerCallback);
        }
    }
}
public function UsePowerCallback(int nReason)
{
    m_bDone = TRUE;
    m_nReason = nReason;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fTimeOut = 5.0
    InputLinks = ({
                   LinkDesc = "In", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Cancel", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Success", 
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
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Pawn", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oPawn', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Power", 
                      ExpectedType = Class'SeqVar_Name', 
                      LinkVar = 'None', 
                      PropertyName = 'nmPower', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oTarget', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "TimeOut", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fTimeOut', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Completion Reason", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'nCompletionReason', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}