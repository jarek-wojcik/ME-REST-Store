Class SeqAct_RangeSwitch extends SequenceAction
    native
    deprecated;

struct native SwitchRange 
{
    var(SwitchRange) int Min;
    var(SwitchRange) int Max;
};

var(SeqAct_RangeSwitch) array<SwitchRange> Ranges;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OutputLinks = ()
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Index", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}