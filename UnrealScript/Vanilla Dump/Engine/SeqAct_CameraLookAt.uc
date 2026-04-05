Class SeqAct_CameraLookAt extends SequenceAction
    native;

var(SeqAct_CameraLookAt) string TextDisplay;
var(SeqAct_CameraLookAt) Vector2D InterpSpeedRange;
var(SeqAct_CameraLookAt) Vector2D InFocusFOV;
var(SeqAct_CameraLookAt) Name FocusBoneName;
var(SeqAct_CameraLookAt) float TotalTime;
var(SeqAct_CameraLookAt) float CameraFOV;
var transient float RemainingTime;
var(SeqAct_CameraLookAt) bool bAffectCamera;
var(SeqAct_CameraLookAt) bool bAlwaysFocus;
var(SeqAct_CameraLookAt) bool bTurnInPlace;
var(SeqAct_CameraLookAt) bool bIgnoreTrace;
var(SeqAct_CameraLookAt) bool bAffectHead;
var(SeqAct_CameraLookAt) bool bRotatePlayerWithCamera;
var(SeqAct_CameraLookAt) bool bToggleGodMode;
var(SeqAct_CameraLookAt) bool bLeaveCameraRotation;
var(SeqAct_CameraLookAt) bool bDisableInput;
var bool bUsedTimer;
var(SeqAct_CameraLookAt) bool bCheckLineOfSight;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 3;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InterpSpeedRange = {X = 3.0, Y = 3.0}
    InFocusFOV = {X = 1.0, Y = 1.0}
    CameraFOV = -1.0
    bAffectCamera = TRUE
    bTurnInPlace = TRUE
    bDisableInput = TRUE
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
                    LinkDesc = "Finished", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Succeeded", 
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
                      LinkDesc = "Focus", 
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
    bLatentExecution = TRUE
}