Class SFXSeqAct_SetGoalPriority extends SequenceAction;

var Object m_oTarget;
var SFXNav_GoalPoint m_oGoal;
var int m_nSetPriority;
var(SFXSeqAct_SetGoalPriority) bool m_bResetPriorityToDefault;

public function Activated()
{
    m_oGoal = SFXNav_GoalPoint(m_oTarget);
    if (m_oGoal != None)
    {
        if (m_bResetPriorityToDefault)
        {
            m_oGoal.ResetPriority();
        }
        else
        {
            m_oGoal.OverridePriority(m_nSetPriority);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "GoalPoint", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_oTarget', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Priority", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nSetPriority', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}