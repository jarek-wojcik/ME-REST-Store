Class SequenceVariable extends SequenceObject
    native
    abstract;

var(SequenceVariable) Name VarName;

public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}