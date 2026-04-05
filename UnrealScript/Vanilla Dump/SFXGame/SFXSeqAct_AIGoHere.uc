Class SFXSeqAct_AIGoHere extends BioSequenceLatentAction
    deprecated;

var(SFXSeqAct_AIGoHere) float m_fTimeOut;
var(SFXSeqAct_AIGoHere) float m_fInvalidateRange;
var transient BioPawn m_Pawn;
var transient NavigationPoint m_TargetNav;
var transient NavigationPoint m_TargetNavAtInvalidation;
var transient float m_TimeRemaining;
var transient float m_UpdateTimer;
var(SFXSeqAct_AIGoHere) bool m_bInvalidateOnFlank;
var(SFXSeqAct_AIGoHere) bool m_bInstanceLogging;
var transient bool m_bArrivedPinFired;
var transient bool m_bTargetInvalidated;

public event function Activated()
{
    OutputLinks[0].bHasImpulse = TRUE;
}
public event function Deactivated()
{
    local SFXAI_Core oAI;
    
    if (m_Pawn != None)
    {
        oAI = SFXAI_Core(m_Pawn.Controller);
        if (oAI != None)
        {
            oAI.ClearGoHereDelegates();
        }
    }
}
public event function bool UpdateOp(float DeltaTime)
{
    return TRUE;
}
public function ClearGoHereTarget()
{
    AbortFor(m_Pawn, TRUE);
}
public function InvalidateGoHereTarget()
{
    m_bTargetInvalidated = TRUE;
    OutputLinks[3].bHasImpulse = TRUE;
    ResetUpdateTimer();
}
public function ResetUpdateTimer()
{
    m_UpdateTimer = 1.0;
}
public function bool TryInvalidateTargetFlank()
{
    if (m_bInvalidateOnFlank)
    {
        if (m_bInstanceLogging)
        {
        }
        InvalidateGoHereTarget();
        return TRUE;
    }
    return FALSE;
}
public function bool TryInvalidateTargetRange(float fRangeToTargetInUU)
{
    if (fRangeToTargetInUU / 100.0 < m_fInvalidateRange)
    {
        if (m_bInstanceLogging)
        {
        }
        InvalidateGoHereTarget();
        return TRUE;
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fTimeOut = 120.0
    m_bInvalidateOnFlank = TRUE
    InputLinks = ({
                   LinkDesc = "Set", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Clear", 
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
                    LinkDesc = "Arrived", 
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
                    LinkDesc = "Invalidated", 
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
                      PropertyName = 'm_Pawn', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Target Nav", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_TargetNav', 
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