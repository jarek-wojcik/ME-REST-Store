Class SFXInterpTrackAttachVFXToObject extends SFXGameInterpTrackCustom
    native
    collapsecategories;

var(SFXInterpTrackAttachVFXToObject) array<BioSeqVar_ObjectFindByTag> m_aAttachToTarget;
var(SFXInterpTrackAttachVFXToObject) Vector m_vOffset;
var(SFXInterpTrackAttachVFXToObject) Name m_nmSocketOrBone;
var(SFXInterpTrackAttachVFXToObject) Object m_oEffect;

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
    return "Attach VFX Key Data";
}
public static event function string NewKeyDefaultName()
{
    return "AttachVFX";
}
public event function TriggerKey(BioInterpTrackInst pTrackInst)
{
    local BioSeqAct_AttachVisualEffect Seq;
    local Actor CurrentTarget;
    local int i;
    
    Seq = new (Outer) Class'BioSeqAct_AttachVisualEffect';
    Seq.m_nmSocketOrBone = m_nmSocketOrBone;
    Seq.m_vOffset = m_vOffset;
    Seq.m_oEffect = m_oEffect;
    Seq.m_oAttachTo.Length = 0;
    if (m_aAttachToTarget.Length > 0)
    {
        for (i = 0; i < m_aAttachToTarget.Length; i++)
        {
            CurrentTarget = Actor(GetObjectRef(m_aAttachToTarget[i]));
            if (CurrentTarget != None)
            {
                Seq.m_oAttachTo.AddItem(CurrentTarget);
            }
        }
    }
    else if (pTrackInst != None)
    {
        CurrentTarget = GetGroupLinkedActor(pTrackInst);
        if (CurrentTarget != None)
        {
            Seq.m_oAttachTo.AddItem(CurrentTarget);
        }
    }
    Seq.Activated();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Attach VFX"
}