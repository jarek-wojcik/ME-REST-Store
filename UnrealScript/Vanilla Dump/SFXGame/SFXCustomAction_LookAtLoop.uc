Class SFXCustomAction_LookAtLoop extends BioCustomAction
    abstract
    config(Game);

enum ECustomActionLoopState
{
    LoopState_Start,
    LoopState_Loop,
    LoopState_End,
};

var(SFXCustomAction_LookAtLoop) BodyStance BS_StartAnim;
var(SFXCustomAction_LookAtLoop) BodyStance BS_LoopAnim;
var(SFXCustomAction_LookAtLoop) BodyStance BS_EndAnim;
var transient BodyStance BS_ToPlay;
var transient BodyStance BS_LoopToPlay;
var transient BodyStance BS_EndToPlay;
var(SFXCustomAction_LookAtLoop) float PlayRate;
var(SFXCustomAction_LookAtLoop) float BlendInTime;
var(SFXCustomAction_LookAtLoop) float BlendOutTime;
var(SFXCustomAction_LookAtLoop) float StartTime;
var(SFXCustomAction_LookAtLoop) float LoopDuration;
var transient ECustomActionLoopState LoopState;
var(SFXCustomAction_LookAtLoop) ERootMotionMode RootMotionMode;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_StartAnim, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_LoopAnim, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_EndAnim, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    BS_ToPlay = GetStartBodyStanceAnim();
    if (m_oPawn.PlayBodyStance(BS_ToPlay, PlayRate, BlendInTime, 0.0, , , , StartTime) != 0.0)
    {
        ApplyTimeline(TimelineTemplate, m_oPawn);
        LoopState = ECustomActionLoopState.LoopState_Start;
        m_oPawn.SetBodyStanceAnimEndNotification(BS_ToPlay, TRUE);
        if (RootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_ToPlay, 2, 2);
            m_oPawn.Mesh.RootMotionMode = RootMotionMode;
            m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
        }
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (LoopState == ECustomActionLoopState.LoopState_Start)
    {
        BS_LoopToPlay = GetLoopBodyStanceAnim();
        m_oPawn.PlayBodyStance(BS_LoopToPlay, PlayRate, 0.0, 0.0, TRUE);
        m_oPawn.SetBodyStanceAnimEndNotification(BS_ToPlay, FALSE);
        if (RootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_LoopToPlay, 2, 2);
        }
        LoopState = ECustomActionLoopState.LoopState_Loop;
        m_oPawn.SetTimer(LoopDuration, FALSE, 'BodyStanceAnimEndNotification', Self);
    }
    else if (LoopState == ECustomActionLoopState.LoopState_Loop)
    {
        BS_EndToPlay = GetEndBodyStanceAnim();
        m_oPawn.PlayBodyStance(BS_EndToPlay, PlayRate, 0.0, BlendOutTime);
        m_oPawn.SetBodyStanceAnimEndNotification(BS_EndToPlay, TRUE);
        if (RootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_EndToPlay, 2, 2);
        }
        LoopState = ECustomActionLoopState.LoopState_End;
    }
    else
    {
        InterruptThisCustomAction();
    }
}
public function BodyStance GetEndBodyStanceAnim()
{
    return BS_EndAnim;
}
public function BodyStance GetLoopBodyStanceAnim()
{
    return BS_LoopAnim;
}
public function BodyStance GetStartBodyStanceAnim()
{
    return BS_StartAnim;
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    RemoveTimeline();
    m_oPawn.ClearTimer('BodyStanceAnimEndNotification', Self);
    m_oPawn.StopBodyStance(BS_ToPlay, BlendOutTime);
    m_oPawn.StopBodyStance(BS_LoopToPlay, BlendOutTime);
    m_oPawn.StopBodyStance(BS_EndToPlay, BlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_ToPlay, FALSE);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_LoopToPlay, FALSE);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_EndToPlay, FALSE);
    if (RootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_ToPlay, 1, 1, 1);
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_LoopToPlay, 1, 1, 1);
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_EndToPlay, 1, 1, 1);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PlayRate = 1.0
    BlendInTime = 0.200000003
    BlendOutTime = 0.200000003
    LoopDuration = 1.0
    RootMotionMode = ERootMotionMode.RMM_Ignore
    bAllowChargeHolding = TRUE
    bReplicateCustomAction = TRUE
    bClientPredictCustomAction = TRUE
}