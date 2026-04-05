Class NavMeshPathGoalEvaluator
    native;

var NavMeshPathGoalEvaluator NextEvaluator;
var int MaxPathVisits;
var int NumNodesThrownOut;
var int NumNodesProcessed;
var bool bAlwaysCallEvaluateGoal;

public event function string GetDumpString()
{
    return string(Self);
}
public event function Recycle()
{
    NumNodesThrownOut = 0;
    NumNodesProcessed = 0;
    NextEvaluator = None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxPathVisits = 1024
}