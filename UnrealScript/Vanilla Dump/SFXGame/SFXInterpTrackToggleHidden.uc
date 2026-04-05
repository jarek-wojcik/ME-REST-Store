Class SFXInterpTrackToggleHidden extends SFXInterpTrackToggleBase
    native
    collapsecategories;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataDisplayName()
{
    return "Toggle Hidden Key Data";
}
public static event function string NewKeyDefaultName()
{
    return "ToggleHidden";
}
public event function TriggerKey(BioInterpTrackInst pTrackInst, bool bToggle, bool bEnable)
{
    local SeqAct_ToggleHidden Seq;
    local Actor CurrentTarget;
    local int i;
    
    Seq = new (Outer) Class'SeqAct_ToggleHidden';
    SetupToggleSequenceOp(Seq, bToggle, bEnable);
    if (m_aTarget.Length > 0)
    {
        for (i = 0; i < m_aTarget.Length; i++)
        {
            CurrentTarget = Actor(GetObjectRef(m_aTarget[i]));
            if (CurrentTarget != None)
            {
                CurrentTarget.OnToggleHidden(Seq);
                continue;
            }
        }
    }
    else if (pTrackInst != None)
    {
        CurrentTarget = GetGroupLinkedActor(pTrackInst);
        if (CurrentTarget != None)
        {
            CurrentTarget.OnToggleHidden(Seq);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackTitle = "Toggle Hidden"
}