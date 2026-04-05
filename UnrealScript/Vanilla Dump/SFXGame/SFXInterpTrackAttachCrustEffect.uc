Class SFXInterpTrackAttachCrustEffect extends SFXGameInterpTrackCustom
    native
    collapsecategories;

struct native SFXAttachCrustEffectTrackData 
{
    var(SFXAttachCrustEffectTrackData) float m_fLifeTime;
    var(SFXAttachCrustEffectTrackData) bool m_bAttach;
};

var(SFXInterpTrackAttachCrustEffect) array<SFXAttachCrustEffectTrackData> m_aCrustEffectKeyData;
var(SFXInterpTrackAttachCrustEffect) array<BioSeqVar_ObjectFindByTag> m_aTarget;
var(SFXInterpTrackAttachCrustEffect) Object oEffect;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataArrayName()
{
    return "m_aCrustEffectKeyData";
}
public static event function string KeyDataDisplayName()
{
    return "Crust Effect Key Data";
}
public static event function string NewKeyDefaultName()
{
    return "CrustEffectAttach";
}
public event function TriggerKey(BioInterpTrackInst pTrackInst, bool bAttach, float fLifeTime)
{
    local BioSeqAct_AttachCrustEffect Seq;
    local Actor CurrentTarget;
    local int i;
    
    Seq = new (Outer) Class'BioSeqAct_AttachCrustEffect';
    Seq.oEffect = oEffect;
    Seq.fLifeTime = fLifeTime;
    if (bAttach)
    {
        Seq.InputLinks[0].bHasImpulse = TRUE;
        Seq.InputLinks[1].bHasImpulse = FALSE;
    }
    else
    {
        Seq.InputLinks[0].bHasImpulse = FALSE;
        Seq.InputLinks[1].bHasImpulse = TRUE;
    }
    if (m_aTarget.Length > 0)
    {
        for (i = 0; i < m_aTarget.Length; i++)
        {
            CurrentTarget = Actor(GetObjectRef(m_aTarget[i]));
            Seq.Target = CurrentTarget;
            if (CurrentTarget != None)
            {
                Seq.Activated();
                continue;
            }
        }
    }
    else if (pTrackInst != None)
    {
        CurrentTarget = GetGroupLinkedActor(pTrackInst);
        Seq.Target = CurrentTarget;
        if (CurrentTarget != None)
        {
            Seq.Activated();
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Attach Crust Effect"
}