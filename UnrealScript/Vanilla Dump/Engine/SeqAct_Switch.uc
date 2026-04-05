Class SeqAct_Switch extends SequenceAction
    native;

var(SeqAct_Switch) array<int> Indices;
var(SeqAct_Switch) int LinkCount;
var(SeqAct_Switch) int IncrementAmount;
var(SeqAct_Switch) bool bLooping;
var(SeqAct_Switch) bool bAutoDisableLinks;

public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Indices = (1)
    LinkCount = 1
    IncrementAmount = 1
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Link 1", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Index", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'Indices', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}