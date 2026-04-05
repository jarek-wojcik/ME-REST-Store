Class SFXCustomAction_SyncBase_Loop extends SFXCustomAction_SyncPawnInstigator_Base
    abstract
    config(Game);

var(Instigator) BodyStance BS_InstigatorStart;
var(Instigator) BodyStance BS_InstigatorLoop;
var(Instigator) BodyStance BS_InstigatorEnd;
var(Victim) BodyStance BS_VictimStart;
var(Victim) BodyStance BS_VictimLoop;
var(Victim) BodyStance BS_VictimEnd;
var(LoopInfo) float LoopDuration;
var(Instigator) float InstigatorPlayRate;
var(Instigator) float InstigatorBlendInTime;
var(Instigator) float InstigatorBlendOutTime;
var(Victim) float VictimAnimDelay;
var(Victim) float VictimPlayRate;
var(Victim) float VictimBlendInTime;
var(Victim) float VictimBlendOutTime;
var(Victim) AnimSet VictimAnimSet;
var transient ECustomActionLoopState LoopState;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_InstigatorStart, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_InstigatorLoop, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_InstigatorEnd, UsedAnims);
    Super(BioCustomAction).GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    if (SyncPartner != None && VictimAnimSet != None)
    {
        SyncPartner.RegisterTemporaryAnim(VictimAnimSet);
    }
}
public function StartInteraction()
{
    MoveToMarkers();
    ApplyTimeline(TimelineTemplate, m_oPawn, SyncPartner);
    LoopState = ECustomActionLoopState.LoopState_Start;
    m_oPawn.PlayBodyStance(BS_InstigatorStart, InstigatorPlayRate, InstigatorBlendInTime, 0.0);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_InstigatorStart, TRUE);
    m_oPawn.Mesh.RootMotionMode = ERootMotionMode.RMM_Translate;
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_InstigatorStart, 2, 2, 2);
    SyncPartner.SetTimer(FMax(0.00100000005, VictimAnimDelay), FALSE, 'StartVictimAnim', Self);
    Super.StartInteraction();
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    SyncPartner.ClearTimer('StartVictimAnim');
    if (LoopState == ECustomActionLoopState.LoopState_Start)
    {
        m_oPawn.PlayBodyStance(BS_InstigatorLoop, InstigatorPlayRate, 0.0, 0.0, TRUE);
        m_oPawn.SetBodyStanceAnimEndNotification(BS_InstigatorStart, FALSE);
        SyncPartner.PlayBodyStance(BS_VictimLoop, VictimPlayRate, 0.0, 0.0, TRUE);
        LoopState = ECustomActionLoopState.LoopState_Loop;
        m_oPawn.SetTimer(LoopDuration, FALSE, 'BodyStanceAnimEndNotification', Self);
    }
    else if (LoopState == ECustomActionLoopState.LoopState_Loop)
    {
        m_oPawn.PlayBodyStance(BS_InstigatorEnd, InstigatorPlayRate, 0.0, InstigatorBlendOutTime);
        m_oPawn.SetBodyStanceAnimEndNotification(BS_InstigatorEnd, TRUE);
        SyncPartner.PlayBodyStance(BS_VictimEnd, VictimPlayRate, 0.0, VictimBlendOutTime);
        SyncPartner.SetBodyStanceRootBoneAxisOption(BS_VictimEnd, 2, 2, 2);
        LoopState = ECustomActionLoopState.LoopState_End;
    }
    else
    {
        EndThisCustomAction();
    }
}
public function StartVictimAnim()
{
    SyncPartner.PlayBodyStance(BS_VictimStart, VictimPlayRate, VictimBlendInTime, 0.0);
    SyncPartner.Mesh.RootMotionMode = ERootMotionMode.RMM_Translate;
    SyncPartner.SetBodyStanceRootBoneAxisOption(BS_VictimStart, 2, 2, 2);
}
public function StopCustomAction()
{
    m_oPawn.StopBodyStance(BS_InstigatorEnd, InstigatorBlendOutTime);
    SyncPartner.StopBodyStance(BS_VictimEnd, VictimBlendOutTime);
    m_oPawn.Mesh.RootMotionMode = m_oPawn.Mesh.default.RootMotionMode;
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_InstigatorStart, 1, 1, 1);
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_InstigatorLoop, 1, 1, 1);
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_InstigatorEnd, 1, 1, 1);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_InstigatorStart, FALSE);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_InstigatorLoop, FALSE);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_InstigatorEnd, FALSE);
    SyncPartner.Mesh.RootMotionMode = SyncPartner.Mesh.default.RootMotionMode;
    SyncPartner.SetBodyStanceRootBoneAxisOption(BS_VictimStart, 1, 1, 1);
    SyncPartner.SetBodyStanceRootBoneAxisOption(BS_VictimLoop, 1, 1, 1);
    SyncPartner.SetBodyStanceRootBoneAxisOption(BS_VictimEnd, 1, 1, 1);
    RemoveTimeline();
    SyncPartner.UnregisterTemporaryAnim(VictimAnimSet, VictimBlendOutTime);
    Super.StopCustomAction();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LoopDuration = 2.0
    InstigatorPlayRate = 1.0
    InstigatorBlendInTime = 0.200000003
    InstigatorBlendOutTime = 0.200000003
    VictimPlayRate = 1.0
    VictimBlendInTime = 0.200000003
    VictimBlendOutTime = 0.200000003
    PartnerCustomAction = 3
    Priority = ECustomActionPriority.CA_Priority_SuperHigh
}