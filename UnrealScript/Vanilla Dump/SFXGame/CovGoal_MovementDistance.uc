Class CovGoal_MovementDistance extends CoverGoalConstraint
    native;

var(CovGoal_MovementDistance) float BestCoverDist;
var(CovGoal_MovementDistance) float MaxCoverDist;
var(CovGoal_MovementDistance) float MinCoverDist;
var(CovGoal_MovementDistance) float MinDistTowardGoal;
var(CovGoal_MovementDistance) bool bMoveTowardGoal;
var(CovGoal_MovementDistance) bool bHardConstraint;
var(CovGoal_MovementDistance) bool bIgnoreCoverOutOfRange;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ConstraintEvaluationPriority = 4
}