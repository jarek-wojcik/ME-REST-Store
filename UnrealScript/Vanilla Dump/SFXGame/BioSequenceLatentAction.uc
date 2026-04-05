Class BioSequenceLatentAction extends SeqAct_Latent
    native
    abstract;

var bool bHasTargets;

public event function bool UpdateOp(float DeltaTime)
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bHasTargets = TRUE
}