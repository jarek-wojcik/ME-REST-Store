Class GFxAction_CloseMovie extends SequenceAction
    native;

var(GFxAction_CloseMovie) GFxMovie movie;
var(GFxAction_CloseMovie) bool bUnload;

public event function bool IsValidLevelSequenceObject()
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bUnload = TRUE
    VariableLinks = ()
}