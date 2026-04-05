Class SeqVar_External extends SequenceVariable within Sequence
    native;

var(SeqVar_External) string VariableLabel;
var(SeqVar_External) Class<SequenceVariable> ExpectedType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLabel = "Default Var"
}