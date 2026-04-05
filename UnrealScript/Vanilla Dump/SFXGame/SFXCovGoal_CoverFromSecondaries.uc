Class SFXCovGoal_CoverFromSecondaries extends CoverGoalConstraint
    native;

var array<Vector> SecondaryLocs;
var float FlankDot;
var float MaxWeight;

public native function Init(Goal_AtCover GoalEvaluator);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    FlankDot = 0.100000001
    MaxWeight = 5.0
}