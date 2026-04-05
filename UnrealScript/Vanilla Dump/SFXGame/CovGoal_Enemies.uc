Class CovGoal_Enemies extends CoverGoalConstraint
    native;

struct native ValidEnemyCacheDatum 
{
    var CoverInfo EnemyCover;
    var BioPawn EnemyPawn;
};

var array<ValidEnemyCacheDatum> ValidEnemyCache;

public event native function Init(Goal_AtCover GoalEvaluator);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ConstraintEvaluationPriority = 3
}