Class CovGoal_AvoidEnemies extends CoverGoalConstraint
    native;

struct native EnemyData 
{
    var Vector Direction;
    var Pawn Enemy;
    var float Distance;
};

var transient array<EnemyData> Enemies;

public event native function Init(Goal_AtCover GoalEvaluator);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}