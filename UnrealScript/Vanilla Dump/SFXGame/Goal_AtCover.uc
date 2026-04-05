Class Goal_AtCover extends PathGoalEvaluator
    native;

var export array<CoverGoalConstraint> CoverGoalConstraints;
var SFXAI_NativeBase AI;
var CoverSlotMarker BestMarker;
var int BestRating;
var(Goal_AtCover) int MaxToRate;
var int NumMarkersTested;
var Actor TetherActor;
var transient bool MoveTowardsGoalActor;
var transient bool bIncludePathCost;

public event function AddCoverGoalConstraint(CoverGoalConstraint Constraint)
{
    CoverGoalConstraints[CoverGoalConstraints.Length] = Constraint;
}
public event function string GetDumpString()
{
    local int idx;
    local string Str;
    
    if (CoverGoalConstraints.Length == 0)
    {
        return "Empty Cov Goal Constraints";
    }
    for (idx = 0; idx < CoverGoalConstraints.Length; idx++)
    {
        Str = Str @ CoverGoalConstraints[idx].GetDumpString() @ "\n";
    }
    return Str;
}
public final function Init(SFXAI_NativeBase oAI, Actor GoalActor, bool bAddPathCost)
{
    local int i;
    
    if (oAI.MyBP != None)
    {
        BestMarker = None;
        BestRating = 10000000;
        NumMarkersTested = 0;
        AI = oAI;
        TetherActor = GoalActor;
        bIncludePathCost = bAddPathCost;
        for (i = 0; i < CoverGoalConstraints.Length; i++)
        {
            CoverGoalConstraints[i].Init(Self);
        }
        InitNative();
        oAI.Pawn.AddGoalEvaluator(Self);
    }
}
private final native function InitNative();

public final native function RateSlotMarker(CoverSlotMarker Marker, Pawn Pawn, int BaseRating);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxToRate = 40
    MoveTowardsGoalActor = TRUE
    MaxPathVisits = 500
}