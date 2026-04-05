Class GFxAction_Invoke extends SequenceAction
    native;

var(Invoke) string methodName;
var(Invoke) array<ASValue> Arguments;
var(GFxAction_Invoke) GFxMovie movie;

public event function bool IsValidLevelSequenceObject()
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Result", 
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