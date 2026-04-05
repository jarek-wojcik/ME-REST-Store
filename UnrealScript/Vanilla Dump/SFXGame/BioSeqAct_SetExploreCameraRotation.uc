Class BioSeqAct_SetExploreCameraRotation extends SequenceAction;

var(BioSeqAct_SetExploreCameraRotation) Actor oTarget;
var(BioSeqAct_SetExploreCameraRotation) bool bForceInstant;

public function Activated()
{
    local BioWorldInfo BWI;
    local PlayerController PC;
    
    if (oTarget == None)
    {
        OutputLinks[1].bHasImpulse = TRUE;
        return;
    }
    BWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    PC = BWI.GetLocalPlayerController();
    if (PC == None || PC.PlayerCamera == None)
    {
        OutputLinks[1].bHasImpulse = TRUE;
        return;
    }
    if (SFXPlayerCamera(PC.PlayerCamera) == None || SFXPlayerCamera(PC.PlayerCamera).CurrentCameraMode == None)
    {
        OutputLinks[1].bHasImpulse = TRUE;
        return;
    }
    SFXPlayerCamera(PC.PlayerCamera).CurrentCameraMode.AimAtPoint(oTarget.location);
    PC.SetRotation(SFXPlayerCamera(PC.PlayerCamera).CurrentCameraMode.m_pov.Rotation);
    OutputLinks[0].bHasImpulse = TRUE;
}
public event function bool IsCameraExploreMode(SFXCameraMode pCameraMode)
{
    return SFXCameraMode_Explore(pCameraMode) != None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
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
                      LinkDesc = "bForceAnyCamInstantly", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bForceInstant', 
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