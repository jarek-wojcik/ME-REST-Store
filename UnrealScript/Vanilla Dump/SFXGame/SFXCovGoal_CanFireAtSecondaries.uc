Class SFXCovGoal_CanFireAtSecondaries extends CoverGoalConstraint
    native;

struct native SecondaryTargetData 
{
    var CoverInfo TargetCoverInfo;
    var Actor FireTarget;
    var BioPawn PawnTarget;
};

var array<SecondaryTargetData> Secondaries;
var float MaxWeight;

public native function Init(Goal_AtCover GoalEvaluator);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxWeight = 5.0
}