Class SequenceCondition extends SequenceOp
    native
    abstract;

public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAutoActivateOutputLinks = FALSE
}