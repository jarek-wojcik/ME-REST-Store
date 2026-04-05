Class SFXCovGoal_AwayFromFriendlies extends CoverGoalConstraint
    native;

var transient array<Vector> Friends;
var float AvoidDistance;
var float MaxWeight;

public native function Init(Goal_AtCover GoalEvaluator);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AvoidDistance = 200.0
    MaxWeight = 10.0
}