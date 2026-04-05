Class SeqAct_Teleport extends SequenceAction
    native;

var(SeqAct_Teleport) Vector m_vSFXTeleportLocation;
var(SeqAct_Teleport) Rotator m_rSFXTeleportRotation;
var(SeqAct_Teleport) bool bUpdateRotation;
var(SeqAct_Teleport) bool m_bPreserveVelocity;
var(SeqAct_Teleport) bool m_bSnapToFloor;
var(SeqAct_Teleport) bool m_bSFXTeleportDataIsValid;
var bool m_bSFXCreatedBeforeStuntActorLocationChange;

public event function bool SFXGetTeleportLocAndRot(out Vector vLocation, out Rotator rRotation, out Actor pDestActor)
{
    local array<Object> objVars;
    local int idx;
    local Actor destActor;
    local Controller C;
    
    pDestActor = None;
    GetObjectVars(objVars, "Destination");
    for (idx = 0; idx < objVars.Length && destActor == None; idx++)
    {
        destActor = Actor(objVars[idx]);
        C = Controller(destActor);
        if (C != None && C.Pawn != None)
        {
            destActor = C.Pawn;
        }
        if (destActor != None)
        {
            pDestActor = destActor;
            vLocation = destActor.location;
            rRotation = destActor.Rotation;
            return TRUE;
        }
    }
    if (m_bSFXTeleportDataIsValid)
    {
        vLocation = m_vSFXTeleportLocation;
        rRotation = m_rSFXTeleportRotation;
        return TRUE;
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bUpdateRotation = TRUE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Destination", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}