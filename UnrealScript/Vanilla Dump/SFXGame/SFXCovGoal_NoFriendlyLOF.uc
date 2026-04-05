Class SFXCovGoal_NoFriendlyLOF extends CoverGoalConstraint
    native;

struct native FriendlyLOFData 
{
    var(FriendlyLOFData) Vector Source;
    var(FriendlyLOFData) Vector Target;
};

var transient array<FriendlyLOFData> LOFs;
var float LOFDistance;
var float MaxWeight;

public native function Init(Goal_AtCover GoalEvaluator);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LOFDistance = 150.0
    MaxWeight = 10.0
}