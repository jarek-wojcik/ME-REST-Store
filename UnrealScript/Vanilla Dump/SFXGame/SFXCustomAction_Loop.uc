Class SFXCustomAction_Loop extends BioCustomAction
    abstract
    config(Game);

enum ECustomActionLoopState
{
    LoopState_Start,
    LoopState_Loop,
    LoopState_End,
};

var(SFXCustomAction_Loop) BodyStance BS_Start;
var(SFXCustomAction_Loop) BodyStance BS_Loop;
var(SFXCustomAction_Loop) BodyStance BS_End;
var(SFXCustomAction_Loop) float PlayRate;
var(SFXCustomAction_Loop) float BlendInTime;
var(SFXCustomAction_Loop) float BlendOutTime;
var(SFXCustomAction_Loop) float StartTime;
var(SFXCustomAction_Loop) float LoopDuration;
var transient ECustomActionLoopState LoopState;
var(SFXCustomAction_Loop) ERootMotionMode RootMotionMode;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Start, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_Loop, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_End, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    if (m_oPawn.PlayBodyStance(BS_Start, PlayRate, BlendInTime, 0.0, , , , StartTime) != 0.0)
    {
        ApplyTimeline(TimelineTemplate, m_oPawn);
        SetLoopState(0);
        m_oPawn.SetBodyStanceAnimEndNotification(BS_Start, TRUE);
        if (RootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Start, 2, 2);
            m_oPawn.Mesh.RootMotionMode = RootMotionMode;
            m_oPawn.Velocity = vect(0.0, 0.0, 0.0);
        }
    }
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (LoopState == ECustomActionLoopState.LoopState_Start)
    {
        m_oPawn.PlayBodyStance(BS_Loop, PlayRate, 0.0, 0.0, TRUE);
        m_oPawn.SetBodyStanceAnimEndNotification(BS_Start, FALSE);
        if (RootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Loop, 2, 2);
        }
        SetLoopState(1);
        m_oPawn.SetTimer(LoopDuration, FALSE, 'BodyStanceAnimEndNotification', Self);
    }
    else if (LoopState == ECustomActionLoopState.LoopState_Loop)
    {
        m_oPawn.PlayBodyStance(BS_End, PlayRate, 0.0, BlendOutTime);
        m_oPawn.SetBodyStanceAnimEndNotification(BS_End, TRUE);
        if (RootMotionMode != ERootMotionMode.RMM_Ignore)
        {
            m_oPawn.SetBodyStanceRootBoneAxisOption(BS_End, 2, 2);
        }
        SetLoopState(2);
    }
    else
    {
        EndThisCustomAction();
    }
}
public function SetLoopState(ECustomActionLoopState NewLoopState)
{
    LoopState = NewLoopState;
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    RemoveTimeline();
    m_oPawn.ClearTimer('BodyStanceAnimEndNotification', Self);
    m_oPawn.StopBodyStance(BS_Start, BlendOutTime);
    m_oPawn.StopBodyStance(BS_Loop, BlendOutTime);
    m_oPawn.StopBodyStance(BS_End, BlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Start, FALSE);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Loop, FALSE);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_End, FALSE);
    if (RootMotionMode != ERootMotionMode.RMM_Ignore)
    {
        m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Start, 1, 1, 1);
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_Loop, 1, 1, 1);
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_End, 1, 1, 1);
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
    bBreakFromCover = TRUE
    bDisableMovement = TRUE
    bNotifyKnockedOutOfCover = TRUE
}