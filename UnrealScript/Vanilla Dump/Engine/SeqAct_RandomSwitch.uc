Class SeqAct_RandomSwitch extends SeqAct_Switch
    native;

var array<int> AutoDisabledIndices;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Active Link", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'Indices', 
                      MinVars = 0, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}