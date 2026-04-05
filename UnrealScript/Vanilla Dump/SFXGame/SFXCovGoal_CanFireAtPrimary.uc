Class SFXCovGoal_CanFireAtPrimary extends CoverGoalConstraint
    native;

var CoverInfo TargetCoverInfo;
var BioPawn PawnTarget;
var Actor FireTarget;
var float MaxWeight;

public native function Init(Goal_AtCover GoalEvaluator);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxWeight = 20.0
}