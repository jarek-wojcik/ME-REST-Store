Class SFXSeqAct_HenchmanUseInteractionPoint extends SeqAct_Latent
    native;

var(SFXSeqAct_HenchmanUseInteractionPoint) BioPawn HenchmanPawn;
var(SFXSeqAct_HenchmanUseInteractionPoint) Actor InteractionPoint;
var(SFXSeqAct_HenchmanUseInteractionPoint) float fFidelityTimeout;
var bool m_bStartedInteraction;
var bool m_bDone;
var bool m_bSuccess;

public event function bool CanDoInteraction()
{
    local SFXAI_Henchman oAI;
    
    if (HenchmanPawn != None)
    {
        oAI = SFXAI_Henchman(HenchmanPawn.Controller);
        if (oAI != None && InteractionPoint != None)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public event function bool StartInteraction(out int bBusy)
{
    local SFXAI_Henchman oAI;
    local bool bStarted;
    
    bStarted = FALSE;
    bBusy = 0;
    if (HenchmanPawn != None)
    {
        oAI = SFXAI_Henchman(HenchmanPawn.Controller);
        if (oAI != None)
        {
            bStarted = oAI.UseInteractionPoint(InteractionPoint, fFidelityTimeout, ReachedInteractionCallback, StoppedInteractionCallback, bBusy);
        }
    }
    return bStarted;
}
public event function StopInteraction()
{
    local SFXAI_Henchman oAI;
    
    if (HenchmanPawn != None)
    {
        oAI = SFXAI_Henchman(HenchmanPawn.Controller);
        if (oAI != None)
        {
            oAI.StopInteraction();
        }
    }
    if (!m_bStartedInteraction)
    {
        m_bDone = TRUE;
    }
}
public function ReachedInteractionCallback()
{
    OutputLinks[1].bHasImpulse = TRUE;
}
public function StoppedInteractionCallback(bool bSuccess)
{
    m_bDone = TRUE;
    m_bSuccess = bSuccess;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fFidelityTimeout = 20.0
    InputLinks = ({
                   LinkDesc = "Start", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Started", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Reached Target", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Stopped", 
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
                      LinkDesc = "Henchman", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'HenchmanPawn', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Destination Point", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'InteractionPoint', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}