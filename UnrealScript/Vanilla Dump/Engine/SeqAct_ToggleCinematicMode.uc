Class SeqAct_ToggleCinematicMode extends SequenceAction;

var(SeqAct_ToggleCinematicMode) bool bDisableMovement;
var(SeqAct_ToggleCinematicMode) bool bDisableTurning;
var(SeqAct_ToggleCinematicMode) bool bHidePlayer;
var(SeqAct_ToggleCinematicMode) bool bDisableInput;
var(SeqAct_ToggleCinematicMode) bool bHideHUD;
var(SeqAct_ToggleCinematicMode) bool bDeadBodies;
var(SeqAct_ToggleCinematicMode) bool bDroppedPickups;

public event function Activated();

public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bDisableMovement = TRUE
    bDisableTurning = TRUE
    bDisableInput = TRUE
    bHideHUD = TRUE
    bDeadBodies = TRUE
    bDroppedPickups = TRUE
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "Enable", 
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
                   LinkDesc = "Toggle", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}