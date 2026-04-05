Class SFXCustomAction_VariableExit extends SFXCustomAction_SyncBase_Loop
    abstract
    config(Game);

var(Instigator) BodyStance BS_InstigatorEnd2;
var(Victim) BodyStance BS_VictimEnd2;
var(Instigator) float InstigatorBlendOutTime2;
var(Victim) float VictimBlendOutTime2;
var(Info) SFXTimelineData SuccessTimeline;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_InstigatorEnd2, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (LoopState == ECustomActionLoopState.LoopState_Start)
    {
        SyncPartner.CustomActionMessageEvent('OpenAPSWindow', m_oPawn);
    }
    else if (LoopState == ECustomActionLoopState.LoopState_Loop)
    {
        SyncPartner.CustomActionMessageEvent('CloseAPSWindow', m_oPawn);
    }
    Super.BodyStanceAnimEndNotification(SeqNode, PlayedTime, ExcessTime);
}
public function bool MessageEvent(Name EventName, Object Sender)
{
    if (EventName == 'MashSuccess')
    {
        m_oPawn.StopBodyStance(BS_InstigatorLoop, 0.200000003);
        m_oPawn.PlayBodyStance(BS_InstigatorEnd2, InstigatorPlayRate, 0.200000003, InstigatorBlendOutTime2);
        m_oPawn.SetBodyStanceAnimEndNotification(BS_InstigatorEnd2, TRUE);
        m_oPawn.ClearTimer('BodyStanceAnimEndNotification', Self);
        SyncPartner.StopBodyStance(BS_VictimLoop, 0.200000003);
        SyncPartner.PlayBodyStance(BS_VictimEnd2, VictimPlayRate, 0.200000003, VictimBlendOutTime2);
        SyncPartner.SetBodyStanceRootBoneAxisOption(BS_VictimEnd2, 2, 2, 2);
        m_oPawn.SetBodyStanceRootBoneAxisOption(BS_InstigatorEnd2, 2, 2, 2);
        LoopState = ECustomActionLoopState.LoopState_End;
        RemoveTimeline();
        if (SuccessTimeline != None)
        {
            ApplyTimeline(SuccessTimeline, m_oPawn, SyncPartner);
        }
        return TRUE;
    }
    return Super(SFXCustomAction_SyncPawnInstigator_Base).MessageEvent(EventName, Sender);
}
public function StopCustomAction()
{
    m_oPawn.StopBodyStance(BS_InstigatorEnd2, InstigatorBlendOutTime);
    SyncPartner.StopBodyStance(BS_VictimEnd2, VictimBlendOutTime);
    m_oPawn.SetBodyStanceRootBoneAxisOption(BS_InstigatorEnd2, 1, 1, 1);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_InstigatorEnd2, FALSE);
    SyncPartner.SetBodyStanceRootBoneAxisOption(BS_VictimEnd2, 1, 1, 1);
    Super.StopCustomAction();
    m_oPawn.bMashSuccess = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InstigatorBlendOutTime2 = 0.200000003
    VictimBlendOutTime2 = 0.200000003
}