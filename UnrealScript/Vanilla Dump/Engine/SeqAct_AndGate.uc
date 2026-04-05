Class SeqAct_AndGate extends SequenceAction
    native;

var transient native array<Pointer> LinkedOutputs;
var transient array<bool> LinkedOutputFiredStatus;
var transient bool bOpen;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bOpen = TRUE
    VariableLinks = ()
    bAutoActivateOutputLinks = FALSE
}