Class SFXCovGoal_AvoidHazard extends CoverGoalConstraint
    native;

var transient array<Vector> Hazards;
var float MaxWeight;

public native function Init(Goal_AtCover GoalEvaluator);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxWeight = 10.0
}