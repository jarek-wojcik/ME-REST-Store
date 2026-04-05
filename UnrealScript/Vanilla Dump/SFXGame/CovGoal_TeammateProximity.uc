Class CovGoal_TeammateProximity extends CoverGoalConstraint
    native;

var(CovGoal_TeammateProximity) float fTeammateMinDistanceSq;
var(CovGoal_TeammateProximity) float fProximityPenalty;
var(CovGoal_TeammateProximity) float fSquadLeaderProximityPenalty;
var(CovGoal_TeammateProximity) float fTeammateMaxDistanceSq;
var(CovGoal_TeammateProximity) float fMaxDistancePenalty;
var(CovGoal_TeammateProximity) bool bRestrictMaxDistance;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}