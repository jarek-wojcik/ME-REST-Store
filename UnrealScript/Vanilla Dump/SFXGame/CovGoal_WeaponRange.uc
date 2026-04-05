Class CovGoal_WeaponRange extends CoverGoalConstraint
    native;

var(CovGoal_WeaponRange) float fClosePenalty;
var(CovGoal_WeaponRange) float fFarPenalty;
var float fIdealWeaponRange;
var float fLongWeaponRange;
var float fShortWeaponRange;
var(CovGoal_WeaponRange) bool bHardConstraint;

public function Init(Goal_AtCover GoalEvaluator)
{
    fIdealWeaponRange = GoalEvaluator.AI.GetCombatRange(2);
    fLongWeaponRange = GoalEvaluator.AI.GetCombatRange(3);
    fShortWeaponRange = GoalEvaluator.AI.GetCombatRange(1);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}