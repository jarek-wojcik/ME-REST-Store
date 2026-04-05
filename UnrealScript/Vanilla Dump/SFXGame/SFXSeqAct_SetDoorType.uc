Class SFXSeqAct_SetDoorType extends SequenceAction;

var transient SFXDoor m_Door;
var(SFXDoor) ESFXDoorType m_DoorType;

public event function Activated()
{
    Super(SequenceOp).Activated();
    if (m_Door != None)
    {
        m_Door.m_DoorType = m_DoorType;
        m_Door.OnTransitionEnd();
    }
    OutputLinks[0].bHasImpulse = TRUE;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "Set", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
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