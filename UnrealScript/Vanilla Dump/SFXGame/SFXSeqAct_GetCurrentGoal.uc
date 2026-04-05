Class SFXSeqAct_GetCurrentGoal extends SequenceAction;

var SFXNav_GoalPoint oGoal;
var int nPriority;

public function Activated()
{
    local BioWorldInfo oBWI;
    local BioPlayerController oBPC;
    
    oBWI = BioWorldInfo(GetWorldInfo());
    oBPC = oBWI.GetLocalPlayerController();
    if (oBPC == None)
    {
        OutputLinks[1].bHasImpulse = TRUE;
        return;
    }
    oGoal = oBPC.GetBestGoalPoint();
    if (oGoal == None)
    {
        OutputLinks[1].bHasImpulse = TRUE;
        return;
    }
    nPriority = oGoal.GetPriority();
    OutputLinks[0].bHasImpulse = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Success", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Failed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "GoalPoint", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oGoal', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Priority", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'nPriority', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}