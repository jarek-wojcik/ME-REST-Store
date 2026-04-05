Class CovGoal_GoalProximity extends CoverGoalConstraint
    native;

var(CovGoal_GoalProximity) float BestGoalDist;
var(CovGoal_GoalProximity) float MinGoalDist;
var(CovGoal_GoalProximity) float MaxGoalDist;
var(CovGoal_GoalProximity) bool bHardLimits;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ConstraintEvaluationPriority = 2
}