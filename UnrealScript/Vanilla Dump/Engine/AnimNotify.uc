Class AnimNotify
    native
    editinlinenew
    abstract
    collapsecategories;

public simulated function bool FindNextNotifyOfClass(AnimNodeSequence AnimSeqInstigator, Class<AnimNotify> NotifyClass, out AnimNotifyEvent OutEvent)
{
    local AnimSequence Seq;
    local int i;
    local bool bFoundThis;
    
    if (AnimSeqInstigator.AnimSeq != None)
    {
        Seq = AnimSeqInstigator.AnimSeq;
        for (i = 0; i < Seq.Notifies.Length; i++)
        {
            if (Seq.Notifies[i].Notify == Self)
            {
                bFoundThis = TRUE;
            }
            if (bFoundThis && ClassIsChildOf(Seq.Notifies[i].Notify.Class, NotifyClass))
            {
                OutEvent = Seq.Notifies[i];
                return TRUE;
            }
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}