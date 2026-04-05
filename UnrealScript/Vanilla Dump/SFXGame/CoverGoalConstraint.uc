Class CoverGoalConstraint
    native
    abstract;

var int ConstraintEvaluationPriority;

public event function string GetDumpString()
{
    return string(Self);
}
public event function Init(Goal_AtCover GoalEvaluator);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ConstraintEvaluationPriority = 5
}