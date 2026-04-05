Class SFXSeqAct_SetDoorState extends BioSequenceLatentAction;

var transient SFXDoor m_Door;
var float ActivatedStartTime;
var float MaxWaitTime;
var(SFXSeqAct_SetDoorState) bool m_bInstantTransition;
var bool bForceFireSuccess;

public event function Activated()
{
    local WorldInfo WI;
    
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI != None)
    {
        ActivatedStartTime = WI.TimeSeconds;
    }
    Super(SequenceOp).Activated();
    if (m_Door != None)
    {
        if (InputLinks[5].bHasImpulse == TRUE)
        {
            SetDoorState(4, FALSE);
        }
        else if (InputLinks[6].bHasImpulse == TRUE)
        {
            if (m_Door.m_CurrentDoorState == ESFXDoorState.EDS_Disabled)
            {
                SetDoorState(m_Door.m_PreviousDoorState, TRUE);
            }
        }
        else if (InputLinks[7].bHasImpulse == TRUE)
        {
            SetDoorState(5, FALSE);
        }
        if (InputLinks[0].bHasImpulse == TRUE)
        {
            SetDoorState(1, TRUE);
        }
        else if (InputLinks[1].bHasImpulse == TRUE)
        {
            SetDoorState(0, FALSE);
        }
        else if (InputLinks[2].bHasImpulse == TRUE)
        {
            SetDoorState(2, FALSE);
        }
        else if (InputLinks[3].bHasImpulse == TRUE)
        {
            SetDoorState(3, FALSE);
        }
        else if (InputLinks[4].bHasImpulse == TRUE)
        {
            SetDoorState(0, FALSE);
        }
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}
public function SetDoorState(ESFXDoorState ToState, bool bEnableDoor)
{
    if (m_Door.m_CurrentDoorState != ESFXDoorState.EDS_Disabled)
    {
        m_Door.SetDoorState(ToState, None, m_bInstantTransition);
    }
    else if (m_Door.m_CurrentDoorState == ESFXDoorState.EDS_Disabled && bEnableDoor)
    {
        m_Door.SetDoorState(ToState, None, m_bInstantTransition);
    }
    else if (ToState != ESFXDoorState.EDS_Disabled)
    {
        m_Door.m_PreviousDoorState = ToState;
        m_Door.SaveDoorStates();
    }
}
public function bool UpdateOp(float fDeltaT)
{
    local WorldInfo WI;
    
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI == None)
    {
        OutputLinks[0].bHasImpulse = TRUE;
        return TRUE;
    }
    if (WI.TimeSeconds - ActivatedStartTime > MaxWaitTime || m_Door.m_bIsTransitioning == FALSE)
    {
        OutputLinks[0].bHasImpulse = TRUE;
        return TRUE;
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxWaitTime = 0.5
    bHasTargets = FALSE
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "Open", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Closed", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Hackable Locked", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Plot Locked", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Unlocked", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Disable", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Enable", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Delayed", 
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
                      LinkDesc = "SFXDoor", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_Door', 
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