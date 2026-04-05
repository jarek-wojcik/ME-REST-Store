Class PathGoalEvaluator
    native;

var PathGoalEvaluator NextEvaluator;
var NavigationPoint GeneratedGoal;
var int MaxPathVisits;
var const int CacheIdx;
var bool AllowStartNodeToBeGoal;

public event function string GetDumpString()
{
    return string(Self);
}
public event function Recycle()
{
    GeneratedGoal = None;
    NextEvaluator = None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxPathVisits = 1024
    CacheIdx = -1
}