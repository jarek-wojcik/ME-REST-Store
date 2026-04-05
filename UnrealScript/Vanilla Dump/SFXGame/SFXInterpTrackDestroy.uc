Class SFXInterpTrackDestroy extends SFXGameInterpTrackCustom
    native
    collapsecategories;

var(SFXInterpTrackDestroy) array<BioSeqVar_ObjectFindByTag> m_aTarget;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataArrayName()
{
    return "";
}
public static event function string KeyDataDisplayName()
{
    return "Destroy";
}
public static event function string NewKeyDefaultName()
{
    return "Destroy";
}
public event function TriggerKey(BioInterpTrackInst pTrackInst)
{
    local SeqAct_Destroy Seq;
    local Actor CurrentTarget;
    local int i;
    
    Seq = new (Outer) Class'SeqAct_Destroy';
    if (m_aTarget.Length > 0)
    {
        for (i = 0; i < m_aTarget.Length; i++)
        {
            CurrentTarget = Actor(GetObjectRef(m_aTarget[i]));
            if (CurrentTarget != None)
            {
                CurrentTarget.OnDestroy(Seq);
                continue;
            }
        }
    }
    else if (pTrackInst != None)
    {
        CurrentTarget = GetGroupLinkedActor(pTrackInst);
        if (CurrentTarget != None)
        {
            CurrentTarget.OnDestroy(Seq);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Destroy Track"
}