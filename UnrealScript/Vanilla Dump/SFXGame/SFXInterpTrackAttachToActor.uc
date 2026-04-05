Class SFXInterpTrackAttachToActor extends SFXGameInterpTrackCustom
    native
    collapsecategories;

var(SFXInterpTrackAttachToActor) array<BioSeqVar_ObjectFindByTag> m_aTarget;
var(SFXInterpTrackAttachToActor) Vector RelativeOffset;
var(SFXInterpTrackAttachToActor) Rotator RelativeRotation;
var(SFXInterpTrackAttachToActor) Name BoneName;
var(SFXInterpTrackAttachToActor) bool bDetach;
var(SFXInterpTrackAttachToActor) bool bHardAttach;
var(SFXInterpTrackAttachToActor) bool bUseRelativeOffset;
var(SFXInterpTrackAttachToActor) bool bUseRelativeRotation;

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
    return "AttachToActorKeyData";
}
public static event function string NewKeyDefaultName()
{
    return "AttachToActor";
}
public event function TriggerKey(BioInterpTrackInst pTrackInst)
{
    local SeqAct_AttachToActor Seq;
    local Actor CurrentTarget;
    local int i;
    
    Seq = new (Outer) Class'SeqAct_AttachToActor';
    if (m_aTarget.Length > 0)
    {
        for (i = 0; i < m_aTarget.Length; i++)
        {
            CurrentTarget = Actor(GetObjectRef(m_aTarget[i]));
            if (CurrentTarget != None)
            {
                CurrentTarget.OnAttachToActor(Seq);
                continue;
            }
        }
    }
    else if (pTrackInst != None)
    {
        CurrentTarget = GetGroupLinkedActor(pTrackInst);
        if (CurrentTarget != None)
        {
            CurrentTarget.OnAttachToActor(Seq);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Attach To Actor Track"
}