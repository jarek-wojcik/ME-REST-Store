Class BioAnimNotify_CustomAction extends AnimNotify_Scripted
    editinlinenew
    collapsecategories;

var(BioAnimNotify_CustomAction) Name Info;

public event function Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local BioPawn Pawn;
    
    Pawn = BioPawn(Owner);
    if (Pawn != None)
    {
        Pawn.AnimNotify(AnimSeqInstigator, Self);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}