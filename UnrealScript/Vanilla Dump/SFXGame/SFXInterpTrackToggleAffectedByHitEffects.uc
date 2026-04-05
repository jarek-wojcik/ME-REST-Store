Class SFXInterpTrackToggleAffectedByHitEffects extends SFXInterpTrackToggleBase
    native
    collapsecategories;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataDisplayName()
{
    return "Toggle Hit Effects Key Data";
}
public static event function string NewKeyDefaultName()
{
    return "ToggleAffectedByHitEffects";
}
public event function TriggerKey(BioInterpTrackInst pTrackInst, bool bToggle, bool bEnable)
{
    local SeqAct_ToggleAffectedByHitEffects Seq;
    local Pawn oPawn;
    local int i;
    
    Seq = new (Outer) Class'SeqAct_ToggleAffectedByHitEffects';
    SetupToggleSequenceOp(Seq, bToggle, bEnable);
    if (m_aTarget.Length > 0)
    {
        for (i = 0; i < m_aTarget.Length; i++)
        {
            oPawn = Pawn(GetObjectRef(m_aTarget[i]));
            if (oPawn != None)
            {
                oPawn.Controller.OnToggleAffectedByHitEffects(Seq);
                continue;
            }
        }
    }
    else if (pTrackInst != None)
    {
        oPawn = Pawn(GetGroupLinkedActor(pTrackInst));
        if (oPawn != None)
        {
            oPawn.Controller.OnToggleAffectedByHitEffects(Seq);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackTitle = "Toggle HitEffects"
}