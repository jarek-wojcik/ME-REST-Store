Class GFxAction_SetVariable extends SequenceAction
    native;

var(GFxAction_SetVariable) string Variable;
var(GFxAction_SetVariable) GFxMovie movie;

public event function bool IsValidLevelSequenceObject()
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Value", 
                      ExpectedType = Class'SequenceVariable', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}