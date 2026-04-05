Class SeqAct_ToggleConstraintDrive extends SequenceAction;

var(SeqAct_ToggleConstraintDrive) bool bEnableAngularPositionDrive;
var(SeqAct_ToggleConstraintDrive) bool bEnableAngularVelocityDrive;
var(SeqAct_ToggleConstraintDrive) bool bEnableLinearPositionDrive;
var(SeqAct_ToggleConstraintDrive) bool bEnableLinearvelocityDrive;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InputLinks = ({
                   LinkDesc = "Enable Drive", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Disable All Drive", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}